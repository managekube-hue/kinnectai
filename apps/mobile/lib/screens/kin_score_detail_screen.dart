import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../theme/colors.dart';
import '../theme/typography.dart';
import '../theme/spacing.dart';
import '../models/memory.dart';
import '../services/kernel_service.dart';

class KinScoreDetailScreen extends StatefulWidget {
  final String targetUserId;

  const KinScoreDetailScreen({super.key, required this.targetUserId});

  @override
  State<KinScoreDetailScreen> createState() => _KinScoreDetailScreenState();
}

class _KinScoreDetailScreenState extends State<KinScoreDetailScreen> {
  final KernelService _kernelService = KernelService();
  KinScoreBreakdown? _breakdown;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadBreakdown();
  }

  Future<void> _loadBreakdown() async {
    final breakdown = await _kernelService.getKinScoreBreakdown(
      'current_user_id',
      widget.targetUserId,
    );
    setState(() {
      _breakdown = breakdown;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: KinnectColors.background,
      appBar: AppBar(
        backgroundColor: KinnectColors.surface,
        title: const Text('Kin Score', style: KinnectTextStyles.headlineSmall),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: KinnectColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation(KinnectColors.accent),
              ),
            )
          : _breakdown == null
          ? const Center(
              child: Text(
                'Unable to load Kin Score',
                style: KinnectTextStyles.bodyMedium,
              ),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(KinnectSpacing.lg),
              child: Column(
                children: [
                  _ScoreCircle(score: _breakdown!.score),
                  const SizedBox(height: KinnectSpacing.xl),
                  _InfoCard(
                    title: 'Relationship',
                    value: _breakdown!.relationship,
                    icon: PhosphorIcons.usersThree(),
                  ),
                  const SizedBox(height: KinnectSpacing.md),
                  _InfoCard(
                    title: 'Shared Branches',
                    value: '${_breakdown!.sharedBranches}',
                    icon: PhosphorIcons.treeStructure(),
                  ),
                  const SizedBox(height: KinnectSpacing.md),
                  _InfoCard(
                    title: 'Shared Ancestors',
                    value: '${_breakdown!.sharedAncestors}',
                    icon: PhosphorIcons.usersThree(),
                  ),
                  if (_breakdown!.haplogroup != null) ...[
                    const SizedBox(height: KinnectSpacing.md),
                    _InfoCard(
                      title: 'Haplogroup',
                      value: _breakdown!.haplogroup!,
                      icon: PhosphorIcons.dna(),
                    ),
                  ],
                  if (_breakdown!.connectionPath.isNotEmpty) ...[
                    const SizedBox(height: KinnectSpacing.xl),
                    _ConnectionPath(path: _breakdown!.connectionPath),
                  ],
                ],
              ),
            ),
    );
  }
}

class _ScoreCircle extends StatelessWidget {
  final double score;

  const _ScoreCircle({required this.score});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      height: 200,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [
            KinnectColors.success.withOpacity(0.3),
            KinnectColors.success.withOpacity(0.1),
          ],
        ),
        border: Border.all(color: KinnectColors.success, width: 4),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '${(score * 100).toInt()}%',
              style: KinnectTextStyles.displayLarge.copyWith(
                color: KinnectColors.success,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'Kin Score',
              style: KinnectTextStyles.bodyLarge.copyWith(
                color: KinnectColors.textMediumEmphasis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;

  const _InfoCard({
    required this.title,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(KinnectSpacing.md),
      decoration: BoxDecoration(
        color: KinnectColors.surface,
        borderRadius: BorderRadius.circular(KinnectSpacing.radiusMedium),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: KinnectColors.accent.withOpacity(0.2),
              borderRadius: BorderRadius.circular(KinnectSpacing.radiusSmall),
            ),
            child: Icon(icon, color: KinnectColors.accent),
          ),
          const SizedBox(width: KinnectSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: KinnectTextStyles.caption.copyWith(
                    color: KinnectColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(value, style: KinnectTextStyles.headlineSmall),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ConnectionPath extends StatelessWidget {
  final List<String> path;

  const _ConnectionPath({required this.path});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Connection Path', style: KinnectTextStyles.headlineSmall),
        const SizedBox(height: KinnectSpacing.md),
        ...List.generate(path.length, (index) {
          final isLast = index == path.length - 1;
          return Column(
            children: [
              Container(
                padding: const EdgeInsets.all(KinnectSpacing.md),
                decoration: BoxDecoration(
                  color: KinnectColors.surface,
                  borderRadius: BorderRadius.circular(
                    KinnectSpacing.radiusMedium,
                  ),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 16,
                      backgroundColor: KinnectColors.accent.withOpacity(0.2),
                      child: Text(
                        path[index][0].toUpperCase(),
                        style: KinnectTextStyles.bodyMedium.copyWith(
                          color: KinnectColors.accent,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: KinnectSpacing.sm),
                    Text(path[index], style: KinnectTextStyles.bodyLarge),
                  ],
                ),
              ),
              if (!isLast)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Icon(
                    PhosphorIcons.arrowDown(),
                    color: KinnectColors.accent,
                    size: 20,
                  ),
                ),
            ],
          );
        }),
      ],
    );
  }
}
