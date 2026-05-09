import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../router/app_nav.dart';
import '../services/auth_service.dart';
import '../theme/colors.dart';
import '../theme/typography.dart';
import '../theme/spacing.dart';
import '../widgets/auth_button.dart';

/// OTP Verification Screen
/// Screen 11.3 from PRD
class OTPVerificationScreen extends StatefulWidget {
  const OTPVerificationScreen({super.key});

  @override
  State<OTPVerificationScreen> createState() => _OTPVerificationScreenState();
}

class _OTPVerificationScreenState extends State<OTPVerificationScreen> {
  final _otpController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }

  Future<void> _handleVerify() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() => _isLoading = true);

      try {
        final authService = Provider.of<AuthService>(context, listen: false);
        final email = authService.pendingEmail ?? '';
        
        if (email.isEmpty) {
          throw Exception('No pending email verification');
        }

        await authService.verifyOTP(email, _otpController.text.trim());

        if (mounted) {
          AppNav.go(context, '/home');
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Verification failed: $e'),
              backgroundColor: KinnectColors.error,
            ),
          );
        }
      } finally {
        if (mounted) {
          setState(() => _isLoading = false);
        }
      }
    }
  }

  Future<void> _handleResend() async {
    setState(() => _isLoading = true);

    try {
      final authService = Provider.of<AuthService>(context, listen: false);
      final email = authService.pendingEmail ?? '';
      
      if (email.isEmpty) {
        throw Exception('No pending email verification');
      }

      await authService.sendOTPEmail(email);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Verification code resent'),
            backgroundColor: KinnectColors.success,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to resend code: $e'),
            backgroundColor: KinnectColors.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    final email = authService.pendingEmail ?? '';

    return Scaffold(
      backgroundColor: KinnectColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: KinnectColors.textPrimary),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(KinnectSpacing.screenPadding),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: KinnectSpacing.xl),
                Text(
                  'Verify your email',
                  style: KinnectTextStyles.headline,
                ),
                const SizedBox(height: KinnectSpacing.sm),
                Text(
                  'Enter the code sent to $email',
                  style: KinnectTextStyles.subtitle,
                ),
                const SizedBox(height: KinnectSpacing.xl),
                TextFormField(
                  controller: _otpController,
                  keyboardType: TextInputType.number,
                  style: KinnectTextStyles.bodyLarge,
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    labelText: 'Verification Code',
                    labelStyle: KinnectTextStyles.bodyMedium.copyWith(
                      color: KinnectColors.textSecondary,
                    ),
                    filled: true,
                    fillColor: KinnectColors.surface,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(KinnectSpacing.radiusMedium),
                      borderSide: BorderSide.none,
                    ),
                    prefixIcon: const Icon(
                      Icons.security,
                      color: KinnectColors.textSecondary,
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the verification code';
                    }
                    if (value.length != 6) {
                      return 'Code must be 6 digits';
                    }
                    return null;
                  },
                ),
                const Spacer(),
                AuthButton(
                  type: AuthButtonType.email,
                  text: _isLoading ? 'Verifying...' : 'Verify',
                  onPressed: _isLoading ? null : _handleVerify,
                  isPrimary: true,
                ),
                const SizedBox(height: KinnectSpacing.md),
                TextButton(
                  onPressed: _isLoading ? null : _handleResend,
                  child: Text(
                    'Resend code',
                    style: KinnectTextStyles.bodyMedium.copyWith(
                      color: KinnectColors.primary,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
                const SizedBox(height: KinnectSpacing.lg),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
