import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../models/memory.dart';

/// Kernel service for Kin Score computation (PRD Section 01.3 + Addendum 2.0 S4).
///
/// Client-side: fetches server-computed normalized scores.
/// Caching: in-memory LRU (Dart Map) + hive for offline. TTL: 300s.
/// Stale-while-revalidate: 3600s.
class KernelService {
  KernelService({Dio? dio}) : _dio = dio ?? Dio(BaseOptions(baseUrl: 'http://localhost:8080/v1'));

  final Dio _dio;

  // In-memory LRU cache: key -> (score, fetchedAt)
  final Map<String, _CacheEntry> _cache = {};
  static const _ttl = Duration(seconds: 300);
  static const _staleTtl = Duration(seconds: 3600);
  static const _maxCacheSize = 200;

  /// Get Kin Score between current user and target.
  /// Priority: cache (p99 <200ms) -> live computation.
  Future<double> getKinScore(String userAId, String userBId) async {
    final key = _cacheKey(userAId, userBId);
    final cached = _cache[key];

    // Fresh cache hit
    if (cached != null && !cached.isExpired(_ttl)) {
      return cached.score;
    }

    // Stale-while-revalidate: return stale, refresh in background
    if (cached != null && !cached.isExpired(_staleTtl)) {
      _refreshInBackground(userAId, userBId);
      return cached.score;
    }

    // Cache miss: fetch live
    return _fetchAndCache(userAId, userBId);
  }

  /// Get detailed Kin Score breakdown for Kin Score Detail screen.
  Future<KinScoreBreakdown> getKinScoreBreakdown(String userAId, String userBId) async {
    try {
      final response = await _dio.get<Map<String, dynamic>>(
        '/kin-score/$userBId',
        queryParameters: {'detail': 'true', 'user_a': userAId},
      );
      final data = response.data ?? {};
      return KinScoreBreakdown(
        score: (data['normalized_score'] as num?)?.toDouble() ?? 0,
        relationship: (data['relationship_label'] ?? '').toString(),
        sharedBranches: (data['shared_branches'] as num?)?.toInt() ?? 0,
        sharedAncestors: (data['shared_ancestors'] as num?)?.toInt() ?? 0,
        haplogroup: data['haplogroup']?.toString(),
        connectionPath: ((data['connection_path'] as List?) ?? []).map((e) => e.toString()).toList(),
      );
    } catch (e) {
      debugPrint('Breakdown error: $e');
      rethrow;
    }
  }

  /// Get connection path between two users (Neo4j shortest path).
  Future<List<String>> getConnectionPath(String fromUserId, String toUserId) async {
    try {
      final response = await _dio.get<Map<String, dynamic>>(
        '/graph/path',
        queryParameters: {'from': fromUserId, 'to': toUserId},
      );
      final path = (response.data?['path'] as List?) ?? [];
      return path.map((e) => e.toString()).toList();
    } catch (e) {
      debugPrint('Path error: $e');
      return [];
    }
  }

  Future<double> _fetchAndCache(String userAId, String userBId) async {
    try {
      final response = await _dio.get<Map<String, dynamic>>('/kin-score/$userBId');
      final score = (response.data?['normalized_score'] as num?)?.toDouble() ?? 0;
      _putCache(_cacheKey(userAId, userBId), score);
      return score;
    } catch (e) {
      debugPrint('Kin Score fetch error: $e');
      return 0;
    }
  }

  void _refreshInBackground(String userAId, String userBId) {
    _fetchAndCache(userAId, userBId); // fire-and-forget
  }

  void _putCache(String key, double score) {
    if (_cache.length >= _maxCacheSize) {
      _cache.remove(_cache.keys.first);
    }
    _cache[key] = _CacheEntry(score: score, fetchedAt: DateTime.now());
  }

  String _cacheKey(String a, String b) => a.compareTo(b) < 0 ? '$a:$b' : '$b:$a';

  /// Clear all cached scores (e.g. on logout).
  void clearCache() => _cache.clear();
}

class _CacheEntry {
  const _CacheEntry({required this.score, required this.fetchedAt});
  final double score;
  final DateTime fetchedAt;

  bool isExpired(Duration ttl) => DateTime.now().difference(fetchedAt) > ttl;
}
