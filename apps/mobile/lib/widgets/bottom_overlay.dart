import 'package:flutter/material.dart';
import '../theme/colors.dart';
import '../theme/typography.dart';
import '../theme/spacing.dart';
import '../models/memory.dart';

/// Bottom overlay with creator info, caption, and progress bar
class BottomOverlay extends StatefulWidget {
  final Memory memory;
  final VoidCallback onCreatorTap;
  final VoidCallback onKinScoreTap;
  final VoidCallback? onVoiceprintTap;

  const BottomOverlay({
    super.key,
    required this.memory,
    required this.onCreatorTap,
    required this.onKinScoreTap,
    this.onVoiceprintTap,
  });

  @override
  State<BottomOverlay> createState() => _BottomOverlayState();
}

class _BottomOverlayState extends State<BottomOverlay> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 0,
      right: 80,
      bottom: 0,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            colors: [
              Colors.black.withOpacity(0.8),
              Colors.black.withOpacity(0.4),
              Colors.transparent,
            ],
          ),
        ),
        padding: const EdgeInsets.all(KinnectSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                GestureDetector(
                  onTap: widget.onCreatorTap,
                  child: Text(
                    '@${widget.memory.creatorUsername}',
                    style: KinnectTextStyles.bodyLarge.copyWith(
                      fontWeight: FontWeight.w600,
                      shadows: const [
                        Shadow(
                          color: Colors.black,
                          blurRadius: 4,
                        ),
                      ],
                    ),
                  ),
                ),
                
                const SizedBox(width: KinnectSpacing.sm),
                
                GestureDetector(
                  onTap: widget.onKinScoreTap,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: KinnectColors.success.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(KinnectSpacing.radiusRound),
                    ),
                    child: Text(
                      '${widget.memory.kinScorePercentage} Kin Score',
                      style: KinnectTextStyles.caption.copyWith(
                        fontWeight: FontWeight.w600,
                        color: KinnectColors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: KinnectSpacing.sm),
            
            GestureDetector(
              onTap: () {
                setState(() {
                  _isExpanded = !_isExpanded;
                });
              },
              child: Text(
                widget.memory.caption,
                style: KinnectTextStyles.bodyMedium.copyWith(
                  shadows: const [
                    Shadow(
                      color: Colors.black,
                      blurRadius: 4,
                    ),
                  ],
                ),
                maxLines: _isExpanded ? null : 2,
                overflow: _isExpanded ? null : TextOverflow.ellipsis,
              ),
            ),
            
            const SizedBox(height: KinnectSpacing.sm),
            
            if (widget.memory.voiceprintLabel != null)
              GestureDetector(
                onTap: widget.onVoiceprintTap,
                child: Row(
                  children: [
                    const Icon(
                      Icons.graphic_eq,
                      size: 16,
                      color: KinnectColors.amber,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      widget.memory.voiceprintLabel!,
                      style: KinnectTextStyles.caption.copyWith(
                        fontWeight: FontWeight.w500,
                        shadows: const [
                          Shadow(
                            color: Colors.black,
                            blurRadius: 4,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            
            const SizedBox(height: KinnectSpacing.sm),
            
            // Simple progress bar
            Container(
              height: 3,
              decoration: BoxDecoration(
                color: KinnectColors.grey40,
                borderRadius: BorderRadius.circular(2),
              ),
              child: FractionallySizedBox(
                alignment: Alignment.centerLeft,
                widthFactor: 0.3,
                child: Container(
                  decoration: BoxDecoration(
                    color: KinnectColors.amber,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
