import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../router/app_nav.dart';
import '../theme/design_system.dart';

class CreationHubScreen extends StatelessWidget {
  const CreationHubScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DesignColors.darkBackground,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Create',
                        style: DesignTextStyles.headlineMedium.copyWith(
                          color: DesignColors.darkPrimaryText,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close_rounded, color: DesignColors.darkSecondaryText, size: 24),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                  const SizedBox(height: DesignSpacing.sm),
                  Text(
                    'Preserve your legacy and animate your history with AI-powered ancestral tools.',
                    style: DesignTextStyles.bodyMedium.copyWith(color: DesignColors.darkSecondaryText),
                  ),
                ],
              ),
              
              const SizedBox(height: DesignSpacing.xl),
              
              // Tool Cards Grid
              Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: _ToolCard(
                          icon: Icons.videocam_rounded,
                          bgColor: const Color(0xFFE3F2FD),
                          iconColor: const Color(0xFF42A5F5),
                          title: 'Memory',
                          subtitle: 'Record a standard video',
                          onTap: () {},
                        ),
                      ),
                      const SizedBox(width: DesignSpacing.md),
                      Expanded(
                        child: _ToolCard(
                          icon: Icons.spa_rounded,
                          bgColor: const Color(0xFFE8F5E9),
                          iconColor: const Color(0xFF66BB6A),
                          title: 'Photoplay',
                          subtitle: 'Animate a photo with voice',
                          onTap: () {},
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: DesignSpacing.md),
                  Row(
                    children: [
                      Expanded(
                        child: _ToolCard(
                          icon: Icons.auto_awesome_motion_rounded,
                          bgColor: const Color(0xFFFCE4EC),
                          iconColor: const Color(0xFFEC407A),
                          title: 'Stitch',
                          subtitle: 'Compile multi-kin reels',
                          onTap: () {},
                        ),
                      ),
                      const SizedBox(width: DesignSpacing.md),
                      Expanded(
                        child: _ToolCard(
                          icon: Icons.settings_backup_restore_rounded,
                          bgColor: const Color(0xFFF3E5F5),
                          iconColor: const Color(0xFFAB47BC),
                          title: 'Rewind',
                          subtitle: 'Record a PIP reaction',
                          onTap: () {},
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: DesignSpacing.md),
                  Row(
                    children: [
                      Expanded(
                        child: _ToolCard(
                          icon: Icons.inventory_2_rounded,
                          bgColor: const Color(0xFFFFF3E0),
                          iconColor: const Color(0xFFFFA726),
                          title: 'Memory Box',
                          subtitle: 'Seal a time-triggered message',
                          onTap: () {},
                        ),
                      ),
                      const SizedBox(width: DesignSpacing.md),
                      Expanded(
                        child: _ToolCard(
                          icon: Icons.movie_filter_rounded,
                          bgColor: const Color(0xFFE0F2F1),
                          iconColor: const Color(0xFF26A69A),
                          title: 'Legacy Reel',
                          subtitle: 'AI biographical documentary',
                          onTap: () {},
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              
              const SizedBox(height: DesignSpacing.xl),
              
              // Identity & Heritage Section
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Identity & Heritage',
                    style: DesignTextStyles.titleMedium.copyWith(
                      color: DesignColors.darkPrimaryText,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: DesignSpacing.md),
                  
                  _IdentityCard(
                    icon: Icons.mic_external_on_rounded,
                    bgColor: const Color(0xFFF1F8E9),
                    title: 'Voiceprint',
                    subtitle: 'Capture your unique vocal biometric',
                    onTap: () => AppNav.push(context, '/voiceprint-capture'),
                  ),
                  const SizedBox(height: DesignSpacing.md),
                  
                  _IdentityCard(
                    icon: Icons.shield_rounded,
                    bgColor: const Color(0xFFFFFDE7),
                    title: 'Family Crest',
                    subtitle: 'Generate AI ancestral heraldry',
                    onTap: () {},
                  ),
                ],
              ),
              
              const SizedBox(height: DesignSpacing.xl),
              
              // Bloom Credits Banner
              Container(
                padding: const EdgeInsets.all(DesignSpacing.md),
                decoration: BoxDecoration(
                  color: const Color(0xFFE8F5E9),
                  borderRadius: BorderRadius.circular(DesignRadii.lg),
                  border: Border.all(color: DesignColors.darkSuccess),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.auto_awesome_rounded, color: Color(0xFF2D302C), size: 20),
                    const SizedBox(width: DesignSpacing.md),
                    Text(
                      '3 Bloom Credits Available',
                      style: DesignTextStyles.labelLarge.copyWith(color: const Color(0xFF2D302C)),
                    ),
                    const Spacer(),
                    Text(
                      'Top Up',
                      style: DesignTextStyles.labelMedium.copyWith(
                        color: const Color(0xFF2D302C),
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: DesignSpacing.xl),
              
              // Vault Storage Card
              Container(
                padding: const EdgeInsets.all(DesignSpacing.lg),
                decoration: BoxDecoration(
                  color: DesignColors.darkSurface,
                  borderRadius: BorderRadius.circular(DesignRadii.lg),
                  border: Border.all(color: DesignColors.darkDivider),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.cloud_done_rounded, color: DesignColors.darkSuccess, size: 18),
                            const SizedBox(width: DesignSpacing.sm),
                            Text(
                              'Vault Storage',
                              style: DesignTextStyles.labelLarge.copyWith(color: DesignColors.darkPrimaryText),
                            ),
                          ],
                        ),
                        Text(
                          '1.2 GB / 5 GB',
                          style: DesignTextStyles.labelMedium.copyWith(color: DesignColors.darkSecondaryText),
                        ),
                      ],
                    ),
                    const SizedBox(height: DesignSpacing.md),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: 0.24,
                        backgroundColor: DesignColors.darkDivider,
                        valueColor: AlwaysStoppedAnimation<Color>(DesignColors.darkPrimary),
                        minHeight: 8,
                      ),
                    ),
                    const SizedBox(height: DesignSpacing.md),
                    Text(
                      'Upgrade to Vault+ for 500GB of encrypted space',
                      style: DesignTextStyles.labelSmall.copyWith(color: DesignColors.darkSecondaryText),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ToolCard extends StatelessWidget {
  final IconData icon;
  final Color bgColor;
  final Color iconColor;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _ToolCard({
    required this.icon,
    required this.bgColor,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(DesignSpacing.md),
        decoration: BoxDecoration(
          color: DesignColors.darkSurface,
          borderRadius: BorderRadius.circular(DesignRadii.lg),
          border: Border.all(color: DesignColors.darkDivider),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: bgColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: iconColor, size: 24),
            ),
            const SizedBox(height: DesignSpacing.sm),
            Text(
              title,
              style: DesignTextStyles.titleMedium.copyWith(
                color: DesignColors.darkPrimaryText,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: DesignTextStyles.labelSmall.copyWith(color: DesignColors.darkSecondaryText),
            ),
          ],
        ),
      ),
    );
  }
}

class _IdentityCard extends StatelessWidget {
  final IconData icon;
  final Color bgColor;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _IdentityCard({
    required this.icon,
    required this.bgColor,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(DesignSpacing.md),
        decoration: BoxDecoration(
          color: DesignColors.darkSurface,
          borderRadius: BorderRadius.circular(DesignRadii.lg),
          border: Border.all(color: DesignColors.darkDivider),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: bgColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: const Color(0xFF2D302C), size: 24),
            ),
            const SizedBox(width: DesignSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: DesignTextStyles.titleMedium.copyWith(
                      color: DesignColors.darkPrimaryText,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: DesignTextStyles.labelSmall.copyWith(color: DesignColors.darkSecondaryText),
                  ),
                ],
              ),
            ),
            const Icon(PhosphorIcons.caretRight()_rounded, color: DesignColors.darkSecondaryText),
          ],
        ),
      ),
    );
  }
}



