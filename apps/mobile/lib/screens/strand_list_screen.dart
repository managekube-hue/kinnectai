import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../router/app_nav.dart';
import '../theme/colors.dart';
import '../theme/typography.dart';

/// PRD Section 10.2 -- Strands tab on Root profile + Sidebar.
/// Themed Memory collections. Shows Strand name + cover image + count.
class StrandListScreen extends StatefulWidget {
  const StrandListScreen({super.key});

  @override
  State<StrandListScreen> createState() => _StrandListScreenState();
}

class _StrandListScreenState extends State<StrandListScreen> {
  // TODO: fetch from repository
  static final _strands = [
    _StrandData(id: 's_1', name: 'Wedding Memories', count: 24, coverColor: const Color(0xFFD4A5A5)),
    _StrandData(id: 's_2', name: 'Summer Reunion 2025', count: 18, coverColor: const Color(0xFFA5C4D4)),
    _StrandData(id: 's_3', name: 'Grandma\'s Kitchen', count: 12, coverColor: const Color(0xFFA5D4A8)),
    _StrandData(id: 's_4', name: 'Holiday Traditions', count: 31, coverColor: const Color(0xFFD4CCA5)),
    _StrandData(id: 's_5', name: 'Baby\'s First Year', count: 47, coverColor: const Color(0xFFCDA5D4)),
    _StrandData(id: 's_6', name: 'Road Trip 2024', count: 9, coverColor: const Color(0xFFD4A5C0)),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: KinnectColors.background,
      appBar: AppBar(
        backgroundColor: KinnectColors.surface,
        title: Text('Strands', style: KinnectTextStyles.headlineSmall),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: KinnectColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: _strands.isEmpty
          ? _buildEmpty()
          : GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.8,
              ),
              itemCount: _strands.length,
              itemBuilder: (context, i) => _StrandCard(strand: _strands[i]),
            ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: KinnectColors.accent,
        onPressed: _showCreateStrandSheet,
        child: Icon(PhosphorIcons.plus(), color: KinnectColors.background),
      ),
    );
  }

  Widget _buildEmpty() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(PhosphorIcons.bookmarkSimple(), size: 64, color: KinnectColors.textMuted),
          const SizedBox(height: 16),
          Text('No Strands created', style: KinnectTextStyles.headlineSmall),
          const SizedBox(height: 8),
          Text(
            'Strands are themed Memory collections.\nTap + to create your first.',
            textAlign: TextAlign.center,
            style: TextStyle(color: KinnectColors.textSecondary, fontSize: 14),
          ),
        ],
      ),
    );
  }

  void _showCreateStrandSheet() {
    final nameController = TextEditingController();
    showModalBottomSheet(
      context: context,
      backgroundColor: KinnectColors.surface,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => Padding(
        padding: EdgeInsets.fromLTRB(24, 24, 24, MediaQuery.of(ctx).viewInsets.bottom + 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('New Strand', style: KinnectTextStyles.headlineSmall),
            const SizedBox(height: 16),
            TextField(
              controller: nameController,
              autofocus: true,
              style: const TextStyle(color: KinnectColors.textPrimary),
              decoration: InputDecoration(
                hintText: 'Strand name (e.g. "Wedding Memories")',
                hintStyle: TextStyle(color: KinnectColors.textMuted),
                filled: true,
                fillColor: KinnectColors.surfaceElevated,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Strand created'), backgroundColor: KinnectColors.success),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: KinnectColors.accent,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('Create'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StrandData {
  const _StrandData({required this.id, required this.name, required this.count, required this.coverColor});
  final String id;
  final String name;
  final int count;
  final Color coverColor;
}

class _StrandCard extends StatelessWidget {
  const _StrandCard({required this.strand});
  final _StrandData strand;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => AppNav.push(context, '/strand/${strand.id}'),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: KinnectColors.dividerSubtle),
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
                width: double.infinity,
                color: strand.coverColor.withOpacity(0.3),
                child: Center(
                  child: Icon(PhosphorIcons.bookmarkSimple(), size: 40, color: strand.coverColor),
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(12),
              color: KinnectColors.surface,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(strand.name, style: const TextStyle(color: KinnectColors.textPrimary, fontWeight: FontWeight.w600, fontSize: 14), maxLines: 1, overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 2),
                  Text('${strand.count} memories', style: TextStyle(color: KinnectColors.textSecondary, fontSize: 12)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
