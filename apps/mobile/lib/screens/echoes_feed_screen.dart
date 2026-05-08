import 'package:flutter/material.dart';
import '../theme/colors.dart';

class EchoesFeedScreen extends StatelessWidget {
  const EchoesFeedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: KinnectColors.background,
      appBar: AppBar(
        backgroundColor: KinnectColors.surface,
        title: const Text('Echoes'),
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            color: KinnectColors.accent.withOpacity(0.1),
            child: const Row(
              children: [
                Icon(Icons.history, color: KinnectColors.accent),
                SizedBox(width: 8),
                Text(
                  'On This Day',
                  style: TextStyle(color: KinnectColors.accent, fontSize: 16),
                ),
              ],
            ),
          ),
          const Expanded(
            child: Center(
              child: Text(
                'No historical matches found',
                style: TextStyle(color: KinnectColors.textSecondary),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
