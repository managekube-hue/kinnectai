import 'package:flutter/material.dart';
import '../router/app_nav.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../theme/colors.dart';
import '../models/memory.dart';
import '../cubits/line_bloc.dart';
import '../services/feed_service.dart';

/// The Line - Vertical video feed screen (PRD Section 01)
class LineScreen extends StatelessWidget {
  const LineScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => LineBloc(FeedService())..add(LineFetchRequested('current_user_id')),
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
      backgroundColor: KinnectColors.darkBg,
      body: BlocBuilder<LineBloc, LineState>(
        builder: (context, state) {
          if (state is LineLoading) {
            return const Center(
              child: CircularProgressIndicator(color: KinnectColors.amber),
            );
          }
          
          if (state is LineEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.people_outline, size: 64, color: KinnectColors.grey40),
                  const SizedBox(height: 16),
                  const Text(
                    'Invite your first Kin',
                    style: TextStyle(color: KinnectColors.white, fontSize: 18),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(backgroundColor: KinnectColors.amber),
                    child: const Text('Invite Kin', style: TextStyle(color: KinnectColors.darkBg)),
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
                  const Icon(Icons.error_outline, size: 64, color: KinnectColors.error),
                  const SizedBox(height: 16),
                  Text(
                    state.message,
                    style: const TextStyle(color: KinnectColors.white),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () => context.read<LineBloc>().add(LineFetchRequested('current_user_id')),
                    style: ElevatedButton.styleFrom(backgroundColor: KinnectColors.amber),
                    child: const Text('Retry', style: TextStyle(color: KinnectColors.darkBg)),
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
                  child: Icon(Icons.play_circle_outline, size: 80, color: Colors.white),
                ),
        ),
        
        // Right rail buttons
        Positioned(
          right: 8,
          bottom: 100,
          child: Column(
            children: [
              _buildActionButton(
                icon: memory.isPulsed ? Icons.favorite : Icons.favorite_border,
                label: memory.formattedPulseCount,
                color: memory.isPulsed ? KinnectColors.error : Colors.white,
                onTap: () => context.read<LineBloc>().add(LinePulseTriggered(memory.id)),
              ),
              const SizedBox(height: 16),
              _buildActionButton(
                icon: Icons.comment,
                label: '${memory.commentCount}',
                onTap: () {},
              ),
              const SizedBox(height: 16),
              _buildActionButton(
                icon: Icons.share,
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
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: KinnectColors.amber.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        memory.kinScorePercentage,
                        style: const TextStyle(color: KinnectColors.amber, fontSize: 12),
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

    HapticFeedback.mediumImpact();
    
    // Track analytics
    AnalyticsService().trackPulse(
      memoryId: memory.id,
      creatorId: memory.creatorId,
      isPulsed: !memory.isPulsed,
      source: 'double_tap',
    );
    
    // Update state
    final updatedMemory = memory.copyWith(
      isPulsed: !memory.isPulsed,
      pulseCount: memory.isPulsed
          ? memory.pulseCount - 1
          : memory.pulseCount + 1,
    );
    context.read<LineCubit>().updateMemory(updatedMemory);
    
    // TODO: Call backend API
    // interactionService.togglePulse(memory.id)
  }

  void _handleComment(Memory memory) {
    AnalyticsService().trackCommentOpened(
      memoryId: memory.id,
      creatorId: memory.creatorId,
    );
    AppNav.push(context, '/memory/${memory.id}/comments');
  }

  void _handleRewind(Memory memory) {
    AppNav.push(context, '/create/rewind/${memory.id}');
  }

  void _handleSave(Memory memory) {
    HapticFeedback.lightImpact();
    
    final updatedMemory = memory.copyWith(isSaved: !memory.isSaved);
    context.read<LineCubit>().updateMemory(updatedMemory);
    
    AnalyticsService().trackSave(
      memoryId: memory.id,
      creatorId: memory.creatorId,
      isSaved: !memory.isSaved,
    );
    
    // TODO: Show strand picker bottom sheet
  }

  void _handleShare(Memory memory) {
    AnalyticsService().trackShare(
      memoryId: memory.id,
      creatorId: memory.creatorId,
      shareType: 'branch',
    );
    // TODO: Show share bottom sheet (Branch/Kin/Copy only)
  }

  void _handleBranch(Memory memory) {
    if (memory.branchId != null) {
      AppNav.push(context, '/branch/${memory.branchId}');
    }
  }

  void _handleNetwork(Memory memory) {
    AppNav.push(context, '/graph-path?from=root&to=${memory.creatorId}',
    );
  }

  void _handleCreatorTap(Memory memory) {
    AppNav.push(context, '/root/${memory.creatorId}');
  }

  void _handleKinScoreTap(Memory memory) {
    AnalyticsService().trackKinScoreDetailViewed(
      targetUserId: memory.creatorId,
      kinScore: memory.kinScore,
    );
    AppNav.push(context, '/kin-score-detail?target=${memory.creatorId}',
    );
  }

  void _onPageChanged(int index, List<Memory> memories) {
    context.read<LineCubit>().setCurrentIndex(index);
    
    // Preload videos
    _videoCache.preloadBatch(memories, index);
    _videoCache.disposeOldVideos(index, memories);
    
    // Track scroll depth
    AnalyticsService().trackFeedScrollDepth(
      videoIndex: index,
      totalVideos: memories.length,
    );
  }

  Future<void> _onRefresh() async {
    AnalyticsService().trackFeedRefresh(feedTab: 'all');
    await context.read<LineCubit>().refreshFeed();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: KinnectColors.darkBg,
      extendBodyBehindAppBar: true,
      appBar: _buildTopBar(),
      body: BlocBuilder<LineCubit, LineState>(
        builder: (context, state) {
          if (state is LineLoading) {
            return const Center(
              child: CircularProgressIndicator(color: KinnectColors.amber),
            );
          }
          
          if (state is LineError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 64, color: KinnectColors.error),
                  const SizedBox(height: 16),
                  Text(
                    state.message,
                    style: const TextStyle(color: KinnectColors.grey60),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => context.read<LineCubit>().loadFeed('current_user_id'),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }
          
          if (state is LineLoaded) {
            return LinePullToRefresh(
              onRefresh: _onRefresh,
              child: Stack(
                children: [
                  // Vertical swipeable feed
                  PageView.builder(
                    controller: _pageController,
                    scrollDirection: Axis.vertical,
                    onPageChanged: (index) => _onPageChanged(index, state.memories),
                    itemCount: state.memories.length,
                    itemBuilder: (context, index) {
                      return _buildMemoryCard(
                        state.memories[index],
                        isCurrent: index == state.currentIndex,
                      );
                    },
                  ),
                  
                  // Bottom navigation
                  _buildBottomNav(),
                ],
              ),
            );
          }
          
          return const SizedBox.shrink();
        },
      ),
    );
  }

  PreferredSizeWidget _buildTopBar() {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      systemOverlayStyle: SystemUiOverlayStyle.light,
      leading: const SizedBox(),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _TopBarIcon(icon: Icons.store_outlined, onTap: () {}),
          _TopBarIcon(icon: Icons.auto_awesome_outlined, onTap: () {}),
          _TopBarIcon(icon: Icons.people_outline, onTap: () {}),
          _TopBarIcon(icon: Icons.search, onTap: () {}),
          _TopBarIcon(icon: Icons.videocam_outlined, onTap: () {}),
          _TopBarIcon(icon: Icons.notifications_outlined, onTap: () {}),
        ],
      ),
    );
  }

  Widget _buildMemoryCard(Memory memory, {required bool isCurrent}) {
    return Stack(
      fit: StackFit.expand,
      children: [
        // Enhanced video player with real playback
        EnhancedLineVideoPlayer(
          videoUrl: memory.videoUrl,
          isCurrent: isCurrent,
          onDoubleTapRight: () => _handlePulse(memory),
          onDoubleTapLeft: () {
            // Rewind handled by video player
          },
        ),
        
        // Right rail buttons
        RightRailButtons(
          memory: memory,
          onPulseTap: () => _handlePulse(memory),
          onCommentTap: () => _handleComment(memory),
          onRewindTap: () => _handleRewind(memory),
          onSaveTap: () => _handleSave(memory),
          onShareTap: () => _handleShare(memory),
          onBranchTap: () => _handleBranch(memory),
          onNetworkTap: () => _handleNetwork(memory),
        ),
        
        // Bottom overlay
        BottomOverlay(
          memory: memory,
          onCreatorTap: () => _handleCreatorTap(memory),
          onKinScoreTap: () => _handleKinScoreTap(memory),
        ),
      ],
    );
  }

  Widget _buildBottomNav() {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: Container(
        color: KinnectColors.darkBg.withOpacity(0.95),
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).padding.bottom,
          top: KinnectSpacing.sm,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _NavButton(icon: Icons.home, label: 'Home', isActive: true, onTap: () {}),
            _NavButton(icon: Icons.repeat, label: 'Repost', onTap: () {}),
            _NavButton(icon: Icons.explore_outlined, label: 'Discover', onTap: () {}),
            _NavButton(
              icon: Icons.add_circle,
              label: '',
              iconColor: KinnectColors.amber,
              onTap: () {},
            ),
            _NavButton(icon: Icons.account_tree_outlined, label: 'Tree', onTap: () {}),
            _NavButton(icon: Icons.person_outline, label: 'Root', onTap: () {}),
          ],
        ),
      ),
    );
  }
}

class _TopBarIcon extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _TopBarIcon({
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        icon,
        color: KinnectColors.white,
        shadows: const [
          Shadow(color: Colors.black, blurRadius: 4),
        ],
      ),
      onPressed: onTap,
    );
  }
}

class _NavButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final Color? iconColor;
  final VoidCallback onTap;

  const _NavButton({
    required this.icon,
    required this.label,
    this.isActive = false,
    this.iconColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: iconColor ?? (isActive ? KinnectColors.white : KinnectColors.grey60),
            size: 28,
          ),
          if (label.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                color: isActive ? KinnectColors.white : KinnectColors.grey60,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// TODO: Replace with real API data
List<Memory> _getSampleMemories() {
  return [
    Memory(
      id: '1',
      creatorId: 'elara_vance_id',
      creatorUsername: 'elara_vance',
      creatorDisplayName: 'Elara Vance',
      videoUrl: 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4',
      caption: 'Sharing Grandma\'s secret recipe for Elderberry Wine. Found this in the 1954 Vault. #FamilyHeritage',
      voiceprintLabel: 'Original Voiceprint · Elara Vance',
      pulseCount: 1200,
      commentCount: 84,
      kinScore: 0.92,
      branchId: 'vance_branch',
      branchName: 'Vance Family',
      createdAt: DateTime.now().subtract(const Duration(hours: 2)),
      duration: const Duration(seconds: 45),
    ),
    Memory(
      id: '2',
      creatorId: 'marcus_chen_id',
      creatorUsername: 'marcus_chen',
      creatorDisplayName: 'Marcus Chen',
      videoUrl: 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4',
      caption: 'Just discovered we\'re 5th cousins! The algorithm really is our bloodline ??',
      pulseCount: 856,
      commentCount: 42,
      kinScore: 0.78,
      createdAt: DateTime.now().subtract(const Duration(hours: 5)),
      duration: const Duration(seconds: 32),
    ),
  ];
}




