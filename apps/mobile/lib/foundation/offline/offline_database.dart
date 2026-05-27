import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

part 'offline_database.g.dart';

// ---------------------------------------------------------------------------
// Table definitions (Addendum 2.0 S5: drift for relational caching)
// ---------------------------------------------------------------------------

/// Cached memories for offline feed access. Last 20 per PRD.
class CachedMemories extends Table {
  TextColumn get id => text()();
  TextColumn get creatorId => text()();
  TextColumn get creatorUsername => text().withDefault(const Constant(''))();
  TextColumn get creatorDisplayName => text().withDefault(const Constant(''))();
  TextColumn get mediaUrl => text()();
  TextColumn get thumbnailUrl => text().nullable()();
  TextColumn get caption => text().withDefault(const Constant(''))();
  RealColumn get kinScore => real().withDefault(const Constant(0))();
  IntColumn get pulseCount => integer().withDefault(const Constant(0))();
  IntColumn get commentCount => integer().withDefault(const Constant(0))();
  TextColumn get branchId => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get cachedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}

/// Cached user profiles for offline access.
class CachedProfiles extends Table {
  TextColumn get userId => text()();
  TextColumn get displayName => text()();
  TextColumn get surname => text().withDefault(const Constant(''))();
  TextColumn get haplogroup => text().nullable()();
  RealColumn get kinScore => real().withDefault(const Constant(0))();
  TextColumn get relationshipType => text().withDefault(const Constant(''))();
  BoolColumn get dnaVerified => boolean().withDefault(const Constant(false))();
  DateTimeColumn get cachedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {userId};
}

/// Cached Kinnections (confirmed biological connections).
class CachedKinnections extends Table {
  TextColumn get id => text()();
  TextColumn get userId => text()();
  TextColumn get targetUserId => text()();
  TextColumn get relationshipType => text()();
  RealColumn get kinScore => real()();
  DateTimeColumn get confirmedAt => dateTime()();
  DateTimeColumn get cachedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}

/// Offline mutation queue (backed by Drift for durability).
class OfflineMutations extends Table {
  TextColumn get id => text()();
  TextColumn get type => text()();
  TextColumn get payload => text()(); // JSON-encoded
  IntColumn get attempts => integer().withDefault(const Constant(0))();
  TextColumn get status => text().withDefault(const Constant('pending'))(); // pending, failed, delivered
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get lastAttemptAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

/// Memory Box drafts (local-wins conflict resolution).
class MemoryBoxDrafts extends Table {
  TextColumn get id => text()();
  TextColumn get recipientName => text()();
  TextColumn get triggerType => text()();
  TextColumn get mediaPath => text().nullable()();
  TextColumn get caption => text().withDefault(const Constant(''))();
  BoolColumn get isSealed => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}

// ---------------------------------------------------------------------------
// Database definition
// ---------------------------------------------------------------------------

@DriftDatabase(tables: [
  CachedMemories,
  CachedProfiles,
  CachedKinnections,
  OfflineMutations,
  MemoryBoxDrafts,
])
class OfflineDatabase extends _$OfflineDatabase {
  OfflineDatabase() : super(_openConnection());

  // Bump this when schema changes.
  @override
  int get schemaVersion => 1;

  // ---------------------------------------------------------------------------
  // Memory cache operations
  // ---------------------------------------------------------------------------

  /// Cache a batch of memories (replaces existing).
  Future<void> cacheMemories(List<CachedMemoriesCompanion> memories) async {
    await batch((b) {
      b.insertAllOnConflictUpdate(cachedMemories, memories);
    });
  }

  /// Get cached memories for offline feed (last 20).
  Future<List<CachedMemory>> getCachedFeed({int limit = 20}) {
    return (select(cachedMemories)
          ..orderBy([(t) => OrderingTerm.desc(t.createdAt)])
          ..limit(limit))
        .get();
  }

  /// Clear old cached memories beyond limit.
  Future<void> trimMemoryCache({int keepCount = 50}) async {
    final all = await (select(cachedMemories)
          ..orderBy([(t) => OrderingTerm.desc(t.cachedAt)]))
        .get();
    if (all.length > keepCount) {
      final toDelete = all.sublist(keepCount);
      for (final m in toDelete) {
        await (delete(cachedMemories)..where((t) => t.id.equals(m.id))).go();
      }
    }
  }

  // ---------------------------------------------------------------------------
  // Profile cache operations
  // ---------------------------------------------------------------------------

  Future<void> cacheProfile(CachedProfilesCompanion profile) {
    return into(cachedProfiles).insertOnConflictUpdate(profile);
  }

  Future<CachedProfile?> getCachedProfile(String userId) {
    return (select(cachedProfiles)..where((t) => t.userId.equals(userId))).getSingleOrNull();
  }

  // ---------------------------------------------------------------------------
  // Kinnection cache operations
  // ---------------------------------------------------------------------------

  Future<void> cacheKinnections(List<CachedKinnectionsCompanion> items) async {
    await batch((b) {
      b.insertAllOnConflictUpdate(cachedKinnections, items);
    });
  }

  Future<List<CachedKinnection>> getCachedKinnections(String userId) {
    return (select(cachedKinnections)
          ..where((t) => t.userId.equals(userId))
          ..orderBy([(t) => OrderingTerm.desc(t.kinScore)]))
        .get();
  }

  // ---------------------------------------------------------------------------
  // Mutation queue operations
  // ---------------------------------------------------------------------------

  Future<void> enqueueMutation(OfflineMutationsCompanion mutation) {
    return into(offlineMutations).insertOnConflictUpdate(mutation);
  }

  Future<List<OfflineMutation>> getPendingMutations() {
    return (select(offlineMutations)
          ..where((t) => t.status.equals('pending'))
          ..orderBy([(t) => OrderingTerm.asc(t.createdAt)]))
        .get();
  }

  Future<void> markMutationDelivered(String id) {
    return (update(offlineMutations)..where((t) => t.id.equals(id)))
        .write(const OfflineMutationsCompanion(status: Value('delivered')));
  }

  Future<void> markMutationFailed(String id) {
    return (update(offlineMutations)..where((t) => t.id.equals(id)))
        .write(OfflineMutationsCompanion(
      status: const Value('failed'),
      lastAttemptAt: Value(DateTime.now()),
    ));
  }

  Future<void> incrementMutationAttempt(String id, int currentAttempts) {
    return (update(offlineMutations)..where((t) => t.id.equals(id)))
        .write(OfflineMutationsCompanion(
      attempts: Value(currentAttempts + 1),
      lastAttemptAt: Value(DateTime.now()),
    ));
  }

  // ---------------------------------------------------------------------------
  // Memory Box drafts (local-wins)
  // ---------------------------------------------------------------------------

  Future<void> saveDraft(MemoryBoxDraftsCompanion draft) {
    return into(memoryBoxDrafts).insertOnConflictUpdate(draft);
  }

  Future<List<MemoryBoxDraft>> getDrafts() {
    return (select(memoryBoxDrafts)
          ..where((t) => t.isSealed.equals(false))
          ..orderBy([(t) => OrderingTerm.desc(t.updatedAt)]))
        .get();
  }

  Future<void> deleteDraft(String id) {
    return (delete(memoryBoxDrafts)..where((t) => t.id.equals(id))).go();
  }

  // ---------------------------------------------------------------------------
  // Connection helper
  // ---------------------------------------------------------------------------

  static LazyDatabase _openConnection() {
    return LazyDatabase(() async {
      final dbFolder = await getApplicationDocumentsDirectory();
      final file = File(p.join(dbFolder.path, 'kinnectai_offline.sqlite'));
      return NativeDatabase.createInBackground(file);
    });
  }

  static QueryExecutor openConnection() => _openConnection();
}
