import 'package:flutter/material.dart';
import '../router/app_nav.dart';
import '../theme/colors.dart';
import '../theme/typography.dart';
import '../theme/spacing.dart';
import '../widgets/auth_button.dart';

/// Phone Sign-Up Screen (Placeholder)
/// Screen 11.3 from PRD
class PhoneSignUpScreen extends StatefulWidget {
  const PhoneSignUpScreen({super.key});

  @override
  State<PhoneSignUpScreen> createState() => _PhoneSignUpScreenState();
}

class _PhoneSignUpScreenState extends State<PhoneSignUpScreen> {
  final _phoneController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String _countryCode = '+1';

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  void _handleContinue() {
    if (_formKey.currentState?.validate() ?? false) {
      // TODO: Implement phone signup flow with SMS OTP
      AppNav.go(context, '/home');
    }
  }

  @override
  Widget build(BuildContext context) {
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
                  'Sign up with Phone',
                  style: KinnectTextStyles.headline,
                ),
                const SizedBox(height: KinnectSpacing.sm),
                Text(
                  'We\'ll send you a verification code',
                  style: KinnectTextStyles.subtitle,
                ),
                const SizedBox(height: KinnectSpacing.xl),
                Row(
                  children: [
                    // Country code selector
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: KinnectSpacing.md,
                      ),
                      decoration: BoxDecoration(
                        color: KinnectColors.surface,
                        borderRadius: BorderRadius.circular(KinnectSpacing.radiusMedium),
                      ),
                      child: DropdownButton<String>(
                        value: _countryCode,
                        style: KinnectTextStyles.bodyLarge,
                        dropdownColor: KinnectColors.surface,
                        underline: const SizedBox(),
                        items: const [
                          DropdownMenuItem(value: '+1', child: Text('+1')),
                          DropdownMenuItem(value: '+44', child: Text('+44')),
                          DropdownMenuItem(value: '+91', child: Text('+91')),
                        ],
                        onChanged: (value) {
                          if (value != null) {
                            setState(() => _countryCode = value);
                          }
                        },
                      ),
                    ),
                    const SizedBox(width: KinnectSpacing.md),
                    // Phone number input
                    Expanded(
                      child: TextFormField(
                        controller: _phoneController,
                        keyboardType: TextInputType.phone,
                        style: KinnectTextStyles.bodyLarge,
                        decoration: InputDecoration(
                          labelText: 'Phone Number',
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
                            Icons.phone_outlined,
                            color: KinnectColors.textSecondary,
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your phone number';
                          }
                          if (value.length < 10) {
                            return 'Please enter a valid phone number';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                AuthButton(
                  type: AuthButtonType.phone,
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



