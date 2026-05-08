import 'package:flutter/material.dart';
import '../theme/colors.dart';

class RewindCreatorScreen extends StatelessWidget {
  final String memoryId;
  
  const RewindCreatorScreen({super.key, required this.memoryId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text('Rewind'),
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.videocam, size: 64, color: KinnectColors.textMuted),
            SizedBox(height: 16),
            Text(
              'PIP camera over original Memory',
              style: TextStyle(color: KinnectColors.textPrimary, fontSize: 18),
            ),
            SizedBox(height: 8),
            Text(
              'Records 0-30s',
              style: TextStyle(color: KinnectColors.textSecondary),
            ),
          ],
        ),
      ),
    );
  }
}
