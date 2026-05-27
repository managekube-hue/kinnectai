import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/colors.dart';
import '../theme/typography.dart';
import '../theme/spacing.dart';

enum AuthButtonType {
  google,
  facebook,
  tiktok,
  email,
  phone,
  custom,
}

class AuthButton extends StatelessWidget {
  final AuthButtonType type;
  final String text;
  final VoidCallback onPressed;
  final Widget? icon;
  final bool isPrimary;
  final bool isLoading;
  
  const AuthButton({
    super.key,
    required this.type,
    required this.text,
    required this.onPressed,
    this.icon,
    this.isPrimary = false,
    this.isLoading = false,
  });

  // Factory constructors for common button types
  factory AuthButton.google({
    required VoidCallback onPressed,
    bool isLoading = false,
  }) {
    return AuthButton(
      type: AuthButtonType.google,
      text: 'Continue with Google',
      onPressed: onPressed,
      isLoading: isLoading,
    );
  }

  factory AuthButton.facebook({
    required VoidCallback onPressed,
    bool isLoading = false,
  }) {
    return AuthButton(
      type: AuthButtonType.facebook,
      text: 'Continue with Facebook',
      onPressed: onPressed,
      isLoading: isLoading,
    );
  }

  factory AuthButton.tiktok({
    required VoidCallback onPressed,
    bool isLoading = false,
  }) {
    return AuthButton(
      type: AuthButtonType.tiktok,
      text: 'Continue with TikTok',
      onPressed: onPressed,
      isLoading: isLoading,
    );
  }

  factory AuthButton.email({
    required VoidCallback onPressed,
    bool isLoading = false,
  }) {
    return AuthButton(
      type: AuthButtonType.email,
      text: 'Sign up with Email',
      onPressed: onPressed,
      isPrimary: true,
      isLoading: isLoading,
    );
  }

  factory AuthButton.phone({
    required VoidCallback onPressed,
    bool isLoading = false,
  }) {
    return AuthButton(
      type: AuthButtonType.phone,
      text: 'Sign up with Phone',
      onPressed: onPressed,
      isLoading: isLoading,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: isLoading ? null : () {
          // Haptic feedback
          HapticFeedback.lightImpact();
          onPressed();
        },
        borderRadius: BorderRadius.circular(KinnectSpacing.radiusMedium),
        child: Semantics(
          button: true,
          label: text,
          enabled: !isLoading,
          child: Container(
            height: KinnectSpacing.buttonHeight,
            decoration: BoxDecoration(
              color: _getBackgroundColor(),
              border: _getBorder(),
              borderRadius: BorderRadius.circular(KinnectSpacing.radiusMedium),
              boxShadow: isPrimary
                  ? [
                      BoxShadow(
                        color: KinnectColors.accent.withOpacity(0.3),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ]
                  : null,
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: KinnectSpacing.md),
              child: Row(
                children: [
                  // Icon
                  if (isLoading)
                    SizedBox(
                      width: KinnectSpacing.iconMedium,
                      height: KinnectSpacing.iconMedium,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          _getTextColor(),
                        ),
                      ),
                    )
                  else
                    _buildIcon(),
                  
                  const SizedBox(width: KinnectSpacing.md),
                  
                  // Text
                  Expanded(
                    child: Text(
                      text,
                      style: isPrimary
                          ? KinnectTextStyles.buttonPrimary
                          : KinnectTextStyles.buttonSecondary.copyWith(
                              color: _getTextColor(),
                            ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  
                  // Arrow icon
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                    color: _getTextColor().withOpacity(0.6),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildIcon() {
    if (icon != null) return icon!;
    
    IconData iconData;
    Color iconColor = _getTextColor();
    
    switch (type) {
      case AuthButtonType.google:
        return _buildGoogleIcon();
      case AuthButtonType.facebook:
        iconData = Icons.facebook;
        iconColor = KinnectColors.facebookBlue;
        break;
      case AuthButtonType.tiktok:
        return _buildTikTokIcon();
      case AuthButtonType.email:
        iconData = Icons.email_outlined;
        break;
      case AuthButtonType.phone:
        iconData = Icons.phone_outlined;
        break;
      case AuthButtonType.custom:
        iconData = Icons.login;
        break;
    }
    
    return Icon(
      iconData,
      size: KinnectSpacing.iconMedium,
      color: iconColor,
    );
  }

  Widget _buildGoogleIcon() {
    // Simple Google "G" representation
    return Container(
      width: KinnectSpacing.iconMedium,
      height: KinnectSpacing.iconMedium,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(4),
      ),
      child: const Center(
        child: Text(
          'G',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: KinnectColors.googleBlue,
          ),
        ),
      ),
    );
  }

  Widget _buildTikTokIcon() {
    // Simple TikTok note representation
    return Container(
      width: KinnectSpacing.iconMedium,
      height: KinnectSpacing.iconMedium,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [KinnectColors.tiktokCyan, KinnectColors.tiktokPink],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(4),
      ),
      child: const Icon(
        Icons.music_note,
        size: 16,
        color: Colors.white,
      ),
    );
  }

  Color _getBackgroundColor() {
    if (isPrimary) return KinnectColors.accent;
    if (type == AuthButtonType.phone) return Colors.transparent;
    return KinnectColors.surface;
  }

  Color _getTextColor() {
    if (isPrimary) return KinnectColors.background;
    if (type == AuthButtonType.phone) return KinnectColors.accent;
    return KinnectColors.textPrimary;
  }

  Border? _getBorder() {
    if (type == AuthButtonType.phone) {
      return Border.all(
        color: KinnectColors.accent.withOpacity(0.6),
        width: 2,
      );
    }
    return null;
  }
}
