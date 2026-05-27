import 'package:flutter/material.dart';
import '../router/app_nav.dart';
import 'package:flutter/services.dart';
import '../theme/colors.dart';
import '../theme/typography.dart';
import '../theme/spacing.dart';
import '../widgets/pixelated_tree_background.dart';
import '../widgets/sparkle_icon.dart';
import '../widgets/auth_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  bool _isGoogleLoading = false;
  bool _isFacebookLoading = false;
  bool _isTikTokLoading = false;
  
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  @override
  void initState() {
    super.initState();
    _logAnalyticsEvent('auth_welcome_viewed');
  }

  void _logAnalyticsEvent(String eventName, [Map<String, dynamic>? properties]) {
    debugPrint('Analytics Event: $eventName ${properties ?? {}}');
  }

  Future<void> _handleGoogleSignIn() async {
    setState(() => _isGoogleLoading = true);
    _logAnalyticsEvent('auth_button_tapped', {'method': 'google'});
    _logAnalyticsEvent('auth_oauth_started', {'provider': 'google'});
    
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      
      if (googleUser == null) {
        // User canceled
        setState(() => _isGoogleLoading = false);
        return;
      }
      
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      
      await _auth.signInWithCredential(credential);
      
      _logAnalyticsEvent('auth_oauth_completed', {
        'provider': 'google',
        'success': true,
      });
      
      if (mounted) {
        // Navigate to onboarding
        AppNav.go(context, '/home');
      }
    } catch (e) {
      _logAnalyticsEvent('auth_oauth_completed', {
        'provider': 'google',
        'success': false,
        'error': e.toString(),
      });
      
      if (mounted) {
        _showErrorSnackBar('Google sign-in failed. Try again.');
      }
    } finally {
      if (mounted) {
        setState(() => _isGoogleLoading = false);
      }
    }
  }

  Future<void> _handleFacebookSignIn() async {
    setState(() => _isFacebookLoading = true);
    _logAnalyticsEvent('auth_button_tapped', {'method': 'facebook'});
    _logAnalyticsEvent('auth_oauth_started', {'provider': 'facebook'});
    
    try {
      final LoginResult result = await FacebookAuth.instance.login(
        permissions: ['email', 'public_profile'],
      );
      
      if (result.status == LoginStatus.success) {
        final AccessToken accessToken = result.accessToken!;
        final credential = FacebookAuthProvider.credential(accessToken.token);
        
        await _auth.signInWithCredential(credential);
        
        _logAnalyticsEvent('auth_oauth_completed', {
          'provider': 'facebook',
          'success': true,
        });
        
        if (mounted) {
          AppNav.go(context, '/home');
        }
      } else {
        _logAnalyticsEvent('auth_oauth_completed', {
          'provider': 'facebook',
          'success': false,
          'error': result.message,
        });
        
        if (mounted) {
          _showErrorSnackBar('Facebook sign-in failed. Try again.');
        }
      }
    } catch (e) {
      _logAnalyticsEvent('auth_oauth_completed', {
        'provider': 'facebook',
        'success': false,
        'error': e.toString(),
      });
      
      if (mounted) {
        _showErrorSnackBar('Facebook sign-in failed. Try again.');
      }
    } finally {
      if (mounted) {
        setState(() => _isFacebookLoading = false);
      }
    }
  }

  Future<void> _handleTikTokSignIn() async {
    setState(() => _isTikTokLoading = true);
    _logAnalyticsEvent('auth_button_tapped', {'method': 'tiktok'});
    
    await Future.delayed(const Duration(seconds: 1));
    
    if (mounted) {
      _showErrorSnackBar('TikTok sign-in coming soon!');
      setState(() => _isTikTokLoading = false);
    }
  }

  void _handleEmailSignUp() {
    _logAnalyticsEvent('auth_button_tapped', {'method': 'email'});
    _logAnalyticsEvent('auth_email_initiated');
    AppNav.push(context, '/email-signup');
  }

  void _handlePhoneSignUp() {
    _logAnalyticsEvent('auth_button_tapped', {'method': 'phone'});
    AppNav.push(context, '/phone-signup');
  }

  void _handleSignIn() {
    AppNav.push(context, '/login');
  }

  void _handleTermsOfService() {
    _logAnalyticsEvent('auth_legal_link_viewed', {'document_type': 'terms'});
    AppNav.push(context, '/legal/terms');
  }

  void _handlePrivacyPolicy() {
    _logAnalyticsEvent('auth_legal_link_viewed', {'document_type': 'privacy'});
    AppNav.push(context, '/legal/privacy');
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: KinnectColors.error,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(KinnectSpacing.radiusMedium),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: KinnectColors.background,
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: Stack(
          children: [
            // Animated background
            const Positioned.fill(
              child: PixelatedTreeBackground(),
            ),
            
            // Content
            SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: KinnectSpacing.screenPadding,
                ),
                child: Column(
                  children: [
                    const SizedBox(height: KinnectSpacing.xxl),
                    
                    // Logo section
                    _buildLogoSection(),
                    
                    const SizedBox(height: KinnectSpacing.xxxl),
                    
                    // Auth buttons
                    _buildAuthButtons(),
                    
                    const SizedBox(height: KinnectSpacing.lg),
                    
                    // Sign in link
                    _buildSignInLink(),
                    
                    const SizedBox(height: KinnectSpacing.xl),
                    
                    // Legal footer
                    _buildLegalFooter(),
                    
                    const SizedBox(height: KinnectSpacing.xl),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLogoSection() {
    return Column(
      children: [
        // Sparkle icon
        const SparkleIcon(size: 80),
        
        const SizedBox(height: KinnectSpacing.lg),
        
        // Logo text
        Text(
          'KINNECTAI',
          style: KinnectTextStyles.displayMedium.copyWith(
            letterSpacing: 2.0,
          ),
        ),
        
        const SizedBox(height: KinnectSpacing.sm),
        
        // Tagline
        const Text(
          'The Algorithm Is Your Bloodline',
          style: KinnectTextStyles.subtitle,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildAuthButtons() {
    return Column(
      children: [
        // Google
        AuthButton.google(
          onPressed: _handleGoogleSignIn,
          isLoading: _isGoogleLoading,
        ),
        
        const SizedBox(height: KinnectSpacing.buttonSpacing),
        
        // Facebook
        AuthButton.facebook(
          onPressed: _handleFacebookSignIn,
          isLoading: _isFacebookLoading,
        ),
        
        const SizedBox(height: KinnectSpacing.buttonSpacing),
        
        // TikTok
        AuthButton.tiktok(
          onPressed: _handleTikTokSignIn,
          isLoading: _isTikTokLoading,
        ),
        
        const SizedBox(height: KinnectSpacing.lg),
        
        // Email (Primary)
        AuthButton.email(
          onPressed: _handleEmailSignUp,
        ),
        
        const SizedBox(height: KinnectSpacing.buttonSpacing),
        
        // Phone
        AuthButton.phone(
          onPressed: _handlePhoneSignUp,
        ),
      ],
    );
  }

  Widget _buildSignInLink() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Already have an account? ',
          style: KinnectTextStyles.bodyMedium.copyWith(
            color: KinnectColors.textMediumEmphasis,
          ),
        ),
        GestureDetector(
          onTap: _handleSignIn,
          child: const Text(
            'Sign In',
            style: KinnectTextStyles.link,
          ),
        ),
      ],
    );
  }

  Widget _buildLegalFooter() {
    return Column(
      children: [
        Text(
          'By continuing, you agree to',
          style: KinnectTextStyles.caption.copyWith(
            color: KinnectColors.textSecondary,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: KinnectSpacing.xs),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: _handleTermsOfService,
              child: const Text(
                'Terms of Service',
                style: KinnectTextStyles.linkSmall,
              ),
            ),
            Text(
              '  |  ',
              style: KinnectTextStyles.caption.copyWith(
                color: KinnectColors.textSecondary,
              ),
            ),
            GestureDetector(
              onTap: _handlePrivacyPolicy,
              child: const Text(
                'Privacy Policy',
                style: KinnectTextStyles.linkSmall,
              ),
            ),
          ],
        ),
      ],
    );
  }
}



