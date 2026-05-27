import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../router/app_nav.dart';
import '../theme/colors.dart';
import '../theme/typography.dart';

/// PRD Section 06.2 -- Discover Branches.
/// Browse Branches that share ancestral overlap with the user's Tree.
class BranchDiscoveryScreen extends StatefulWidget {
  const BranchDiscoveryScreen({super.key});

  @override
  State<BranchDiscoveryScreen> createState() => _BranchDiscoveryScreenState();
}

class _BranchDiscoveryScreenState extends State<BranchDiscoveryScreen> {
  bool _isLoading = true;

  static final _branches = List.generate(12, (i) => _BranchPreview(
    id: 'br_$i',
    name: [
      'The Harrington Branch', 'The O\'Sullivan Line', 'The Murphy Clan',
      'The Walsh Ancestry', 'The Byrne Heritage', 'The Kelly Line',
      'The Doyle Branch', 'The Ryan Kinship', 'The Gallagher Line',
      'The Burke Heritage', 'The Vance Ancestry', 'The Smith Branch',
    ][i],
    memberCount: [47, 23, 89, 15, 34, 56, 12, 67, 41, 28, 19, 73][i],
    overlapScore: [0.85, 0.72, 0.65, 0.58, 0.51, 0.48, 0.42, 0.38, 0.35, 0.30, 0.25, 0.20][i],
    countryCount: [14, 8, 22, 5, 11, 17, 4, 19, 13, 9, 6, 21][i],
  ));

  @override
  void initState() {
    super.initState();
    Future<void>.delayed(const Duration(milliseconds: 600), () {
      if (mounted) setState(() => _isLoading = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: KinnectColors.background,
      appBar: AppBar(
        backgroundColor: KinnectColors.surface,
        title: const Text('Discover Branches', style: KinnectTextStyles.headlineSmall),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: KinnectColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation(KinnectColors.accent)))
          : GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.85,
              ),
              itemCount: _branches.length,
              itemBuilder: (context, i) => _BranchCard(branch: _branches[i]),
            ),
    );
  }
}

class _BranchPreview {
  const _BranchPreview({
    required this.id,
    required this.name,
    required this.memberCount,
    required this.overlapScore,
    required this.countryCount,
  });

  final String id;
  final String name;
  final int memberCount;
  final double overlapScore;
  final int countryCount;
}

class _BranchCard extends StatelessWidget {
  const _BranchCard({required this.branch});

  final _BranchPreview branch;

  @override
  Widget build(BuildContext context) {
    final scorePct = (branch.overlapScore * 100).round();
    final scoreColor = scorePct >= 70 ? KinnectColors.accent : scorePct >= 50 ? KinnectColors.primary : KinnectColors.textSecondary;

    return GestureDetector(
      onTap: () => AppNav.push(context, '/branch/${branch.id}'),
      child: Container(
        decoration: BoxDecoration(
          color: KinnectColors.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: KinnectColors.dividerSubtle),
        ),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Overlap score badge
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: KinnectColors.accent.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(PhosphorIcons.treeStructure(), size: 24, color: KinnectColors.accent),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: scoreColor.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      '$scorePct%',
                      style: TextStyle(color: scoreColor, fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Text(
                branch.name,
                style: const TextStyle(color: KinnectColors.textPrimary, fontWeight: FontWeight.w600, fontSize: 14),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 6),
              Text(
                '${branch.memberCount} members',
                style: const TextStyle(color: KinnectColors.textSecondary, fontSize: 12),
              ),
              const SizedBox(height: 2),
              Row(
                children: [
                  Icon(PhosphorIcons.globe(), size: 12, color: KinnectColors.textMuted),
                  const SizedBox(width: 3),
                  Text(
                    '${branch.countryCount} countries',
                    style: const TextStyle(color: KinnectColors.textMuted, fontSize: 11),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
