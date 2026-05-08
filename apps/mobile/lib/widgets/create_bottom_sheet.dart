import 'package:flutter/material.dart';
import '../theme/colors.dart';

class CreateBottomSheet extends StatelessWidget {
  const CreateBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.6,
      decoration: const BoxDecoration(
        color: KinnectColors.darkSurface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: KinnectColors.grey40,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Create',
            style: TextStyle(color: KinnectColors.white, fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 24),
          Expanded(
            child: GridView.count(
              crossAxisCount: 3,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              children: [
                _buildTool(context, Icons.videocam, 'Memory', '/create/memory'),
                _buildTool(context, Icons.mic, 'Voiceprint', '/voiceprint-capture'),
                _buildTool(context, Icons.upload_file, 'Import', '/import'),
                _buildTool(context, Icons.account_tree, 'Branch', '/create/branch'),
                _buildTool(context, Icons.people, 'Invite', '/invite'),
                _buildTool(context, Icons.folder, 'Strand', '/create/strand'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTool(BuildContext context, IconData icon, String label, String route) {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
        Navigator.pushNamed(context, route);
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: KinnectColors.darkBg,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: KinnectColors.amber, size: 32),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(color: KinnectColors.white, fontSize: 12),
          ),
        ],
      ),
    );
  }
}
