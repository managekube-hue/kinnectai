import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../theme/colors.dart';
import '../theme/typography.dart';

/// PRD Section 08.1 -- Rooms List Screen.
class RoomListScreen extends StatefulWidget {
  const RoomListScreen({super.key});

  @override
  State<RoomListScreen> createState() => _RoomListScreenState();
}

class _RoomListScreenState extends State<RoomListScreen> with SingleTickerProviderStateMixin {
  late final TabController _tabController;

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
        title: const Text('Rooms', style: KinnectTextStyles.headlineSmall),
        leading: IconButton(icon: const Icon(Icons.arrow_back, color: KinnectColors.textPrimary), onPressed: () => Navigator.pop(context)),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: KinnectColors.accent,
          labelColor: KinnectColors.accent,
          unselectedLabelColor: KinnectColors.textSecondary,
          tabs: const [Tab(text: 'Active Now'), Tab(text: 'Scheduled'), Tab(text: 'Past')],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [_ActiveTab(), _ScheduledTab(), _PastTab()],
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: KinnectColors.accent,
        onPressed: () {},
        icon: Icon(PhosphorIcons.plus(), color: KinnectColors.background),
        label: const Text('Start Room', style: TextStyle(color: KinnectColors.background)),
      ),
    );
  }
}

class _ActiveTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const _RoomCard(name: 'Harrington Family Call', host: 'James Harrington', participants: 4, duration: '12 min', isLive: false),
        const _RoomCard(name: 'Sunday Catch-up', host: 'Emily Harrington', participants: 8, duration: '45 min', isLive: true),
      ],
    );
  }
}

class _ScheduledTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const _GatheringCard(name: 'Monthly Branch Meeting', date: 'May 15, 2026 at 7:00 PM', invitedCount: 23, hasRsvp: true),
        const _GatheringCard(name: 'Reunion Planning', date: 'May 22, 2026 at 3:00 PM', invitedCount: 12, hasRsvp: false),
      ],
    );
  }
}

class _PastTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(child: Column(mainAxisSize: MainAxisSize.min, children: [
      Icon(PhosphorIcons.videoCamera(), size: 48, color: KinnectColors.textMuted),
      const SizedBox(height: 12),
      const Text('No past recordings', style: TextStyle(color: KinnectColors.textSecondary)),
    ]));
  }
}

class _RoomCard extends StatelessWidget {
  const _RoomCard({required this.name, required this.host, required this.participants, required this.duration, required this.isLive});
  final String name, host, duration;
  final int participants;
  final bool isLive;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: KinnectColors.surface, borderRadius: BorderRadius.circular(12), border: Border.all(color: KinnectColors.dividerSubtle)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Expanded(child: Text(name, style: const TextStyle(color: KinnectColors.textPrimary, fontWeight: FontWeight.w600, fontSize: 16))),
          if (isLive) Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3), decoration: BoxDecoration(color: KinnectColors.error, borderRadius: BorderRadius.circular(8)), child: const Text('LIVE', style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold))),
        ]),
        const SizedBox(height: 6),
        Text('Hosted by $host -- $participants participants -- $duration', style: const TextStyle(color: KinnectColors.textSecondary, fontSize: 13)),
        const SizedBox(height: 12),
        SizedBox(width: double.infinity, child: ElevatedButton(onPressed: () {}, style: ElevatedButton.styleFrom(backgroundColor: KinnectColors.accent, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))), child: const Text('Join'))),
      ]),
    );
  }
}

class _GatheringCard extends StatelessWidget {
  const _GatheringCard({required this.name, required this.date, required this.invitedCount, required this.hasRsvp});
  final String name, date;
  final int invitedCount;
  final bool hasRsvp;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: KinnectColors.surface, borderRadius: BorderRadius.circular(12), border: Border.all(color: KinnectColors.dividerSubtle)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(name, style: const TextStyle(color: KinnectColors.textPrimary, fontWeight: FontWeight.w600, fontSize: 16)),
        const SizedBox(height: 4),
        Row(children: [Icon(PhosphorIcons.calendarBlank(), size: 14, color: KinnectColors.textSecondary), const SizedBox(width: 4), Text(date, style: const TextStyle(color: KinnectColors.textSecondary, fontSize: 13))]),
        const SizedBox(height: 4),
        Text('$invitedCount Kin invited', style: const TextStyle(color: KinnectColors.textMuted, fontSize: 12)),
        const SizedBox(height: 12),
        SizedBox(width: double.infinity, child: hasRsvp
          ? OutlinedButton(onPressed: () {}, style: OutlinedButton.styleFrom(foregroundColor: KinnectColors.success, side: const BorderSide(color: KinnectColors.success)), child: const Text('RSVP\'d'))
          : ElevatedButton(onPressed: () {}, style: ElevatedButton.styleFrom(backgroundColor: KinnectColors.accent, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))), child: const Text('RSVP'))),
      ]),
    );
  }
}
