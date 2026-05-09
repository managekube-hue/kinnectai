import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../router/app_nav.dart';
import '../router/app_router.dart';
import '../theme/colors.dart';
import '../theme/typography.dart';

/// PRD Home Right Rail interactions + Memory view.
/// Full-screen Memory detail with creator info, Kin Score, actions.
class MemoryDetailScreen extends StatefulWidget {
  const MemoryDetailScreen({super.key, required this.memoryId});

  final String memoryId;

  @override
  State<MemoryDetailScreen> createState() => _MemoryDetailScreenState();
}

class _MemoryDetailScreenState extends State<MemoryDetailScreen> {
  bool _isPulsed = false;
  int _pulseCount = 142;
  int _commentCount = 23;
  bool _captionExpanded = false;

  // TODO: fetch from repository
  final _creatorName = 'Elara Vance';
  final _creatorUsername = 'elara_vance';
  final _creatorId = 'user_42';
  final _kinScore = 0.85;
  final _caption = 'Sharing a moment with Kin. This was the day we found out about the '
      'old family recipe that Grandma used to make every Sunday morning.';
  final _createdAt = '3 hours ago';

  @override
  Widget build(BuildContext context) {
    final scoreColor = _kinScore >= 0.8
        ? KinnectColors.accent
        : _kinScore >= 0.5
            ? KinnectColors.primary
            : KinnectColors.textSecondary;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Video area
          Positioned.fill(
            child: GestureDetector(
              onDoubleTapDown: (details) {
                final width = MediaQuery.of(context).size.width;
                if (details.globalPosition.dx > width / 2) {
                  // Double tap right = Pulse
                  _togglePulse();
                }
              },
              child: Container(
                color: KinnectColors.surfaceElevated,
                child: Center(child: Icon(PhosphorIcons.play(), size: 64, color: KinnectColors.textMuted)),
              ),
            ),
          ),

          // Top bar
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const Spacer(),
                    IconButton(
                      icon: Icon(PhosphorIcons.dotsThreeVertical(), color: Colors.white),
                      onPressed: _showOptions,
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Right rail (PRD Home Right Rail)
          Positioned(
            right: 12,
            bottom: 180,
            child: Column(
              children: [
                _RailButton(
                  icon: _isPulsed ? PhosphorIcons.heartFill() : PhosphorIcons.heart(),
                  label: '$_pulseCount',
                  color: _isPulsed ? KinnectColors.error : Colors.white,
                  onTap: _togglePulse,
                ),
                const SizedBox(height: 20),
                _RailButton(
                  icon: PhosphorIcons.chatCircleText(),
                  label: '$_commentCount',
                  onTap: () => AppRouter.showCommentComposerSheet(context, widget.memoryId, (_) {}),
                ),
                const SizedBox(height: 20),
                _RailButton(
                  icon: PhosphorIcons.arrowUDownLeft(),
                  label: 'Rewind',
                  onTap: () => AppNav.push(context, '/create/rewind/${widget.memoryId}'),
                ),
                const SizedBox(height: 20),
                _RailButton(
                  icon: PhosphorIcons.star(),
                  label: 'Save',
                  onTap: () => AppRouter.showStrandSheet(context, widget.memoryId),
                ),
                const SizedBox(height: 20),
                _RailButton(
                  icon: PhosphorIcons.shareNetwork(),
                  label: 'Share',
                  onTap: () => AppRouter.showShareSheet(context, widget.memoryId, 'https://app.kinnectai.app/memory/${widget.memoryId}'),
                ),
              ],
            ),
          ),

          // Bottom overlay (PRD Home Bottom Overlay)
          Positioned(
            left: 0,
            right: 60,
            bottom: 0,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Creator
                    GestureDetector(
                      onTap: () => AppNav.push(context, '/root/$_creatorId'),
                      child: Row(
                        children: [
                          Container(
                            width: 36,
                            height: 36,
                            decoration: const BoxDecoration(shape: BoxShape.circle, color: KinnectColors.surfaceElevated),
                            child: Icon(PhosphorIcons.user(), size: 18, color: KinnectColors.textMuted),
                          ),
                          const SizedBox(width: 8),
                          Text(_creatorName, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15)),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: scoreColor.withOpacity(0.9),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              '${(_kinScore * 100).round()}%',
                              style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Caption
                    GestureDetector(
                      onTap: () => setState(() => _captionExpanded = !_captionExpanded),
                      child: Text(
                        _caption,
                        style: const TextStyle(color: Colors.white, fontSize: 14),
                        maxLines: _captionExpanded ? 100 : 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (!_captionExpanded && _caption.length > 80)
                      GestureDetector(
                        onTap: () => setState(() => _captionExpanded = true),
                        child: const Text('more', style: TextStyle(color: KinnectColors.textSecondary, fontSize: 14)),
                      ),
                    const SizedBox(height: 4),
                    Text(_createdAt, style: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 12)),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _togglePulse() {
    setState(() {
      _isPulsed = !_isPulsed;
      _pulseCount += _isPulsed ? 1 : -1;
    });
  }

  void _showOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: KinnectColors.surface,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(PhosphorIcons.pencilSimple(), color: KinnectColors.textPrimary),
              title: const Text('Edit Memory', style: TextStyle(color: KinnectColors.textPrimary)),
              onTap: () {
                Navigator.pop(ctx);
                AppNav.push(context, '/memory/${widget.memoryId}/edit');
              },
            ),
            ListTile(
              leading: Icon(PhosphorIcons.flag(), color: KinnectColors.textPrimary),
              title: const Text('Report', style: TextStyle(color: KinnectColors.textPrimary)),
              onTap: () => Navigator.pop(ctx),
            ),
            ListTile(
              leading: Icon(PhosphorIcons.prohibit(), color: KinnectColors.error),
              title: const Text('Block Creator', style: TextStyle(color: KinnectColors.error)),
              onTap: () => Navigator.pop(ctx),
            ),
          ],
        ),
      ),
    );
  }
}

class _RailButton extends StatelessWidget {
  const _RailButton({required this.icon, required this.label, this.color, required this.onTap});

  final IconData icon;
  final String label;
  final Color? color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Icon(icon, size: 28, color: color ?? Colors.white),
          const SizedBox(height: 2),
          Text(label, style: TextStyle(color: color ?? Colors.white, fontSize: 11)),
        ],
      ),
    );
  }
}
