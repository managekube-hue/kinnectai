import 'package:flutter/material.dart';
import '../theme/colors.dart';

class BusinessToolsScreen extends StatelessWidget {
  const BusinessToolsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: KinnectColors.darkBg,
      appBar: AppBar(
        backgroundColor: KinnectColors.darkSurface,
        title: const Text('Business Tools'),
      ),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.analytics, color: KinnectColors.amber),
            title: const Text('Branch Analytics', style: TextStyle(color: KinnectColors.white)),
            subtitle: const Text('Dashboard and insights', style: TextStyle(color: KinnectColors.grey60, fontSize: 12)),
            trailing: const Icon(Icons.chevron_right, color: KinnectColors.grey40),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.event, color: KinnectColors.amber),
            title: const Text('Gathering Ticketing', style: TextStyle(color: KinnectColors.white)),
            subtitle: const Text('Room monetization', style: TextStyle(color: KinnectColors.grey60, fontSize: 12)),
            trailing: const Icon(Icons.chevron_right, color: KinnectColors.grey40),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.store, color: KinnectColors.amber),
            title: const Text('Marketplace Seller', style: TextStyle(color: KinnectColors.white)),
            subtitle: const Text('Ancestral products', style: TextStyle(color: KinnectColors.grey60, fontSize: 12)),
            trailing: const Icon(Icons.chevron_right, color: KinnectColors.grey40),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.api, color: KinnectColors.amber),
            title: const Text('KinnectAI Insights API', style: TextStyle(color: KinnectColors.white)),
            subtitle: const Text('Developer access', style: TextStyle(color: KinnectColors.grey60, fontSize: 12)),
            trailing: const Icon(Icons.chevron_right, color: KinnectColors.grey40),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
