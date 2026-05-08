import 'package:flutter/material.dart';
import '../theme/colors.dart';

class BranchSubgraphScreen extends StatelessWidget {
  final String? branchId;
  
  const BranchSubgraphScreen({super.key, this.branchId});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: const BoxDecoration(
        color: KinnectColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          AppBar(
            backgroundColor: Colors.transparent,
            title: const Text('Branch Map'),
            actions: [
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          const Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.account_tree, size: 64, color: KinnectColors.textMuted),
                  SizedBox(height: 16),
                  Text(
                    'Join a Branch to activate',
                    style: TextStyle(color: KinnectColors.textPrimary, fontSize: 18),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Discovery CTA',
                    style: TextStyle(color: KinnectColors.textSecondary),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
