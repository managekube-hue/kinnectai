import 'package:flutter/material.dart';
import '../theme/colors.dart';

class ContentPreferencesScreen extends StatefulWidget {
  const ContentPreferencesScreen({super.key});

  @override
  State<ContentPreferencesScreen> createState() => _ContentPreferencesScreenState();
}

class _ContentPreferencesScreenState extends State<ContentPreferencesScreen> {
  bool _restrictedMode = false;
  bool _stemFeed = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: KinnectColors.darkBg,
      appBar: AppBar(
        backgroundColor: KinnectColors.darkSurface,
        title: const Text('Content Preferences'),
      ),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.block, color: KinnectColors.amber),
            title: const Text('Filter keywords', style: TextStyle(color: KinnectColors.white)),
            subtitle: const Text('Block specific words', style: TextStyle(color: KinnectColors.grey60, fontSize: 12)),
            trailing: const Icon(Icons.chevron_right, color: KinnectColors.grey40),
            onTap: () {},
          ),
          SwitchListTile(
            title: const Text('Restricted Mode', style: TextStyle(color: KinnectColors.white)),
            subtitle: const Text('Limit mature content', style: TextStyle(color: KinnectColors.grey60, fontSize: 12)),
            value: _restrictedMode,
            activeColor: KinnectColors.amber,
            onChanged: (value) => setState(() => _restrictedMode = value),
          ),
          SwitchListTile(
            title: const Text('STEM feed', style: TextStyle(color: KinnectColors.white)),
            subtitle: const Text('Education-focused content', style: TextStyle(color: KinnectColors.grey60, fontSize: 12)),
            value: _stemFeed,
            activeColor: KinnectColors.amber,
            onChanged: (value) => setState(() => _stemFeed = value),
          ),
          ListTile(
            leading: const Icon(Icons.refresh, color: KinnectColors.amber),
            title: const Text('Refresh your Line', style: TextStyle(color: KinnectColors.white)),
            subtitle: const Text('Reset behavioral weights', style: TextStyle(color: KinnectColors.grey60, fontSize: 12)),
            trailing: const Icon(Icons.chevron_right, color: KinnectColors.grey40),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
