import 'package:flutter/material.dart';
import '../theme/colors.dart';

class SecuritySettingsScreen extends StatelessWidget {
  const SecuritySettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: KinnectColors.darkBg,
      appBar: AppBar(
        backgroundColor: KinnectColors.darkSurface,
        title: const Text('Security & Permissions'),
      ),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.security, color: KinnectColors.amber),
            title: const Text('Security alerts', style: TextStyle(color: KinnectColors.white)),
            subtitle: const Text('Anomalous login attempts', style: TextStyle(color: KinnectColors.grey60, fontSize: 12)),
            trailing: const Icon(Icons.chevron_right, color: KinnectColors.grey40),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.devices, color: KinnectColors.amber),
            title: const Text('Manage devices', style: TextStyle(color: KinnectColors.white)),
            subtitle: const Text('Active sessions', style: TextStyle(color: KinnectColors.grey60, fontSize: 12)),
            trailing: const Icon(Icons.chevron_right, color: KinnectColors.grey40),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.verified_user, color: KinnectColors.amber),
            title: const Text('2-step verification', style: TextStyle(color: KinnectColors.white)),
            subtitle: const Text('TOTP or SMS', style: TextStyle(color: KinnectColors.grey60, fontSize: 12)),
            trailing: const Icon(Icons.chevron_right, color: KinnectColors.grey40),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.apps, color: KinnectColors.amber),
            title: const Text('App permissions', style: TextStyle(color: KinnectColors.white)),
            subtitle: const Text('Third-party OAuth apps', style: TextStyle(color: KinnectColors.grey60, fontSize: 12)),
            trailing: const Icon(Icons.chevron_right, color: KinnectColors.grey40),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
