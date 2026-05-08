import 'package:flutter/material.dart';

/// Design system colors from JSON specification
class DesignColors {
  // Light Theme Colors
  static const Color lightPrimary = Color(0xFFA8B5A0);
  static const Color lightOnPrimary = Color(0xFFFAF7F2);
  static const Color lightSecondary = Color(0xFFD4A5A5);
  static const Color lightOnSecondary = Color(0xFFFAF7F2);
  static const Color lightAccent = Color(0xFFE8DCC4);
  static const Color lightBackground = Color(0xFFFAF7F2);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightOnSurface = Color(0xFF4A4A4A);
  static const Color lightPrimaryText = Color(0xFF2D302C);
  static const Color lightSecondaryText = Color(0xFF6B706A);
  static const Color lightHint = Color(0xFFC2C7C0);
  static const Color lightError = Color(0xFFBC6C74);
  static const Color lightOnError = Color(0xFFFAF7F2);
  static const Color lightSuccess = Color(0xFF8FA185);
  static const Color lightDivider = Color(0xFFE5E1DA);
  
  // Dark Theme Colors
  static const Color darkPrimary = Color(0xFF8A9981);
  static const Color darkOnPrimary = Color(0xFF000000);
  static const Color darkSecondary = Color(0xFFB58A8A);
  static const Color darkOnSecondary = Color(0xFF1A1C19);
  static const Color darkAccent = Color(0xFFD1C4AC);
  static const Color darkBackground = Color(0xFF1A1C19);
  static const Color darkSurface = Color(0xFF242723);
  static const Color darkOnSurface = Color(0xFFE2E5E0);
  static const Color darkPrimaryText = Color(0xFFFAF7F2);
  static const Color darkSecondaryText = Color(0xFFFAF7F2);
  static const Color darkHint = Color(0xFFA8B5A0);
  static const Color darkError = Color(0xFFD4A5A5);
  static const Color darkOnError = Color(0xFF1A1C19);
  static const Color darkSuccess = Color(0xFFA8B5A0);
  static const Color darkDivider = Color(0xFF2D302C);
  
  // Transparent
  static const Color transparent = Color(0x00000000);
  
  // Shadow colors
  static const Color shadowSm = Color(0x26A8B5A0);
  static const Color shadowMd = Color(0x33A8B5A0);
  static const Color shadowLg = Color(0x40A8B5A0);
  static const Color shadowXl = Color(0x4DA8B5A0);
}

/// Design system spacing values
class DesignSpacing {
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 16;
  static const double lg = 24;
  static const double xl = 32;
}

/// Design system border radii
class DesignRadii {
  static const double sm = 8;
  static const double md = 16;
  static const double lg = 24;
  static const double full = 9999;
}

/// Design system shadows
class DesignShadows {
  static List<BoxShadow> sm = [
    BoxShadow(
      color: DesignColors.shadowSm,
      offset: const Offset(0, 2),
      blurRadius: 4,
      spreadRadius: 0,
    ),
  ];
  
  static List<BoxShadow> md = [
    BoxShadow(
      color: DesignColors.shadowMd,
      offset: const Offset(0, 4),
      blurRadius: 8,
      spreadRadius: 0,
    ),
  ];
  
  static List<BoxShadow> lg = [
    BoxShadow(
      color: DesignColors.shadowLg,
      offset: const Offset(0, 8),
      blurRadius: 16,
      spreadRadius: 0,
    ),
  ];
  
  static List<BoxShadow> xl = [
    BoxShadow(
      color: DesignColors.shadowXl,
      offset: const Offset(0, 12),
      blurRadius: 24,
      spreadRadius: 0,
    ),
  ];
}

/// Design system text styles
class DesignTextStyles {
  // Google Fonts: Nunito (primary), DM Sans (secondary)
  static const String primaryFont = 'Nunito';
  static const String secondaryFont = 'DM Sans';
  
  static const TextStyle headlineLarge = TextStyle(
    fontFamily: primaryFont,
    fontSize: 32,
    fontWeight: FontWeight.w700,
    height: 1.2,
  );
  
  static const TextStyle headlineMedium = TextStyle(
    fontFamily: primaryFont,
    fontSize: 26,
    fontWeight: FontWeight.w600,
    height: 1.25,
  );
  
  static const TextStyle titleLarge = TextStyle(
    fontFamily: primaryFont,
    fontSize: 20,
    fontWeight: FontWeight.w600,
    height: 1.3,
  );
  
  static const TextStyle titleMedium = TextStyle(
    fontFamily: secondaryFont,
    fontSize: 17,
    fontWeight: FontWeight.w600,
    height: 1.4,
  );
  
  static const TextStyle bodyLarge = TextStyle(
    fontFamily: secondaryFont,
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 1.6,
  );
  
  static const TextStyle bodyMedium = TextStyle(
    fontFamily: secondaryFont,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 1.55,
  );
  
  static const TextStyle bodySmall = TextStyle(
    fontFamily: secondaryFont,
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 1.5,
  );
  
  static const TextStyle labelLarge = TextStyle(
    fontFamily: primaryFont,
    fontSize: 14,
    fontWeight: FontWeight.w600,
    height: 1.3,
  );
  
  static const TextStyle labelMedium = TextStyle(
    fontFamily: primaryFont,
    fontSize: 12,
    fontWeight: FontWeight.w600,
    height: 1.3,
  );
  
  static const TextStyle labelSmall = TextStyle(
    fontFamily: primaryFont,
    fontSize: 10,
    fontWeight: FontWeight.w700,
    height: 1.2,
  );
}

/// Helper to create ThemeData from design system
ThemeData createDesignTheme({bool isDark = true}) {
  final colors = isDark
      ? ColorScheme.dark(
          primary: DesignColors.darkPrimary,
          onPrimary: DesignColors.darkOnPrimary,
          secondary: DesignColors.darkSecondary,
          onSecondary: DesignColors.darkOnSecondary,
          error: DesignColors.darkError,
          onError: DesignColors.darkOnError,
          surface: DesignColors.darkSurface,
          onSurface: DesignColors.darkOnSurface,
        )
      : ColorScheme.light(
          primary: DesignColors.lightPrimary,
          onPrimary: DesignColors.lightOnPrimary,
          secondary: DesignColors.lightSecondary,
          onSecondary: DesignColors.lightOnSecondary,
          error: DesignColors.lightError,
          onError: DesignColors.lightOnError,
          surface: DesignColors.lightSurface,
          onSurface: DesignColors.lightOnSurface,
        );

  return ThemeData(
    useMaterial3: true,
    colorScheme: colors,
    scaffoldBackgroundColor: isDark ? DesignColors.darkBackground : DesignColors.lightBackground,
    fontFamily: DesignTextStyles.secondaryFont,
    textTheme: TextTheme(
      displayLarge: DesignTextStyles.headlineLarge,
      displayMedium: DesignTextStyles.headlineMedium,
      titleLarge: DesignTextStyles.titleLarge,
      titleMedium: DesignTextStyles.titleMedium,
      bodyLarge: DesignTextStyles.bodyLarge,
      bodyMedium: DesignTextStyles.bodyMedium,
      bodySmall: DesignTextStyles.bodySmall,
      labelLarge: DesignTextStyles.labelLarge,
      labelMedium: DesignTextStyles.labelMedium,
      labelSmall: DesignTextStyles.labelSmall,
    ),
  );
}
