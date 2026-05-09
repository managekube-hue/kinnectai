import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../theme/colors.dart';
import '../theme/typography.dart';

/// PRD Addendum 3.0 S3 -- Room Recording Consent.
///
/// Originator clicks Record -> system prompts all participants:
/// "This Room will be recorded. All participants must consent to continue
/// recording. Tap Agree or Leave."
/// If >50% opt-out -> recording auto-aborts.
class RecordingConsentDialog extends StatelessWidget {
  const RecordingConsentDialog({super.key, required this.roomName, required this.originatorName});

  final String roomName;
  final String originatorName;

  /// Show the dialog and return the user's choice.
  static Future<RecordingConsentChoice> show(BuildContext context, {required String roomName, required String originatorName}) async {
    final result = await showDialog<RecordingConsentChoice>(
      context: context,
      barrierDismissible: false,
      builder: (_) => RecordingConsentDialog(roomName: roomName, originatorName: originatorName),
    );
    return result ?? RecordingConsentChoice.leave;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: KinnectColors.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Row(
        children: [
          Icon(PhosphorIcons.record(), color: KinnectColors.error, size: 28),
          const SizedBox(width: 12),
          Text('Recording', style: KinnectTextStyles.headlineSmall),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$originatorName wants to record this Room.',
            style: const TextStyle(color: KinnectColors.textPrimary, fontSize: 15, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 12),
          Text(
            'This Room will be recorded and may be sealed to the Memory Box. '
            'Tap Agree to continue or Leave to exit the Room.',
            style: TextStyle(color: KinnectColors.textSecondary, fontSize: 14, height: 1.5),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: KinnectColors.warning.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: KinnectColors.warning.withOpacity(0.3)),
            ),
            child: Row(
              children: [
                Icon(PhosphorIcons.info(), size: 18, color: KinnectColors.warning),
                const SizedBox(width: 8),
                Expanded(child: Text(
                  'Legal basis: GDPR Art. 6(1)(a) / CCPA explicit consent',
                  style: TextStyle(color: KinnectColors.textSecondary, fontSize: 12),
                )),
              ],
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, RecordingConsentChoice.leave),
          child: const Text('Leave Room', style: TextStyle(color: KinnectColors.error)),
        ),
        ElevatedButton(
          onPressed: () => Navigator.pop(context, RecordingConsentChoice.agree),
          style: ElevatedButton.styleFrom(backgroundColor: KinnectColors.accent, foregroundColor: Colors.white),
          child: const Text('Agree'),
        ),
      ],
    );
  }
}

enum RecordingConsentChoice { agree, leave }
