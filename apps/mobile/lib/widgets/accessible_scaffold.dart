import 'package:flutter/material.dart';

import '../utils/accessibility_helpers.dart';
import 'app_error_boundary.dart';

/// Global accessibility wrapper applied to every route via MaterialApp.builder.
///
/// Provides:
/// - FocusTraversalGroup (ordered traversal per Addendum 2.0 S7)
/// - Semantics tree structure
/// - Reduced motion detection
/// - AppErrorBoundary (snackbar/banner/full-screen errors)
/// - Offline banner when disconnected
class AccessibleApp extends StatelessWidget {
  const AccessibleApp({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return FocusTraversalGroup(
      policy: OrderedTraversalPolicy(),
      child: Semantics(
        label: 'KinnectAI',
        child: MediaQuery(
          // Enforce minimum text scale for accessibility
          data: MediaQuery.of(context).copyWith(
            textScaler: TextScaler.linear(
              MediaQuery.of(context).textScaler.scale(1.0).clamp(1.0, 1.5),
            ),
          ),
          child: AppErrorBoundary(child: child),
        ),
      ),
    );
  }
}

/// Mixin for screens that need accessibility features wired in.
/// Apply to State classes to get reduced motion, contrast checks.
mixin AccessibleScreenMixin<T extends StatefulWidget> on State<T> {
  /// Whether the user prefers reduced motion.
  bool get reducedMotion => A11y.prefersReducedMotion(context);

  /// Get duration respecting reduced motion preference.
  Duration adaptDuration(Duration d) => A11y.adaptiveDuration(context, d);

  /// Check if a color pair meets WCAG AA contrast.
  bool checkContrast(Color fg, Color bg, {bool isLargeText = false}) {
    return A11y.meetsContrastAA(foreground: fg, background: bg, isLargeText: isLargeText);
  }
}
