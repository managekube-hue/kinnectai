import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../router/app_nav.dart';
import '../theme/colors.dart';
import '../theme/typography.dart';

/// PRD Section 12.0 -- Top-Level Settings Menu.
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: KinnectColors.background,
      appBar: AppBar(
        backgroundColor: KinnectColors.surface,
        title: Text('Settings and privacy', style: KinnectTextStyles.headlineSmall),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: KinnectColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView(
        children: [
          _buildSection(context, 'Account', [
            _buildItem(context, 'Balance', 'Bloom Credits, Vault+, Kinnect Card', PhosphorIcons.wallet(), '/settings/balance'),
            _buildItem(context, 'Personal tools', 'Voiceprint, Family Crest, Restore', PhosphorIcons.wrench(), '/settings/personal-tools'),
            _buildItem(context, 'Your QR code', 'Share your Root profile', PhosphorIcons.qrCode(), '/settings/qr-code'),
          ]),
          _buildSection(context, 'Content', [
            _buildItem(context, 'Activity Center', 'History, Time & Engagement', PhosphorIcons.clockCounterClockwise(), '/settings/activity-center'),
            _buildItem(context, 'Content Preferences', 'Filter keywords, topics', PhosphorIcons.slidersHorizontal(), '/settings/content-preferences'),
            _buildItem(context, 'Offline videos', 'Downloaded Memories', PhosphorIcons.downloadSimple(), '/settings/offline-videos'),
          ]),
          _buildSection(context, 'Time & Well-being', [
            _buildItem(context, 'Screen time', 'Daily limits and breaks', PhosphorIcons.timer(), '/time-wellbeing'),
            _buildItem(context, 'Night mode schedule', 'Auto-enable grayscale', PhosphorIcons.moon(), '/settings/night-mode'),
          ]),
          _buildSection(context, 'Family', [
            _buildItem(context, 'Family Pairing', 'Teen safety controls', PhosphorIcons.usersThree(), '/settings/family-pairing'),
            _buildItem(context, 'Memory Box', 'Vault settings, Steward', PhosphorIcons.lock(), '/memory-box'),
          ]),
          _buildSection(context, 'Account & Security', [
            _buildItem(context, 'Account', 'Password, verification, data', PhosphorIcons.user(), '/settings/account'),
            _buildItem(context, 'Security & Permissions', 'Devices, 2FA, app permissions', PhosphorIcons.shieldCheck(), '/settings/security'),
            _buildItem(context, 'Privacy', 'Visibility, data controls', PhosphorIcons.eye(), '/settings/privacy'),
          ]),
          _buildSection(context, 'Notifications', [
            _buildItem(context, 'Push notifications', 'Manage all notification types', PhosphorIcons.bell(), '/settings/notifications'),
          ]),
          _buildSection(context, 'Business', [
            _buildItem(context, 'Creation & business tools', 'Analytics, Marketplace, API', PhosphorIcons.briefcase(), '/settings/business-tools'),
          ]),
          _buildSection(context, 'Support', [
            _buildItem(context, 'Help Center', 'FAQs and support', PhosphorIcons.question(), '/settings/help-center'),
            _buildItem(context, 'User Guidelines', 'Community standards', PhosphorIcons.bookOpenText(), '/settings/guidelines'),
            _buildItem(context, 'Legal', 'Terms, Privacy Policy', PhosphorIcons.scales(), '/legal/terms'),
          ]),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildSection(BuildContext context, String title, List<Widget> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
          child: Text(
            title,
            style: const TextStyle(
              color: KinnectColors.textSecondary,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        ...items,
      ],
    );
  }

  Widget _buildItem(BuildContext context, String title, String subtitle, IconData icon, String route) {
    return ListTile(
      leading: Icon(icon, color: KinnectColors.accent),
      title: Text(title, style: const TextStyle(color: KinnectColors.textPrimary)),
      subtitle: Text(subtitle, style: const TextStyle(color: KinnectColors.textSecondary, fontSize: 12)),
      trailing: Icon(PhosphorIcons.caretRight(), color: KinnectColors.textMuted),
      onTap: () => AppNav.push(context, route),
    );
  }
}
