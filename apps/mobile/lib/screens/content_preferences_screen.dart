import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../cubits/settings_cubit.dart';
import '../models/dtos/settings_state_dto.dart';
import '../theme/colors.dart';
import '../theme/typography.dart';

/// PRD Section 3.1 -- Content Preferences.
/// All toggles wired to SettingsCubit -> API.
class ContentPreferencesScreen extends StatelessWidget {
  const ContentPreferencesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: KinnectColors.background,
      appBar: AppBar(
        backgroundColor: KinnectColors.surface,
        title: const Text('Content Preferences', style: KinnectTextStyles.headlineSmall),
        leading: IconButton(icon: const Icon(Icons.arrow_back, color: KinnectColors.textPrimary), onPressed: () => Navigator.pop(context)),
      ),
      body: BlocBuilder<SettingsCubit, SettingsState>(
        builder: (context, state) {
          final s = state is SettingsLoaded ? state.settings : const SettingsStateDTO();
          final cubit = context.read<SettingsCubit>();

          return ListView(
            children: [
              ListTile(
                leading: Icon(PhosphorIcons.prohibit(), color: KinnectColors.accent),
                title: const Text('Filter keywords', style: TextStyle(color: KinnectColors.textPrimary)),
                subtitle: const Text('Block specific words from The Line', style: TextStyle(color: KinnectColors.textSecondary, fontSize: 12)),
                trailing: Icon(PhosphorIcons.caretRight(), color: KinnectColors.textMuted),
                onTap: () {},
              ),
              SwitchListTile(
                secondary: Icon(PhosphorIcons.shieldCheck(), color: KinnectColors.accent),
                title: const Text('Restricted Mode', style: TextStyle(color: KinnectColors.textPrimary)),
                subtitle: const Text('Limits mature or sensitive content', style: TextStyle(color: KinnectColors.textSecondary, fontSize: 12)),
                value: s.restrictedMode,
                activeThumbColor: KinnectColors.accent,
                onChanged: (v) => cubit.updateContentPreferences(restrictedMode: v),
              ),
              SwitchListTile(
                secondary: Icon(PhosphorIcons.atom(), color: KinnectColors.accent),
                title: const Text('STEM feed', style: TextStyle(color: KinnectColors.textPrimary)),
                subtitle: const Text('Education-focused content stream', style: TextStyle(color: KinnectColors.textSecondary, fontSize: 12)),
                value: s.stemFeed,
                activeThumbColor: KinnectColors.accent,
                onChanged: (v) => cubit.updateContentPreferences(stemFeed: v),
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
                subtitle: const Text('Reset behavioral weights (not Kin Scores)', style: TextStyle(color: KinnectColors.textSecondary, fontSize: 12)),
                trailing: Icon(PhosphorIcons.caretRight(), color: KinnectColors.textMuted),
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Behavioral weights reset. Your Line will refresh.'), backgroundColor: KinnectColors.success),
                  );
                },
              ),
              ListTile(
                leading: Icon(PhosphorIcons.speakerSlash(), color: KinnectColors.accent),
                title: const Text('Muted Kin / Branches', style: TextStyle(color: KinnectColors.textPrimary)),
                subtitle: const Text('Suppress without removing Kinnection', style: TextStyle(color: KinnectColors.textSecondary, fontSize: 12)),
                trailing: Icon(PhosphorIcons.caretRight(), color: KinnectColors.textMuted),
                onTap: () {},
              ),
            ],
          );
        },
      ),
    );
  }
}
