import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../router/app_nav.dart';
import '../theme/colors.dart';
import '../theme/typography.dart';

/// PRD Section 12.0 -- Personal Tools.
class PersonalToolsScreen extends StatelessWidget {
  const PersonalToolsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: KinnectColors.background,
      appBar: AppBar(
        backgroundColor: KinnectColors.surface,
        title: Text('Personal Tools', style: KinnectTextStyles.headlineSmall),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: KinnectColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView(
        children: [
          ListTile(
            leading: Icon(PhosphorIcons.microphone(), color: KinnectColors.accent),
            title: const Text('Voiceprint', style: TextStyle(color: KinnectColors.textPrimary)),
            subtitle: const Text('Voice cloning for Blooms', style: TextStyle(color: KinnectColors.textSecondary, fontSize: 12)),
            trailing: Icon(PhosphorIcons.caretRight(), color: KinnectColors.textMuted),
            onTap: () => AppNav.push(context, '/voiceprint-capture'),
          ),
          ListTile(
            leading: Icon(PhosphorIcons.shield(), color: KinnectColors.accent),
            title: const Text('Family Crest', style: TextStyle(color: KinnectColors.textPrimary)),
            subtitle: const Text('AI-generated crest', style: TextStyle(color: KinnectColors.textSecondary, fontSize: 12)),
            trailing: Icon(PhosphorIcons.caretRight(), color: KinnectColors.textMuted),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(PhosphorIcons.magicWand(), color: KinnectColors.accent),
            title: const Text('Restore Tool', style: TextStyle(color: KinnectColors.textPrimary)),
            subtitle: const Text('Colorize & upscale photos', style: TextStyle(color: KinnectColors.textSecondary, fontSize: 12)),
            trailing: Icon(PhosphorIcons.caretRight(), color: KinnectColors.textMuted),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(PhosphorIcons.filmStrip(), color: KinnectColors.accent),
            title: const Text('Legacy Reel', style: TextStyle(color: KinnectColors.textPrimary)),
            subtitle: const Text('AI documentary generator', style: TextStyle(color: KinnectColors.textSecondary, fontSize: 12)),
            trailing: Icon(PhosphorIcons.caretRight(), color: KinnectColors.textMuted),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(PhosphorIcons.dna(), color: KinnectColors.accent),
            title: const Text('DNA Kit', style: TextStyle(color: KinnectColors.textPrimary)),
            subtitle: const Text('Order or check kit status', style: TextStyle(color: KinnectColors.textSecondary, fontSize: 12)),
            trailing: Icon(PhosphorIcons.caretRight(), color: KinnectColors.textMuted),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
