import 'package:flutter/foundation.dart';

/// Performance SLA enforcement (Addendum 2.0 S9).
///
/// | Metric              | Target          |
/// |---------------------|-----------------|
/// | Cold Start          | < 2.0s          |
/// | Feed p99 Load       | < 100ms (cache) / < 300ms (network) |
/// | Video First Frame   | < 1.5s          |
/// | Memory Baseline     | < 150MB         |
/// | Frame Rate          | 60fps UI / 30fps video |
/// | BLoC State Updates  | < 16ms          |
class PerformanceSLA {
  PerformanceSLA._();

  static final _violations = <SLAViolation>[];
  static DateTime? _coldStartBegin;

  // ---------------------------------------------------------------------------
  // SLA thresholds (in milliseconds)
  // ---------------------------------------------------------------------------

  static const int coldStartMs = 2000;
  static const int feedCacheMs = 100;
  static const int feedNetworkMs = 300;
  static const int videoFirstFrameMs = 1500;
  static const int memoryBaselineMB = 150;
  static const double targetFps = 60.0;
  static const int blocUpdateMs = 16;

  // ---------------------------------------------------------------------------
  // Cold start tracking
  // ---------------------------------------------------------------------------

  /// Call at very start of main().
  static void markColdStartBegin() {
    _coldStartBegin = DateTime.now();
  }

  /// Call when first frame is rendered.
  static void markColdStartEnd() {
    if (_coldStartBegin == null) return;
    final elapsed = DateTime.now().difference(_coldStartBegin!);
    _coldStartBegin = null;

    if (elapsed.inMilliseconds > coldStartMs) {
      _report(SLAViolation(
        metric: 'cold_start',
        threshold: coldStartMs,
        actual: elapsed.inMilliseconds,
        message: 'Cold start took ${elapsed.inMilliseconds}ms (SLA: <${coldStartMs}ms)',
      ));
    } else {
      debugPrint('[PerfSLA] Cold start: ${elapsed.inMilliseconds}ms (OK)');
    }
  }

  // ---------------------------------------------------------------------------
  // Feed load tracking
  // ---------------------------------------------------------------------------

  static void checkFeedLoad(Duration duration, {required bool fromCache}) {
    final threshold = fromCache ? feedCacheMs : feedNetworkMs;
    if (duration.inMilliseconds > threshold) {
      _report(SLAViolation(
        metric: fromCache ? 'feed_cache_load' : 'feed_network_load',
        threshold: threshold,
        actual: duration.inMilliseconds,
        message: 'Feed load took ${duration.inMilliseconds}ms (SLA: <${threshold}ms, ${fromCache ? "cache" : "network"})',
      ));
    }
  }

  // ---------------------------------------------------------------------------
  // Video first frame
  // ---------------------------------------------------------------------------

  static void checkVideoFirstFrame(Duration duration) {
    if (duration.inMilliseconds > videoFirstFrameMs) {
      _report(SLAViolation(
        metric: 'video_first_frame',
        threshold: videoFirstFrameMs,
        actual: duration.inMilliseconds,
        message: 'Video first frame took ${duration.inMilliseconds}ms (SLA: <${videoFirstFrameMs}ms)',
      ));
    }
  }

  // ---------------------------------------------------------------------------
  // BLoC state update
  // ---------------------------------------------------------------------------

  static void checkBlocUpdate(String blocName, Duration duration) {
    if (duration.inMilliseconds > blocUpdateMs) {
      _report(SLAViolation(
        metric: 'bloc_update',
        threshold: blocUpdateMs,
        actual: duration.inMilliseconds,
        message: '$blocName state update took ${duration.inMilliseconds}ms (SLA: <${blocUpdateMs}ms)',
      ));
    }
  }

  // ---------------------------------------------------------------------------
  // Frame rate monitoring
  // ---------------------------------------------------------------------------

  static int _frameDropCount = 0;

  /// Call from WidgetsBinding.addPostFrameCallback to track jank.
  static void trackFrame(Duration frameDuration) {
    // 60fps = 16.67ms per frame. Anything over 32ms is a frame drop.
    if (frameDuration.inMilliseconds > 32) {
      _frameDropCount++;
      if (_frameDropCount % 5 == 0) {
        debugPrint('[PerfSLA] Frame drops: $_frameDropCount (${frameDuration.inMilliseconds}ms last frame)');
      }
    }
  }

  /// Get total frame drop count.
  static int get frameDropCount => _frameDropCount;

  // ---------------------------------------------------------------------------
  // Violation reporting
  // ---------------------------------------------------------------------------

  static void _report(SLAViolation violation) {
    _violations.add(violation);
    debugPrint('[PerfSLA VIOLATION] ${violation.message}');
  }

  /// Get all violations (for debug screen / CI reporting).
  static List<SLAViolation> get violations => List.unmodifiable(_violations);

  /// Clear violations.
  static void clearViolations() => _violations.clear();

  /// Summary for logging.
  static String summary() {
    if (_violations.isEmpty) return 'No SLA violations';
    final byMetric = <String, int>{};
    for (final v in _violations) {
      byMetric[v.metric] = (byMetric[v.metric] ?? 0) + 1;
    }
    return 'SLA violations: ${_violations.length} total -- ${byMetric.entries.map((e) => '${e.key}:${e.value}').join(', ')}';
  }
}

class SLAViolation {
  SLAViolation({
    required this.metric,
    required this.threshold,
    required this.actual,
    required this.message,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();

  final String metric;
  final int threshold;
  final int actual;
  final String message;
  final DateTime timestamp;
}
