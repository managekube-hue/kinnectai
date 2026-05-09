import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../cubits/settings_cubit.dart';
import '../router/app_nav.dart';
import '../theme/colors.dart';
import '../theme/typography.dart';

/// PRD Section 12.0 -- Top-Level Settings Menu.
///
/// 8 top-level items. Activity Center and Settings & Privacy expand inline
/// to show sub-category headers that each navigate to their own screen.
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _activityExpanded = false;
  bool _settingsExpanded = false;

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
      body: ListView(
        children: [
          // 1. Balance
          _TopItem(icon: PhosphorIcons.wallet, label: 'Balance', subtitle: 'Bloom Credits, Vault+, Kinnect Card', onTap: () => AppNav.push(context, '/settings/balance')),
          // 2. Personal tools
          _TopItem(icon: PhosphorIcons.wrench, label: 'Personal tools', subtitle: 'Voiceprint, Family Crest, Restore, DNA Kit', onTap: () => AppNav.push(context, '/settings/personal-tools')),
          // 3. Activity Center (expand to sub-categories)
          _ExpandableItem(
            icon: PhosphorIcons.clockCounterClockwise,
            label: 'Activity Center',
            subtitle: 'History, Time & Engagement, Content Permissions',
            expanded: _activityExpanded,
            onTap: () => setState(() => _activityExpanded = !_activityExpanded),
            children: [
              _SubItem(label: 'History', subtitle: 'Watch, comment, search, mention, account', onTap: () => AppNav.push(context, '/settings/activity-center')),
              _SubItem(label: 'Screen Time', subtitle: 'Daily and weekly usage stats', onTap: () => AppNav.push(context, '/time-wellbeing')),
              _SubItem(label: 'Content Permissions', subtitle: 'Memory reuse, visibility, Pulse permissions', onTap: () => AppNav.push(context, '/settings/activity-center')),
            ],
          ),
          // 4. Offline videos
          _TopItem(icon: PhosphorIcons.downloadSimple, label: 'Offline videos', subtitle: 'Downloaded Memories', onTap: () => AppNav.push(context, '/settings/offline-videos')),
          // 5. QR code
          _TopItem(icon: PhosphorIcons.qrCode, label: 'Your QR code', subtitle: 'Share your Root profile', onTap: () => AppNav.push(context, '/settings/qr-code')),
          // 6. Creation & business tools
          _TopItem(icon: PhosphorIcons.briefcase, label: 'Creation & business tools', subtitle: 'Analytics, Marketplace, API', onTap: () => AppNav.push(context, '/settings/business-tools')),
          // 7. Memory Box
          _TopItem(icon: PhosphorIcons.lock, label: 'Memory Box', subtitle: 'Vault settings, Steward, triggers, export', onTap: () => AppNav.push(context, '/settings/memory-box')),
          // 8. Settings and privacy (expand to sub-categories)
          _ExpandableItem(
            icon: PhosphorIcons.gear,
            label: 'Settings and privacy',
            subtitle: 'Content, well-being, family, account, security, notifications, privacy',
            expanded: _settingsExpanded,
            onTap: () => setState(() => _settingsExpanded = !_settingsExpanded),
            children: [
              _SubItem(label: 'Content Preferences', subtitle: 'Filter keywords, Restricted Mode, STEM, topics', onTap: () => AppNav.push(context, '/settings/content-preferences')),
              _SubItem(label: 'Time & Well-being', subtitle: 'Daily limits, breaks, night mode', onTap: () => AppNav.push(context, '/time-wellbeing')),
              _SubItem(label: 'Family Pairing', subtitle: 'Teen safety controls (COPPA)', onTap: () => AppNav.push(context, '/settings/family-pairing')),
              _SubItem(label: 'Account', subtitle: 'Password, Passkey, verification, data export, delete', onTap: () => AppNav.push(context, '/settings/account')),
              _SubItem(label: 'Security & Permissions', subtitle: 'Devices, 2FA, app permissions, browser', onTap: () => AppNav.push(context, '/settings/security')),
              _SubItem(label: 'Notifications', subtitle: '14 push + in-app notification toggles', onTap: () => AppNav.push(context, '/settings/notifications')),
              _SubItem(label: 'Privacy', subtitle: 'Visibility, genomic data, tracking, ads', onTap: () => AppNav.push(context, '/settings/privacy')),
            ],
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Top-level item (navigates directly)
// ---------------------------------------------------------------------------
class _TopItem extends StatelessWidget {
  const _TopItem({required this.icon, required this.label, required this.subtitle, required this.onTap});
  final IconData Function() icon;
  final String label;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon(), color: KinnectColors.accent),
      title: Text(label, style: const TextStyle(color: KinnectColors.textPrimary)),
      subtitle: Text(subtitle, style: const TextStyle(color: KinnectColors.textSecondary, fontSize: 12)),
      trailing: Icon(PhosphorIcons.caretRight(), color: KinnectColors.textMuted),
      onTap: onTap,
    );
  }
}

// ---------------------------------------------------------------------------
// Expandable item (shows sub-categories when tapped)
// ---------------------------------------------------------------------------
class _ExpandableItem extends StatelessWidget {
  const _ExpandableItem({required this.icon, required this.label, required this.subtitle, required this.expanded, required this.onTap, required this.children});
  final IconData Function() icon;
  final String label;
  final String subtitle;
  final bool expanded;
  final VoidCallback onTap;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          leading: Icon(icon(), color: KinnectColors.accent),
          title: Text(label, style: const TextStyle(color: KinnectColors.textPrimary)),
          subtitle: Text(subtitle, style: const TextStyle(color: KinnectColors.textSecondary, fontSize: 12)),
          trailing: AnimatedRotation(
            turns: expanded ? 0.5 : 0,
            duration: const Duration(milliseconds: 200),
            child: Icon(PhosphorIcons.caretDown(), color: KinnectColors.textMuted),
          ),
          onTap: onTap,
        ),
        AnimatedCrossFade(
          firstChild: const SizedBox.shrink(),
          secondChild: Container(
            margin: const EdgeInsets.only(left: 24),
            decoration: BoxDecoration(
              border: Border(left: BorderSide(color: KinnectColors.accent.withOpacity(0.3), width: 2)),
            ),
            child: Column(children: children),
          ),
          crossFadeState: expanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
          duration: const Duration(milliseconds: 200),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Sub-category item (navigates to its dedicated screen)
// ---------------------------------------------------------------------------
class _SubItem extends StatelessWidget {
  const _SubItem({required this.label, required this.subtitle, required this.onTap});
  final String label;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.only(left: 32, right: 16),
      title: Text(label, style: const TextStyle(color: KinnectColors.textPrimary, fontSize: 14, fontWeight: FontWeight.w500)),
      subtitle: Text(subtitle, style: TextStyle(color: KinnectColors.textSecondary, fontSize: 11)),
      trailing: Icon(PhosphorIcons.caretRight(), size: 16, color: KinnectColors.textMuted),
      onTap: onTap,
    );
  }
}
