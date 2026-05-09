import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../theme/colors.dart';
import '../theme/typography.dart';

/// Step-up authentication for sensitive operations (Addendum 2.0 S12 + Addendum 3.0 S4).
///
/// Required for:
/// - Purchases > $10
/// - Memory Box sealing
/// - Voiceprint capture/revocation
/// - DNA kit connections
/// - Account deletion
/// - Steward designation changes
class StepUpAuth {
  StepUpAuth._();

  /// Show step-up auth dialog. Returns true if authenticated.
  static Future<bool> verify(
    BuildContext context, {
    required String reason,
    bool requireBiometric = true,
  }) async {
    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => _StepUpAuthDialog(
        reason: reason,
        requireBiometric: requireBiometric,
      ),
    );
    return result ?? false;
  }

  /// Check if step-up auth is required for a purchase amount.
  static bool requiredForAmount(double amountCents) {
    return amountCents > 1000; // > $10.00
  }
}

class _StepUpAuthDialog extends StatefulWidget {
  const _StepUpAuthDialog({required this.reason, required this.requireBiometric});

  final String reason;
  final bool requireBiometric;

  @override
  State<_StepUpAuthDialog> createState() => _StepUpAuthDialogState();
}

class _StepUpAuthDialogState extends State<_StepUpAuthDialog> {
  bool _isVerifying = false;
  String? _error;
  final _pinController = TextEditingController();

  @override
  void dispose() {
    _pinController.dispose();
    super.dispose();
  }

  Future<void> _verifyBiometric() async {
    setState(() {
      _isVerifying = true;
      _error = null;
    });

    try {
      // TODO: Integrate with local_auth package for Face ID / fingerprint
      await Future<void>.delayed(const Duration(milliseconds: 800));

      if (!mounted) return;
      Navigator.pop(context, true);
    } catch (e) {
      setState(() {
        _isVerifying = false;
        _error = 'Biometric verification failed. Try PIN instead.';
      });
    }
  }

  Future<void> _verifyPin() async {
    if (_pinController.text.length < 4) {
      setState(() => _error = 'Enter your PIN');
      return;
    }

    setState(() {
      _isVerifying = true;
      _error = null;
    });

    try {
      // TODO: Verify PIN against stored hash
      await Future<void>.delayed(const Duration(milliseconds: 500));

      if (!mounted) return;
      Navigator.pop(context, true);
    } catch (e) {
      setState(() {
        _isVerifying = false;
        _error = 'Invalid PIN. Please try again.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: KinnectColors.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Row(
        children: [
          Icon(PhosphorIcons.shieldCheck(), color: KinnectColors.accent, size: 28),
          const SizedBox(width: 12),
          Text('Verify Identity', style: KinnectTextStyles.headlineSmall),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            widget.reason,
            style: TextStyle(color: KinnectColors.textSecondary, fontSize: 14, height: 1.5),
          ),
          const SizedBox(height: 20),

          if (widget.requireBiometric) ...[
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _isVerifying ? null : _verifyBiometric,
                icon: _isVerifying
                    ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                    : Icon(PhosphorIcons.fingerprint(), size: 20),
                label: const Text('Verify with Face ID / Fingerprint'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: KinnectColors.accent,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text('or enter PIN', style: TextStyle(color: KinnectColors.textMuted, fontSize: 13)),
            const SizedBox(height: 12),
          ],

          // PIN fallback
          TextField(
            controller: _pinController,
            obscureText: true,
            keyboardType: TextInputType.number,
            maxLength: 6,
            style: const TextStyle(color: KinnectColors.textPrimary, letterSpacing: 8, fontSize: 24),
            textAlign: TextAlign.center,
            decoration: InputDecoration(
              hintText: '------',
              hintStyle: TextStyle(color: KinnectColors.textMuted, letterSpacing: 8),
              counterText: '',
              filled: true,
              fillColor: KinnectColors.surfaceElevated,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
            ),
          ),

          if (_error != null) ...[
            const SizedBox(height: 8),
            Text(_error!, style: TextStyle(color: KinnectColors.error, fontSize: 13)),
          ],
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: const Text('Cancel', style: TextStyle(color: KinnectColors.textSecondary)),
        ),
        if (!widget.requireBiometric || _error != null)
          ElevatedButton(
            onPressed: _isVerifying ? null : _verifyPin,
            style: ElevatedButton.styleFrom(backgroundColor: KinnectColors.accent, foregroundColor: Colors.white),
            child: const Text('Verify PIN'),
          ),
      ],
    );
  }
}
