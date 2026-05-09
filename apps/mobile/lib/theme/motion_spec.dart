import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'colors.dart';

/// PRD Addendum 1.0 -- Immutable Motion System.
///
/// All color/state animations MUST use KinnectMotion tokens.
/// Lint rule: `no_hardcoded_animations` fails if Duration/Curve used directly.
class KinnectMotion {
  KinnectMotion._();

  // ---------------------------------------------------------------------------
  // Easing curves (all animations must use these -- no custom curves)
  // ---------------------------------------------------------------------------

  /// Material standard: fast out, slow in.
  static const standardEasing = Curves.fastOutSlowIn;

  /// Celebratory moments: Bloom complete, Kinnection confirmed.
  static const emphasisEasing = Curves.elasticInOut;

  /// Dismissals, transitions out.
  static const decelerateEasing = Curves.decelerate;

  // ---------------------------------------------------------------------------
  // Duration tokens
  // ---------------------------------------------------------------------------

  /// Icon color shifts, small state changes.
  static const durationMicro = Duration(milliseconds: 100);

  /// Button presses, tab switches.
  static const durationStandard = Duration(milliseconds: 200);

  /// Bloom render complete, Kin Score threshold crossed.
  static const durationEmphasis = Duration(milliseconds: 300);

  /// Screen transitions, Branch Map load.
  static const durationMacro = Duration(milliseconds: 500);

  // ---------------------------------------------------------------------------
  // Kin Score badge animation (PRD Addendum 3.0 S1 color thresholds)
  // ---------------------------------------------------------------------------

  /// Animated Kin Score badge with color transitions.
  /// Thresholds: >=80 -> #FF6B1A, 50-79 -> #00C2D4, <50 -> #B0B0D0 @60%
  static Widget animateKinScoreBadge({required double score, required Widget child}) {
    final targetColor = score >= 80
        ? KinnectColors.accent
        : score >= 50
            ? KinnectColors.primary
            : KinnectColors.textSecondary.withOpacity(0.6);

    return AnimatedContainer(
      duration: durationEmphasis,
      curve: emphasisEasing,
      decoration: BoxDecoration(
        color: targetColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: score >= 80
            ? [BoxShadow(color: KinnectColors.accent.withOpacity(0.4), blurRadius: 8)]
            : [],
      ),
      child: child,
    );
  }

  // ---------------------------------------------------------------------------
  // Pulse icon amber burst animation
  // ---------------------------------------------------------------------------

  /// Pulse icon scale + color burst on double-tap.
  static Widget animatePulseBurst({required bool isPulsed, required Widget icon}) {
    return AnimatedScale(
      scale: isPulsed ? 1.2 : 1.0,
      duration: durationMicro,
      curve: standardEasing,
      child: AnimatedDefaultTextStyle(
        style: TextStyle(
          color: isPulsed ? KinnectColors.accent : KinnectColors.textPrimary,
          fontSize: 24,
        ),
        duration: durationMicro,
        child: icon,
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Reduced motion compliance
  // ---------------------------------------------------------------------------

  /// Respect platform reduced-motion accessibility setting.
  /// MediaQuery.of(context).disableAnimations == true -> auto-pause.
  static bool get respectReducedMotion {
    try {
      return WidgetsBinding.instance.platformDispatcher.accessibilityFeatures.reduceMotion;
    } catch (_) {
      return false;
    }
  }

  /// Returns Duration.zero if reduced motion is enabled, otherwise standard.
  static Duration get adaptiveDuration => respectReducedMotion ? Duration.zero : durationStandard;

  /// Returns Duration.zero if reduced motion, otherwise the provided duration.
  static Duration adaptive(Duration duration) => respectReducedMotion ? Duration.zero : duration;
}
