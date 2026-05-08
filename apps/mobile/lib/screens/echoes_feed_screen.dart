import 'package:flutter/material.dart';
import '../theme/colors.dart';

class EchoesFeedScreen extends StatelessWidget {
  const EchoesFeedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: KinnectColors.darkBg,
      appBar: AppBar(
        backgroundColor: KinnectColors.darkSurface,
        title: const Text('Echoes'),
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            color: KinnectColors.amber.withOpacity(0.1),
            child: const Row(
              children: [
                Icon(Icons.history, color: KinnectColors.amber),
                SizedBox(width: 8),
                Text(
                  'On This Day',
                  style: TextStyle(color: KinnectColors.amber, fontSize: 16),
                ),
              ],
            ),
          ),
          const Expanded(
            child: Center(
              child: Text(
                'No historical matches found',
                style: TextStyle(color: KinnectColors.grey60),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
