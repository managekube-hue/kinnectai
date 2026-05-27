import 'package:flutter/material.dart';

/// Performance monitoring for The Line feed
class PerformanceMonitor {
  static final Map<String, DateTime> _startTimes = {};
  static final Map<String, List<Duration>> _metrics = {};

  /// Start tracking a performance metric
  static void start(String metric) {
    _startTimes[metric] = DateTime.now();
  }

  /// Stop tracking and record the duration
  static Duration? stop(String metric) {
    final startTime = _startTimes.remove(metric);
    if (startTime == null) {
      debugPrint('?? Performance metric "$metric" was not started');
      return null;
    }

    final duration = DateTime.now().difference(startTime);
    
    // Store metric
    _metrics.putIfAbsent(metric, () => []);
    _metrics[metric]!.add(duration);

    // Log if slow
    if (duration.inMilliseconds > 100) {
      debugPrint('?? SLOW: $metric took ${duration.inMilliseconds}ms');
    } else {
      debugPrint('? $metric took ${duration.inMilliseconds}ms');
    }

    return duration;
  }

  /// Measure a synchronous function
  static T measure<T>(String metric, T Function() function) {
    start(metric);
    try {
      return function();
    } finally {
      stop(metric);
    }
  }

  /// Measure an asynchronous function
  static Future<T> measureAsync<T>(
    String metric,
    Future<T> Function() function,
  ) async {
    start(metric);
    try {
      return await function();
    } finally {
      stop(metric);
    }
  }

  /// Get statistics for a metric
  static Map<String, dynamic>? getStats(String metric) {
    final durations = _metrics[metric];
    if (durations == null || durations.isEmpty) return null;

    final milliseconds = durations.map((d) => d.inMilliseconds).toList()..sort();
    final sum = milliseconds.reduce((a, b) => a + b);
    final avg = sum / milliseconds.length;
    final p50 = milliseconds[milliseconds.length ~/ 2];
    final p95 = milliseconds[(milliseconds.length * 0.95).floor()];
    final p99 = milliseconds[(milliseconds.length * 0.99).floor()];

    return {
      'metric': metric,
      'count': milliseconds.length,
      'avg': avg.toStringAsFixed(2),
      'min': milliseconds.first,
      'max': milliseconds.last,
      'p50': p50,
      'p95': p95,
      'p99': p99,
    };
  }

  /// Get all metrics statistics
  static Map<String, Map<String, dynamic>> getAllStats() {
    final stats = <String, Map<String, dynamic>>{};
    for (final metric in _metrics.keys) {
      final metricStats = getStats(metric);
      if (metricStats != null) {
        stats[metric] = metricStats;
      }
    }
    return stats;
  }

  /// Print all metrics to console
  static void printAllStats() {
    final stats = getAllStats();
    if (stats.isEmpty) {
      debugPrint('?? No performance metrics recorded');
      return;
    }

    debugPrint('?? Performance Metrics:');
    debugPrint('?' * 80);
    debugPrint('Metric                     Count   Avg    Min    P50    P95    P99    Max');
    debugPrint('?' * 80);
    
    for (final entry in stats.entries) {
      final metric = entry.key;
      final data = entry.value;
      debugPrint(
        '${metric.padRight(25)} '
        '${data['count'].toString().padLeft(5)} '
        '${data['avg'].toString().padLeft(6)}ms '
        '${data['min'].toString().padLeft(5)}ms '
        '${data['p50'].toString().padLeft(5)}ms '
        '${data['p95'].toString().padLeft(5)}ms '
        '${data['p99'].toString().padLeft(5)}ms '
        '${data['max'].toString().padLeft(5)}ms',
      );
    }
    debugPrint('?' * 80);
  }

  /// Clear all metrics
  static void clear() {
    _startTimes.clear();
    _metrics.clear();
  }

  // === Predefined metrics for The Line ===

  static const String feedLoad = 'line_feed_load';
  static const String feedRefresh = 'line_feed_refresh';
  static const String videoInit = 'line_video_init';
  static const String videoPreload = 'line_video_preload';
  static const String kinScoreCompute = 'line_kin_score_compute';
  static const String pulseAction = 'line_pulse_action';
  static const String commentLoad = 'line_comment_load';
  static const String pageTransition = 'line_page_transition';
}

/// Widget to automatically track build performance
class PerformanceTracker extends StatelessWidget {
  final String metricName;
  final Widget child;

  const PerformanceTracker({
    super.key,
    required this.metricName,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        PerformanceMonitor.start('$metricName.build');
        
        // Schedule stop after frame renders
        WidgetsBinding.instance.addPostFrameCallback((_) {
          PerformanceMonitor.stop('$metricName.build');
        });
        
        return child;
      },
    );
  }
}
