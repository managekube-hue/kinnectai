import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../models/memory.dart';
import '../feed_service.dart';
import '../theme/colors.dart';
import '../theme/typography.dart';

/// PRD Section 01.1 -- Echoes tab.
/// Date-matched memory surfacing: "On this day" content elevated from the
/// biological graph.
class EchoesFeedScreen extends StatefulWidget {
  const EchoesFeedScreen({super.key});

  @override
  State<EchoesFeedScreen> createState() => _EchoesFeedScreenState();
}

class _EchoesFeedScreenState extends State<EchoesFeedScreen> {
  final FeedService _feedService = FeedService();
  List<Memory> _echoes = [];
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
      final memories = await _feedService.getLine('current_user_id', tab: LineTab.echoes);
      if (!mounted) return;
      setState(() {
        _echoes = memories;
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
              ? _ErrorView(message: _error!, onRetry: _load)
              : _echoes.isEmpty
                  ? _EmptyView()
                  : RefreshIndicator(
                      color: KinnectColors.accent,
                      onRefresh: _load,
                      child: CustomScrollView(
                        slivers: [
                          // "On This Day" banner
                          SliverToBoxAdapter(
                            child: Container(
                              margin: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [KinnectColors.accent.withOpacity(0.15), KinnectColors.accent.withOpacity(0.05)],
                                ),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: KinnectColors.accent.withOpacity(0.3)),
                              ),
                              child: Row(
                                children: [
                                  Icon(PhosphorIcons.clockCounterClockwise(), color: KinnectColors.accent, size: 28),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text('On This Day', style: KinnectTextStyles.headlineSmall.copyWith(color: KinnectColors.accent)),
                                        const SizedBox(height: 2),
                                        Text(
                                          '${_echoes.length} memories from your Kin on this date',
                                          style: const TextStyle(color: KinnectColors.textSecondary, fontSize: 13),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          // Echo cards
                          SliverList(
                            delegate: SliverChildBuilderDelegate(
                              (context, index) => _EchoCard(memory: _echoes[index]),
                              childCount: _echoes.length,
                            ),
                          ),

                          const SliverPadding(padding: EdgeInsets.only(bottom: 80)),
                        ],
                      ),
                    ),
    );
  }
}

class _EchoCard extends StatelessWidget {
  const _EchoCard({required this.memory});

  final Memory memory;

  @override
  Widget build(BuildContext context) {
    final year = memory.createdAt.year;
    final yearsAgo = DateTime.now().year - year;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: KinnectColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: KinnectColors.dividerSubtle),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Thumbnail
          Container(
            height: 180,
            width: double.infinity,
            decoration: const BoxDecoration(
              color: KinnectColors.surfaceElevated,
              borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
            ),
            child: Stack(
              children: [
                Center(child: Icon(PhosphorIcons.play(), size: 48, color: KinnectColors.textMuted)),
                Positioned(
                  top: 8,
                  left: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: KinnectColors.accent.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      yearsAgo == 0 ? 'Today' : '$yearsAgo year${yearsAgo > 1 ? 's' : ''} ago',
                      style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 32,
                      height: 32,
                      decoration: const BoxDecoration(shape: BoxShape.circle, color: KinnectColors.surfaceElevated),
                      child: Icon(PhosphorIcons.user(), size: 16, color: KinnectColors.textMuted),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(memory.creatorDisplayName, style: const TextStyle(color: KinnectColors.textPrimary, fontWeight: FontWeight.w600, fontSize: 14)),
                          Text('@${memory.creatorUsername}', style: const TextStyle(color: KinnectColors.textMuted, fontSize: 12)),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: KinnectColors.primary.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        '${(memory.kinScore * 100).round()}%',
                        style: const TextStyle(color: KinnectColors.primary, fontSize: 12, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
                if (memory.caption.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Text(memory.caption, style: const TextStyle(color: KinnectColors.textPrimary, fontSize: 14), maxLines: 2, overflow: TextOverflow.ellipsis),
                ],
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(PhosphorIcons.heart(), size: 16, color: KinnectColors.textSecondary),
                    const SizedBox(width: 4),
                    Text('${memory.pulseCount}', style: const TextStyle(color: KinnectColors.textSecondary, fontSize: 13)),
                    const SizedBox(width: 16),
                    Icon(PhosphorIcons.chatCircleText(), size: 16, color: KinnectColors.textSecondary),
                    const SizedBox(width: 4),
                    Text('${memory.commentCount}', style: const TextStyle(color: KinnectColors.textSecondary, fontSize: 13)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(PhosphorIcons.clockCounterClockwise(), size: 64, color: KinnectColors.textMuted),
          const SizedBox(height: 16),
          Text('No historical matches found', style: KinnectTextStyles.bodyLarge.copyWith(color: KinnectColors.textSecondary)),
          const SizedBox(height: 8),
          const Text('Share more memories to unlock Echoes.', style: TextStyle(color: KinnectColors.textMuted, fontSize: 13)),
        ],
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(PhosphorIcons.wifiSlash(), size: 48, color: KinnectColors.error),
            const SizedBox(height: 12),
            Text('No connection. Tap to retry.', style: KinnectTextStyles.bodyLarge.copyWith(color: KinnectColors.textSecondary)),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: onRetry,
              style: ElevatedButton.styleFrom(backgroundColor: KinnectColors.accent),
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}
