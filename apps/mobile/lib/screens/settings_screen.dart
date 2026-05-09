import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../cubits/settings_cubit.dart';
import '../models/dtos/settings_state_dto.dart';
import '../router/app_nav.dart';
import '../theme/colors.dart';
import '../theme/typography.dart';

/// PRD Section 12.0 -- Top-Level Settings Menu.
///
/// Parent-child expandable structure:
/// - Balance -> navigate
/// - Personal tools -> navigate
/// - Activity Center -> EXPAND INLINE (History, Time & Engagement, Content Permissions)
/// - Offline videos -> navigate
/// - Your QR code -> navigate
/// - Creation & business tools -> navigate
/// - Memory Box -> navigate to /settings/memory-box
/// - Settings and privacy -> EXPAND INLINE (Content Preferences, Time & Well-being, Family Pairing, Account, Security, Notifications, Privacy)
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _activityCenterExpanded = false;
  bool _settingsPrivacyExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: KinnectColors.background,
      appBar: AppBar(
        backgroundColor: KinnectColors.surface,
        title: Text('Settings and privacy', style: KinnectTextStyles.headlineSmall),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: KinnectColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: BlocBuilder<SettingsCubit, SettingsState>(
        builder: (context, state) {
          return ListView(
            children: [
              // 1. Balance
              _navItem(PhosphorIcons.wallet(), 'Balance', 'Bloom Credits, Vault+, Kinnect Card', '/settings/balance'),
              // 2. Personal tools
              _navItem(PhosphorIcons.wrench(), 'Personal tools', 'Voiceprint, Family Crest, Restore, DNA Kit', '/settings/personal-tools'),
              // 3. Activity Center (EXPANDS INLINE)
              _expandItem(
                PhosphorIcons.clockCounterClockwise(),
                'Activity Center',
                'History, Time & Engagement, Content Permissions',
                _activityCenterExpanded,
                () => setState(() => _activityCenterExpanded = !_activityCenterExpanded),
                _buildActivityCenterChildren(),
              ),
              // 4. Offline videos
              _navItem(PhosphorIcons.downloadSimple(), 'Offline videos', 'Downloaded Memories', '/settings/offline-videos'),
              // 5. Your QR code
              _navItem(PhosphorIcons.qrCode(), 'Your QR code', 'Share your Root profile', '/settings/qr-code'),
              // 6. Creation & business tools
              _navItem(PhosphorIcons.briefcase(), 'Creation & business tools', 'Analytics, Marketplace, API', '/settings/business-tools'),
              // 7. Memory Box
              _navItem(PhosphorIcons.lock(), 'Memory Box', 'Vault settings, Steward, triggers', '/settings/memory-box'),
              // 8. Settings and privacy (EXPANDS INLINE)
              _expandItem(
                PhosphorIcons.gear(),
                'Settings and privacy',
                'Content Preferences, Well-being, Family, Account, Security, Notifications, Privacy',
                _settingsPrivacyExpanded,
                () => setState(() => _settingsPrivacyExpanded = !_settingsPrivacyExpanded),
                _buildSettingsPrivacyChildren(),
              ),
              const SizedBox(height: 32),
            ],
          );
        },
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Activity Center inline expansion (PRD Section 2)
  // ---------------------------------------------------------------------------
  List<Widget> _buildActivityCenterChildren() {
    return [
      _sectionHeader('History'),
      _childNav(PhosphorIcons.play(), 'Watch history', 'Videos and Blooms viewed', clearable: true),
      _childNav(PhosphorIcons.chatCircleText(), 'Comment history', 'All comments made', clearable: true),
      _childNav(PhosphorIcons.magnifyingGlass(), 'Search history', 'Search terms in Discovery', clearable: true),
      _childNav(PhosphorIcons.at(), 'Mention history', '@mentions by other Kin'),
      _childNav(PhosphorIcons.clockCounterClockwise(), 'Account history', 'Login events, device changes'),
      _sectionHeader('Time & Engagement'),
      _childNavRoute(PhosphorIcons.timer(), 'Screen time', 'Daily and weekly usage stats', '/time-wellbeing'),
      _sectionHeader('Content Permissions'),
      _childNav(PhosphorIcons.filmStrip(), 'Memory reuse history', 'Which Memories were Stitched'),
      _childNav(PhosphorIcons.trash(), 'Recently deleted', 'Deleted content (30 days)'),
      _childNav(PhosphorIcons.eye(), 'Manage Memory visibility', 'Per-Memory control'),
      _childNav(PhosphorIcons.heart(), 'Manage Pulse permissions', 'Who can Pulse on Memories'),
      _childNav(PhosphorIcons.gear(), 'Manage Memory reuse', 'Stitch/Rewind permissions'),
    ];
  }

  // ---------------------------------------------------------------------------
  // Settings and privacy inline expansion (PRD Sections 3-7)
  // ---------------------------------------------------------------------------
  List<Widget> _buildSettingsPrivacyChildren() {
    return [
      _childNavRoute(PhosphorIcons.slidersHorizontal(), 'Content Preferences', 'Filter keywords, topics, Restricted Mode', '/settings/content-preferences'),
      _childNavRoute(PhosphorIcons.timer(), 'Time & Well-being', 'Daily limits, breaks, night mode', '/time-wellbeing'),
      _childNavRoute(PhosphorIcons.usersThree(), 'Family Pairing', 'Teen safety controls', '/settings/family-pairing'),
      _childNavRoute(PhosphorIcons.user(), 'Account', 'Password, verification, data export', '/settings/account'),
      _childNavRoute(PhosphorIcons.shieldCheck(), 'Security & Permissions', 'Devices, 2FA, app permissions', '/settings/security'),
      _childNavRoute(PhosphorIcons.bell(), 'Notifications', 'Push and in-app notification toggles', '/settings/notifications'),
      _childNavRoute(PhosphorIcons.eye(), 'Privacy', 'Visibility, data controls, genomic, tracking', '/settings/privacy'),
    ];
  }

  // ---------------------------------------------------------------------------
  // Widget builders
  // ---------------------------------------------------------------------------

  Widget _navItem(IconData Function() icon, String title, String subtitle, String route) {
    return ListTile(
      leading: Icon(icon(), color: KinnectColors.accent),
      title: Text(title, style: const TextStyle(color: KinnectColors.textPrimary)),
      subtitle: Text(subtitle, style: const TextStyle(color: KinnectColors.textSecondary, fontSize: 12)),
      trailing: Icon(PhosphorIcons.caretRight(), color: KinnectColors.textMuted),
      onTap: () => AppNav.push(context, route),
    );
  }

  Widget _expandItem(IconData Function() icon, String title, String subtitle, bool expanded, VoidCallback onTap, List<Widget> children) {
    return Column(
      children: [
        ListTile(
          leading: Icon(icon(), color: KinnectColors.accent),
          title: Text(title, style: const TextStyle(color: KinnectColors.textPrimary)),
          subtitle: Text(subtitle, style: const TextStyle(color: KinnectColors.textSecondary, fontSize: 12)),
          trailing: Icon(
            expanded ? PhosphorIcons.caretUp() : PhosphorIcons.caretDown(),
            color: KinnectColors.textMuted,
          ),
          onTap: onTap,
        ),
        if (expanded)
          Container(
            color: KinnectColors.surfaceElevated.withOpacity(0.3),
            child: Column(children: children),
          ),
      ],
    );
  }

  Widget _sectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(56, 16, 16, 4),
      child: Text(title, style: TextStyle(color: KinnectColors.accent, fontSize: 12, fontWeight: FontWeight.bold)),
    );
  }

  Widget _childNav(IconData Function() icon, String title, String subtitle, {bool clearable = false}) {
    return ListTile(
      contentPadding: const EdgeInsets.only(left: 56, right: 16),
      leading: Icon(icon(), size: 20, color: KinnectColors.textSecondary),
      title: Text(title, style: const TextStyle(color: KinnectColors.textPrimary, fontSize: 14)),
      subtitle: Text(subtitle, style: TextStyle(color: KinnectColors.textSecondary, fontSize: 11)),
      trailing: clearable
          ? TextButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$title cleared'), backgroundColor: KinnectColors.success));
              },
              child: Text('Clear', style: TextStyle(color: KinnectColors.primary, fontSize: 12)),
            )
          : Icon(PhosphorIcons.caretRight(), size: 16, color: KinnectColors.textMuted),
      onTap: () {},
    );
  }

  Widget _childNavRoute(IconData Function() icon, String title, String subtitle, String route) {
    return ListTile(
      contentPadding: const EdgeInsets.only(left: 56, right: 16),
      leading: Icon(icon(), size: 20, color: KinnectColors.textSecondary),
      title: Text(title, style: const TextStyle(color: KinnectColors.textPrimary, fontSize: 14)),
      subtitle: Text(subtitle, style: TextStyle(color: KinnectColors.textSecondary, fontSize: 11)),
      trailing: Icon(PhosphorIcons.caretRight(), size: 16, color: KinnectColors.textMuted),
      onTap: () => AppNav.push(context, route),
    );
  }
}
