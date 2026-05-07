import 'package:flutter/material.dart';
import '../theme/colors.dart';
import '../theme/typography.dart';
import '../theme/spacing.dart';
import '../widgets/auth_button.dart';

/// Email Sign-Up Screen (Placeholder)
/// Screen 11.2 from PRD
class EmailSignUpScreen extends StatefulWidget {
  const EmailSignUpScreen({super.key});

  @override
  State<EmailSignUpScreen> createState() => _EmailSignUpScreenState();
}

class _EmailSignUpScreenState extends State<EmailSignUpScreen> {
  final _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _handleContinue() {
    if (_formKey.currentState?.validate() ?? false) {
      // TODO: Implement email signup flow with OTP
      Navigator.pushReplacementNamed(context, '/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: KinnectColors.darkBg,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: KinnectColors.white),
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
                  'Sign up with Email',
                  style: KinnectTextStyles.headline,
                ),
                const SizedBox(height: KinnectSpacing.sm),
                Text(
                  'We\'ll send you a verification code',
                  style: KinnectTextStyles.subtitle,
                ),
                const SizedBox(height: KinnectSpacing.xl),
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  style: KinnectTextStyles.bodyLarge,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    labelStyle: KinnectTextStyles.bodyMedium.copyWith(
                      color: KinnectColors.grey60,
                    ),
                    filled: true,
                    fillColor: KinnectColors.darkSurface,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(KinnectSpacing.radiusMedium),
                      borderSide: BorderSide.none,
                    ),
                    prefixIcon: const Icon(
                      Icons.email_outlined,
                      color: KinnectColors.grey60,
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    if (!value.contains('@')) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                ),
                const Spacer(),
                AuthButton(
                  type: AuthButtonType.email,
                  text: 'Continue',
                  onPressed: _handleContinue,
                  isPrimary: true,
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
