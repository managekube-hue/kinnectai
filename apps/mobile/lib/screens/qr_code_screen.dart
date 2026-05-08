import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../theme/colors.dart';

class QRCodeScreen extends StatelessWidget {
  const QRCodeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const profileUrl = 'https://kinnect.ai/root/user_id_123';
    
    return Scaffold(
      backgroundColor: KinnectColors.darkBg,
      appBar: AppBar(
        backgroundColor: KinnectColors.darkSurface,
        title: const Text('Your QR Code'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: QrImageView(
                data: profileUrl,
                version: QrVersions.auto,
                size: 280,
              ),
            ),
            const SizedBox(height: 32),
            const Text(
              'Scan to view Root profile',
              style: TextStyle(color: KinnectColors.grey60, fontSize: 16),
            ),
            const SizedBox(height: 48),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.download),
                  label: const Text('Save'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: KinnectColors.amber,
                    foregroundColor: KinnectColors.darkBg,
                  ),
                ),
                const SizedBox(width: 16),
                OutlinedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.share),
                  label: const Text('Share'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: KinnectColors.amber,
                    side: const BorderSide(color: KinnectColors.amber),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
