import 'package:flutter/material.dart';
import '../theme/colors.dart';
import '../theme/typography.dart';
import '../theme/spacing.dart';
import '../models/memory.dart';

/// Right rail interaction buttons for The Line
class RightRailButtons extends StatelessWidget {
  final Memory memory;
  final VoidCallback onPulseTap;
  final VoidCallback onCommentTap;
  final VoidCallback onRewindTap;
  final VoidCallback onSaveTap;
  final VoidCallback onShareTap;
  final VoidCallback onBranchTap;
  final VoidCallback onNetworkTap;

  const RightRailButtons({
    super.key,
    required this.memory,
    required this.onPulseTap,
    required this.onCommentTap,
    required this.onRewindTap,
    required this.onSaveTap,
    required this.onShareTap,
    required this.onBranchTap,
    required this.onNetworkTap,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: 12,
      bottom: 120,
      child: Column(
        children: [
          // Pulse/Like
          _InteractionButton(
            icon: memory.isPulsed ? Icons.favorite : Icons.favorite_border,
            iconColor: memory.isPulsed ? KinnectColors.error : KinnectColors.white,
            label: memory.formattedPulseCount,
            onTap: onPulseTap,
          ),
          
          const SizedBox(height: KinnectSpacing.lg),
          
          // Comment
          _InteractionButton(
            icon: Icons.chat_bubble_outline,
            label: memory.formattedCommentCount,
            onTap: onCommentTap,
          ),
          
          const SizedBox(height: KinnectSpacing.lg),
          
          // Rewind
          _InteractionButton(
            icon: Icons.restart_alt,
            label: 'Rewind',
            onTap: onRewindTap,
          ),
          
          const SizedBox(height: KinnectSpacing.lg),
          
          // Save
          _InteractionButton(
            icon: memory.isSaved ? Icons.star : Icons.star_border,
            iconColor: memory.isSaved ? KinnectColors.amber : KinnectColors.white,
            label: 'Save',
            onTap: onSaveTap,
          ),
          
          const SizedBox(height: KinnectSpacing.lg),
          
          // Share
          _InteractionButton(
            icon: Icons.share_outlined,
            label: 'Share',
            onTap: onShareTap,
          ),
          
          const SizedBox(height: KinnectSpacing.lg),
          
          // Branch
          if (memory.branchId != null)
            _InteractionButton(
              icon: Icons.account_tree_outlined,
              label: 'Branch',
              onTap: onBranchTap,
            ),
          
          if (memory.branchId != null)
            const SizedBox(height: KinnectSpacing.lg),
          
          // Network/Graph Path
          _InteractionButton(
            icon: Icons.hub_outlined,
            label: '',
            onTap: onNetworkTap,
          ),
        ],
      ),
    );
  }
}

class _InteractionButton extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label;
  final VoidCallback onTap;

  const _InteractionButton({
    required this.icon,
    this.iconColor = KinnectColors.white,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.3),
          borderRadius: BorderRadius.circular(KinnectSpacing.radiusLarge),
        ),
        padding: const EdgeInsets.all(8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: iconColor,
              size: KinnectSpacing.iconLarge,
              shadows: const [
                Shadow(
                  color: Colors.black,
                  blurRadius: 4,
                ),
              ],
            ),
            if (label.isNotEmpty) ...[
              const SizedBox(height: 4),
              Text(
                label,
                style: KinnectTextStyles.caption.copyWith(
                  shadows: const [
                    Shadow(
                      color: Colors.black,
                      blurRadius: 4,
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
