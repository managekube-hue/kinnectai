import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../router/app_nav.dart';
import '../theme/colors.dart';
import '../theme/typography.dart';

/// PRD Section 06 -- Branch Page.
/// A Branch is not a group -- it is the living expression of a shared
/// ancestral line.
class BranchDetailScreen extends StatefulWidget {
  const BranchDetailScreen({super.key, required this.branchId});

  final String branchId;

  @override
  State<BranchDetailScreen> createState() => _BranchDetailScreenState();
}

class _BranchDetailScreenState extends State<BranchDetailScreen> with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  // TODO: fetch from API
  final _branchName = 'The Harrington Branch';
  final _memberCount = 47;
  final _activeCount = 12;
  final _countryCount = 14;
  final _stewardName = 'James Harrington';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
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
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          SliverAppBar(
            backgroundColor: KinnectColors.surface,
            pinned: true,
            expandedHeight: 220,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: KinnectColors.textPrimary),
              onPressed: () => Navigator.pop(context),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [KinnectColors.surfaceElevated, KinnectColors.surface],
                  ),
                ),
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 56, 16, 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 56,
                              height: 56,
                              decoration: BoxDecoration(
                                color: KinnectColors.accent.withOpacity(0.15),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Icon(PhosphorIcons.treeStructure(), size: 28, color: KinnectColors.accent),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(_branchName, style: KinnectTextStyles.headlineSmall),
                                  const SizedBox(height: 4),
                                  Text(
                                    '$_memberCount members -- $_activeCount active in last 30 days',
                                    style: TextStyle(color: KinnectColors.textSecondary, fontSize: 13),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Icon(PhosphorIcons.globe(), size: 14, color: KinnectColors.primary),
                            const SizedBox(width: 4),
                            Text(
                              'Members in $_countryCount countries',
                              style: TextStyle(color: KinnectColors.primary, fontSize: 13),
                            ),
                            const SizedBox(width: 16),
                            Icon(PhosphorIcons.shield(), size: 14, color: KinnectColors.accent),
                            const SizedBox(width: 4),
                            Text(
                              'Steward: $_stewardName',
                              style: TextStyle(color: KinnectColors.textSecondary, fontSize: 13),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            bottom: TabBar(
              controller: _tabController,
              isScrollable: true,
              indicatorColor: KinnectColors.accent,
              labelColor: KinnectColors.accent,
              unselectedLabelColor: KinnectColors.textSecondary,
              tabs: const [
                Tab(text: 'Memories'),
                Tab(text: 'Map'),
                Tab(text: 'Merge'),
                Tab(text: 'Markers'),
                Tab(text: 'Gatherings'),
              ],
            ),
          ),
        ],
        body: TabBarView(
          controller: _tabController,
          children: [
            _MemoriesTab(),
            _MapTab(),
            _MergeTab(branchId: widget.branchId),
            _MarkersTab(),
            _GatheringsTab(),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Memories Tab (PRD 06.2)
// ---------------------------------------------------------------------------
class _MemoriesTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 10,
      itemBuilder: (context, i) => Container(
        margin: const EdgeInsets.only(bottom: 12),
        height: 80,
        decoration: BoxDecoration(
          color: KinnectColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: KinnectColors.dividerSubtle),
        ),
        child: Row(
          children: [
            Container(
              width: 80,
              decoration: const BoxDecoration(
                color: KinnectColors.surfaceElevated,
                borderRadius: BorderRadius.horizontal(left: Radius.circular(12)),
              ),
              child: Center(child: Icon(PhosphorIcons.play(), color: KinnectColors.textMuted)),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Memory from Kin ${i + 1}', style: const TextStyle(color: KinnectColors.textPrimary, fontWeight: FontWeight.w600, fontSize: 14)),
                    const SizedBox(height: 4),
                    Text('Shared 3 days ago', style: TextStyle(color: KinnectColors.textSecondary, fontSize: 12)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Map Tab (PRD 06.2)
// ---------------------------------------------------------------------------
class _MapTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(PhosphorIcons.mapPin(), size: 64, color: KinnectColors.primary),
          const SizedBox(height: 16),
          Text('Branch Map', style: KinnectTextStyles.headlineSmall),
          const SizedBox(height: 8),
          Text(
            'Members pinned by location, colour-coded by haplogroup.',
            textAlign: TextAlign.center,
            style: TextStyle(color: KinnectColors.textSecondary, fontSize: 13),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Merge Tab (PRD 06.2)
// ---------------------------------------------------------------------------
class _MergeTab extends StatelessWidget {
  const _MergeTab({required this.branchId});

  final String branchId;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(PhosphorIcons.gitMerge(), size: 64, color: KinnectColors.accent),
            const SizedBox(height: 16),
            Text('Pending Merges', style: KinnectTextStyles.headlineSmall),
            const SizedBox(height: 8),
            Text(
              'No pending Branch Merge requests.\nTwo biologically related Branches can be unified here.',
              textAlign: TextAlign.center,
              style: TextStyle(color: KinnectColors.textSecondary, fontSize: 13),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Markers Tab (PRD 06.2)
// ---------------------------------------------------------------------------
class _MarkersTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: const [
        _MarkerTile(icon: Icons.sailing, title: 'Ellis Island Arrival', subtitle: 'Harrington, 1892', date: '1892'),
        _MarkerTile(icon: Icons.flag, title: 'County of Origin', subtitle: 'Cork, Ireland', date: '1840s'),
        _MarkerTile(icon: Icons.biotech, title: 'AADR Ancient DNA', subtitle: 'R1b haplogroup match', date: '~3000 BCE'),
      ],
    );
  }
}

class _MarkerTile extends StatelessWidget {
  const _MarkerTile({required this.icon, required this.title, required this.subtitle, required this.date});

  final IconData icon;
  final String title;
  final String subtitle;
  final String date;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: KinnectColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: KinnectColors.dividerSubtle),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: KinnectColors.accent.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: KinnectColors.accent, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(color: KinnectColors.textPrimary, fontWeight: FontWeight.w600, fontSize: 14)),
                Text(subtitle, style: TextStyle(color: KinnectColors.textSecondary, fontSize: 13)),
              ],
            ),
          ),
          Text(date, style: TextStyle(color: KinnectColors.textMuted, fontSize: 12)),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Gatherings Tab (PRD 06.2)
// ---------------------------------------------------------------------------
class _GatheringsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(PhosphorIcons.videoCamera(), size: 64, color: KinnectColors.primary),
          const SizedBox(height: 16),
          Text('Gatherings', style: KinnectTextStyles.headlineSmall),
          const SizedBox(height: 8),
          Text(
            'No upcoming Gatherings for this Branch.',
            style: TextStyle(color: KinnectColors.textSecondary, fontSize: 13),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () {},
            icon: Icon(PhosphorIcons.plus(), size: 18),
            label: const Text('Schedule Gathering'),
            style: ElevatedButton.styleFrom(
              backgroundColor: KinnectColors.accent,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
        ],
      ),
    );
  }
}
