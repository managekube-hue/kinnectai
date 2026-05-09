import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../models/memory.dart';
import '../feed_service.dart';
import '../router/app_nav.dart';
import '../theme/colors.dart';
import '../theme/typography.dart';

/// PRD Section 01.1 -- Kinnections tab.
/// Filters The Line to confirmed biological connections only.
/// No Discovery cards injected.
class KinnectionsFeedScreen extends StatefulWidget {
  const KinnectionsFeedScreen({super.key});

  @override
  State<KinnectionsFeedScreen> createState() => _KinnectionsFeedScreenState();
}

class _KinnectionsFeedScreenState extends State<KinnectionsFeedScreen> {
  final FeedService _feedService = FeedService();
  List<Memory> _memories = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      final memories = await _feedService.getLine('current_user_id', tab: LineTab.kinnections);
      if (!mounted) return;
      setState(() {
        _memories = memories;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: KinnectColors.background,
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation(KinnectColors.accent)))
          : _error != null
              ? _buildError()
              : _memories.isEmpty
                  ? _buildEmpty()
                  : RefreshIndicator(
                      color: KinnectColors.accent,
                      onRefresh: _load,
                      child: ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        itemCount: _memories.length,
                        itemBuilder: (context, i) => _KinnectionMemoryCard(memory: _memories[i]),
                      ),
                    ),
    );
  }

  Widget _buildEmpty() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(PhosphorIcons.usersThree(), size: 64, color: KinnectColors.textMuted),
            const SizedBox(height: 16),
            Text('No confirmed Kinnections', style: KinnectTextStyles.headlineSmall),
            const SizedBox(height: 8),
            Text(
              'Invite family members or explore Discovery to find biological connections.',
              textAlign: TextAlign.center,
              style: KinnectTextStyles.bodyLarge.copyWith(color: KinnectColors.textSecondary),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => AppNav.go(context, '/discover'),
              icon: Icon(PhosphorIcons.magnifyingGlass(), size: 18),
              label: const Text('Explore Discovery'),
              style: ElevatedButton.styleFrom(
                backgroundColor: KinnectColors.accent,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildError() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(PhosphorIcons.wifiSlash(), size: 48, color: KinnectColors.error),
          const SizedBox(height: 12),
          Text('No connection. Tap to retry.', style: KinnectTextStyles.bodyLarge.copyWith(color: KinnectColors.textSecondary)),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _load,
            style: ElevatedButton.styleFrom(backgroundColor: KinnectColors.accent),
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }
}

class _KinnectionMemoryCard extends StatelessWidget {
  const _KinnectionMemoryCard({required this.memory});

  final Memory memory;

  @override
  Widget build(BuildContext context) {
    final scoreColor = memory.kinScore >= 0.8
        ? KinnectColors.accent
        : memory.kinScore >= 0.5
            ? KinnectColors.primary
            : KinnectColors.textSecondary;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: KinnectColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: KinnectColors.dividerSubtle),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Video thumbnail
          Container(
            height: 200,
            width: double.infinity,
            decoration: const BoxDecoration(
              color: KinnectColors.surfaceElevated,
              borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
            ),
            child: Center(child: Icon(PhosphorIcons.play(), size: 48, color: KinnectColors.textMuted)),
          ),

          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                // Creator avatar
                GestureDetector(
                  onTap: () => AppNav.push(context, '/root/${memory.creatorId}'),
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: const BoxDecoration(shape: BoxShape.circle, color: KinnectColors.surfaceElevated),
                    child: Icon(PhosphorIcons.user(), size: 20, color: KinnectColors.textMuted),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(memory.creatorDisplayName, style: const TextStyle(color: KinnectColors.textPrimary, fontWeight: FontWeight.w600, fontSize: 14)),
                      if (memory.caption.isNotEmpty)
                        Text(memory.caption, style: const TextStyle(color: KinnectColors.textSecondary, fontSize: 13), maxLines: 1, overflow: TextOverflow.ellipsis),
                    ],
                  ),
                ),
                // Kin Score badge
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: scoreColor.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${(memory.kinScore * 100).round()}%',
                    style: TextStyle(color: scoreColor, fontSize: 13, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),

          // Action row
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
            child: Row(
              children: [
                _SmallAction(icon: PhosphorIcons.heart(), label: '${memory.pulseCount}'),
                const SizedBox(width: 20),
                _SmallAction(icon: PhosphorIcons.chatCircleText(), label: '${memory.commentCount}'),
                const Spacer(),
                Icon(PhosphorIcons.shareNetwork(), size: 18, color: KinnectColors.textSecondary),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SmallAction extends StatelessWidget {
  const _SmallAction({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 18, color: KinnectColors.textSecondary),
        const SizedBox(width: 4),
        Text(label, style: const TextStyle(color: KinnectColors.textSecondary, fontSize: 13)),
      ],
    );
  }
}
