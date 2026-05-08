import 'package:flutter/material.dart';
import '../router/app_nav.dart';
import '../theme/colors.dart';

class BranchDiscoveryScreen extends StatefulWidget {
  const BranchDiscoveryScreen({super.key});

  @override
  State<BranchDiscoveryScreen> createState() => _BranchDiscoveryScreenState();
}

class _BranchDiscoveryScreenState extends State<BranchDiscoveryScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: KinnectColors.darkBg,
      appBar: AppBar(
        backgroundColor: KinnectColors.darkSurface,
        title: const Text('Discover Branches'),
        elevation: 0,
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
        ),
        itemCount: 12,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () => AppNav.push(context, '/branch/${index + 1}'),
            child: Container(
              decoration: BoxDecoration(
                color: KinnectColors.darkCard,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.account_tree,
                    size: 48,
                    color: KinnectColors.amber,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Branch ${index + 1}',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Family line',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}



