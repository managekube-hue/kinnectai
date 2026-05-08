import 'package:flutter/material.dart';
import '../theme/colors.dart';

class BalanceScreen extends StatelessWidget {
  const BalanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: KinnectColors.background,
      appBar: AppBar(
        backgroundColor: KinnectColors.surface,
        title: const Text('Balance'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildBalanceCard('Bloom Credits', '12', Icons.auto_awesome, KinnectColors.accent),
            const SizedBox(height: 16),
            _buildBalanceCard('Vault+ Storage', '47 GB / 500 GB', Icons.cloud, KinnectColors.success),
            const SizedBox(height: 16),
            _buildBalanceCard('Kinnect Card', '\$25.00', Icons.credit_card, KinnectColors.warning),
            const Spacer(),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: KinnectColors.accent,
                minimumSize: const Size(double.infinity, 56),
              ),
              child: const Text('Purchase Credits', style: TextStyle(color: KinnectColors.background, fontSize: 16)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBalanceCard(String title, String value, IconData icon, Color color) {
    return Card(
      color: KinnectColors.surface,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Row(
          children: [
            Icon(icon, color: color, size: 40),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(color: KinnectColors.textSecondary, fontSize: 14)),
                  const SizedBox(height: 4),
                  Text(value, style: const TextStyle(color: KinnectColors.textPrimary, fontSize: 24, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
