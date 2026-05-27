import 'package:flutter/material.dart';
import '../theme/design_system.dart';

class MemoryBoxScreen extends StatefulWidget {
  const MemoryBoxScreen({super.key});

  @override
  State<MemoryBoxScreen> createState() => _MemoryBoxScreenState();
}

class _MemoryBoxScreenState extends State<MemoryBoxScreen> {
  int _selectedTab = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DesignColors.darkBackground,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(DesignSpacing.lg),
            color: DesignColors.darkBackground,
            child: SafeArea(
              bottom: false,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back_rounded, color: DesignColors.darkPrimaryText, size: 24),
                        onPressed: () => Navigator.pop(context),
                      ),
                      Text(
                        'Memory Box',
                        style: DesignTextStyles.titleLarge.copyWith(
                          fontWeight: FontWeight.bold,
                          color: DesignColors.darkPrimaryText,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.settings_outlined, color: DesignColors.darkPrimaryText, size: 24),
                        onPressed: () {},
                      ),
                    ],
                  ),
                  const SizedBox(height: DesignSpacing.md),
                  Text(
                    'Your encrypted, posthumous, and time-triggered memory delivery system.',
                    style: DesignTextStyles.bodyMedium.copyWith(color: DesignColors.darkSecondaryText),
                  ),
                ],
              ),
            ),
          ),
          
          // Tab Bar
          Container(
            color: DesignColors.darkBackground,
            padding: const EdgeInsets.symmetric(horizontal: DesignSpacing.lg),
            child: Row(
              children: [
                _TabButton(
                  label: 'Sealed',
                  isSelected: _selectedTab == 0,
                  onTap: () => setState(() => _selectedTab = 0),
                ),
                const SizedBox(width: DesignSpacing.md),
                _TabButton(
                  label: 'Delivered',
                  isSelected: _selectedTab == 1,
                  onTap: () => setState(() => _selectedTab = 1),
                ),
                const SizedBox(width: DesignSpacing.md),
                _TabButton(
                  label: 'Drafts',
                  isSelected: _selectedTab == 2,
                  onTap: () => setState(() => _selectedTab = 2),
                ),
              ],
            ),
          ),
          
          // Content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(DesignSpacing.lg),
              child: _selectedTab == 0 ? _buildSealedTab() : _buildEmptyState(),
            ),
          ),
          
          // Create Button
          Container(
            padding: const EdgeInsets.all(DesignSpacing.lg),
            decoration: const BoxDecoration(
              color: DesignColors.darkSurface,
              border: Border(top: BorderSide(color: DesignColors.darkDivider)),
            ),
            child: SafeArea(
              top: false,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: DesignColors.darkPrimary,
                  foregroundColor: DesignColors.darkOnPrimary,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(DesignRadii.md)),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.add_rounded, size: 20),
                    SizedBox(width: DesignSpacing.sm),
                    Text('Create Memory Box', style: DesignTextStyles.labelLarge),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSealedTab() {
    return const Column(
      children: [
        _MemoryBoxCard(
          title: 'To Maya, my firstborn',
          deliveryCondition: 'Posthumous: Unlocks 30 days after verified death',
          iconBgColor: Color(0xFFE8F5E9),
          iconColor: Color(0xFF66BB6A),
          icon: Icons.favorite_rounded,
          status: 'Sealed',
          statusColor: DesignColors.darkSuccess,
          date: 'Created Dec 12, 2024',
        ),
        SizedBox(height: DesignSpacing.md),
        _MemoryBoxCard(
          title: 'For Marcus on his 18th birthday',
          deliveryCondition: 'Time-Triggered: Feb 14, 2032 at 8:00 AM',
          iconBgColor: Color(0xFFFFF3E0),
          iconColor: Color(0xFFFFA726),
          icon: Icons.cake_rounded,
          status: 'Sealed',
          statusColor: DesignColors.darkSuccess,
          date: 'Created Nov 3, 2024',
        ),
        SizedBox(height: DesignSpacing.md),
        _MemoryBoxCard(
          title: "Grandma's recipe collection",
          deliveryCondition: 'Multi-Stage: Unlocks for all Kin when I turn 80',
          iconBgColor: Color(0xFFFCE4EC),
          iconColor: Color(0xFFEC407A),
          icon: Icons.restaurant_menu_rounded,
          status: 'Sealed',
          statusColor: DesignColors.darkSuccess,
          date: 'Created Aug 22, 2024',
        ),
        SizedBox(height: DesignSpacing.md),
        _MemoryBoxCard(
          title: 'Financial wisdom for my kids',
          deliveryCondition: 'Conditional: Unlocks when net worth > \$100k',
          iconBgColor: Color(0xFFE3F2FD),
          iconColor: Color(0xFF42A5F5),
          icon: Icons.attach_money_rounded,
          status: 'Sealed',
          statusColor: DesignColors.darkSuccess,
          date: 'Created Jul 9, 2024',
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(DesignSpacing.xl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: DesignColors.darkSurface,
                borderRadius: BorderRadius.circular(DesignRadii.lg),
              ),
              child: const Icon(
                Icons.inventory_2_outlined,
                size: 40,
                color: DesignColors.darkHint,
              ),
            ),
            const SizedBox(height: DesignSpacing.lg),
            Text(
              _selectedTab == 1 ? 'No Delivered Boxes' : 'No Drafts',
              style: DesignTextStyles.titleMedium.copyWith(color: DesignColors.darkPrimaryText),
            ),
            const SizedBox(height: DesignSpacing.sm),
            Text(
              _selectedTab == 1
                  ? 'Your delivered Memory Boxes will appear here'
                  : 'Start creating a Memory Box to save drafts',
              style: DesignTextStyles.bodySmall.copyWith(color: DesignColors.darkSecondaryText),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _TabButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _TabButton({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? DesignColors.darkPrimary : DesignColors.transparent,
          borderRadius: BorderRadius.circular(DesignRadii.full),
        ),
        child: Text(
          label,
          style: DesignTextStyles.labelMedium.copyWith(
            color: isSelected ? DesignColors.darkOnPrimary : DesignColors.darkSecondaryText,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
          ),
        ),
      ),
    );
  }
}

class _MemoryBoxCard extends StatelessWidget {
  final String title;
  final String deliveryCondition;
  final Color iconBgColor;
  final Color iconColor;
  final IconData icon;
  final String status;
  final Color statusColor;
  final String date;

  const _MemoryBoxCard({
    required this.title,
    required this.deliveryCondition,
    required this.iconBgColor,
    required this.iconColor,
    required this.icon,
    required this.status,
    required this.statusColor,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(DesignSpacing.md),
      decoration: BoxDecoration(
        color: DesignColors.darkSurface,
        borderRadius: BorderRadius.circular(DesignRadii.lg),
        border: Border.all(color: DesignColors.darkDivider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: iconBgColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: iconColor, size: 24),
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
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      date,
                      style: DesignTextStyles.labelSmall.copyWith(color: DesignColors.darkSecondaryText),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(DesignRadii.full),
                ),
                child: Row(
                  children: [
                    Icon(Icons.lock_rounded, size: 12, color: statusColor),
                    const SizedBox(width: 4),
                    Text(
                      status,
                      style: DesignTextStyles.labelSmall.copyWith(color: statusColor, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: DesignSpacing.md),
          Container(
            padding: const EdgeInsets.all(DesignSpacing.sm),
            decoration: BoxDecoration(
              color: DesignColors.darkBackground,
              borderRadius: BorderRadius.circular(DesignRadii.sm),
              border: Border.all(color: DesignColors.darkDivider),
            ),
            child: Row(
              children: [
                const Icon(Icons.schedule_rounded, size: 16, color: DesignColors.darkPrimary),
                const SizedBox(width: DesignSpacing.sm),
                Expanded(
                  child: Text(
                    deliveryCondition,
                    style: DesignTextStyles.bodySmall.copyWith(color: DesignColors.darkSecondaryText),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: DesignSpacing.sm),
          Row(
            children: [
              _ActionChip(
                icon: Icons.visibility_outlined,
                label: 'Preview',
                onTap: () {},
              ),
              const SizedBox(width: DesignSpacing.sm),
              _ActionChip(
                icon: Icons.edit_outlined,
                label: 'Edit Triggers',
                onTap: () {},
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ActionChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _ActionChip({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: DesignColors.darkBackground,
          borderRadius: BorderRadius.circular(DesignRadii.full),
          border: Border.all(color: DesignColors.darkDivider),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 14, color: DesignColors.darkPrimary),
            const SizedBox(width: 6),
            Text(
              label,
              style: DesignTextStyles.labelSmall.copyWith(color: DesignColors.darkPrimaryText),
            ),
          ],
        ),
      ),
    );
  }
}
