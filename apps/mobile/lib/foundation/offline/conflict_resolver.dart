import 'dart:convert';

import 'package:flutter/foundation.dart';

/// Conflict resolution logic (Addendum 2.0 S5).
///
/// Server-wins for graph/Kinnections data.
/// Local-wins for Memory Box drafts & Bloom credits balance
/// (local optimistic, reconcile on sync).
class ConflictResolver {
  ConflictResolver._();

  /// Resolve a conflict between local and server data.
  ///
  /// Returns the winning version based on data type.
  static Map<String, dynamic> resolve({
    required String dataType,
    required Map<String, dynamic> localData,
    required Map<String, dynamic> serverData,
  }) {
    final strategy = _strategyFor(dataType);

    switch (strategy) {
      case ConflictStrategy.serverWins:
        return _serverWins(localData, serverData, dataType);
      case ConflictStrategy.localWins:
        return _localWins(localData, serverData, dataType);
      case ConflictStrategy.lastWriteWins:
        return _lastWriteWins(localData, serverData);
      case ConflictStrategy.merge:
        return _merge(localData, serverData);
    }
  }

  /// Determine conflict strategy based on data type.
  static ConflictStrategy _strategyFor(String dataType) {
    switch (dataType) {
      // Server-wins: graph data, Kinnections, Discovery, Tree
      case 'kinnection':
      case 'tree_node':
      case 'tree_edge':
      case 'branch':
      case 'branch_merge':
      case 'discovery_candidate':
      case 'kin_score':
      case 'profile':
        return ConflictStrategy.serverWins;

      // Local-wins: Memory Box drafts, Bloom credits (optimistic)
      case 'memory_box_draft':
      case 'bloom_credit_balance':
      case 'settings_draft':
        return ConflictStrategy.localWins;

      // Last-write-wins: comments, reactions (Pulse)
      case 'comment':
      case 'pulse':
      case 'strand':
        return ConflictStrategy.lastWriteWins;

      // Merge: settings (merge individual fields)
      case 'settings':
      case 'notification_prefs':
        return ConflictStrategy.merge;

      default:
        return ConflictStrategy.serverWins;
    }
  }

  /// Server data always wins. Log conflict for debugging.
  static Map<String, dynamic> _serverWins(
    Map<String, dynamic> local,
    Map<String, dynamic> server,
    String dataType,
  ) {
    debugPrint('[ConflictResolver] Server wins for $dataType');
    return server;
  }

  /// Local data always wins. Used for drafts and optimistic balances.
  /// Server is updated on next sync.
  static Map<String, dynamic> _localWins(
    Map<String, dynamic> local,
    Map<String, dynamic> server,
    String dataType,
  ) {
    debugPrint('[ConflictResolver] Local wins for $dataType');
    return local;
  }

  /// Whoever wrote last wins, based on updated_at timestamp.
  static Map<String, dynamic> _lastWriteWins(
    Map<String, dynamic> local,
    Map<String, dynamic> server,
  ) {
    final localTime = DateTime.tryParse(
      (local['updated_at'] ?? local['created_at'] ?? '').toString(),
    );
    final serverTime = DateTime.tryParse(
      (server['updated_at'] ?? server['created_at'] ?? '').toString(),
    );

    if (localTime != null && serverTime != null) {
      if (localTime.isAfter(serverTime)) {
        debugPrint('[ConflictResolver] Last-write-wins: local is newer');
        return local;
      }
    }
    debugPrint('[ConflictResolver] Last-write-wins: server is newer (or equal)');
    return server;
  }

  /// Merge strategy: take non-null fields from both, prefer server for conflicts.
  static Map<String, dynamic> _merge(
    Map<String, dynamic> local,
    Map<String, dynamic> server,
  ) {
    final merged = Map<String, dynamic>.from(server);

    for (final entry in local.entries) {
      // Only take local value if server doesn't have it
      if (!merged.containsKey(entry.key) || merged[entry.key] == null) {
        merged[entry.key] = entry.value;
      }
    }

    debugPrint('[ConflictResolver] Merged ${local.length} local + ${server.length} server fields');
    return merged;
  }

  /// Reconcile Bloom credit balance after sync.
  /// Local: optimistic count. Server: actual count.
  /// Delta = local_changes_since_last_sync applied to server count.
  static int reconcileBloomCredits({
    required int serverBalance,
    required int localBalance,
    required int pendingPurchases,
    required int pendingSpends,
  }) {
    // Server balance + pending purchases - pending spends
    final reconciled = serverBalance + pendingPurchases - pendingSpends;
    debugPrint(
      '[ConflictResolver] Bloom credits reconciled: '
      'server=$serverBalance + pending_purchases=$pendingPurchases '
      '- pending_spends=$pendingSpends = $reconciled',
    );
    return reconciled;
  }
}

enum ConflictStrategy {
  /// Server data always wins (graph, Kinnections, Tree).
  serverWins,

  /// Local data always wins (Memory Box drafts, Bloom credits).
  localWins,

  /// Most recent write wins (comments, Pulses).
  lastWriteWins,

  /// Merge fields from both (settings).
  merge,
}
