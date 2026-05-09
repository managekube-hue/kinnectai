import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../theme/colors.dart';
import '../theme/typography.dart';
import '../utils/audit_logger.dart';
import '../utils/step_up_auth.dart';

/// GDPR Art. 17 -- Data Deletion Flow.
/// Settings -> Account -> Deactivate or Delete.
class DataDeletionScreen extends StatefulWidget {
  const DataDeletionScreen({super.key});

  @override
  State<DataDeletionScreen> createState() => _DataDeletionScreenState();
}

class _DataDeletionScreenState extends State<DataDeletionScreen> {
  bool _isProcessing = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: KinnectColors.background,
      appBar: AppBar(
        backgroundColor: KinnectColors.surface,
        title: Text('Delete Account', style: KinnectTextStyles.headlineSmall),
        leading: IconButton(icon: const Icon(Icons.arrow_back, color: KinnectColors.textPrimary), onPressed: () => Navigator.pop(context)),
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Icon(PhosphorIcons.warning(), size: 64, color: KinnectColors.error),
          const SizedBox(height: 16),
          Text('This action is permanent', style: KinnectTextStyles.headlineMedium, textAlign: TextAlign.center),
          const SizedBox(height: 12),
          Text(
            'Deleting your account will permanently remove all your data including Memories, Blooms, Tree connections, Voiceprints, and Kinnections.',
            textAlign: TextAlign.center,
            style: TextStyle(color: KinnectColors.textSecondary, height: 1.5),
          ),
          const SizedBox(height: 24),

          _DataItem(icon: PhosphorIcons.play(), label: 'All Memories & Blooms', willDelete: true),
          _DataItem(icon: PhosphorIcons.treeStructure(), label: 'Tree & Kinnections', willDelete: true),
          _DataItem(icon: PhosphorIcons.microphone(), label: 'Voiceprints & embeddings', willDelete: true),
          _DataItem(icon: PhosphorIcons.lock(), label: 'Memory Box items', willDelete: true),
          _DataItem(icon: PhosphorIcons.dna(), label: 'Genomic data (30-day purge)', willDelete: true),
          _DataItem(icon: PhosphorIcons.chartBar(), label: 'Behavioral & activity data', willDelete: true),

          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(color: KinnectColors.warning.withOpacity(0.1), borderRadius: BorderRadius.circular(12), border: Border.all(color: KinnectColors.warning.withOpacity(0.3))),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                Icon(PhosphorIcons.shield(), size: 18, color: KinnectColors.warning),
                const SizedBox(width: 8),
                Text('Memory Box Alert', style: TextStyle(color: KinnectColors.warning, fontWeight: FontWeight.w600)),
              ]),
              const SizedBox(height: 8),
              Text(
                'If you have active Memory Box items with Stewards, they will be notified. Sealed memories may be transferred to Steward custody per the Steward Agreement.',
                style: TextStyle(color: KinnectColors.textSecondary, fontSize: 13, height: 1.5),
              ),
            ]),
          ),
          const SizedBox(height: 24),

          // Deactivate (soft delete)
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: _isProcessing ? null : () => _handleDeactivate(context),
              style: OutlinedButton.styleFrom(foregroundColor: KinnectColors.warning, side: const BorderSide(color: KinnectColors.warning), padding: const EdgeInsets.symmetric(vertical: 16), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
              child: const Text('Deactivate Account (30 days)'),
            ),
          ),
          const SizedBox(height: 12),

          // Permanent delete
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _isProcessing ? null : () => _handleDelete(context),
              style: ElevatedButton.styleFrom(backgroundColor: KinnectColors.error, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 16), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
              child: _isProcessing ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white)) : const Text('Permanently Delete Account'),
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Future<void> _handleDeactivate(BuildContext context) async {
    final confirmed = await StepUpAuth.verify(context, reason: 'Verify identity to deactivate your account.');
    if (!confirmed || !mounted) return;

    AuditLogger.logSecurity(userId: 'current_user', action: 'account_deactivated');

    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Account deactivated. You have 30 days to reactivate.'), backgroundColor: KinnectColors.warning));
    Navigator.pop(context);
  }

  Future<void> _handleDelete(BuildContext context) async {
    final confirmed = await StepUpAuth.verify(context, reason: 'Verify identity to permanently delete your account and all data.');
    if (!confirmed || !mounted) return;

    setState(() => _isProcessing = true);

    AuditLogger.logDataOperation(userId: 'current_user', operation: 'account_permanent_deletion', dataType: 'all');

    await Future<void>.delayed(const Duration(seconds: 1));
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Account deletion initiated. Data will be purged within 30 days.'), backgroundColor: KinnectColors.error));
    Navigator.pop(context);
  }
}

class _DataItem extends StatelessWidget {
  const _DataItem({required this.icon, required this.label, required this.willDelete});
  final IconData Function() icon;
  final String label;
  final bool willDelete;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(children: [
        Icon(willDelete ? PhosphorIcons.xCircle() : PhosphorIcons.checkCircle(), size: 18, color: willDelete ? KinnectColors.error : KinnectColors.success),
        const SizedBox(width: 10),
        Text(label, style: const TextStyle(color: KinnectColors.textPrimary, fontSize: 14)),
      ]),
    );
  }
}
