import 'package:flutter/material.dart';

/// PRD Addendum 1.0 §5 — production palette only.
class KinnectColors {
  KinnectColors._();
  static const primary = Color(0xFF00C2D4);
  static const accent = Color(0xFFFF6B1A);
  static const accentLight = Color(0xFFFF8F4D);
  static const accentDark = Color(0xFFE55100);

  static const background = Color(0xFF0D0D2B);
  static const surface = Color(0xFF1A1A3A);
  static const surfaceElevated = Color(0xFF252548);

  static const textPrimary = Color(0xFFFFFFFF);
  static const textSecondary = Color(0xFFB0B0D0);

  static const success = Color(0xFF00D68F);
  static const error = Color(0xFFFF4D4D);
  static const warning = Color(0xFFFFA726);
  static const info = Color(0xFF29B6F6);

  /// Overlays and dividers derived from PRD text on navy.
  static const textHighEmphasis = Color(0xE6FFFFFF);
  static const textMediumEmphasis = Color(0xCCB0B0D0);
  static const textMuted = Color(0x66B0B0D0);
  static const dividerSubtle = Color(0x33B0B0D0);

  static const googleBlue = Color(0xFF4285F4);
  static const googleRed = Color(0xFFEA4335);
  static const facebookBlue = Color(0xFF1877F2);
  static const tiktokBlack = Color(0xFF000000);
  static const tiktokCyan = Color(0xFF00F2EA);
  static const tiktokPink = Color(0xFFFF0050);

  static const gradientStart = surface;
  static const gradientEnd = background;
}

