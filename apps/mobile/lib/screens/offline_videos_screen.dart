import 'package:flutter/material.dart';
import '../theme/colors.dart';

class OfflineVideosScreen extends StatelessWidget {
  const OfflineVideosScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: KinnectColors.darkBg,
      appBar: AppBar(
        backgroundColor: KinnectColors.darkSurface,
        title: const Text('Offline Videos'),
        actions: [
          IconButton(icon: const Icon(Icons.delete_sweep), onPressed: () {}),
        ],
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.download_outlined, size: 64, color: KinnectColors.grey40),
            SizedBox(height: 16),
            Text('No downloaded Memories', style: TextStyle(color: KinnectColors.white, fontSize: 18)),
            SizedBox(height: 8),
            Text('Download Memories for offline viewing', style: TextStyle(color: KinnectColors.grey60)),
          ],
        ),
      ),
    );
  }
}
