import 'package:flutter/material.dart';
import '../router/app_nav.dart';
import '../theme/colors.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: KinnectColors.darkBg,
      appBar: AppBar(
        backgroundColor: KinnectColors.darkSurface,
        title: const Text('Settings and privacy'),
      ),
      body: ListView(
        children: [
          _buildSection(context, 'Account', [
            _buildItem(context, 'Balance', 'Bloom Credits, Vault+, Kinnect Card', Icons.account_balance_wallet, '/settings/balance'),
            _buildItem(context, 'Personal tools', 'Voiceprint, Family Crest, Restore', Icons.build, '/settings/personal-tools'),
            _buildItem(context, 'Your QR code', 'Share your Root profile', Icons.qr_code, '/settings/qr-code'),
          ]),
          _buildSection(context, 'Content', [
            _buildItem(context, 'Activity Center', 'History, Time & Engagement', Icons.history, '/settings/activity-center'),
            _buildItem(context, 'Content Preferences', 'Filter keywords, topics', Icons.tune, '/settings/content-preferences'),
            _buildItem(context, 'Offline videos', 'Downloaded Memories', Icons.download, '/settings/offline-videos'),
          ]),
          _buildSection(context, 'Time & Well-being', [
            _buildItem(context, 'Screen time', 'Daily limits and breaks', Icons.timer, '/time-wellbeing'),
            _buildItem(context, 'Night mode schedule', 'Auto-enable grayscale', Icons.nightlight, '/settings/night-mode'),
          ]),
          _buildSection(context, 'Family', [
            _buildItem(context, 'Family Pairing', 'Teen safety controls', Icons.family_restroom, '/settings/family-pairing'),
            _buildItem(context, 'Memory Box', 'Vault settings, Steward', Icons.lock, '/memory-box'),
          ]),
          _buildSection(context, 'Account & Security', [
            _buildItem(context, 'Account', 'Password, verification, data', Icons.person, '/settings/account'),
            _buildItem(context, 'Security & Permissions', 'Devices, 2FA, app permissions', Icons.security, '/settings/security'),
            _buildItem(context, 'Privacy', 'Visibility, data controls', Icons.privacy_tip, '/settings/privacy'),
          ]),
          _buildSection(context, 'Notifications', [
            _buildItem(context, 'Push notifications', 'Manage all notification types', Icons.notifications, '/settings/notifications'),
          ]),
          _buildSection(context, 'Business', [
            _buildItem(context, 'Creation & business tools', 'Analytics, Marketplace, API', Icons.business, '/settings/business-tools'),
          ]),
          _buildSection(context, 'Support', [
            _buildItem(context, 'Help Center', 'FAQs and support', Icons.help, '/settings/help-center'),
            _buildItem(context, 'User Guidelines', 'Community standards', Icons.description, '/settings/guidelines'),
            _buildItem(context, 'Legal', 'Terms, Privacy Policy', Icons.gavel, '/legal/terms'),
          ]),
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
              color: KinnectColors.grey60,
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
      leading: Icon(icon, color: KinnectColors.amber),
      title: Text(title, style: const TextStyle(color: KinnectColors.white)),
      subtitle: Text(subtitle, style: const TextStyle(color: KinnectColors.grey60, fontSize: 12)),
      trailing: const Icon(Icons.chevron_right, color: KinnectColors.grey40),
      onTap: () => AppNav.push(context, route),
    );
  }
}




