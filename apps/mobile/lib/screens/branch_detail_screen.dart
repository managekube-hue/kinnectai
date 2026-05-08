import 'package:flutter/material.dart';
import '../router/app_nav.dart';
import '../theme/colors.dart';

class BranchDetailScreen extends StatefulWidget {
  final String branchId;

  const BranchDetailScreen({super.key, required this.branchId});

  @override
  State<BranchDetailScreen> createState() => _BranchDetailScreenState();
}

class _BranchDetailScreenState extends State<BranchDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: KinnectColors.background,
      appBar: AppBar(
        backgroundColor: KinnectColors.surface,
        title: Text('Branch ${widget.branchId}'),
        elevation: 0,
      ),
      body: ListView(
        children: [
          Container(
            color: KinnectColors.surfaceElevated,
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.account_tree, size: 48, color: KinnectColors.accent),
                const SizedBox(height: 16),
                Text(
                  'Branch Title',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 8),
                Text(
                  '12 members â€¢ Founded 2020',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Members',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    TextButton(
                      onPressed: () => AppNav.push(context, '/branch/${widget.branchId}/members',
                      ),
                      child: const Text('View All'),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                ...List.generate(
                  3,
                  (index) => ListTile(
                    leading: const Icon(Icons.person_outline),
                    title: Text('Member ${index + 1}'),
                    subtitle: const Text('Family relation'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}




