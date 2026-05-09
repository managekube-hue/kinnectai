import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../router/app_nav.dart';
import '../theme/colors.dart';
import '../theme/typography.dart';
import '../utils/step_up_auth.dart';

/// PRD Section 12.9 -- Memory Box Settings.
/// Storage, Steward designation, triggers, export.
/// All actions require step-up authentication.
class MemoryBoxSettingsScreen extends StatefulWidget {
  const MemoryBoxSettingsScreen({super.key});

  @override
  State<MemoryBoxSettingsScreen> createState() => _MemoryBoxSettingsScreenState();
}

class _MemoryBoxSettingsScreenState extends State<MemoryBoxSettingsScreen> {
  // TODO: Fetch from MemoryBoxCubit / API
  final double _storageUsedGB = 2.3;
  final double _storageLimitGB = 5.0;
  final bool _isVaultPlus = false;
  final int _sealedCount = 4;
  final double _kinshipAlertRadiusKm = 0.5;

  @override
  Widget build(BuildContext context) {
    final storagePercent = (_storageUsedGB / _storageLimitGB).clamp(0.0, 1.0);

    return Scaffold(
      backgroundColor: KinnectColors.background,
      appBar: AppBar(
        backgroundColor: KinnectColors.surface,
        title: Text('Memory Box Settings', style: KinnectTextStyles.headlineSmall),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: KinnectColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView(
        children: [
          // Storage usage (PRD 12.9 item 1)
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: KinnectColors.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: storagePercent > 0.8 ? KinnectColors.warning : KinnectColors.dividerSubtle),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(PhosphorIcons.database(), size: 20, color: KinnectColors.accent),
                    const SizedBox(width: 8),
                    Text('Memory Box Storage', style: KinnectTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.w600)),
                  ],
                ),
                const SizedBox(height: 12),
                LinearProgressIndicator(
                  value: storagePercent,
                  backgroundColor: KinnectColors.surfaceElevated,
                  valueColor: AlwaysStoppedAnimation(storagePercent > 0.8 ? KinnectColors.warning : KinnectColors.primary),
                ),
                const SizedBox(height: 8),
                Text(
                  '${_storageUsedGB.toStringAsFixed(1)} GB / ${_storageLimitGB.toStringAsFixed(0)} GB used',
                  style: TextStyle(color: KinnectColors.textSecondary, fontSize: 13),
                ),
                if (!_isVaultPlus && storagePercent > 0.8) ...[
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => AppNav.push(context, '/subscription'),
                      style: ElevatedButton.styleFrom(backgroundColor: KinnectColors.accent, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                      child: const Text('Upgrade to Vault+ (500 GB)'),
                    ),
                  ),
                ],
              ],
            ),
          ),

          // Manage Vault Memories (PRD 12.9 item 2)
          _SettingsTile(
            icon: PhosphorIcons.lock(),
            title: 'Manage Memory Box Memories',
            subtitle: '$_sealedCount sealed memories',
            onTap: () => AppNav.push(context, '/memory-box'),
          ),

          // Steward designation (PRD 12.9 item 3)
          _SettingsTile(
            icon: PhosphorIcons.shield(),
            title: 'Steward Designation',
            subtitle: 'Assign Kin to manage posthumous delivery',
            onTap: () async {
              final authed = await StepUpAuth.verify(context, reason: 'Verify identity to manage Steward designation.');
              if (authed && mounted) AppNav.push(context, '/steward-consent');
            },
          ),

          // Death trigger settings (PRD 12.9 item 4)
          _SettingsTile(
            icon: PhosphorIcons.heartbreak(),
            title: 'Posthumous Delivery Settings',
            subtitle: 'SSDI match, obituary, Steward confirmation',
            onTap: () async {
              final authed = await StepUpAuth.verify(context, reason: 'Verify identity to manage death trigger settings.');
              if (authed && mounted) _showDeathTriggerSettings();
            },
          ),

          // Time Capsule delivery (PRD 12.9 item 5)
          _SettingsTile(
            icon: PhosphorIcons.calendarBlank(),
            title: 'Time Capsule Settings',
            subtitle: 'Review calendar-triggered memories',
            onTap: () {},
          ),

          // Milestone Memory triggers (PRD 12.9 item 6)
          _SettingsTile(
            icon: PhosphorIcons.graduationCap(),
            title: 'Milestone Memory Triggers',
            subtitle: 'Graduation, marriage, new child events',
            onTap: () {},
          ),

          // Kinship Alert radius (PRD 12.9 item 7)
          _SettingsTile(
            icon: PhosphorIcons.mapPin(),
            title: 'Kinship Alert Radius',
            subtitle: '${(_kinshipAlertRadiusKm * 1000).round()}m (adjustable 100m-5km)',
            onTap: _showRadiusPicker,
          ),

          // Memory Box export (PRD 12.9 item 8)
          _SettingsTile(
            icon: PhosphorIcons.downloadSimple(),
            title: 'Memory Box Export',
            subtitle: 'GDPR Art. 20 encrypted archive',
            onTap: () async {
              final authed = await StepUpAuth.verify(context, reason: 'Verify identity to export Memory Box data.');
              if (authed && mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Export requested. Decryption key will be sent to your verified email.'), backgroundColor: KinnectColors.primary),
                );
              }
            },
          ),

          const SizedBox(height: 32),
        ],
      ),
    );
  }

  void _showDeathTriggerSettings() {
    showModalBottomSheet(
      context: context,
      backgroundColor: KinnectColors.surface,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Death Verification Signals', style: KinnectTextStyles.headlineSmall),
            const SizedBox(height: 16),
            SwitchListTile(title: const Text('SSDI / DeathMaster match', style: TextStyle(color: KinnectColors.textPrimary)), value: true, activeColor: KinnectColors.accent, onChanged: (_) {}),
            SwitchListTile(title: const Text('Obituary ingestion (LexisNexis)', style: TextStyle(color: KinnectColors.textPrimary)), value: true, activeColor: KinnectColors.accent, onChanged: (_) {}),
            SwitchListTile(title: const Text('Steward confirmation', style: TextStyle(color: KinnectColors.textPrimary)), value: true, activeColor: KinnectColors.accent, onChanged: (_) {}),
            SwitchListTile(title: const Text('Biometric inactivity threshold', style: TextStyle(color: KinnectColors.textPrimary)), value: false, activeColor: KinnectColors.accent, onChanged: (_) {}),
            const SizedBox(height: 12),
            Text('Require multiple signals for higher confidence.', style: TextStyle(color: KinnectColors.textMuted, fontSize: 12)),
          ],
        ),
      ),
    );
  }

  void _showRadiusPicker() {
    double radius = _kinshipAlertRadiusKm;
    showModalBottomSheet(
      context: context,
      backgroundColor: KinnectColors.surface,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setSheetState) => Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Kinship Alert Radius', style: KinnectTextStyles.headlineSmall),
              const SizedBox(height: 16),
              Text('${(radius * 1000).round()}m', style: KinnectTextStyles.headlineMedium.copyWith(color: KinnectColors.accent)),
              Slider(
                value: radius,
                min: 0.1,
                max: 5.0,
                divisions: 49,
                activeColor: KinnectColors.accent,
                onChanged: (v) => setSheetState(() => radius = v),
              ),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Text('100m', style: TextStyle(color: KinnectColors.textMuted, fontSize: 12)),
                Text('5km', style: TextStyle(color: KinnectColors.textMuted, fontSize: 12)),
              ]),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(ctx);
                    setState(() {});
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: KinnectColors.accent, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                  child: const Text('Save'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  const _SettingsTile({required this.icon, required this.title, required this.subtitle, required this.onTap});
  final IconData Function() icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon(), color: KinnectColors.accent),
      title: Text(title, style: const TextStyle(color: KinnectColors.textPrimary)),
      subtitle: Text(subtitle, style: TextStyle(color: KinnectColors.textSecondary, fontSize: 12)),
      trailing: Icon(PhosphorIcons.caretRight(), color: KinnectColors.textMuted),
      onTap: onTap,
    );
  }
}
