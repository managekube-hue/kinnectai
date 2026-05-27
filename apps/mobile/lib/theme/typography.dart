import 'package:flutter/material.dart';
import 'colors.dart';

/// KinnectAI typography styles
class KinnectTextStyles {
  // Display Styles
  static const displayLarge = TextStyle(
    fontFamily: 'Inter',
    fontSize: 48,
    fontWeight: FontWeight.bold,
    color: KinnectColors.textPrimary,
    letterSpacing: -1.0,
  );
  
  static const displayMedium = TextStyle(
    fontFamily: 'Inter',
    fontSize: 36,
    fontWeight: FontWeight.bold,
    color: KinnectColors.textPrimary,
    letterSpacing: -0.5,
  );
  
  // Headline Styles
  static const headline = TextStyle(
    fontFamily: 'Inter',
    fontSize: 32,
    fontWeight: FontWeight.bold,
    color: KinnectColors.textPrimary,
    letterSpacing: -0.5,
  );
  
  static const headlineMedium = TextStyle(
    fontFamily: 'Inter',
    fontSize: 24,
    fontWeight: FontWeight.w600,
    color: KinnectColors.textPrimary,
  );
  
  static const headlineSmall = TextStyle(
    fontFamily: 'Inter',
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: KinnectColors.textPrimary,
  );

  static const titleMedium = TextStyle(
    fontFamily: 'Inter',
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: KinnectColors.textPrimary,
  );
  
  // Body Styles
  static const bodyLarge = TextStyle(
    fontFamily: 'Inter',
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: KinnectColors.textPrimary,
    height: 1.5,
  );
  
  static const bodyMedium = TextStyle(
    fontFamily: 'Inter',
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: KinnectColors.textPrimary,
    height: 1.5,
  );
  
  static const bodySmall = TextStyle(
    fontFamily: 'Inter',
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: KinnectColors.textMediumEmphasis,
    height: 1.5,
  );
  
  // Button Styles
  static const buttonPrimary = TextStyle(
    fontFamily: 'Inter',
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: KinnectColors.background,
    letterSpacing: 0.5,
  );
  
  static const buttonSecondary = TextStyle(
    fontFamily: 'Inter',
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: KinnectColors.textPrimary,
    letterSpacing: 0.5,
  );
  
  // Subtitle Styles
  static const subtitle = TextStyle(
    fontFamily: 'Inter',
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: KinnectColors.textSecondary,
  );
  
  static const subtitleBold = TextStyle(
    fontFamily: 'Inter',
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: KinnectColors.textMediumEmphasis,
  );
  
  // Caption Styles
  static const caption = TextStyle(
    fontFamily: 'Inter',
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: KinnectColors.textSecondary,
  );
  
  // Link Styles
  static const link = TextStyle(
    fontFamily: 'Inter',
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: KinnectColors.accent,
    decoration: TextDecoration.underline,
  );
  
  static const linkSmall = TextStyle(
    fontFamily: 'Inter',
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: KinnectColors.accent,
    decoration: TextDecoration.underline,
  );
  
  // Private constructor
  KinnectTextStyles._();
}
