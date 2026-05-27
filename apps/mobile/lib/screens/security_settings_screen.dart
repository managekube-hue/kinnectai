import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../theme/colors.dart';
import '../theme/typography.dart';

/// PRD Section 12.6 -- Security & Permissions.
class SecuritySettingsScreen extends StatelessWidget {
  const SecuritySettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: KinnectColors.background,
      appBar: AppBar(
        backgroundColor: KinnectColors.surface,
        title: const Text('Security & Permissions', style: KinnectTextStyles.headlineSmall),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: KinnectColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView(
        children: [
          ListTile(
            leading: Icon(PhosphorIcons.shieldWarning(), color: KinnectColors.accent),
            title: const Text('Security alerts', style: TextStyle(color: KinnectColors.textPrimary)),
            subtitle: const Text('Anomalous login attempts', style: TextStyle(color: KinnectColors.textSecondary, fontSize: 12)),
            trailing: Icon(PhosphorIcons.caretRight(), color: KinnectColors.textMuted),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(PhosphorIcons.devices(), color: KinnectColors.accent),
            title: const Text('Manage devices', style: TextStyle(color: KinnectColors.textPrimary)),
            subtitle: const Text('Active sessions', style: TextStyle(color: KinnectColors.textSecondary, fontSize: 12)),
            trailing: Icon(PhosphorIcons.caretRight(), color: KinnectColors.textMuted),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(PhosphorIcons.shieldCheck(), color: KinnectColors.accent),
            title: const Text('2-step verification', style: TextStyle(color: KinnectColors.textPrimary)),
            subtitle: const Text('TOTP or SMS', style: TextStyle(color: KinnectColors.textSecondary, fontSize: 12)),
            trailing: Icon(PhosphorIcons.caretRight(), color: KinnectColors.textMuted),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.extension, color: KinnectColors.accent),
            title: const Text('App permissions', style: TextStyle(color: KinnectColors.textPrimary)),
            subtitle: const Text('Third-party OAuth apps', style: TextStyle(color: KinnectColors.textSecondary, fontSize: 12)),
            trailing: Icon(PhosphorIcons.caretRight(), color: KinnectColors.textMuted),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(PhosphorIcons.browser(), color: KinnectColors.accent),
            title: const Text('Browser settings', style: TextStyle(color: KinnectColors.textPrimary)),
            subtitle: const Text('Tracking Pixel opt-out', style: TextStyle(color: KinnectColors.textSecondary, fontSize: 12)),
            trailing: Icon(PhosphorIcons.caretRight(), color: KinnectColors.textMuted),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
