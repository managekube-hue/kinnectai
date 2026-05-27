import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../router/app_nav.dart';
import '../theme/colors.dart';
import '../theme/typography.dart';

/// PRD Home Right Rail -- Branch icon.
/// Shows Branch subgraph: geographic map + member list + Memories tab.
/// Opened as a modal from The Line.
class BranchSubgraphScreen extends StatelessWidget {
  const BranchSubgraphScreen({super.key, this.branchId});

  final String? branchId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: KinnectColors.background,
      appBar: AppBar(
        backgroundColor: KinnectColors.surface,
        title: const Text('Branch Subgraph', style: KinnectTextStyles.headlineSmall),
        leading: IconButton(
          icon: const Icon(Icons.close, color: KinnectColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          if (branchId != null)
            TextButton(
              onPressed: () => AppNav.push(context, '/branch/$branchId'),
              child: const Text('Full Branch', style: TextStyle(color: KinnectColors.primary)),
            ),
        ],
      ),
      body: branchId == null
          ? _buildNoBranch(context)
          : _buildSubgraph(context),
    );
  }

  Widget _buildNoBranch(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(PhosphorIcons.treeStructure(), size: 64, color: KinnectColors.textMuted),
            const SizedBox(height: 16),
            const Text('Join a Branch to activate', style: KinnectTextStyles.headlineSmall),
            const SizedBox(height: 8),
            const Text(
              'This Memory doesn\'t belong to a Branch yet. Explore Discovery to find your ancestral lines.',
              textAlign: TextAlign.center,
              style: TextStyle(color: KinnectColors.textSecondary, fontSize: 14),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => AppNav.go(context, '/discover'),
              icon: Icon(PhosphorIcons.magnifyingGlass(), size: 18),
              label: const Text('Explore Discovery'),
              style: ElevatedButton.styleFrom(
                backgroundColor: KinnectColors.accent,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSubgraph(BuildContext context) {
    return Column(
      children: [
        // Map area
        Container(
          height: 220,
          width: double.infinity,
          color: KinnectColors.surfaceElevated,
          child: Stack(
            children: [
              Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(PhosphorIcons.mapPin(), size: 40, color: KinnectColors.primary),
                    const SizedBox(height: 8),
                    const Text('Branch Geographic View', style: TextStyle(color: KinnectColors.textSecondary)),
                  ],
                ),
              ),
              // Simulated node pins
              for (var i = 0; i < 5; i++)
                Positioned(
                  left: 40.0 + i * 60,
                  top: 60.0 + (i % 3) * 40,
                  child: _NodePin(
                    color: i < 2 ? KinnectColors.success : i < 4 ? KinnectColors.primary : KinnectColors.accent,
                    label: ['You', 'Parent', 'Cousin', 'Uncle', 'GGP'][i],
                  ),
                ),
            ],
          ),
        ),

        // Legend
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          color: KinnectColors.surface,
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _LegendDot(color: KinnectColors.success, label: 'Living'),
              SizedBox(width: 20),
              _LegendDot(color: Colors.grey, label: 'Deceased'),
              SizedBox(width: 20),
              _LegendDot(color: KinnectColors.accent, label: 'Historical'),
            ],
          ),
        ),

        // Members in this subgraph
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Row(
            children: [
              const Text('Subgraph Members', style: KinnectTextStyles.headlineSmall),
              const Spacer(),
              TextButton(
                onPressed: () => AppNav.push(context, '/branch/$branchId/members'),
                child: const Text('View All'),
              ),
            ],
          ),
        ),

        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: 6,
            itemBuilder: (context, i) {
              final names = ['You', 'Emily Harrington', 'James Harrington', 'Margaret Smith', 'Thomas Vance', 'Robert Harrington'];
              final types = ['Self', 'Parent', '1st Cousin', 'Grandparent (deceased)', 'Great-uncle (deceased)', 'AADR match'];
              final nodeColors = [KinnectColors.success, KinnectColors.success, KinnectColors.success, Colors.grey, Colors.grey, KinnectColors.accent];

              return ListTile(
                leading: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: nodeColors[i].withOpacity(0.15),
                    border: Border.all(color: nodeColors[i], width: 2),
                  ),
                  child: Icon(PhosphorIcons.user(), size: 18, color: nodeColors[i]),
                ),
                title: Text(names[i], style: const TextStyle(color: KinnectColors.textPrimary, fontWeight: FontWeight.w600, fontSize: 14)),
                subtitle: Text(types[i], style: const TextStyle(color: KinnectColors.textSecondary, fontSize: 12)),
                trailing: i == 0 ? null : Icon(PhosphorIcons.caretRight(), size: 16, color: KinnectColors.textMuted),
                onTap: i == 0 ? null : () => AppNav.push(context, '/root/user_$i'),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _NodePin extends StatelessWidget {
  const _NodePin({required this.color, required this.label});
  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 2),
            boxShadow: [BoxShadow(color: color.withOpacity(0.3), blurRadius: 6)],
          ),
          child: Icon(PhosphorIcons.user(), size: 14, color: Colors.white),
        ),
        const SizedBox(height: 2),
        Text(label, style: const TextStyle(color: KinnectColors.textSecondary, fontSize: 9)),
      ],
    );
  }
}

class _LegendDot extends StatelessWidget {
  const _LegendDot({required this.color, required this.label});
  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(width: 10, height: 10, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 4),
        Text(label, style: const TextStyle(color: KinnectColors.textSecondary, fontSize: 12)),
      ],
    );
  }
}
