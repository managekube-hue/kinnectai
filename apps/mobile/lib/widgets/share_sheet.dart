import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/colors.dart';

class ShareSheet extends StatelessWidget {
  final String memoryId;
  final String memoryUrl;
  
  const ShareSheet({super.key, required this.memoryId, required this.memoryUrl});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.4,
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
            'Share Memory',
            style: TextStyle(color: KinnectColors.white, fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 24),
          _buildShareOption(
            context,
            Icons.account_tree,
            'Share to Branch',
            'Share with your Branch members',
            () => Navigator.pop(context),
          ),
          const SizedBox(height: 16),
          _buildShareOption(
            context,
            Icons.people,
            'Share with Specific Kin',
            'Choose Kin to share with',
            () => Navigator.pop(context),
          ),
          const SizedBox(height: 16),
          _buildShareOption(
            context,
            Icons.link,
            'Copy Link',
            'Copy shareable link',
            () {
              Clipboard.setData(ClipboardData(text: memoryUrl));
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Link copied to clipboard')),
              );
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildShareOption(
    BuildContext context,
    IconData icon,
    String title,
    String subtitle,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: KinnectColors.darkBg,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(icon, color: KinnectColors.amber, size: 32),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(color: KinnectColors.white, fontSize: 16),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(color: KinnectColors.grey60, fontSize: 12),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
