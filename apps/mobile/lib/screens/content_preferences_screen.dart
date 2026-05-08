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
      backgroundColor: KinnectColors.background,
      appBar: AppBar(
        backgroundColor: KinnectColors.surface,
        title: const Text('Content Preferences'),
      ),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.block, color: KinnectColors.accent),
            title: const Text('Filter keywords', style: TextStyle(color: KinnectColors.textPrimary)),
            subtitle: const Text('Block specific words', style: TextStyle(color: KinnectColors.textSecondary, fontSize: 12)),
            trailing: const Icon(Icons.chevron_right, color: KinnectColors.textMuted),
            onTap: () {},
          ),
          SwitchListTile(
            title: const Text('Restricted Mode', style: TextStyle(color: KinnectColors.textPrimary)),
            subtitle: const Text('Limit mature content', style: TextStyle(color: KinnectColors.textSecondary, fontSize: 12)),
            value: _restrictedMode,
            activeColor: KinnectColors.accent,
            onChanged: (value) => setState(() => _restrictedMode = value),
          ),
          SwitchListTile(
            title: const Text('STEM feed', style: TextStyle(color: KinnectColors.textPrimary)),
            subtitle: const Text('Education-focused content', style: TextStyle(color: KinnectColors.textSecondary, fontSize: 12)),
            value: _stemFeed,
            activeColor: KinnectColors.accent,
            onChanged: (value) => setState(() => _stemFeed = value),
          ),
          ListTile(
            leading: const Icon(Icons.refresh, color: KinnectColors.accent),
            title: const Text('Refresh your Line', style: TextStyle(color: KinnectColors.textPrimary)),
            subtitle: const Text('Reset behavioral weights', style: TextStyle(color: KinnectColors.textSecondary, fontSize: 12)),
            trailing: const Icon(Icons.chevron_right, color: KinnectColors.textMuted),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
