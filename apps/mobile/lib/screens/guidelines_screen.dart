import 'package:flutter/material.dart';
import '../theme/colors.dart';

class GuidelinesScreen extends StatelessWidget {
  const GuidelinesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: KinnectColors.background,
      appBar: AppBar(
        backgroundColor: KinnectColors.surface,
        title: const Text('Community Guidelines'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          Text('Community Standards', style: TextStyle(color: KinnectColors.textPrimary, fontSize: 24, fontWeight: FontWeight.bold)),
          SizedBox(height: 16),
          Text('1. Respect biological truth', style: TextStyle(color: KinnectColors.accent, fontSize: 18, fontWeight: FontWeight.bold)),
          SizedBox(height: 8),
          Text('KinnectAI is built on verifiable biological relationships. Misrepresenting family connections or falsifying DNA data violates our core principle.', style: TextStyle(color: KinnectColors.textSecondary, height: 1.6)),
          SizedBox(height: 24),
          Text('2. Honor Memory Box consent', style: TextStyle(color: KinnectColors.accent, fontSize: 18, fontWeight: FontWeight.bold)),
          SizedBox(height: 8),
          Text('Sealed Memories are legally binding. Attempting to access, leak, or circumvent Memory Box triggers is prohibited.', style: TextStyle(color: KinnectColors.textSecondary, height: 1.6)),
          SizedBox(height: 24),
          Text('3. No harassment or hate', style: TextStyle(color: KinnectColors.accent, fontSize: 18, fontWeight: FontWeight.bold)),
          SizedBox(height: 8),
          Text('Threats, harassment, hate speech, or discriminatory content targeting Kin based on ethnicity, haplogroup, or biological identity is strictly forbidden.', style: TextStyle(color: KinnectColors.textSecondary, height: 1.6)),
        ],
      ),
    );
  }
}
