import 'dart:async';
import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../services/network/dio_client.dart';

/// Type-aware mutation queue with per-item retry and dead-letter box
/// (PRD §11.4 — Offline-First, Addendum 2.0 §S5).
///
/// Backed by two Hive boxes:
/// - `mutation_queue`  — pending mutations, FIFO.
/// - `mutation_dlq`    — items that exhausted 3 retry attempts.
///
/// Retry schedule: immediate, 1 s, 4 s (exponential 100 ms × 2^attempt).
/// On reconnect [OfflineSyncManager] calls [MutationQueue.flush]; the queue
/// is also flushed automatically whenever [enqueue] is called while online.
abstract class MutationQueue {
  static const _queueBox = 'mutation_queue';
  static const _dlqBox = 'mutation_dlq';
  static const _maxAttempts = 3;

  // In-memory attempt counter (reset on app restart — acceptable; box key
  // provides stable identity within a session).
  static final Map<String, int> _attempts = {};

  static bool _flushing = false;

  // ── Public API ──────────────────────────────────────────────────────────

  /// Enqueue a mutation. Immediately tries to flush if online.
  static Future<void> enqueue(String type, Map<String, dynamic> payload) async {
    final box = Hive.box<String>(_queueBox);
    final id = '${DateTime.now().microsecondsSinceEpoch}';
    await box.put(id, jsonEncode({'id': id, 'type': type, 'payload': payload}));
    debugPrint('[MutationQueue] enqueued $type ($id)');
    await flush();
  }

  /// Process all pending mutations. Safe to call concurrently — only one
  /// flush runs at a time.
  static Future<void> flush() async {
    if (_flushing) return;
    final connectivity = await Connectivity().checkConnectivity();
    if (connectivity.contains(ConnectivityResult.none)) return;

    _flushing = true;
    try {
      await _processQueue();
    } finally {
      _flushing = false;
    }
  }

  // ── Internal ────────────────────────────────────────────────────────────

  static Future<void> _processQueue() async {
    final box = Hive.box<String>(_queueBox);
    final dlq = Hive.box<String>(_dlqBox);

    // Iterate over a snapshot of keys so deletions don't affect iteration.
    final keys = box.keys.cast<String>().toList();
    for (final key in keys) {
      final raw = box.get(key);
      if (raw == null) continue;

      final item = jsonDecode(raw) as Map<String, dynamic>;
      final id = item['id'] as String;
      final attempts = _attempts[id] ?? 0;

      try {
        await _dispatch(
          item['type'] as String,
          (item['payload'] as Map<dynamic, dynamic>).cast<String, dynamic>(),
        );
        await box.delete(key);
        _attempts.remove(id);
        debugPrint('[MutationQueue] dispatched ${item['type']} ($id)');
      } catch (e) {
        if (attempts + 1 >= _maxAttempts) {
          debugPrint(
            '[MutationQueue] DLQ ${item['type']} ($id) after $attempts attempts: $e',
          );
          await dlq.put(key, raw);
          await box.delete(key);
          _attempts.remove(id);
        } else {
          _attempts[id] = attempts + 1;
          final backoffMs = 100 * (1 << attempts); // 100 ms, 200 ms, 400 ms
          debugPrint(
            '[MutationQueue] retry ${attempts + 1}/$_maxAttempts for ${item['type']} in ${backoffMs}ms',
          );
          await Future<void>.delayed(Duration(milliseconds: backoffMs));
        }
      }
    }
  }

  /// Dispatch a mutation to the appropriate repository.
  ///
  /// Override this via [MutationQueue.setDispatcher] to wire up actual repos
  /// without creating a circular dependency on the DI container.
  static Future<void> Function(String type, Map<String, dynamic> payload)
  _dispatcher = _defaultDispatcher;

  static Future<void> _defaultDispatcher(
    String type,
    Map<String, dynamic> payload,
  ) async {
    final endpoint = payload['endpoint']?.toString();
    if (endpoint == null || endpoint.isEmpty) {
      throw ArgumentError(
        'MutationQueue dispatcher not configured and payload.endpoint is missing for "$type".',
      );
    }

    final method = (payload['method']?.toString() ?? 'POST').toUpperCase();
    final data = payload['body'];
    final queryParameters = _toStringDynamicMap(payload['query']);
    final headers = _toStringDynamicMap(payload['headers']);

    final response = await DioClient.instance().request<dynamic>(
      endpoint,
      data: data,
      queryParameters: queryParameters,
      options: Options(method: method, headers: headers),
    );

    final statusCode = response.statusCode ?? 0;
    if (statusCode < 200 || statusCode >= 300) {
      throw StateError(
        'MutationQueue dispatch failed: $method $endpoint returned $statusCode for "$type".',
      );
    }
  }

  /// Register the application-level dispatch function.
  ///
  /// ```dart
  /// MutationQueue.setDispatcher((type, payload) async {
  ///   switch (type) {
  ///     case 'feed.react':   return feedRepo.react(payload);
  ///     case 'vault.update': return vaultRepo.update(payload);
  ///     // …
  ///   }
  /// });
  /// ```
  static void setDispatcher(
    Future<void> Function(String type, Map<String, dynamic> payload) fn,
  ) {
    _dispatcher = fn;
  }

  static Future<void> _dispatch(String type, Map<String, dynamic> payload) =>
      _dispatcher(type, payload);

  static Map<String, dynamic>? _toStringDynamicMap(Object? value) {
    if (value == null) return null;
    if (value is! Map) return null;
    return value.map((key, mapValue) => MapEntry(key.toString(), mapValue));
  }

  // ── Box initialisation (call from AppBootstrap) ──────────────────────

  /// Open required Hive boxes. Must be called before any other method.
  static Future<void> initialize() async {
    await Future.wait([
      Hive.openBox<String>(_queueBox),
      Hive.openBox<String>(_dlqBox),
    ]);
  }
}
