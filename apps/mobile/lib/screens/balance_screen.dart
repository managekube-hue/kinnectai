import 'package:flutter/material.dart';
import '../theme/colors.dart';

class BalanceScreen extends StatelessWidget {
  const BalanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: KinnectColors.darkBg,
      appBar: AppBar(
        backgroundColor: KinnectColors.darkSurface,
        title: const Text('Balance'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildBalanceCard('Bloom Credits', '12', Icons.auto_awesome, KinnectColors.amber),
            const SizedBox(height: 16),
            _buildBalanceCard('Vault+ Storage', '47 GB / 500 GB', Icons.cloud, KinnectColors.success),
            const SizedBox(height: 16),
            _buildBalanceCard('Kinnect Card', '\$25.00', Icons.credit_card, KinnectColors.warning),
            const Spacer(),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: KinnectColors.amber,
                minimumSize: const Size(double.infinity, 56),
              ),
              child: const Text('Purchase Credits', style: TextStyle(color: KinnectColors.darkBg, fontSize: 16)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBalanceCard(String title, String value, IconData icon, Color color) {
    return Card(
      color: KinnectColors.darkSurface,
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
                  Text(title, style: const TextStyle(color: KinnectColors.grey60, fontSize: 14)),
                  const SizedBox(height: 4),
                  Text(value, style: const TextStyle(color: KinnectColors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
