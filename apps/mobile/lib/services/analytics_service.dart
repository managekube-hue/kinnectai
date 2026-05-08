import 'package:flutter/foundation.dart';

/// Analytics service for tracking user events
/// TODO: Integrate with Firebase Analytics, Mixpanel, or your preferred analytics platform
class AnalyticsService {
  static final AnalyticsService _instance = AnalyticsService._internal();
  
  factory AnalyticsService() {
    return _instance;
  }
  
  AnalyticsService._internal();

  /// Track a custom event
  Future<void> trackEvent(
    String eventName, [
    Map<String, dynamic>? properties,
  ]) async {
    if (kDebugMode) {
      debugPrint('?? Analytics Event: $eventName');
      if (properties != null && properties.isNotEmpty) {
        debugPrint('   Properties: $properties');
      }
    }
    
    // TODO: Implement actual analytics tracking
    // Example integrations:
    // - Firebase Analytics: await FirebaseAnalytics.instance.logEvent(name: eventName, parameters: properties);
    // - Mixpanel: Mixpanel.track(eventName, properties);
    // - Amplitude: Amplitude.getInstance().logEvent(eventName, eventProperties: properties);
  }

  /// Track screen view
  Future<void> trackScreenView(String screenName) async {
    await trackEvent('screen_view', {'screen_name': screenName});
  }

  /// Track authentication events
  Future<void> trackAuthWelcomeViewed({
    required String deviceType,
    required String appVersion,
    required bool firstLaunch,
  }) async {
    await trackEvent('auth_welcome_viewed', {
      'device_type': deviceType,
      'app_version': appVersion,
      'first_launch': firstLaunch,
    });
  }

  // === The Line Feed Analytics ===

  /// Track video view
  Future<void> trackVideoViewed({
    required String memoryId,
    required String creatorId,
    required double kinScore,
    required int durationSeconds,
    required double watchPercentage,
  }) async {
    await trackEvent('line_video_viewed', {
      'memory_id': memoryId,
      'creator_id': creatorId,
      'kin_score': kinScore,
      'duration_seconds': durationSeconds,
      'watch_percentage': watchPercentage,
    });
  }

  /// Track pulse (like) action
  Future<void> trackPulse({
    required String memoryId,
    required String creatorId,
    required bool isPulsed,
    required String source, // 'button' or 'double_tap'
  }) async {
    await trackEvent('line_pulse', {
      'memory_id': memoryId,
      'creator_id': creatorId,
      'action': isPulsed ? 'add' : 'remove',
      'source': source,
    });
  }

  /// Track comment action
  Future<void> trackCommentOpened({
    required String memoryId,
    required String creatorId,
  }) async {
    await trackEvent('line_comment_opened', {
      'memory_id': memoryId,
      'creator_id': creatorId,
    });
  }

  /// Track save/strand action
  Future<void> trackSave({
    required String memoryId,
    required String creatorId,
    required bool isSaved,
    String? strandId,
  }) async {
    await trackEvent('line_save', {
      'memory_id': memoryId,
      'creator_id': creatorId,
      'action': isSaved ? 'add' : 'remove',
      'strand_id': ?strandId,
    });
  }

  /// Track share action
  Future<void> trackShare({
    required String memoryId,
    required String creatorId,
    required String shareType, // 'branch', 'kin', 'copy'
  }) async {
    await trackEvent('line_share', {
      'memory_id': memoryId,
      'creator_id': creatorId,
      'share_type': shareType,
    });
  }

  /// Track Kin Score detail view
  Future<void> trackKinScoreDetailViewed({
    required String targetUserId,
    required double kinScore,
  }) async {
    await trackEvent('kin_score_detail_viewed', {
      'target_user_id': targetUserId,
      'kin_score': kinScore,
    });
  }

  /// Track feed refresh
  Future<void> trackFeedRefresh({
    required String feedTab,
  }) async {
    await trackEvent('line_feed_refresh', {
      'feed_tab': feedTab,
    });
  }

  /// Track feed scroll depth
  Future<void> trackFeedScrollDepth({
    required int videoIndex,
    required int totalVideos,
  }) async {
    await trackEvent('line_feed_scroll', {
      'video_index': videoIndex,
      'total_videos': totalVideos,
      'scroll_percentage': ((videoIndex / totalVideos) * 100).toInt(),
    });
  }

  Future<void> trackAuthButtonTapped(String method) async {
    await trackEvent('auth_button_tapped', {
      'method': method,
      'timestamp': DateTime.now().toIso8601String(),
    });
  }

  Future<void> trackAuthOAuthStarted({
    required String provider,
    required String sessionId,
  }) async {
    await trackEvent('auth_oauth_started', {
      'provider': provider,
      'session_id': sessionId,
    });
  }

  Future<void> trackAuthOAuthCompleted({
    required String provider,
    required int durationMs,
    required bool success,
    String? errorCode,
  }) async {
    await trackEvent('auth_oauth_completed', {
      'provider': provider,
      'duration_ms': durationMs,
      'success': success,
      'error_code': ?errorCode,
    });
  }

  Future<void> trackAuthEmailInitiated() async {
    await trackEvent('auth_email_initiated');
  }

  Future<void> trackAuthLegalLinkViewed({
    required String documentType,
    required int durationSeconds,
  }) async {
    await trackEvent('auth_legal_link_viewed', {
      'document_type': documentType,
      'duration_seconds': durationSeconds,
    });
  }

  /// Set user properties
  Future<void> setUserId(String userId) async {
    if (kDebugMode) {
      debugPrint('?? Analytics: Set User ID: $userId');
    }
    
    // TODO: Implement user ID setting
    // Example: await FirebaseAnalytics.instance.setUserId(id: userId);
  }

  Future<void> setUserProperty(String key, String value) async {
    if (kDebugMode) {
      debugPrint('?? Analytics: Set User Property: $key = $value');
    }
    
    // TODO: Implement user property setting
    // Example: await FirebaseAnalytics.instance.setUserProperty(name: key, value: value);
  }

  /// Clear user data (on logout)
  Future<void> clearUserData() async {
    if (kDebugMode) {
      debugPrint('?? Analytics: Clear User Data');
    }
    
    // TODO: Implement user data clearing
    // Example: await FirebaseAnalytics.instance.resetAnalyticsData();
  }
}
