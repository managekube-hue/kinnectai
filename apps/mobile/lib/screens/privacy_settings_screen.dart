import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../theme/colors.dart';

class PrivacySettingsScreen extends StatefulWidget {
  const PrivacySettingsScreen({super.key});

  @override
  State<PrivacySettingsScreen> createState() => _PrivacySettingsScreenState();
}

class _PrivacySettingsScreenState extends State<PrivacySettingsScreen> {
  bool _isPublicAccount = false;
  bool _showActivityStatus = true;
  bool _allowDiscovery = true;
  bool _syncContacts = false;
  bool _showHaplogroup = true;
  double _minKinScore = 0.2;
  bool _allowPulses = true;
  bool _allowDMs = true;
  bool _allowStitch = true;
  bool _trackOffPlatform = false;
  bool _contextualAds = true;
  bool _feedbackSharing = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: KinnectColors.background,
      appBar: AppBar(
        backgroundColor: KinnectColors.surface,
        title: const Text('Privacy'),
      ),
      body: ListView(
        children: [
          _buildSection('Account Visibility', [
            SwitchListTile(
              title: const Text('Public Account', style: TextStyle(color: KinnectColors.textPrimary)),
              subtitle: const Text('Allow non-Kinnections to see your Memories', style: TextStyle(color: KinnectColors.textSecondary, fontSize: 12)),
              value: _isPublicAccount,
              activeColor: KinnectColors.accent,
              onChanged: (value) => setState(() => _isPublicAccount = value),
            ),
            SwitchListTile(
              title: const Text('Activity Status', style: TextStyle(color: KinnectColors.textPrimary)),
              subtitle: const Text('Show when you\'re active', style: TextStyle(color: KinnectColors.textSecondary, fontSize: 12)),
              value: _showActivityStatus,
              activeColor: KinnectColors.accent,
              onChanged: (value) => setState(() => _showActivityStatus = value),
            ),
            SwitchListTile(
              title: const Text('Discoverability', style: TextStyle(color: KinnectColors.textPrimary)),
              subtitle: const Text('Appear in Discovery and Lost Branches', style: TextStyle(color: KinnectColors.textSecondary, fontSize: 12)),
              value: _allowDiscovery,
              activeColor: KinnectColors.accent,
              onChanged: (value) => setState(() => _allowDiscovery = value),
            ),
          ]),
          _buildSection('Data Controls', [
            SwitchListTile(
              title: const Text('Sync Contacts', style: TextStyle(color: KinnectColors.textPrimary)),
              subtitle: const Text('Find Kin from your contacts', style: TextStyle(color: KinnectColors.textSecondary, fontSize: 12)),
              value: _syncContacts,
              activeColor: KinnectColors.accent,
              onChanged: (value) => setState(() => _syncContacts = value),
            ),
            ListTile(
              title: const Text('Interaction Permissions', style: TextStyle(color: KinnectColors.textPrimary)),
              subtitle: const Text('Who can Pulse, DM, Stitch', style: TextStyle(color: KinnectColors.textSecondary, fontSize: 12)),
              trailing: Icon(PhosphorIcons.caretRight(), color: KinnectColors.textMuted),
              onTap: _showInteractionPermissions,
            ),
          ]),
          _buildSection('Genomic Data', [
            SwitchListTile(
              title: const Text('Haplogroup Visibility', style: TextStyle(color: KinnectColors.textPrimary)),
              subtitle: const Text('Show haplogroup on public profile', style: TextStyle(color: KinnectColors.textSecondary, fontSize: 12)),
              value: _showHaplogroup,
              activeColor: KinnectColors.accent,
              onChanged: (value) => setState(() => _showHaplogroup = value),
            ),
            ListTile(
              title: const Text('Kin Score Display Range', style: TextStyle(color: KinnectColors.textPrimary)),
              subtitle: Text('Minimum: ${(_minKinScore * 100).toStringAsFixed(1)}% (~6th cousin)', style: const TextStyle(color: KinnectColors.textSecondary, fontSize: 12)),
              onTap: _showKinScoreSlider,
            ),
            ListTile(
              title: const Text('DNA Kit Connection', style: TextStyle(color: KinnectColors.textPrimary)),
              subtitle: const Text('Manage Sequencing.com OAuth', style: TextStyle(color: KinnectColors.textSecondary, fontSize: 12)),
              trailing: Icon(PhosphorIcons.caretRight(), color: KinnectColors.textMuted),
              onTap: () {},
            ),
            ListTile(
              title: const Text('Raw Data Deletion', style: TextStyle(color: KinnectColors.error)),
              subtitle: const Text('Delete FASTQ/BAM files (irreversible)', style: TextStyle(color: KinnectColors.textSecondary, fontSize: 12)),
              trailing: Icon(PhosphorIcons.warning(), color: KinnectColors.error),
              onTap: _showDeleteDataWarning,
            ),
          ]),
          _buildSection('Off-Platform Tracking', [
            SwitchListTile(
              title: const Text('Tracking Pixel Opt-Out', style: TextStyle(color: KinnectColors.textPrimary)),
              subtitle: const Text('Disable Layer 4 behavioral signals', style: TextStyle(color: KinnectColors.textSecondary, fontSize: 12)),
              value: _trackOffPlatform,
              activeColor: KinnectColors.accent,
              onChanged: (value) => setState(() => _trackOffPlatform = value),
            ),
            ListTile(
              title: const Text('Third-Party Sharing Opt-Out', style: TextStyle(color: KinnectColors.textPrimary)),
              subtitle: const Text('NielsenIQ, Facteus data sharing', style: TextStyle(color: KinnectColors.textSecondary, fontSize: 12)),
              trailing: Icon(PhosphorIcons.caretRight(), color: KinnectColors.textMuted),
              onTap: () {},
            ),
            SwitchListTile(
              title: const Text('Contextual Ad Preferences', style: TextStyle(color: KinnectColors.textPrimary)),
              subtitle: const Text('Bio-Identity-based contextual offer relevance', style: TextStyle(color: KinnectColors.textSecondary, fontSize: 12)),
              value: _contextualAds,
              activeColor: KinnectColors.accent,
              onChanged: (value) => setState(() => _contextualAds = value),
            ),
            ListTile(
              title: const Text('Partner Muting', style: TextStyle(color: KinnectColors.textPrimary)),
              subtitle: const Text('Mute specific partner brands from offers', style: TextStyle(color: KinnectColors.textSecondary, fontSize: 12)),
              trailing: Icon(PhosphorIcons.caretRight(), color: KinnectColors.textMuted),
              onTap: () {},
            ),
            SwitchListTile(
              title: const Text('Feedback Sharing', style: TextStyle(color: KinnectColors.textPrimary)),
              subtitle: const Text('Allow anonymized usage data to improve KinnectAI. No PII or genomic data shared.', style: TextStyle(color: KinnectColors.textSecondary, fontSize: 12)),
              value: _feedbackSharing,
              activeColor: KinnectColors.accent,
              onChanged: (value) => setState(() => _feedbackSharing = value),
            ),
          ]),
        ],
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
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

  void _showInteractionPermissions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: KinnectColors.surface,
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Interaction Permissions', style: TextStyle(color: KinnectColors.textPrimary, fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 24),
              SwitchListTile(
                title: const Text('Allow Pulses', style: TextStyle(color: KinnectColors.textPrimary)),
                subtitle: const Text('All Kin / Confirmed Kinnections / Off', style: TextStyle(color: KinnectColors.textSecondary, fontSize: 12)),
                value: _allowPulses,
                activeColor: KinnectColors.accent,
                onChanged: (value) => setModalState(() => _allowPulses = value),
              ),
              SwitchListTile(
                title: const Text('Allow DMs', style: TextStyle(color: KinnectColors.textPrimary)),
                subtitle: const Text('Confirmed Kinnections only', style: TextStyle(color: KinnectColors.textSecondary, fontSize: 12)),
                value: _allowDMs,
                activeColor: KinnectColors.accent,
                onChanged: (value) => setModalState(() => _allowDMs = value),
              ),
              SwitchListTile(
                title: const Text('Allow Stitch/Rewind', style: TextStyle(color: KinnectColors.textPrimary)),
                subtitle: const Text('Others can use your Memories', style: TextStyle(color: KinnectColors.textSecondary, fontSize: 12)),
                value: _allowStitch,
                activeColor: KinnectColors.accent,
                onChanged: (value) => setModalState(() => _allowStitch = value),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showKinScoreSlider() {
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          backgroundColor: KinnectColors.surface,
          title: const Text('Kin Score Display Range', style: TextStyle(color: KinnectColors.textPrimary)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '${(_minKinScore * 100).toStringAsFixed(1)}%',
                style: const TextStyle(color: KinnectColors.accent, fontSize: 32, fontWeight: FontWeight.bold),
              ),
              Slider(
                value: _minKinScore,
                min: 0.0,
                max: 10.0,
                divisions: 100,
                activeColor: KinnectColors.accent,
                label: '${(_minKinScore * 100).toStringAsFixed(1)}%',
                onChanged: (value) => setDialogState(() => _minKinScore = value),
              ),
              const Text('Only show Kin Score above this threshold', style: TextStyle(color: KinnectColors.textSecondary, fontSize: 12)),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel', style: TextStyle(color: KinnectColors.textSecondary))),
            ElevatedButton(
              onPressed: () {
                setState(() {});
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(backgroundColor: KinnectColors.accent),
              child: const Text('Save', style: TextStyle(color: KinnectColors.background)),
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteDataWarning() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: KinnectColors.surface,
        title: const Text('Delete Raw Genomic Data?', style: TextStyle(color: KinnectColors.error)),
        content: const Text(
          'This will permanently delete your FASTQ/BAM files from our servers. This action is irreversible and will be processed within 30 days.\n\nYour Kin Score and connections will not be affected.',
          style: TextStyle(color: KinnectColors.textPrimary),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel', style: TextStyle(color: KinnectColors.textSecondary))),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(backgroundColor: KinnectColors.error),
            child: const Text('Request Deletion'),
          ),
        ],
      ),
    );
  }
}
