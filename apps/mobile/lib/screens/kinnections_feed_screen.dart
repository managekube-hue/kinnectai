import 'package:flutter/material.dart';
import '../theme/colors.dart';

class KinnectionsFeedScreen extends StatelessWidget {
  const KinnectionsFeedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: KinnectColors.darkBg,
      appBar: AppBar(
        backgroundColor: KinnectColors.darkSurface,
        title: const Text('Kinnections'),
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.people, size: 64, color: KinnectColors.grey40),
            SizedBox(height: 16),
            Text(
              'No confirmed Kinnections',
              style: TextStyle(color: KinnectColors.white, fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
