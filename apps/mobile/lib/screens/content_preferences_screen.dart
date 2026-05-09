import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../theme/colors.dart';
import '../theme/typography.dart';

/// PRD Section 12.2 -- Content Preferences.
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
        title: Text('Content Preferences', style: KinnectTextStyles.headlineSmall),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: KinnectColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView(
        children: [
          ListTile(
            leading: Icon(PhosphorIcons.prohibit(), color: KinnectColors.accent),
            title: const Text('Filter keywords', style: TextStyle(color: KinnectColors.textPrimary)),
            subtitle: const Text('Block specific words', style: TextStyle(color: KinnectColors.textSecondary, fontSize: 12)),
            trailing: Icon(PhosphorIcons.caretRight(), color: KinnectColors.textMuted),
            onTap: () {},
          ),
          SwitchListTile(
            secondary: Icon(PhosphorIcons.shieldCheck(), color: KinnectColors.accent),
            title: const Text('Restricted Mode', style: TextStyle(color: KinnectColors.textPrimary)),
            subtitle: const Text('Limits mature or sensitive content', style: TextStyle(color: KinnectColors.textSecondary, fontSize: 12)),
            value: _restrictedMode,
            activeColor: KinnectColors.accent,
            onChanged: (v) => setState(() => _restrictedMode = v),
          ),
          SwitchListTile(
            secondary: Icon(PhosphorIcons.atom(), color: KinnectColors.accent),
            title: const Text('STEM feed', style: TextStyle(color: KinnectColors.textPrimary)),
            subtitle: const Text('Education-focused content', style: TextStyle(color: KinnectColors.textSecondary, fontSize: 12)),
            value: _stemFeed,
            activeColor: KinnectColors.accent,
            onChanged: (v) => setState(() => _stemFeed = v),
          ),
          ListTile(
            leading: Icon(PhosphorIcons.slidersHorizontal(), color: KinnectColors.accent),
            title: const Text('Manage topics', style: TextStyle(color: KinnectColors.textPrimary)),
            subtitle: const Text('Interests that modulate feed ranking', style: TextStyle(color: KinnectColors.textSecondary, fontSize: 12)),
            trailing: Icon(PhosphorIcons.caretRight(), color: KinnectColors.textMuted),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(PhosphorIcons.arrowCounterClockwise(), color: KinnectColors.accent),
            title: const Text('Refresh your Line', style: TextStyle(color: KinnectColors.textPrimary)),
            subtitle: const Text('Reset behavioral weights', style: TextStyle(color: KinnectColors.textSecondary, fontSize: 12)),
            trailing: Icon(PhosphorIcons.caretRight(), color: KinnectColors.textMuted),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(PhosphorIcons.speakerSlash(), color: KinnectColors.accent),
            title: const Text('Muted accounts/Branches', style: TextStyle(color: KinnectColors.textPrimary)),
            subtitle: const Text('Suppress without removing Kinnection', style: TextStyle(color: KinnectColors.textSecondary, fontSize: 12)),
            trailing: Icon(PhosphorIcons.caretRight(), color: KinnectColors.textMuted),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
