import 'package:flutter/material.dart';
import '../theme/colors.dart';

class PersonalToolsScreen extends StatelessWidget {
  const PersonalToolsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: KinnectColors.darkBg,
      appBar: AppBar(
        backgroundColor: KinnectColors.darkSurface,
        title: const Text('Personal Tools'),
      ),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.mic, color: KinnectColors.amber),
            title: const Text('Voiceprint', style: TextStyle(color: KinnectColors.white)),
            subtitle: const Text('Voice cloning for Blooms', style: TextStyle(color: KinnectColors.grey60, fontSize: 12)),
            trailing: const Icon(Icons.chevron_right, color: KinnectColors.grey40),
            onTap: () => Navigator.pushNamed(context, '/voiceprint-capture'),
          ),
          ListTile(
            leading: const Icon(Icons.shield, color: KinnectColors.amber),
            title: const Text('Family Crest', style: TextStyle(color: KinnectColors.white)),
            subtitle: const Text('AI-generated crest', style: TextStyle(color: KinnectColors.grey60, fontSize: 12)),
            trailing: const Icon(Icons.chevron_right, color: KinnectColors.grey40),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.photo_library, color: KinnectColors.amber),
            title: const Text('Restore Tool', style: TextStyle(color: KinnectColors.white)),
            subtitle: const Text('Colorize & upscale photos', style: TextStyle(color: KinnectColors.grey60, fontSize: 12)),
            trailing: const Icon(Icons.chevron_right, color: KinnectColors.grey40),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.movie, color: KinnectColors.amber),
            title: const Text('Legacy Reel', style: TextStyle(color: KinnectColors.white)),
            subtitle: const Text('AI documentary generator', style: TextStyle(color: KinnectColors.grey60, fontSize: 12)),
            trailing: const Icon(Icons.chevron_right, color: KinnectColors.grey40),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
