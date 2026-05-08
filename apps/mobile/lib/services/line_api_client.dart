import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../models/memory.dart';
import '../utils/error_handler.dart';
import '../utils/performance_monitor.dart';

/// API client for The Line backend integration
class LineApiClient {
  late final Dio _dio;
  final String baseUrl;
  
  LineApiClient({
    required this.baseUrl,
    String? authToken,
  }) {
    _dio = Dio(BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 30),
      headers: {
        'Content-Type': 'application/json',
        if (authToken != null) 'Authorization': 'Bearer $authToken',
      },
    ));
    
    // Add interceptors for logging
    if (kDebugMode) {
      _dio.interceptors.add(LogInterceptor(
        requestBody: true,
        responseBody: true,
        error: true,
      ));
    }
  }

  /// Get The Line feed from backend
  /// GET /api/v1/line/feed?tab={tab}&limit={limit}&cursor={cursor}
  Future<Result<List<Memory>>> getFeed({
    required String userId,
    String tab = 'all',
    int limit = 20,
    String? cursor,
  }) async {
    try {
      final response = await PerformanceMonitor.measureAsync(
        PerformanceMonitor.feedLoad,
        () => NetworkErrorHandler.executeWithRetry(
          request: () => _dio.get(
            '/api/v1/line/feed',
            queryParameters: {
              'user_id': userId,
              'tab': tab,
              'limit': limit,
              'cursor': ?cursor,
            },
          ),
          shouldRetry: NetworkErrorHandler.isRetryable,
        ),
      );

      final List<dynamic> items = response.data['items'] ?? [];
      final memories = items
          .map((json) => Memory.fromJson(json as Map<String, dynamic>))
          .toList();

      return Result.success(memories);
      
    } catch (e) {
      debugPrint('? API Error (getFeed): $e');
      return Result.failure(NetworkErrorHandler.getUserMessage(e));
    }
  }

  /// Toggle pulse (like) on a memory
  /// POST /api/v1/memories/{memoryId}/pulse
  Future<Result<bool>> togglePulse({
    required String memoryId,
    required bool isPulsed,
  }) async {
    try {
      final response = await PerformanceMonitor.measureAsync(
        PerformanceMonitor.pulseAction,
        () => NetworkErrorHandler.executeWithRetry(
          request: () => _dio.post(
            '/api/v1/memories/$memoryId/pulse',
            data: {'is_pulsed': isPulsed},
          ),
          shouldRetry: NetworkErrorHandler.isRetryable,
        ),
      );

      return Result.success(response.data['success'] ?? true);
      
    } catch (e) {
      debugPrint('? API Error (togglePulse): $e');
      return Result.failure(NetworkErrorHandler.getUserMessage(e));
    }
  }

  /// Save memory to a strand
  /// POST /api/v1/memories/{memoryId}/save
  Future<Result<bool>> saveMemory({
    required String memoryId,
    String? strandId,
  }) async {
    try {
      final response = await _dio.post(
        '/api/v1/memories/$memoryId/save',
        data: {
          'strand_id': ?strandId,
        },
      );

      return Result.success(response.data['success'] ?? true);
      
    } catch (e) {
      debugPrint('? API Error (saveMemory): $e');
      return Result.failure(NetworkErrorHandler.getUserMessage(e));
    }
  }

  /// Unsave memory
  /// DELETE /api/v1/memories/{memoryId}/save
  Future<Result<bool>> unsaveMemory({
    required String memoryId,
  }) async {
    try {
      final response = await _dio.delete(
        '/api/v1/memories/$memoryId/save',
      );

      return Result.success(response.data['success'] ?? true);
      
    } catch (e) {
      debugPrint('? API Error (unsaveMemory): $e');
      return Result.failure(NetworkErrorHandler.getUserMessage(e));
    }
  }

  /// Get comments for a memory
  /// GET /api/v1/memories/{memoryId}/comments
  Future<Result<List<dynamic>>> getComments({
    required String memoryId,
    int limit = 50,
    String? cursor,
  }) async {
    try {
      final response = await PerformanceMonitor.measureAsync(
        PerformanceMonitor.commentLoad,
        () => _dio.get(
          '/api/v1/memories/$memoryId/comments',
          queryParameters: {
            'limit': limit,
            'cursor': ?cursor,
          },
        ),
      );

      final List<dynamic> comments = response.data['comments'] ?? [];
      return Result.success(comments);
      
    } catch (e) {
      debugPrint('? API Error (getComments): $e');
      return Result.failure(NetworkErrorHandler.getUserMessage(e));
    }
  }

  /// Compute Kin Score for user pair
  /// GET /api/v1/kin-score?from={fromUserId}&to={toUserId}
  Future<Result<Map<String, dynamic>>> computeKinScore({
    required String fromUserId,
    required String toUserId,
  }) async {
    try {
      final response = await PerformanceMonitor.measureAsync(
        PerformanceMonitor.kinScoreCompute,
        () => _dio.get(
          '/api/v1/kin-score',
          queryParameters: {
            'from': fromUserId,
            'to': toUserId,
          },
        ),
      );

      return Result.success(response.data as Map<String, dynamic>);
      
    } catch (e) {
      debugPrint('? API Error (computeKinScore): $e');
      return Result.failure(NetworkErrorHandler.getUserMessage(e));
    }
  }

  /// Record video view
  /// POST /api/v1/memories/{memoryId}/view
  Future<void> recordView({
    required String memoryId,
    required double watchPercentage,
    required Duration watchDuration,
  }) async {
    try {
      await _dio.post(
        '/api/v1/memories/$memoryId/view',
        data: {
          'watch_percentage': watchPercentage,
          'watch_duration_seconds': watchDuration.inSeconds,
        },
      );
    } catch (e) {
      debugPrint('?? Failed to record view: $e');
      // Don't fail on analytics errors
    }
  }

  /// Share memory
  /// POST /api/v1/memories/{memoryId}/share
  Future<Result<Map<String, dynamic>>> shareMemory({
    required String memoryId,
    required String shareType, // 'branch', 'kin', 'copy'
  }) async {
    try {
      final response = await _dio.post(
        '/api/v1/memories/$memoryId/share',
        data: {
          'share_type': shareType,
        },
      );

      return Result.success(response.data as Map<String, dynamic>);
      
    } catch (e) {
      debugPrint('? API Error (shareMemory): $e');
      return Result.failure(NetworkErrorHandler.getUserMessage(e));
    }
  }
}
