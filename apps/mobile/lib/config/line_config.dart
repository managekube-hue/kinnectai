/// Configuration constants for The Line feature
class LineConfig {
  // Feed Settings
  static const int defaultFeedPageSize = 20;
  static const int preloadVideoCount = 3;
  static const int maxCachedVideos = 5;
  static const Duration feedCacheExpiry = Duration(minutes: 5);

  // Video Settings
  static const Duration videoLoadTimeout = Duration(seconds: 10);
  static const Duration doubleTapWindow = Duration(milliseconds: 300);
  static const double minSwipeVelocity = 300.0;
  static const double minSwipeDistance = 50.0;

  // Performance Thresholds
  static const int slowLoadThresholdMs = 500;
  static const int videoInitThresholdMs = 2000;
  static const Duration animationDuration = Duration(milliseconds: 300);

  // Analytics
  static const double minWatchPercentageToTrack = 0.05; // 5%
  static const Duration viewCountDebounce = Duration(seconds: 3);

  // Network
  static const int maxRetries = 3;
  static const Duration retryDelay = Duration(seconds: 2);
  static const Duration apiTimeout = Duration(seconds: 30);

  // UI
  static const double pulseIconSize = 32.0;
  static const double kinScoreBadgeSize = 60.0;
  static const double rightRailButtonSize = 48.0;
  static const double bottomOverlayHeight = 180.0;

  // Colors (Kin Score ranges)
  static const double kinScoreHighThreshold = 0.85; // Green
  static const double kinScoreMediumThreshold = 0.50; // Amber
  // Below medium is Red

  // Feature Flags
  static const bool enableVideoCache = true;
  static const bool enableAnalytics = true;
  static const bool enablePerformanceMonitoring = true;
  static const bool enableDoubleTapPulse = true;
  static const bool enableAutoplay = true;
  static const bool enableVideoLooping = true;

  // Debug
  static const bool showDebugOverlay = false;
  static const bool logPerformanceMetrics = true;
  static const bool mockVideos = false; // Use placeholder videos in dev
}

/// Environment-specific configuration
enum Environment {
  development,
  staging,
  production,
}

class EnvironmentConfig {
  final Environment environment;
  final String apiBaseUrl;
  final String wsBaseUrl;
  final String redisHost;
  final bool enableLogging;
  final bool enableCrashlytics;

  const EnvironmentConfig({
    required this.environment,
    required this.apiBaseUrl,
    required this.wsBaseUrl,
    required this.redisHost,
    this.enableLogging = true,
    this.enableCrashlytics = false,
  });

  static const development = EnvironmentConfig(
    environment: Environment.development,
    apiBaseUrl: 'http://localhost:3000',
    wsBaseUrl: 'ws://localhost:3000',
    redisHost: 'localhost:6379',
    enableLogging: true,
    enableCrashlytics: false,
  );

  static const staging = EnvironmentConfig(
    environment: Environment.staging,
    apiBaseUrl: 'https://staging-api.kinnect.ai',
    wsBaseUrl: 'wss://staging-api.kinnect.ai',
    redisHost: 'staging-redis.kinnect.ai:6379',
    enableLogging: true,
    enableCrashlytics: true,
  );

  static const production = EnvironmentConfig(
    environment: Environment.production,
    apiBaseUrl: 'https://api.kinnect.ai',
    wsBaseUrl: 'wss://api.kinnect.ai',
    redisHost: 'prod-redis.kinnect.ai:6379',
    enableLogging: false,
    enableCrashlytics: true,
  );

  bool get isDevelopment => environment == Environment.development;
  bool get isStaging => environment == Environment.staging;
  bool get isProduction => environment == Environment.production;
}
