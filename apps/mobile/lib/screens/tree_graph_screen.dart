import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import '../theme/colors.dart';
import 'dart:math' as math;

class TreeGraphScreen extends StatefulWidget {
  const TreeGraphScreen({super.key});

  @override
  State<TreeGraphScreen> createState() => _TreeGraphScreenState();
}

class _TreeGraphScreenState extends State<TreeGraphScreen> {
  final TransformationController _transformationController = TransformationController();
  final List<TreeNode> _nodes = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadTreeData();
  }

  @override
  void dispose() {
    _transformationController.dispose();
    super.dispose();
  }

  Future<void> _loadTreeData() async {
    await Future.delayed(const Duration(milliseconds: 500));
    setState(() {
      _nodes.addAll(_getSampleTreeNodes());
      _isLoading = false;
    });
  }

  List<TreeNode> _getSampleTreeNodes() {
    return [
      TreeNode(id: '1', name: 'You', x: 0, y: 0, generation: 0),
      TreeNode(id: '2', name: 'Parent 1', x: -100, y: -150, generation: 1),
      TreeNode(id: '3', name: 'Parent 2', x: 100, y: -150, generation: 1),
      TreeNode(id: '4', name: 'Grandparent 1', x: -200, y: -300, generation: 2),
      TreeNode(id: '5', name: 'Grandparent 2', x: -50, y: -300, generation: 2),
      TreeNode(id: '6', name: 'Grandparent 3', x: 50, y: -300, generation: 2),
      TreeNode(id: '7', name: 'Grandparent 4', x: 200, y: -300, generation: 2),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: KinnectColors.background,
      appBar: AppBar(
        backgroundColor: KinnectColors.surface,
        title: const Text('Family Tree'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle_outline),
            onPressed: _showAddFamilyDialog,
          ),
          IconButton(
            icon: const Icon(Icons.upload_file),
            onPressed: _importGedcom,
          ),
          IconButton(
            icon: const Icon(Icons.zoom_in),
            onPressed: _zoomIn,
          ),
          IconButton(
            icon: const Icon(Icons.zoom_out),
            onPressed: _zoomOut,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: KinnectColors.accent))
          : _nodes.isEmpty
              ? _buildEmptyState()
              : _buildTreeView(),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddFamilyDialog,
        backgroundColor: KinnectColors.accent,
        child: const Icon(Icons.person_add, color: KinnectColors.background),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.account_tree, size: 80, color: KinnectColors.textMuted),
          const SizedBox(height: 24),
          const Text(
            'Build your Tree',
            style: TextStyle(color: KinnectColors.textPrimary, fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            'Import GEDCOM or add family manually',
            style: TextStyle(color: KinnectColors.textSecondary, fontSize: 16),
          ),
          const SizedBox(height: 32),
          ElevatedButton.icon(
            onPressed: _importGedcom,
            icon: const Icon(Icons.upload_file),
            label: const Text('Import GEDCOM'),
            style: ElevatedButton.styleFrom(
              backgroundColor: KinnectColors.accent,
              foregroundColor: KinnectColors.background,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            ),
          ),
          const SizedBox(height: 16),
          OutlinedButton.icon(
            onPressed: _showAddFamilyDialog,
            icon: const Icon(Icons.person_add),
            label: const Text('Add Family Member'),
            style: OutlinedButton.styleFrom(
              foregroundColor: KinnectColors.accent,
              side: const BorderSide(color: KinnectColors.accent),
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTreeView() {
    return InteractiveViewer(
      transformationController: _transformationController,
      minScale: 0.5,
      maxScale: 3.0,
      boundaryMargin: const EdgeInsets.all(200),
      child: Center(
        child: CustomPaint(
          size: const Size(800, 1000),
          painter: TreePainter(nodes: _nodes),
          child: SizedBox(
            width: 800,
            height: 1000,
            child: Stack(
              children: _nodes.map((node) => _buildNodeWidget(node)).toList(),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNodeWidget(TreeNode node) {
    final offsetX = 400 + node.x;
    final offsetY = 600 + node.y;

    return Positioned(
      left: offsetX - 40,
      top: offsetY - 40,
      child: GestureDetector(
        onTap: () => _showNodeDetails(node),
        child: Column(
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: KinnectColors.surface,
                shape: BoxShape.circle,
                border: Border.all(color: KinnectColors.accent, width: 2),
              ),
              child: const Icon(Icons.person, color: KinnectColors.accent, size: 40),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: KinnectColors.surface,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                node.name,
                style: const TextStyle(color: KinnectColors.textPrimary, fontSize: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showNodeDetails(TreeNode node) {
    showModalBottomSheet(
      context: context,
      backgroundColor: KinnectColors.surface,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.person, size: 64, color: KinnectColors.accent),
            const SizedBox(height: 16),
            Text(
              node.name,
              style: const TextStyle(color: KinnectColors.textPrimary, fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Generation: ${node.generation}',
              style: const TextStyle(color: KinnectColors.textSecondary, fontSize: 16),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: KinnectColors.accent,
                foregroundColor: KinnectColors.background,
              ),
              child: const Text('View Profile'),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddFamilyDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: KinnectColors.surface,
        title: const Text('Add Family Member', style: TextStyle(color: KinnectColors.textPrimary)),
        content: const Text(
          'This feature will allow you to add family members manually',
          style: TextStyle(color: KinnectColors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(color: KinnectColors.textSecondary)),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(backgroundColor: KinnectColors.accent),
            child: const Text('Add', style: TextStyle(color: KinnectColors.background)),
          ),
        ],
      ),
    );
  }

  void _importGedcom() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('GEDCOM import coming soon'),
        backgroundColor: KinnectColors.warning,
      ),
    );
  }

  void _zoomIn() {
    final currentScale = _transformationController.value.getMaxScaleOnAxis();
    if (currentScale < 3.0) {
      _transformationController.value = _transformationController.value * (Matrix4.identity()..scale(1.2));
    }
  }

  void _zoomOut() {
    final currentScale = _transformationController.value.getMaxScaleOnAxis();
    if (currentScale > 0.5) {
      _transformationController.value = _transformationController.value * (Matrix4.identity()..scale(0.8));
    }
  }
}

class TreeNode {
  final String id;
  final String name;
  final double x;
  final double y;
  final int generation;

  TreeNode({
    required this.id,
    required this.name,
    required this.x,
    required this.y,
    required this.generation,
  });
}

class TreePainter extends CustomPainter {
  final List<TreeNode> nodes;

  TreePainter({required this.nodes});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = KinnectColors.textMuted
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;

    // Draw connections
    for (int i = 0; i < nodes.length; i++) {
      for (int j = i + 1; j < nodes.length; j++) {
        if ((nodes[j].generation - nodes[i].generation).abs() == 1) {
          final start = Offset(400 + nodes[i].x, 600 + nodes[i].y);
          final end = Offset(400 + nodes[j].x, 600 + nodes[j].y);
          canvas.drawLine(start, end, paint);
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

