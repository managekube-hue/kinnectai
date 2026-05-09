import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../theme/colors.dart';
import '../theme/typography.dart';

/// PRD Section 10.2 -- Strand detail / player.
/// Shows a themed Memory collection with playable items.
class StrandDetailScreen extends StatefulWidget {
  const StrandDetailScreen({super.key, required this.strandId});

  final String strandId;

  @override
  State<StrandDetailScreen> createState() => _StrandDetailScreenState();
}

class _StrandDetailScreenState extends State<StrandDetailScreen> {
  // TODO: fetch from repository
  final _strandName = 'Wedding Memories';
  final _memoryCount = 24;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: KinnectColors.background,
      body: CustomScrollView(
        slivers: [
          // Header
          SliverAppBar(
            backgroundColor: KinnectColors.surface,
            expandedHeight: 200,
            pinned: true,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: KinnectColors.textPrimary),
              onPressed: () => Navigator.pop(context),
            ),
            actions: [
              IconButton(
                icon: Icon(PhosphorIcons.dotsThreeVertical(), color: KinnectColors.textPrimary),
                onPressed: _showOptions,
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [const Color(0xFFD4A5A5).withOpacity(0.3), KinnectColors.surface],
                  ),
                ),
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 56, 16, 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(_strandName, style: KinnectTextStyles.headlineMedium),
                        const SizedBox(height: 4),
                        Text('$_memoryCount memories', style: TextStyle(color: KinnectColors.textSecondary, fontSize: 14)),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            ElevatedButton.icon(
                              onPressed: () {},
                              icon: Icon(PhosphorIcons.play(), size: 18),
                              label: const Text('Play All'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: KinnectColors.accent,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              ),
                            ),
                            const SizedBox(width: 12),
                            OutlinedButton.icon(
                              onPressed: () {},
                              icon: Icon(PhosphorIcons.shuffle(), size: 18),
                              label: const Text('Shuffle'),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: KinnectColors.textPrimary,
                                side: const BorderSide(color: KinnectColors.dividerSubtle),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Memory grid
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 4,
                mainAxisSpacing: 4,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, i) => _MemoryThumb(index: i),
                childCount: _memoryCount,
              ),
            ),
          ),

          const SliverPadding(padding: EdgeInsets.only(bottom: 80)),
        ],
      ),
    );
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
              title: const Text('Rename Strand', style: TextStyle(color: KinnectColors.textPrimary)),
              onTap: () => Navigator.pop(ctx),
            ),
            ListTile(
              leading: Icon(PhosphorIcons.image(), color: KinnectColors.textPrimary),
              title: const Text('Set Cover Image', style: TextStyle(color: KinnectColors.textPrimary)),
              onTap: () => Navigator.pop(ctx),
            ),
            ListTile(
              leading: Icon(PhosphorIcons.shareNetwork(), color: KinnectColors.textPrimary),
              title: const Text('Share Strand', style: TextStyle(color: KinnectColors.textPrimary)),
              onTap: () => Navigator.pop(ctx),
            ),
            ListTile(
              leading: Icon(PhosphorIcons.trash(), color: KinnectColors.error),
              title: const Text('Delete Strand', style: TextStyle(color: KinnectColors.error)),
              onTap: () {
                Navigator.pop(ctx);
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _MemoryThumb extends StatelessWidget {
  const _MemoryThumb({required this.index});
  final int index;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: KinnectColors.surfaceElevated,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Stack(
        children: [
          Center(child: Icon(PhosphorIcons.play(), size: 24, color: KinnectColors.textMuted)),
          if (index == 0)
            Positioned(
              top: 4,
              left: 4,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                decoration: BoxDecoration(
                  color: KinnectColors.accent,
                  borderRadius: BorderRadius.circular(3),
                ),
                child: const Text('Cover', style: TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold)),
              ),
            ),
        ],
      ),
    );
  }
}
