import 'package:flutter/material.dart';
import '../router/app_nav.dart';
import '../theme/colors.dart';

class AccountSettingsScreen extends StatelessWidget {
  const AccountSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: KinnectColors.background,
      appBar: AppBar(
        backgroundColor: KinnectColors.surface,
        title: const Text('Account'),
      ),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.lock, color: KinnectColors.accent),
            title: const Text('Password', style: TextStyle(color: KinnectColors.textPrimary)),
            subtitle: const Text('Change account password', style: TextStyle(color: KinnectColors.textSecondary, fontSize: 12)),
            trailing: const Icon(Icons.chevron_right, color: KinnectColors.textMuted),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.fingerprint, color: KinnectColors.accent),
            title: const Text('Passkey', style: TextStyle(color: KinnectColors.textPrimary)),
            subtitle: const Text('Face ID / Fingerprint login', style: TextStyle(color: KinnectColors.textSecondary, fontSize: 12)),
            trailing: const Icon(Icons.chevron_right, color: KinnectColors.textMuted),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.verified, color: KinnectColors.accent),
            title: const Text('Verification', style: TextStyle(color: KinnectColors.textPrimary)),
            subtitle: const Text('Phone and email status', style: TextStyle(color: KinnectColors.textSecondary, fontSize: 12)),
            trailing: const Icon(Icons.chevron_right, color: KinnectColors.textMuted),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.download, color: KinnectColors.accent),
            title: const Text('Download your data', style: TextStyle(color: KinnectColors.textPrimary)),
            subtitle: const Text('GDPR export (ZIP)', style: TextStyle(color: KinnectColors.textSecondary, fontSize: 12)),
            trailing: const Icon(Icons.chevron_right, color: KinnectColors.textMuted),
            onTap: () => AppNav.push(context, '/settings/data-export'),
          ),
          const Divider(color: KinnectColors.dividerSubtle),
          ListTile(
            leading: const Icon(Icons.delete_forever, color: KinnectColors.error),
            title: const Text('Deactivate or delete', style: TextStyle(color: KinnectColors.error)),
            subtitle: const Text('Deactivate (30 days) or permanent deletion', style: TextStyle(color: KinnectColors.textSecondary, fontSize: 12)),
            trailing: const Icon(Icons.chevron_right, color: KinnectColors.error),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}



