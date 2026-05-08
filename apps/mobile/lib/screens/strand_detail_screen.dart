import 'package:flutter/material.dart';
import '../theme/colors.dart';

class StrandDetailScreen extends StatefulWidget {
  final String strandId;

  const StrandDetailScreen({super.key, required this.strandId});

  @override
  State<StrandDetailScreen> createState() => _StrandDetailScreenState();
}

class _StrandDetailScreenState extends State<StrandDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: KinnectColors.darkBg,
      appBar: AppBar(
        backgroundColor: KinnectColors.darkSurface,
        title: Text('Strand ${widget.strandId}'),
        elevation: 0,
      ),
      body: ListView(
        children: [
          Container(
            color: KinnectColors.darkCard,
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Strand Title',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 8),
                Text(
                  'Family lineage information',
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
                Text('Members', style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 12),
                ...List.generate(
                  5,
                  (index) => ListTile(
                    leading: const Icon(Icons.person_outline),
                    title: Text('Member ${index + 1}'),
                    subtitle: const Text('Family relation'),
                    trailing: const Icon(Icons.chevron_right),
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
