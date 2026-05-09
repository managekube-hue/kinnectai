import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../router/app_nav.dart';
import '../theme/colors.dart';

class ActivityCenterScreen extends StatefulWidget {
  const ActivityCenterScreen({super.key});

  @override
  State<ActivityCenterScreen> createState() => _ActivityCenterScreenState();
}

class _ActivityCenterScreenState extends State<ActivityCenterScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: KinnectColors.background,
      appBar: AppBar(
        backgroundColor: KinnectColors.surface,
        title: const Text('Activity Center'),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: KinnectColors.accent,
          tabs: const [
            Tab(text: 'History'),
            Tab(text: 'Time & Engagement'),
            Tab(text: 'Content Permissions'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildHistoryTab(),
          _buildTimeTab(),
          _buildPermissionsTab(),
        ],
      ),
    );
  }

  Widget _buildHistoryTab() {
    return ListView(
      children: [
        _buildListItem('Watch history', 'All videos and Blooms viewed', PhosphorIcons.play(), true, () {}),
        _buildListItem('Comment history', 'All comments made', PhosphorIcons.chatCircleText(), true, () {}),
        _buildListItem('Search history', 'Search terms in Discovery', PhosphorIcons.magnifyingGlass(), true, () {}),
        _buildListItem('Mention history', '@mentions by other Kin', PhosphorIcons.at(), false, () {}),
        _buildListItem('Account history', 'Login events, device changes', PhosphorIcons.clockCounterClockwise(), false, () {}),
      ],
    );
  }

  Widget _buildTimeTab() {
    return ListView(
      children: [
        _buildListItem('Screen time', 'Daily and weekly usage stats', PhosphorIcons.timer(), false, () {
          AppNav.push(context, '/time-wellbeing');
        }),
        _buildListItem('Daily time limit', 'Set maximum daily usage', PhosphorIcons.alarm(), false, () {}),
        _buildListItem('Break reminders', 'Timed nudges during sessions', PhosphorIcons.pause(), false, () {}),
      ],
    );
  }

  Widget _buildPermissionsTab() {
    return ListView(
      children: [
        _buildListItem('Memory reuse history', 'Which Memories were Stitched', PhosphorIcons.filmStrip(), false, () {}),
        _buildListItem('Recently deleted', 'Deleted content (30 days)', PhosphorIcons.trash(), false, () {}),
        _buildListItem('Manage Memory visibility', 'Per-Memory control', PhosphorIcons.eye(), false, () {}),
        _buildListItem('Manage Pulse permissions', 'Who can Pulse on Memories', PhosphorIcons.heart(), false, () {}),
        _buildListItem('Manage Memory reuse', 'Stitch/Rewind permissions', PhosphorIcons.gear(), false, () {}),
      ],
    );
  }

  Widget _buildListItem(String title, String subtitle, IconData icon, bool showClear, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: KinnectColors.accent),
      title: Text(title, style: const TextStyle(color: KinnectColors.textPrimary)),
      subtitle: Text(subtitle, style: const TextStyle(color: KinnectColors.textSecondary, fontSize: 12)),
      trailing: showClear
          ? TextButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    backgroundColor: KinnectColors.surface,
                    title: const Text('Clear history?', style: TextStyle(color: KinnectColors.textPrimary)),
                    content: Text('This will clear your $title', style: const TextStyle(color: KinnectColors.textSecondary)),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Cancel', style: TextStyle(color: KinnectColors.textSecondary)),
                      ),
                      ElevatedButton(
                        onPressed: () => Navigator.pop(context),
                        style: ElevatedButton.styleFrom(backgroundColor: KinnectColors.error),
                        child: const Text('Clear'),
                      ),
                    ],
                  ),
                );
              },
              child: const Text('Clear', style: TextStyle(color: KinnectColors.error)),
            )
          : Icon(PhosphorIcons.caretRight(), color: KinnectColors.textMuted),
      onTap: onTap,
    );
  }
}



