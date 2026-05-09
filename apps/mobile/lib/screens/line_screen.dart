import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../cubits/line_bloc.dart';
import '../models/memory.dart';
import '../feed_service.dart';
import '../router/app_nav.dart';
import '../theme/colors.dart';

/// The Line - Vertical video feed screen (PRD Section 01)
class LineScreen extends StatelessWidget {
  const LineScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          LineBloc(FeedService())..add(LineFetchRequested('current_user_id')),
      child: const _LineScreenContent(),
    );
  }
}

class _LineScreenContent extends StatefulWidget {
  const _LineScreenContent();

  @override
  State<_LineScreenContent> createState() => _LineScreenContentState();
}

class _LineScreenContentState extends State<_LineScreenContent> {
  final PageController _pageController = PageController();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: KinnectColors.background,
      body: Stack(
        children: [
          BlocBuilder<LineBloc, LineState>(
        builder: (context, state) {
          if (state is LineLoading) {
            return const Center(
              child: CircularProgressIndicator(color: KinnectColors.accent),
            );
          }

          if (state is LineEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(PhosphorIcons.usersThree(),
                      size: 64, color: KinnectColors.textMuted),
                  const SizedBox(height: 16),
                  const Text(
                    'Invite your first Kin',
                    style: TextStyle(color: KinnectColors.textPrimary, fontSize: 18),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                        backgroundColor: KinnectColors.accent),
                    child: const Text('Invite Kin',
                        style: TextStyle(color: KinnectColors.background)),
                  ),
                ],
              ),
            );
          }

          if (state is LineError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(PhosphorIcons.warningCircle(),
                      size: 64, color: KinnectColors.error),
                  const SizedBox(height: 16),
                  Text(
                    state.message,
                    style: const TextStyle(color: KinnectColors.textPrimary),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () => context.read<LineBloc>().add(
                        LineFetchRequested('current_user_id')),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: KinnectColors.accent),
                    child: const Text('Retry',
                        style: TextStyle(color: KinnectColors.background)),
                  ),
                ],
              ),
            );
          }

          if (state is LineLoaded) {
            return PageView.builder(
              controller: _pageController,
              scrollDirection: Axis.vertical,
              itemCount: state.memories.length,
              onPageChanged: (index) {
                if (index == state.memories.length - 3 && state.hasMore) {
                  context.read<LineBloc>().add(LineLoadMore());
                }
              },
              itemBuilder: (context, index) {
                final memory = state.memories[index];
                return _buildMemoryCard(context, memory);
              },
            );
          }

          return const SizedBox.shrink();
        },
      ),
          // Floating top bar with marketplace storefront icon (PRD Section 00)
          Positioned(
            top: MediaQuery.of(context).padding.top + 8,
            left: 16,
            right: 16,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('The Line', style: TextStyle(
                  color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold,
                  shadows: [Shadow(blurRadius: 8, color: Colors.black54)],
                )),
                Row(
                  children: [
                    _topBarIcon(PhosphorIcons.storefront(), 'Shop', () => AppNav.push(context, '/marketplace')),
                    const SizedBox(width: 12),
                    _topBarIcon(PhosphorIcons.bell(), 'Alerts', () => AppNav.push(context, '/pulse')),
                    const SizedBox(width: 12),
                    _topBarIcon(PhosphorIcons.magnifyingGlass(), 'Search', () {}),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _topBarIcon(IconData icon, String tooltip, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.3),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: Colors.white, size: 22),
      ),
    );
  }

  Widget _buildMemoryCard(BuildContext context, Memory memory) {
    return Stack(
      children: [
        // Video placeholder (will be replaced with actual video player)
        Container(
          color: Colors.black,
          child: memory.thumbnailUrl != null
              ? Image.network(
                  memory.thumbnailUrl!,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                )
              : const Center(
                  child: Icon(PhosphorIcons.play(),
                      size: 80, color: Colors.white),
                ),
        ),

        // Right rail buttons
        Positioned(
          right: 8,
          bottom: 100,
          child: Column(
            children: [
              _buildActionButton(
                icon: memory.isPulsed ? PhosphorIcons.heartFill() : PhosphorIcons.heart(),
                label: memory.formattedPulseCount,
                color: memory.isPulsed ? KinnectColors.error : Colors.white,
                onTap: () => context.read<LineBloc>().add(LinePulseTriggered(memory.id)),
              ),
              const SizedBox(height: 16),
              _buildActionButton(
                icon: PhosphorIcons.chatCircleText(),
                label: '${memory.commentCount}',
                onTap: () {},
              ),
              const SizedBox(height: 16),
              _buildActionButton(
                icon: PhosphorIcons.shareNetwork(),
                label: 'Share',
                onTap: () {},
              ),
            ],
          ),
        ),

        // Bottom overlay
        Positioned(
          bottom: 0,
          left: 0,
          right: 80,
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [
                  Colors.black.withOpacity(0.8),
                  Colors.transparent,
                ],
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      memory.creatorDisplayName,
                      style: const TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: KinnectColors.accent.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        memory.kinScorePercentage,
                        style: const TextStyle(
                            color: KinnectColors.accent, fontSize: 12),
                      ),
                    ),
                  ],
                ),
                if (memory.caption.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Text(
                    memory.caption,
                    style: const TextStyle(color: Colors.white),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    Color color = Colors.white,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Icon(icon, color: color, size: 32),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(color: Colors.white, fontSize: 12),
          ),
        ],
      ),
    );
  }
}
