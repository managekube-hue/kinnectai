import 'package:flutter/material.dart';
import '../theme/colors.dart';

class BusinessToolsScreen extends StatelessWidget {
  const BusinessToolsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: KinnectColors.background,
      appBar: AppBar(
        backgroundColor: KinnectColors.surface,
        title: const Text('Business Tools'),
      ),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.analytics, color: KinnectColors.accent),
            title: const Text('Branch Analytics', style: TextStyle(color: KinnectColors.textPrimary)),
            subtitle: const Text('Dashboard and insights', style: TextStyle(color: KinnectColors.textSecondary, fontSize: 12)),
            trailing: const Icon(Icons.chevron_right, color: KinnectColors.textMuted),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.event, color: KinnectColors.accent),
            title: const Text('Gathering Ticketing', style: TextStyle(color: KinnectColors.textPrimary)),
            subtitle: const Text('Room monetization', style: TextStyle(color: KinnectColors.textSecondary, fontSize: 12)),
            trailing: const Icon(Icons.chevron_right, color: KinnectColors.textMuted),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.store, color: KinnectColors.accent),
            title: const Text('Marketplace Seller', style: TextStyle(color: KinnectColors.textPrimary)),
            subtitle: const Text('Ancestral products', style: TextStyle(color: KinnectColors.textSecondary, fontSize: 12)),
            trailing: const Icon(Icons.chevron_right, color: KinnectColors.textMuted),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.api, color: KinnectColors.accent),
            title: const Text('KinnectAI Insights API', style: TextStyle(color: KinnectColors.textPrimary)),
            subtitle: const Text('Developer access', style: TextStyle(color: KinnectColors.textSecondary, fontSize: 12)),
            trailing: const Icon(Icons.chevron_right, color: KinnectColors.textMuted),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
