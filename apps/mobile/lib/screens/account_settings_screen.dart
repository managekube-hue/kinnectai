import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../router/app_nav.dart';
import '../theme/colors.dart';
import '../theme/typography.dart';
import '../utils/step_up_auth.dart';

/// PRD Section 12.5 -- Account settings.
class AccountSettingsScreen extends StatelessWidget {
  const AccountSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: KinnectColors.background,
      appBar: AppBar(
        backgroundColor: KinnectColors.surface,
        title: const Text('Account', style: KinnectTextStyles.headlineSmall),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: KinnectColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView(
        children: [
          _buildSectionTitle('Account Information'),
          ListTile(
            leading: Icon(PhosphorIcons.lock(), color: KinnectColors.accent),
            title: const Text('Password', style: TextStyle(color: KinnectColors.textPrimary)),
            subtitle: const Text('Change account password', style: TextStyle(color: KinnectColors.textSecondary, fontSize: 12)),
            trailing: Icon(PhosphorIcons.caretRight(), color: KinnectColors.textMuted),
            onTap: () async {
              final authed = await StepUpAuth.verify(context, reason: 'Verify identity to change password.');
              if (authed) {
              }
            },
          ),
          ListTile(
            leading: Icon(PhosphorIcons.fingerprint(), color: KinnectColors.accent),
            title: const Text('Passkey', style: TextStyle(color: KinnectColors.textPrimary)),
            subtitle: const Text('Face ID / Fingerprint login', style: TextStyle(color: KinnectColors.textSecondary, fontSize: 12)),
            trailing: Icon(PhosphorIcons.caretRight(), color: KinnectColors.textMuted),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(PhosphorIcons.sealCheck(), color: KinnectColors.accent),
            title: const Text('Verification', style: TextStyle(color: KinnectColors.textPrimary)),
            subtitle: const Text('Phone and email status', style: TextStyle(color: KinnectColors.textSecondary, fontSize: 12)),
            trailing: Icon(PhosphorIcons.caretRight(), color: KinnectColors.textMuted),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(PhosphorIcons.downloadSimple(), color: KinnectColors.accent),
            title: const Text('Download your data', style: TextStyle(color: KinnectColors.textPrimary)),
            subtitle: const Text('GDPR export (ZIP)', style: TextStyle(color: KinnectColors.textSecondary, fontSize: 12)),
            trailing: Icon(PhosphorIcons.caretRight(), color: KinnectColors.textMuted),
            onTap: () => AppNav.push(context, '/settings/data-export'),
          ),
          const Divider(color: KinnectColors.dividerSubtle),
          ListTile(
            leading: Icon(PhosphorIcons.trash(), color: KinnectColors.error),
            title: const Text('Deactivate or delete', style: TextStyle(color: KinnectColors.error)),
            subtitle: const Text('Deactivate (30 days) or permanent deletion', style: TextStyle(color: KinnectColors.textSecondary, fontSize: 12)),
            trailing: Icon(PhosphorIcons.caretRight(), color: KinnectColors.error),
            onTap: () => AppNav.push(context, '/settings/delete-account'),
          ),
          _buildSectionTitle('Account Type'),
          ListTile(
            leading: Icon(PhosphorIcons.briefcase(), color: KinnectColors.accent),
            title: const Text('Switch to Business', style: TextStyle(color: KinnectColors.textPrimary)),
            subtitle: const Text('Analytics, Marketplace, API access', style: TextStyle(color: KinnectColors.textSecondary, fontSize: 12)),
            trailing: Icon(PhosphorIcons.caretRight(), color: KinnectColors.textMuted),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(PhosphorIcons.shield(), color: KinnectColors.accent),
            title: const Text('Switch to Steward', style: TextStyle(color: KinnectColors.textPrimary)),
            subtitle: const Text('Memory Box custodian role', style: TextStyle(color: KinnectColors.textSecondary, fontSize: 12)),
            trailing: Icon(PhosphorIcons.caretRight(), color: KinnectColors.textMuted),
            onTap: () {},
          ),
          _buildSectionTitle('Profile Sharing'),
          ListTile(
            leading: Icon(PhosphorIcons.shareNetwork(), color: KinnectColors.accent),
            title: const Text('Share Root profile', style: TextStyle(color: KinnectColors.textPrimary)),
            subtitle: const Text('Link or QR code', style: TextStyle(color: KinnectColors.textSecondary, fontSize: 12)),
            trailing: Icon(PhosphorIcons.caretRight(), color: KinnectColors.textMuted),
            onTap: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
      child: Text(title, style: const TextStyle(color: KinnectColors.textSecondary, fontSize: 14, fontWeight: FontWeight.bold)),
    );
  }
}
