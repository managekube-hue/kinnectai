import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/memory.dart';

/// Feed service for loading The Line (PRD Section 01.1)
/// Handles Redis cache ? PostgreSQL fallback pattern
class FeedService {
  // TODO: Replace with actual dio HTTP client
  // final Dio _dio;
  // final WebSocketChannel _ws;
  
  static const String _cacheKeyPrefix = 'feed:';
  static const Duration _cacheExpiry = Duration(minutes: 5);

  /// Get The Line feed for a user
  /// Priority: Redis cache (p99 <100ms) ? Live KC computation fallback
  Future<List<Memory>> getLine(
    String userId, {
    LineTab tab = LineTab.all,
    int limit = 20,
    String? cursor,
  }) async {
    try {
      // 1. Try local cache first (simulating Redis)
      final cached = await _getCachedFeed(userId, tab);
      if (cached != null && cached.isNotEmpty) {
        debugPrint('?? Feed loaded from cache (${cached.length} items)');
        return cached;
      }
      
      // 2. Fetch from API (simulating PostgreSQL + KC computation)
      debugPrint('?? Fetching feed from API...');
      final feed = await _fetchFeedFromAPI(userId, tab, limit, cursor);
      
      // 3. Cache the result
      await _cacheFeed(userId, tab, feed);
      
      return feed;
    } catch (e) {
      debugPrint('? Error loading feed: $e');
      // Return empty feed on error
      return [];
    }
  }

  /// Load next page of feed
  Future<List<Memory>> loadNext(String userId, String cursor, {LineTab tab = LineTab.all}) async {
    return getLine(userId, tab: tab, cursor: cursor);
  }

  /// Refresh feed (clear cache and reload)
  Future<List<Memory>> refreshFeed(String userId, {LineTab tab = LineTab.all}) async {
    await _clearCache(userId, tab);
    return getLine(userId, tab: tab);
  }

  Future<List<Memory>?> _getCachedFeed(String userId, LineTab tab) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final key = '${_cacheKeyPrefix}${userId}:${tab.name}';
      final cached = prefs.getString(key);
      
      if (cached == null) return null;
      
      final data = jsonDecode(cached) as Map<String, dynamic>;
      final timestamp = DateTime.parse(data['timestamp'] as String);
      
      // Check expiry
      if (DateTime.now().difference(timestamp) > _cacheExpiry) {
        await prefs.remove(key);
        return null;
      }
      
      final List<dynamic> items = data['items'] as List;
      return items.map((json) => Memory.fromJson(json)).toList();
    } catch (e) {
      debugPrint('Cache read error: $e');
      return null;
    }
  }

  Future<void> _cacheFeed(String userId, LineTab tab, List<Memory> feed) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final key = '${_cacheKeyPrefix}${userId}:${tab.name}';
      final data = {
        'timestamp': DateTime.now().toIso8601String(),
        'items': feed.map((m) => m.toJson()).toList(),
      };
      await prefs.setString(key, jsonEncode(data));
    } catch (e) {
      debugPrint('Cache write error: $e');
    }
  }

  Future<void> _clearCache(String userId, LineTab tab) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final key = '${_cacheKeyPrefix}${userId}:${tab.name}';
      await prefs.remove(key);
    } catch (e) {
      debugPrint('Cache clear error: $e');
    }
  }

  Future<List<Memory>> _fetchFeedFromAPI(
    String userId,
    LineTab tab,
    int limit,
    String? cursor,
  ) async {
    // TODO: Replace with actual API call
    // final response = await _dio.get(
    //   '/v1/line/$userId',
    //   queryParameters: {
    //     'tab': tab.name,
    //     'limit': limit,
    //     if (cursor != null) 'cursor': cursor,
    //   },
    // );
    // return (response.data as List).map((json) => Memory.fromJson(json)).toList();
    
    // For now, return sample data
    await Future.delayed(const Duration(milliseconds: 500));
    return _getSampleFeed();
  }

  List<Memory> _getSampleFeed() {
    return [
      Memory(
        id: '1',
        creatorId: 'elara_vance_id',
        creatorUsername: 'elara_vance',
        creatorDisplayName: 'Elara Vance',
        videoUrl: 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4',
        caption: 'Sharing Grandma\'s secret recipe for Elderberry Wine. Found this in the 1954 Vault. #FamilyHeritage',
        voiceprintLabel: 'Original Voiceprint · Elara Vance',
        pulseCount: 1200,
        commentCount: 84,
        kinScore: 0.92,
        branchId: 'vance_branch',
        branchName: 'Vance Family',
        createdAt: DateTime.now().subtract(const Duration(hours: 2)),
        duration: const Duration(seconds: 45),
      ),
      Memory(
        id: '2',
        creatorId: 'marcus_chen_id',
        creatorUsername: 'marcus_chen',
        creatorDisplayName: 'Marcus Chen',
        videoUrl: 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4',
        caption: 'Just discovered we\'re 5th cousins! The algorithm really is our bloodline ??',
        pulseCount: 856,
        commentCount: 42,
        kinScore: 0.78,
        createdAt: DateTime.now().subtract(const Duration(hours: 5)),
        duration: const Duration(seconds: 32),
      ),
      Memory(
        id: '3',
        creatorId: 'sarah_kim_id',
        creatorUsername: 'sarah_kim',
        creatorDisplayName: 'Sarah Kim',
        videoUrl: 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4',
        caption: 'Found my great-great-grandmother\'s journal from 1892. Her voice clone is incredible!',
        voiceprintLabel: 'Cloned Voiceprint · Margaret Kim (1892)',
        pulseCount: 2340,
        commentCount: 156,
        kinScore: 0.85,
        branchId: 'kim_branch',
        branchName: 'Kim Family',
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
        duration: const Duration(seconds: 52),
      ),
    ];
  }
}

/// Line feed tabs
enum LineTab {
  all,
  branch,
  echoes,
  saved,
}