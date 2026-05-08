import 'package:flutter/foundation.dart';
import 'package:video_player/video_player.dart';
import '../models/memory.dart';

/// Video cache manager for preloading videos in The Line
/// Implements LRU cache with configurable size
class VideoCache {
  static const int _maxCacheSize = 5; // Keep 5 videos in memory
  final Map<String, VideoPlayerController> _cache = {};
  final List<String> _lruQueue = [];

  /// Preload video controllers for smooth playback
  Future<VideoPlayerController?> preload(Memory memory) async {
    final videoUrl = memory.videoUrl;
    
    // Return existing controller if cached
    if (_cache.containsKey(videoUrl)) {
      _updateLRU(videoUrl);
      return _cache[videoUrl];
    }
    
    try {
      // Create new controller
      final controller = videoUrl.startsWith('http')
          ? VideoPlayerController.networkUrl(Uri.parse(videoUrl))
          : VideoPlayerController.asset(videoUrl);
      
      await controller.initialize();
      controller.setLooping(true);
      
      // Add to cache
      _addToCache(videoUrl, controller);
      
      debugPrint('? Preloaded video: ${memory.id}');
      return controller;
      
    } catch (e) {
      debugPrint('? Failed to preload video: $e');
      return null;
    }
  }

  /// Preload multiple videos in batch (current + next 2)
  Future<void> preloadBatch(List<Memory> memories, int currentIndex) async {
    final startIndex = currentIndex;
    final endIndex = (currentIndex + 3).clamp(0, memories.length);
    
    for (int i = startIndex; i < endIndex; i++) {
      if (!_cache.containsKey(memories[i].videoUrl)) {
        await preload(memories[i]);
      }
    }
  }

  /// Get cached controller
  VideoPlayerController? get(String videoUrl) {
    if (_cache.containsKey(videoUrl)) {
      _updateLRU(videoUrl);
      return _cache[videoUrl];
    }
    return null;
  }

  /// Remove video from cache
  void remove(String videoUrl) {
    final controller = _cache.remove(videoUrl);
    _lruQueue.remove(videoUrl);
    controller?.dispose();
  }

  /// Clear all cached videos
  void clearAll() {
    for (final controller in _cache.values) {
      controller.dispose();
    }
    _cache.clear();
    _lruQueue.clear();
  }

  /// Dispose controller when far from view
  void disposeOldVideos(int currentIndex, List<Memory> memories) {
    for (int i = 0; i < memories.length; i++) {
      // Keep videos within ±3 positions
      if ((i - currentIndex).abs() > 3) {
        final videoUrl = memories[i].videoUrl;
        if (_cache.containsKey(videoUrl)) {
          remove(videoUrl);
          debugPrint('??? Disposed old video: ${memories[i].id}');
        }
      }
    }
  }

  void _addToCache(String videoUrl, VideoPlayerController controller) {
    // Evict oldest if cache is full
    if (_cache.length >= _maxCacheSize) {
      final oldest = _lruQueue.first;
      remove(oldest);
    }
    
    _cache[videoUrl] = controller;
    _lruQueue.add(videoUrl);
  }

  void _updateLRU(String videoUrl) {
    _lruQueue.remove(videoUrl);
    _lruQueue.add(videoUrl);
  }

  /// Get cache statistics
  Map<String, dynamic> getStats() {
    return {
      'cached_videos': _cache.length,
      'max_size': _maxCacheSize,
      'cache_keys': _lruQueue,
    };
  }
}
