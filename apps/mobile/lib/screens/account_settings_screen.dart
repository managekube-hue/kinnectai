import 'package:flutter/material.dart';
import '../theme/colors.dart';

class AccountSettingsScreen extends StatelessWidget {
  const AccountSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: KinnectColors.darkBg,
      appBar: AppBar(
        backgroundColor: KinnectColors.darkSurface,
        title: const Text('Account'),
      ),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.lock, color: KinnectColors.amber),
            title: const Text('Password', style: TextStyle(color: KinnectColors.white)),
            subtitle: const Text('Change account password', style: TextStyle(color: KinnectColors.grey60, fontSize: 12)),
            trailing: const Icon(Icons.chevron_right, color: KinnectColors.grey40),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.fingerprint, color: KinnectColors.amber),
            title: const Text('Passkey', style: TextStyle(color: KinnectColors.white)),
            subtitle: const Text('Face ID / Fingerprint login', style: TextStyle(color: KinnectColors.grey60, fontSize: 12)),
            trailing: const Icon(Icons.chevron_right, color: KinnectColors.grey40),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.verified, color: KinnectColors.amber),
            title: const Text('Verification', style: TextStyle(color: KinnectColors.white)),
            subtitle: const Text('Phone and email status', style: TextStyle(color: KinnectColors.grey60, fontSize: 12)),
            trailing: const Icon(Icons.chevron_right, color: KinnectColors.grey40),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.download, color: KinnectColors.amber),
            title: const Text('Download your data', style: TextStyle(color: KinnectColors.white)),
            subtitle: const Text('GDPR export (ZIP)', style: TextStyle(color: KinnectColors.grey60, fontSize: 12)),
            trailing: const Icon(Icons.chevron_right, color: KinnectColors.grey40),
            onTap: () => Navigator.pushNamed(context, '/settings/data-export'),
          ),
          const Divider(color: KinnectColors.grey20),
          ListTile(
            leading: const Icon(Icons.delete_forever, color: KinnectColors.error),
            title: const Text('Deactivate or delete', style: TextStyle(color: KinnectColors.error)),
            subtitle: const Text('Deactivate (30 days) or permanent deletion', style: TextStyle(color: KinnectColors.grey60, fontSize: 12)),
            trailing: const Icon(Icons.chevron_right, color: KinnectColors.error),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
