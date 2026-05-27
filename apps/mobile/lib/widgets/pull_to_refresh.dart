import 'package:flutter/material.dart';
import '../theme/colors.dart';

/// Custom pull-to-refresh indicator for The Line
class LinePullToRefresh extends StatelessWidget {
  final Widget child;
  final Future<void> Function() onRefresh;
  final Color? color;
  final Color? backgroundColor;

  const LinePullToRefresh({
    super.key,
    required this.child,
    required this.onRefresh,
    this.color,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: onRefresh,
      color: color ?? KinnectColors.accent,
      backgroundColor: backgroundColor ?? KinnectColors.surface,
      strokeWidth: 2.5,
      displacement: 60,
      child: child,
    );
  }
}

/// Sparkle refresh indicator (matches welcome screen aesthetic)
class SparkleRefreshIndicator extends StatefulWidget {
  final Widget child;
  final Future<void> Function() onRefresh;

  const SparkleRefreshIndicator({
    super.key,
    required this.child,
    required this.onRefresh,
  });

  @override
  State<SparkleRefreshIndicator> createState() => _SparkleRefreshIndicatorState();
}

class _SparkleRefreshIndicatorState extends State<SparkleRefreshIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _handleRefresh() async {
    _controller.repeat();
    try {
      await widget.onRefresh();
    } finally {
      _controller.stop();
      _controller.reset();
    }
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _handleRefresh,
      color: Colors.transparent,
      backgroundColor: Colors.transparent,
      strokeWidth: 0,
      displacement: 60,
      child: widget.child,
      // Custom indicator builder
      notificationPredicate: (notification) {
        return notification.depth == 0;
      },
    );
  }
}

/// Loading shimmer for feed items
class FeedLoadingShimmer extends StatefulWidget {
  const FeedLoadingShimmer({super.key});

  @override
  State<FeedLoadingShimmer> createState() => _FeedLoadingShimmerState();
}

class _FeedLoadingShimmerState extends State<FeedLoadingShimmer>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                KinnectColors.background,
                KinnectColors.surface.withOpacity(0.5),
                KinnectColors.background,
              ],
              stops: [
                _controller.value - 0.3,
                _controller.value,
                _controller.value + 0.3,
              ].map((v) => v.clamp(0.0, 1.0)).toList(),
            ),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.auto_awesome,
                  size: 48,
                  color: KinnectColors.accent.withOpacity(0.3),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Loading your feed...',
                  style: TextStyle(
                    color: KinnectColors.textSecondary,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
