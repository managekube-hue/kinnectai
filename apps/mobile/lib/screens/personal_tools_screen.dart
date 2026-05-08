import 'package:flutter/material.dart';
import '../router/app_nav.dart';
import '../theme/colors.dart';

class PersonalToolsScreen extends StatelessWidget {
  const PersonalToolsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: KinnectColors.background,
      appBar: AppBar(
        backgroundColor: KinnectColors.surface,
        title: const Text('Personal Tools'),
      ),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.mic, color: KinnectColors.accent),
            title: const Text('Voiceprint', style: TextStyle(color: KinnectColors.textPrimary)),
            subtitle: const Text('Voice cloning for Blooms', style: TextStyle(color: KinnectColors.textSecondary, fontSize: 12)),
            trailing: const Icon(Icons.chevron_right, color: KinnectColors.textMuted),
            onTap: () => AppNav.push(context, '/voiceprint-capture'),
          ),
          ListTile(
            leading: const Icon(Icons.shield, color: KinnectColors.accent),
            title: const Text('Family Crest', style: TextStyle(color: KinnectColors.textPrimary)),
            subtitle: const Text('AI-generated crest', style: TextStyle(color: KinnectColors.textSecondary, fontSize: 12)),
            trailing: const Icon(Icons.chevron_right, color: KinnectColors.textMuted),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.photo_library, color: KinnectColors.accent),
            title: const Text('Restore Tool', style: TextStyle(color: KinnectColors.textPrimary)),
            subtitle: const Text('Colorize & upscale photos', style: TextStyle(color: KinnectColors.textSecondary, fontSize: 12)),
            trailing: const Icon(Icons.chevron_right, color: KinnectColors.textMuted),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.movie, color: KinnectColors.accent),
            title: const Text('Legacy Reel', style: TextStyle(color: KinnectColors.textPrimary)),
            subtitle: const Text('AI documentary generator', style: TextStyle(color: KinnectColors.textSecondary, fontSize: 12)),
            trailing: const Icon(Icons.chevron_right, color: KinnectColors.textMuted),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}



