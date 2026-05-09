import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../theme/colors.dart';
import '../theme/typography.dart';

/// PRD Addendum 1.0 Section 6 -- Community Guidelines / Safety.
class GuidelinesScreen extends StatelessWidget {
  const GuidelinesScreen({super.key});

  static const _guidelines = [
    _GuidelineSection(
      title: '1. Respect biological truth',
      icon: PhosphorIcons.dna,
      body: 'KinnectAI is built on verifiable biological relationships. '
          'Misrepresenting family connections or falsifying DNA data violates '
          'our core principle and will result in permanent account removal.',
    ),
    _GuidelineSection(
      title: '2. Honor Memory Box consent',
      icon: PhosphorIcons.lock,
      body: 'Sealed Memories are legally binding. Attempting to access, leak, '
          'or circumvent Memory Box triggers is prohibited and may result in '
          'legal action under applicable law.',
    ),
    _GuidelineSection(
      title: '3. No harassment or hate',
      icon: PhosphorIcons.prohibit,
      body: 'Threats, harassment, hate speech, or discriminatory content '
          'targeting Kin based on ethnicity, haplogroup, or biological '
          'identity is strictly forbidden. Violations are routed to Trust & '
          'Safety with a 24-hour SLA.',
    ),
    _GuidelineSection(
      title: '4. Protect minor safety',
      icon: PhosphorIcons.baby,
      body: 'Minor accounts (under 18) have restricted features. Under-13 '
          'accounts require guardian consent under COPPA. Never share DNA, '
          'voiceprint, or facial biometric data of minors without guardian '
          'authorization.',
    ),
    _GuidelineSection(
      title: '5. Consent before capture',
      icon: PhosphorIcons.fingerprint,
      body: 'All biometric features (Voiceprint, facial matching) require '
          'explicit user consent. Recording in Rooms requires consent from '
          'all participants. If majority decline, recording stops automatically.',
    ),
    _GuidelineSection(
      title: '6. Respect Steward responsibilities',
      icon: PhosphorIcons.shield,
      body: 'Stewards are entrusted with confirming death signals and managing '
          'posthumous delivery. Abusing Steward privileges, providing false '
          'death confirmations, or obstructing delivery is a violation of the '
          'Steward Agreement.',
    ),
    _GuidelineSection(
      title: '7. Content moderation',
      icon: PhosphorIcons.eye,
      body: 'All Memories, Blooms, and comments are subject to automated '
          'content moderation (Perspective API for toxicity, CLIP for visual '
          'content). Flagged content is reviewed within 24 hours. Illegal '
          'content (CSAM, threats) is removed within 2 hours and reported to '
          'law enforcement.',
    ),
    _GuidelineSection(
      title: '8. Data portability',
      icon: PhosphorIcons.downloadSimple,
      body: 'Under GDPR Article 20 and CCPA, you have the right to download '
          'all your data. Use Settings > Download Your Data to request an '
          'export. Genomic raw data can be deleted separately under Settings > '
          'Genomic Data Controls.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: KinnectColors.background,
      appBar: AppBar(
        backgroundColor: KinnectColors.surface,
        title: Text('Community Guidelines', style: KinnectTextStyles.headlineSmall),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: KinnectColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _guidelines.length + 1,
        itemBuilder: (context, i) {
          if (i == 0) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Column(
                children: [
                  Icon(PhosphorIcons.bookOpenText(), size: 48, color: KinnectColors.primary),
                  const SizedBox(height: 12),
                  Text('Community Standards', style: KinnectTextStyles.headlineMedium, textAlign: TextAlign.center),
                  const SizedBox(height: 8),
                  Text(
                    'The algorithm is your bloodline. These guidelines protect the integrity of biological truth and the safety of every Kin.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: KinnectColors.textSecondary, height: 1.5),
                  ),
                ],
              ),
            );
          }
          final g = _guidelines[i - 1];
          return _GuidelineTile(section: g);
        },
      ),
    );
  }
}

class _GuidelineSection {
  const _GuidelineSection({required this.title, required this.icon, required this.body});
  final String title;
  final IconData Function() icon;
  final String body;
}

class _GuidelineTile extends StatelessWidget {
  const _GuidelineTile({required this.section});
  final _GuidelineSection section;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: KinnectColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: KinnectColors.dividerSubtle),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(section.icon(), size: 22, color: KinnectColors.accent),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  section.title,
                  style: KinnectTextStyles.bodyLarge.copyWith(
                    fontWeight: FontWeight.bold,
                    color: KinnectColors.accent,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            section.body,
            style: const TextStyle(color: KinnectColors.textSecondary, height: 1.6, fontSize: 14),
          ),
        ],
      ),
    );
  }
}
