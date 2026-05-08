import 'package:flutter/material.dart';
import '../theme/colors.dart';

class StrandManagerSheet extends StatelessWidget {
  final String memoryId;
  
  const StrandManagerSheet({super.key, required this.memoryId});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      decoration: const BoxDecoration(
        color: KinnectColors.darkSurface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          AppBar(
            backgroundColor: Colors.transparent,
            title: const Text('Save to Strand'),
            actions: [
              IconButton(
                icon: const Icon(Icons.add),
                onPressed: () {},
              ),
            ],
          ),
          const Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.folder_outlined, size: 64, color: KinnectColors.grey40),
                  SizedBox(height: 16),
                  Text(
                    'No Strands created',
                    style: TextStyle(color: KinnectColors.white, fontSize: 18),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Tap + to create your first Strand',
                    style: TextStyle(color: KinnectColors.grey60),
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
