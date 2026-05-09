import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../theme/colors.dart';
import '../theme/typography.dart';

/// PRD Section 12.0 -- Creation & Business Tools.
class BusinessToolsScreen extends StatelessWidget {
  const BusinessToolsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: KinnectColors.background,
      appBar: AppBar(
        backgroundColor: KinnectColors.surface,
        title: Text('Business Tools', style: KinnectTextStyles.headlineSmall),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: KinnectColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView(
        children: [
          ListTile(
            leading: Icon(PhosphorIcons.chartBar(), color: KinnectColors.accent),
            title: const Text('Branch Analytics', style: TextStyle(color: KinnectColors.textPrimary)),
            subtitle: const Text('Dashboard and insights', style: TextStyle(color: KinnectColors.textSecondary, fontSize: 12)),
            trailing: Icon(PhosphorIcons.caretRight(), color: KinnectColors.textMuted),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(PhosphorIcons.calendarBlank(), color: KinnectColors.accent),
            title: const Text('Gathering Ticketing', style: TextStyle(color: KinnectColors.textPrimary)),
            subtitle: const Text('Room monetization', style: TextStyle(color: KinnectColors.textSecondary, fontSize: 12)),
            trailing: Icon(PhosphorIcons.caretRight(), color: KinnectColors.textMuted),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(PhosphorIcons.storefront(), color: KinnectColors.accent),
            title: const Text('Marketplace Seller', style: TextStyle(color: KinnectColors.textPrimary)),
            subtitle: const Text('Ancestral products', style: TextStyle(color: KinnectColors.textSecondary, fontSize: 12)),
            trailing: Icon(PhosphorIcons.caretRight(), color: KinnectColors.textMuted),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(PhosphorIcons.code(), color: KinnectColors.accent),
            title: const Text('KinnectAI Insights API', style: TextStyle(color: KinnectColors.textPrimary)),
            subtitle: const Text('Developer access', style: TextStyle(color: KinnectColors.textSecondary, fontSize: 12)),
            trailing: Icon(PhosphorIcons.caretRight(), color: KinnectColors.textMuted),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
