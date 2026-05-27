import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../theme/colors.dart';

class OfflineVideosScreen extends StatelessWidget {
  const OfflineVideosScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: KinnectColors.background,
      appBar: AppBar(
        backgroundColor: KinnectColors.surface,
        title: const Text('Offline Videos'),
        actions: [
          IconButton(icon: Icon(PhosphorIcons.trash(), color: KinnectColors.textPrimary), onPressed: () {}),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(PhosphorIcons.downloadSimple(), size: 64, color: KinnectColors.textMuted),
            const SizedBox(height: 16),
            const Text('No downloaded Memories', style: TextStyle(color: KinnectColors.textPrimary, fontSize: 18)),
            const SizedBox(height: 8),
            const Text('Download Memories for offline viewing', style: TextStyle(color: KinnectColors.textSecondary)),
          ],
        ),
      ),
    );
  }
}
