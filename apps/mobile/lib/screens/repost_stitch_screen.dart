import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../router/app_nav.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../theme/colors.dart';
import '../models/memory.dart';
import '../feed_service.dart';

class RepostStitchScreen extends StatefulWidget {
  const RepostStitchScreen({super.key});

  @override
  State<RepostStitchScreen> createState() => _RepostStitchScreenState();
}

class _RepostStitchScreenState extends State<RepostStitchScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final FeedService _feedService = FeedService();
  List<Memory> _eligibleMemories = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadEligibleMemories();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadEligibleMemories() async {
    setState(() => _isLoading = true);
    final memories = await _feedService.getLine('current_user_id', limit: 50);
    setState(() {
      _eligibleMemories = memories;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: KinnectColors.background,
      appBar: AppBar(
        backgroundColor: KinnectColors.surface,
        title: const Text('Repost & Stitch'),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: KinnectColors.accent,
          tabs: const [
            Tab(text: 'Repost'),
            Tab(text: 'Stitch'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildRepostView(),
          _buildStitchView(),
        ],
      ),
    );
  }

  Widget _buildRepostView() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator(color: KinnectColors.accent));
    }

    if (_eligibleMemories.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(PhosphorIcons.repeat(), size: 64, color: KinnectColors.textMuted),
            const SizedBox(height: 16),
            const Text(
              'No eligible Memories',
              style: TextStyle(color: KinnectColors.textSecondary, fontSize: 18),
            ),
            const SizedBox(height: 8),
            const Text(
              'Memories you can repost will appear here',
              style: TextStyle(color: KinnectColors.textMuted, fontSize: 14),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: _eligibleMemories.length,
      itemBuilder: (context, index) {
        final memory = _eligibleMemories[index];
        return _buildMemoryCard(memory, isStitch: false);
      },
    );
  }

  Widget _buildStitchView() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator(color: KinnectColors.accent));
    }

    if (_eligibleMemories.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(PhosphorIcons.filmStrip(), size: 64, color: KinnectColors.textMuted),
            const SizedBox(height: 16),
            const Text(
              'No eligible Memories',
              style: TextStyle(color: KinnectColors.textSecondary, fontSize: 18),
            ),
            const SizedBox(height: 8),
            const Text(
              'Memories you can stitch will appear here',
              style: TextStyle(color: KinnectColors.textMuted, fontSize: 14),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: _eligibleMemories.length,
      itemBuilder: (context, index) {
        final memory = _eligibleMemories[index];
        return _buildMemoryCard(memory, isStitch: true);
      },
    );
  }

  Widget _buildMemoryCard(Memory memory, {required bool isStitch}) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: KinnectColors.surface,
      child: InkWell(
        onTap: () => _handleAction(memory, isStitch),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: KinnectColors.background,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: memory.thumbnailUrl != null
                    ? Image.network(memory.thumbnailUrl!, fit: BoxFit.cover)
                    : const Icon(PhosphorIcons.videoCamera(), color: KinnectColors.textMuted, size: 32),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      memory.creatorDisplayName,
                      style: const TextStyle(
                        color: KinnectColors.textPrimary,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      memory.caption,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: KinnectColors.textSecondary, fontSize: 14),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(PhosphorIcons.heart(), size: 16, color: KinnectColors.error),
                        const SizedBox(width: 4),
                        Text(
                          memory.formattedPulseCount,
                          style: const TextStyle(color: KinnectColors.textSecondary, fontSize: 12),
                        ),
                        const SizedBox(width: 16),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: KinnectColors.success.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            memory.kinScorePercentage,
                            style: const TextStyle(
                              color: KinnectColors.success,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Icon(
                isStitch ? PhosphorIcons.filmStrip() : PhosphorIcons.repeat(),
                color: KinnectColors.accent,
                size: 32,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleAction(Memory memory, bool isStitch) {
    if (isStitch) {
      AppNav.push(context, '/rewind',
        arguments: {'memoryId': memory.id},
      );
    } else {
      // TODO: Implement repost logic
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Reposting ${memory.creatorDisplayName}\'s Memory'),
          backgroundColor: KinnectColors.success,
        ),
      );
    }
  }
}





