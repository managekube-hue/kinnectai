import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../cubits/settings_cubit.dart';
import '../models/dtos/settings_state_dto.dart';
import '../theme/colors.dart';

/// PRD Section 7 -- Privacy Controls.
/// All toggles wired to SettingsCubit -> API.
class PrivacySettingsScreen extends StatelessWidget {
  const PrivacySettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: KinnectColors.background,
      appBar: AppBar(
        backgroundColor: KinnectColors.surface,
        title: const Text('Privacy'),
        leading: IconButton(icon: const Icon(Icons.arrow_back, color: KinnectColors.textPrimary), onPressed: () => Navigator.pop(context)),
      ),
      body: BlocBuilder<SettingsCubit, SettingsState>(
        builder: (context, state) {
          final s = state is SettingsLoaded ? state.settings : const SettingsStateDTO();
          final cubit = context.read<SettingsCubit>();

          return ListView(
            children: [
              _section('Account Visibility', [
                _toggle('Public Account', 'Allow non-Kinnections to see your Memories', s.privateAccount == false, (v) => cubit.updatePrivacy(privateAccount: !v)),
                _toggle('Activity Status', 'Show when you\'re active', s.activityStatus, (v) => cubit.updatePrivacy(activityStatus: v)),
                _toggle('Discoverability', 'Appear in Discovery and Lost Branches', s.discoveryEnabled, (v) => cubit.updatePrivacy(discoveryEnabled: v)),
              ]),
              _section('Data Controls', [
                _toggle('Sync Contacts', 'Find Kin from your contacts', s.syncContacts, (v) => cubit.updatePrivacy(syncContacts: v)),
                _nav('Interaction Permissions', 'Who can Pulse, DM, Stitch', () => _showInteractionSheet(context, s, cubit)),
              ]),
              _section('Genomic Data', [
                _toggle('Haplogroup Visibility', 'Show haplogroup on public profile', s.showHaplogroup, (v) => cubit.updatePrivacy(showHaplogroup: v)),
                ListTile(
                  title: const Text('Kin Score Display Range', style: TextStyle(color: KinnectColors.textPrimary)),
                  subtitle: Text('Minimum: ${(s.minKinScoreDisplay * 100).toStringAsFixed(1)}%', style: const TextStyle(color: KinnectColors.textSecondary, fontSize: 12)),
                  onTap: () => _showKinScoreSlider(context, s, cubit),
                ),
                _nav('DNA Kit Connection', 'Manage Sequencing.com OAuth', () {}),
                ListTile(
                  title: const Text('Raw Data Deletion', style: TextStyle(color: KinnectColors.error)),
                  subtitle: const Text('Delete FASTQ/BAM files (irreversible)', style: TextStyle(color: KinnectColors.textSecondary, fontSize: 12)),
                  trailing: Icon(PhosphorIcons.warning(), color: KinnectColors.error),
                  onTap: () => _showDeleteDataWarning(context),
                ),
                _toggle('Third-Party Sharing Opt-Out', 'NielsenIQ, Facteus data sharing', s.thirdPartySharing == false, (v) => cubit.updatePrivacy(thirdPartySharing: !v)),
              ]),
              _section('Off-Platform Tracking', [
                _toggle('Tracking Pixel Opt-Out', 'Disable Layer 4 behavioral signals', s.offPlatformTracking == false, (v) => cubit.updatePrivacy(offPlatformTracking: !v)),
                _toggle('Contextual Ad Preferences', 'Bio-Identity-based offer relevance', s.contextualAds, (v) => cubit.updatePrivacy(contextualAds: v)),
                _nav('Partner Muting', 'Mute specific partner brands', () {}),
                _toggle('Feedback Sharing', 'Anonymized usage data (no PII/genomic)', s.feedbackSharing, (v) => cubit.updatePrivacy(feedbackSharing: v)),
              ]),
            ],
          );
        },
      ),
    );
  }

  Widget _section(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
          child: Text(title, style: const TextStyle(color: KinnectColors.textSecondary, fontSize: 14, fontWeight: FontWeight.bold)),
        ),
        ...children,
      ],
    );
  }

  Widget _toggle(String title, String subtitle, bool value, ValueChanged<bool> onChanged) {
    return SwitchListTile(
      title: Text(title, style: const TextStyle(color: KinnectColors.textPrimary)),
      subtitle: Text(subtitle, style: const TextStyle(color: KinnectColors.textSecondary, fontSize: 12)),
      value: value,
      activeColor: KinnectColors.accent,
      onChanged: onChanged,
    );
  }

  Widget _nav(String title, String subtitle, VoidCallback onTap) {
    return ListTile(
      title: Text(title, style: const TextStyle(color: KinnectColors.textPrimary)),
      subtitle: Text(subtitle, style: const TextStyle(color: KinnectColors.textSecondary, fontSize: 12)),
      trailing: Icon(PhosphorIcons.caretRight(), color: KinnectColors.textMuted),
      onTap: onTap,
    );
  }

  void _showInteractionSheet(BuildContext context, SettingsStateDTO s, SettingsCubit cubit) {
    showModalBottomSheet(
      context: context,
      backgroundColor: KinnectColors.surface,
      builder: (_) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          const Text('Interaction Permissions', style: TextStyle(color: KinnectColors.textPrimary, fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 24),
          SwitchListTile(title: const Text('Allow Pulses', style: TextStyle(color: KinnectColors.textPrimary)), value: s.allowPulses, activeColor: KinnectColors.accent, onChanged: (v) => cubit.updatePrivacy(allowPulses: v)),
          SwitchListTile(title: const Text('Allow DMs', style: TextStyle(color: KinnectColors.textPrimary)), value: s.allowDMs, activeColor: KinnectColors.accent, onChanged: (v) => cubit.updatePrivacy(allowDMs: v)),
          SwitchListTile(title: const Text('Allow Stitch/Rewind', style: TextStyle(color: KinnectColors.textPrimary)), value: s.allowStitch, activeColor: KinnectColors.accent, onChanged: (v) => cubit.updatePrivacy(allowStitch: v)),
        ]),
      ),
    );
  }

  void _showKinScoreSlider(BuildContext context, SettingsStateDTO s, SettingsCubit cubit) {
    double val = s.minKinScoreDisplay;
    showDialog(
      context: context,
      builder: (_) => StatefulBuilder(
        builder: (_, setDialogState) => AlertDialog(
          backgroundColor: KinnectColors.surface,
          title: const Text('Kin Score Display Range', style: TextStyle(color: KinnectColors.textPrimary)),
          content: Column(mainAxisSize: MainAxisSize.min, children: [
            Text('${(val * 100).toStringAsFixed(1)}%', style: const TextStyle(color: KinnectColors.accent, fontSize: 32, fontWeight: FontWeight.bold)),
            Slider(value: val, min: 0.0, max: 10.0, divisions: 100, activeColor: KinnectColors.accent, onChanged: (v) => setDialogState(() => val = v)),
          ]),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
            ElevatedButton(
              onPressed: () { cubit.updatePrivacy(minKinScoreDisplay: val); Navigator.pop(context); },
              style: ElevatedButton.styleFrom(backgroundColor: KinnectColors.accent),
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteDataWarning(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: KinnectColors.surface,
        title: const Text('Delete Raw Genomic Data?', style: TextStyle(color: KinnectColors.error)),
        content: const Text('This will permanently delete your FASTQ/BAM files. Irreversible. Processed within 30 days.', style: TextStyle(color: KinnectColors.textPrimary)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(onPressed: () => Navigator.pop(context), style: ElevatedButton.styleFrom(backgroundColor: KinnectColors.error), child: const Text('Request Deletion')),
        ],
      ),
    );
  }
}
