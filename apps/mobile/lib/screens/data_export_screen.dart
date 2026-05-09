import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../cubits/export_cubit.dart';
import '../theme/colors.dart';
import '../theme/typography.dart';

/// PRD Section 12.5 -- Download Your Data (GDPR Art. 20).
class DataExportScreen extends StatelessWidget {
  const DataExportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ExportCubit(),
      child: const _DataExportContent(),
    );
  }
}

class _DataExportContent extends StatelessWidget {
  const _DataExportContent();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: KinnectColors.background,
      appBar: AppBar(
        backgroundColor: KinnectColors.surface,
        title: Text('Download Your Data', style: KinnectTextStyles.headlineSmall),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: KinnectColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: BlocBuilder<ExportCubit, ExportState>(
        builder: (context, state) {
          return ListView(
            padding: const EdgeInsets.all(24),
            children: [
              Icon(PhosphorIcons.downloadSimple(), size: 64, color: KinnectColors.primary),
              const SizedBox(height: 16),
              Text(
                'Export Your KinnectAI Data',
                textAlign: TextAlign.center,
                style: KinnectTextStyles.headlineMedium,
              ),
              const SizedBox(height: 8),
              Text(
                'Request a full copy of your data. Under GDPR Article 20 and CCPA, you have the right to receive a portable copy of all personal data.',
                textAlign: TextAlign.center,
                style: KinnectTextStyles.bodyLarge.copyWith(color: KinnectColors.textSecondary),
              ),
              const SizedBox(height: 32),

              // Data categories
              const _DataCategory(icon: PhosphorIcons.play, label: 'Memories & Blooms'),
              const _DataCategory(icon: PhosphorIcons.treeStructure, label: 'Tree & Kinnections'),
              const _DataCategory(icon: PhosphorIcons.microphone, label: 'Voiceprints'),
              const _DataCategory(icon: PhosphorIcons.lock, label: 'Memory Box (encrypted)'),
              const _DataCategory(icon: PhosphorIcons.chartBar, label: 'Behavioral & Activity Data'),
              const _DataCategory(icon: PhosphorIcons.dna, label: 'Genomic Data (if connected)'),
              const SizedBox(height: 32),

              // Status
              if (state is ExportRequesting)
                const Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation(KinnectColors.accent))),

              if (state is ExportPending)
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: KinnectColors.warning.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: KinnectColors.warning.withOpacity(0.3)),
                  ),
                  child: Column(
                    children: [
                      Icon(PhosphorIcons.clock(), color: KinnectColors.warning, size: 28),
                      const SizedBox(height: 8),
                      Text('Export in progress', style: KinnectTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.w600)),
                      const SizedBox(height: 4),
                      Text(
                        'We\'ll send an email when your data is ready to download.',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: KinnectColors.textSecondary, fontSize: 13),
                      ),
                      const SizedBox(height: 12),
                      TextButton(
                        onPressed: () => context.read<ExportCubit>().checkStatus(state.exportId),
                        child: const Text('Check Status'),
                      ),
                    ],
                  ),
                ),

              if (state is ExportReady)
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: KinnectColors.success.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: KinnectColors.success.withOpacity(0.3)),
                  ),
                  child: Column(
                    children: [
                      Icon(PhosphorIcons.checkCircle(), color: KinnectColors.success, size: 28),
                      const SizedBox(height: 8),
                      Text('Export Ready', style: KinnectTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.w600)),
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: () {},
                          icon: Icon(PhosphorIcons.downloadSimple(), size: 18),
                          label: const Text('Download ZIP'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: KinnectColors.success,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

              if (state is ExportError)
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: KinnectColors.error.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(state.message, style: TextStyle(color: KinnectColors.error)),
                ),

              if (state is ExportIdle) ...[
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => context.read<ExportCubit>().requestExport(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: KinnectColors.accent,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text('Request Export'),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Export typically takes 24-48 hours. Decryption key sent to your verified email separately.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: KinnectColors.textMuted, fontSize: 12),
                ),
              ],
            ],
          );
        },
      ),
    );
  }
}

class _DataCategory extends StatelessWidget {
  const _DataCategory({required this.icon, required this.label});
  final IconData Function() icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(PhosphorIcons.checkSquare(), size: 20, color: KinnectColors.success),
          const SizedBox(width: 12),
          Text(label, style: const TextStyle(color: KinnectColors.textPrimary, fontSize: 14)),
        ],
      ),
    );
  }
}
