import 'package:flutter/material.dart';
import '../theme/colors.dart';

class AncestralMarketplaceScreen extends StatelessWidget {
  const AncestralMarketplaceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: KinnectColors.background,
      appBar: AppBar(
        backgroundColor: KinnectColors.surface,
        title: const Text('Ancestral Marketplace'),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () {},
          ),
        ],
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.store, size: 64, color: KinnectColors.textMuted),
            SizedBox(height: 16),
            Text(
              'Curated heritage items coming soon',
              style: TextStyle(color: KinnectColors.textPrimary, fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
