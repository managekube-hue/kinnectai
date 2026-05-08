import 'package:flutter/material.dart';
import '../theme/colors.dart';

class DataExportScreen extends StatelessWidget {
  const DataExportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: KinnectColors.background,
      appBar: AppBar(
        backgroundColor: KinnectColors.surface,
        title: const Text('Download Your Data'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('GDPR Export', style: TextStyle(color: KinnectColors.textPrimary, fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            const Text('Download a complete archive of your KinnectAI data:', style: TextStyle(color: KinnectColors.textSecondary)),
            const SizedBox(height: 16),
            _buildDataItem('Memories & Blooms'),
            _buildDataItem('Tree & Kinnections'),
            _buildDataItem('Voiceprints'),
            _buildDataItem('Memory Box (encrypted)'),
            _buildDataItem('Behavioral data'),
            const Spacer(),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: KinnectColors.accent,
                minimumSize: const Size(double.infinity, 56),
              ),
              child: const Text('Request Export', style: TextStyle(color: KinnectColors.background, fontSize: 16)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDataItem(String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          const Icon(Icons.check_circle, color: KinnectColors.success, size: 20),
          const SizedBox(width: 12),
          Text(label, style: const TextStyle(color: KinnectColors.textPrimary)),
        ],
      ),
    );
  }
}
