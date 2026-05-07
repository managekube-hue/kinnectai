import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/colors.dart';
import '../theme/spacing.dart';
import '../models/memory.dart';
import '../widgets/line_video_player.dart';
import '../widgets/right_rail_buttons.dart';
import '../widgets/bottom_overlay.dart';

/// The Line - Vertical video feed screen (PRD Section 01)
class LineScreen extends StatefulWidget {
  const LineScreen({super.key});

  @override
  State<LineScreen> createState() => _LineScreenState();
}

class _LineScreenState extends State<LineScreen> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;
  
  // TODO: Replace with real feed service
  final List<Memory> _memories = _getSampleMemories();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _handlePulse(Memory memory) {
    HapticFeedback.mediumImpact();
    // TODO: Call interactionService.togglePulse(memory.id)
    debugPrint('Pulse tapped: ${memory.id}');
    setState(() {
      final index = _memories.indexWhere((m) => m.id == memory.id);
      if (index >= 0) {
        _memories[index] = _memories[index].copyWith(
          isPulsed: !_memories[index].isPulsed,
          pulseCount: _memories[index].isPulsed
              ? _memories[index].pulseCount - 1
              : _memories[index].pulseCount + 1,
        );
      }
    });
  }

  void _handleComment(Memory memory) {
    Navigator.pushNamed(context, '/memory/${memory.id}/comments');
  }

  void _handleRewind(Memory memory) {
    Navigator.pushNamed(context, '/create/rewind/${memory.id}');
  }

  void _handleSave(Memory memory) {
    HapticFeedback.lightImpact();
    // TODO: Show strand picker bottom sheet
    debugPrint('Save tapped: ${memory.id}');
    setState(() {
      final index = _memories.indexWhere((m) => m.id == memory.id);
      if (index >= 0) {
        _memories[index] = _memories[index].copyWith(
          isSaved: !_memories[index].isSaved,
        );
      }
    });
  }

  void _handleShare(Memory memory) {
    // TODO: Show share bottom sheet (Branch/Kin/Copy only)
    debugPrint('Share tapped: ${memory.id}');
  }

  void _handleBranch(Memory memory) {
    if (memory.branchId != null) {
      Navigator.pushNamed(context, '/branch/${memory.branchId}');
    }
  }

  void _handleNetwork(Memory memory) {
    Navigator.pushNamed(
      context,
      '/graph-path?from=root&to=${memory.creatorId}',
    );
  }

  void _handleCreatorTap(Memory memory) {
    Navigator.pushNamed(context, '/root/${memory.creatorId}');
  }

  void _handleKinScoreTap(Memory memory) {
    Navigator.pushNamed(
      context,
      '/kin-score-detail?target=${memory.creatorId}',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: KinnectColors.darkBg,
      extendBodyBehindAppBar: true,
      appBar: _buildTopBar(),
      body: Stack(
        children: [
          // Vertical swipeable feed
          PageView.builder(
            controller: _pageController,
            scrollDirection: Axis.vertical,
            onPageChanged: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            itemCount: _memories.length,
            itemBuilder: (context, index) {
              return _buildMemoryCard(_memories[index]);
            },
          ),
          
          // Bottom navigation
          _buildBottomNav(),
        ],
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

  Widget _buildMemoryCard(Memory memory) {
    return Stack(
      fit: StackFit.expand,
      children: [
        // Video player
        LineVideoPlayer(
          videoUrl: memory.videoUrl,
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
