import 'package:flutter/material.dart';
import '../theme/colors.dart';
import '../theme/typography.dart';

class BiometricConsentDialog extends StatefulWidget {
  final String dataType;
  final String purpose;
  final String retention;
  final List<String> rights;

  const BiometricConsentDialog({
    super.key,
    required this.dataType,
    required this.purpose,
    required this.retention,
    required this.rights,
  });

  @override
  State<BiometricConsentDialog> createState() => _BiometricConsentDialogState();
}

class _BiometricConsentDialogState extends State<BiometricConsentDialog> {
  bool _consentChecked = false;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: KinnectColors.darkSurface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Row(
        children: [
          const Icon(Icons.security, color: KinnectColors.amber, size: 28),
          const SizedBox(width: 12),
          Text('Biometric Consent', style: KinnectTextStyles.headlineSmall),
        ],
      ),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'By proceeding, you grant KinnectAI permission to capture and store a 256-dim embedding of your ${widget.dataType} for the purpose of ${widget.purpose}.',
              style: KinnectTextStyles.bodyMedium.copyWith(height: 1.5),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: KinnectColors.darkBg,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: KinnectColors.amber.withOpacity(0.3)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Data Handling:', style: KinnectTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 12),
                  _buildInfoRow(Icons.storage, widget.retention),
                  const SizedBox(height: 8),
                  _buildInfoRow(Icons.lock, 'End-to-end encrypted'),
                  const SizedBox(height: 8),
                  _buildInfoRow(Icons.verified_user, 'Vault protected'),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Text('Your Rights:', style: KinnectTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            ...widget.rights.map((right) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.check_circle, size: 16, color: KinnectColors.success),
                  const SizedBox(width: 8),
                  Expanded(child: Text(right, style: KinnectTextStyles.bodySmall)),
                ],
              ),
            )),
            const SizedBox(height: 16),
            Row(
              children: [
                Checkbox(
                  value: _consentChecked,
                  onChanged: (value) => setState(() => _consentChecked = value ?? false),
                  activeColor: KinnectColors.amber,
                ),
                Expanded(
                  child: Text(
                    'I provide explicit biometric consent',
                    style: KinnectTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Padding(
              padding: const EdgeInsets.only(left: 48),
              child: Text(
                'Required for ElevenLabs synthesis',
                style: KinnectTextStyles.caption.copyWith(color: KinnectColors.grey60),
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: const Text('Decline', style: TextStyle(color: KinnectColors.error)),
        ),
        ElevatedButton(
          onPressed: _consentChecked ? () => Navigator.pop(context, true) : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: KinnectColors.amber,
            foregroundColor: KinnectColors.darkBg,
            disabledBackgroundColor: KinnectColors.grey40,
          ),
          child: const Text('I Consent'),
        ),
      ],
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 16, color: KinnectColors.amber),
        const SizedBox(width: 8),
        Expanded(child: Text(text, style: KinnectTextStyles.bodySmall)),
      ],
    );
  }
}
