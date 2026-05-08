import 'package:flutter/material.dart';
import '../theme/colors.dart';

class DiscoveryPageScreen extends StatelessWidget {
  const DiscoveryPageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: KinnectColors.darkBg,
      appBar: AppBar(
        backgroundColor: KinnectColors.darkSurface,
        title: const Text('Discover'),
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(color: KinnectColors.amber),
            SizedBox(height: 16),
            Text(
              'Scanning biological graph…',
              style: TextStyle(color: KinnectColors.white, fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
