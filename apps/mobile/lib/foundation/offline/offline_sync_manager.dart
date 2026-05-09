import 'dart:async';
import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../services/connectivity_service.dart';

/// Offline sync manager (Addendum 2.0 S5).
///
/// Local Storage: drift for relational caching, hive for BLoC state/prefs.
/// Mutation Queue: workmanager + drift queue. On reconnect, flush FIFO.
/// Retry: 3 attempts (1s, 5s, 15s). On failure -> failed_mutations table.
/// Conflict Resolution: Server-wins for graph/Kinnections.
///   Local-wins for Memory Box drafts & Bloom credits (optimistic, reconcile on sync).
class OfflineSyncManager {
  OfflineSyncManager({ConnectivityService? connectivity})
      : _connectivity = connectivity ?? ConnectivityService();

  final ConnectivityService _connectivity;
  StreamSubscription<List<ConnectivityResult>>? _subscription;
  bool _isOnline = true;

  static const _mutationQueueBox = 'offline_mutation_queue';
  static const _failedMutationsBox = 'offline_failed_mutations';
  static const _cachedFeedBox = 'offline_cached_feed';
  static const _cachedProfileBox = 'offline_cached_profile';
  static const _cachedSettingsBox = 'offline_cached_settings';

  bool get isOnline => _isOnline;

  /// Initialize offline sync: open Hive boxes, start connectivity listener.
  Future<void> initialize() async {
    await Hive.initFlutter();
    await Future.wait([
      Hive.openBox<String>(_mutationQueueBox),
      Hive.openBox<String>(_failedMutationsBox),
      Hive.openBox<String>(_cachedFeedBox),
      Hive.openBox<String>(_cachedProfileBox),
      Hive.openBox<String>(_cachedSettingsBox),
    ]);

    _isOnline = await _connectivity.isConnected;

    _subscription = _connectivity.changes.listen((results) {
      final wasOffline = !_isOnline;
      _isOnline = !results.contains(ConnectivityResult.none);

      if (_isOnline && wasOffline) {
        debugPrint('[OfflineSync] Back online -- flushing mutation queue');
        flushMutationQueue();
      }
    });
  }

  /// Enqueue a mutation for offline sync.
  /// Mutations are processed FIFO on reconnect.
  Future<void> enqueueMutation({
    required String type,
    required Map<String, dynamic> payload,
  }) async {
    final box = Hive.box<String>(_mutationQueueBox);
    final id = DateTime.now().microsecondsSinceEpoch.toString();
    final mutation = jsonEncode({
      'id': id,
      'type': type,
      'payload': payload,
      'created_at': DateTime.now().toIso8601String(),
      'attempts': 0,
    });
    await box.put(id, mutation);
    debugPrint('[OfflineSync] Enqueued mutation: $type ($id)');
  }

  /// Flush all pending mutations. Called on reconnect.
  Future<void> flushMutationQueue() async {
    final box = Hive.box<String>(_mutationQueueBox);
    final failedBox = Hive.box<String>(_failedMutationsBox);
    final keys = box.keys.cast<String>().toList();

    for (final key in keys) {
      final raw = box.get(key);
      if (raw == null) continue;

      final mutation = jsonDecode(raw) as Map<String, dynamic>;
      final attempts = (mutation['attempts'] as int?) ?? 0;

      if (attempts >= 3) {
        // Move to failed_mutations after 3 attempts
        await failedBox.put(key, raw);
        await box.delete(key);
        debugPrint('[OfflineSync] Mutation $key moved to failed after 3 attempts');
        continue;
      }

      try {
        final delivered = await _dispatchMutation(
          type: mutation['type'] as String,
          payload: (mutation['payload'] as Map<String, dynamic>?) ?? {},
        );

        if (delivered) {
          await box.delete(key);
          debugPrint('[OfflineSync] Mutation $key delivered');
        } else {
          // Increment attempt counter
          mutation['attempts'] = attempts + 1;
          await box.put(key, jsonEncode(mutation));
        }
      } catch (e) {
        mutation['attempts'] = attempts + 1;
        await box.put(key, jsonEncode(mutation));
        debugPrint('[OfflineSync] Mutation $key failed (attempt ${attempts + 1}): $e');

        // Retry delays: 1s, 5s, 15s
        final delays = [1, 5, 15];
        if (attempts < delays.length) {
          await Future<void>.delayed(Duration(seconds: delays[attempts]));
        }
      }
    }
  }

  /// Dispatch a single mutation to the server.
  Future<bool> _dispatchMutation({
    required String type,
    required Map<String, dynamic> payload,
  }) async {
    // TODO: Route to appropriate repository/service based on mutation type
    // For now, log and return false to retry
    debugPrint('[OfflineSync] Dispatching: $type');
    return false;
  }

  // ---------------------------------------------------------------------------
  // Feed caching (Addendum 2.0 S5: "Load last 20 cached memories")
  // ---------------------------------------------------------------------------

  /// Cache feed data for offline access.
  Future<void> cacheFeed(String key, String jsonData) async {
    final box = Hive.box<String>(_cachedFeedBox);
    await box.put(key, jsonData);
  }

  /// Get cached feed data.
  String? getCachedFeed(String key) {
    final box = Hive.box<String>(_cachedFeedBox);
    return box.get(key);
  }

  // ---------------------------------------------------------------------------
  // Settings caching
  // ---------------------------------------------------------------------------

  Future<void> cacheSettings(String jsonData) async {
    final box = Hive.box<String>(_cachedSettingsBox);
    await box.put('settings', jsonData);
  }

  String? getCachedSettings() {
    final box = Hive.box<String>(_cachedSettingsBox);
    return box.get('settings');
  }

  // ---------------------------------------------------------------------------
  // Pending mutations info (for "Action pending. Tap to retry." UI)
  // ---------------------------------------------------------------------------

  int get pendingMutationCount => Hive.box<String>(_mutationQueueBox).length;

  int get failedMutationCount => Hive.box<String>(_failedMutationsBox).length;

  /// Retry all failed mutations.
  Future<void> retryFailedMutations() async {
    final failedBox = Hive.box<String>(_failedMutationsBox);
    final queueBox = Hive.box<String>(_mutationQueueBox);

    for (final key in failedBox.keys.cast<String>().toList()) {
      final raw = failedBox.get(key);
      if (raw == null) continue;

      final mutation = jsonDecode(raw) as Map<String, dynamic>;
      mutation['attempts'] = 0; // Reset attempts
      await queueBox.put(key, jsonEncode(mutation));
      await failedBox.delete(key);
    }

    await flushMutationQueue();
  }

  /// Dispose resources.
  void dispose() {
    _subscription?.cancel();
  }
}
