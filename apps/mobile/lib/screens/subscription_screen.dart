import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../router/app_nav.dart';
import '../theme/colors.dart';
import '../theme/typography.dart';

/// PRD Section 12 + Addendum 2.0 Section 12 -- Vault+ Subscription.
class SubscriptionScreen extends StatelessWidget {
  const SubscriptionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: KinnectColors.background,
      appBar: AppBar(
        backgroundColor: KinnectColors.surface,
        title: const Text('Vault+ Subscription', style: KinnectTextStyles.headlineSmall),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: KinnectColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // Current plan card
          const _PlanCard(
            title: 'Vault+ Premium',
            price: '\$4.99/month',
            isActive: true,
            features: [
              '500 GB Memory Box storage',
              'Priority Photplay rendering',
              'Extended Legacy Reel duration',
              'Unlimited Strand collections',
              'Priority customer support',
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: KinnectColors.surfaceElevated,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                Icon(PhosphorIcons.calendarBlank(), size: 18, color: KinnectColors.textSecondary),
                const SizedBox(width: 8),
                const Text('Renews May 15, 2026', style: TextStyle(color: KinnectColors.textSecondary, fontSize: 13)),
                const Spacer(),
                TextButton(
                  onPressed: () {},
                  child: const Text('Manage', style: TextStyle(color: KinnectColors.primary, fontSize: 13)),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),

          // Available plans
          const Text('All Plans', style: KinnectTextStyles.headlineSmall),
          const SizedBox(height: 16),

          // Free plan
          _PlanCard(
            title: 'Free',
            price: '\$0',
            isActive: false,
            features: const [
              '5 GB Memory Box storage',
              'Standard Photplay (SadTalker)',
              '3 Strand collections',
              'Basic Discovery',
            ],
            actionLabel: 'Downgrade',
            onAction: () {},
          ),
          const SizedBox(height: 16),

          // Vault+ Monthly
          const _PlanCard(
            title: 'Vault+ Monthly',
            price: '\$4.99/mo',
            isActive: true,
            features: [
              '500 GB Memory Box storage',
              'Priority Photplay rendering (D-ID)',
              'Extended Legacy Reel duration',
              'Unlimited Strand collections',
              'Priority support',
            ],
            actionLabel: 'Current Plan',
            onAction: null,
          ),
          const SizedBox(height: 16),

          // Vault+ Annual
          _PlanCard(
            title: 'Vault+ Annual',
            price: '\$49.99/yr',
            isActive: false,
            badge: 'Save 17%',
            features: const [
              'Everything in Monthly',
              '2 months free',
              'Early access to new features',
            ],
            actionLabel: 'Switch to Annual',
            onAction: () {},
          ),
          const SizedBox(height: 32),

          // Photplay Credits section
          const Text('Photplay Credits', style: KinnectTextStyles.headlineSmall),
          const SizedBox(height: 12),
          const Text(
            'Consumable credits for Premium Photplay animations. 1 credit = 1 Premium Photplay.',
            style: TextStyle(color: KinnectColors.textSecondary, fontSize: 14),
          ),
          const SizedBox(height: 16),
          const Row(
            children: [
              Expanded(child: _CreditOption(amount: '1', price: '\$0.99')),
              SizedBox(width: 8),
              Expanded(child: _CreditOption(amount: '5', price: '\$4.49')),
              SizedBox(width: 8),
              Expanded(child: _CreditOption(amount: '10', price: '\$8.99')),
              SizedBox(width: 8),
              Expanded(child: _CreditOption(amount: '20', price: '\$16.99')),
            ],
          ),
          const SizedBox(height: 32),

          // Restore purchases
          Center(
            child: TextButton.icon(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Restoring purchases...'), backgroundColor: KinnectColors.primary),
                );
              },
              icon: Icon(PhosphorIcons.arrowCounterClockwise(), size: 18),
              label: const Text('Restore Purchases'),
              style: TextButton.styleFrom(foregroundColor: KinnectColors.primary),
            ),
          ),

          // Payment history link
          Center(
            child: TextButton.icon(
              onPressed: () => AppNav.push(context, '/settings/payment-history'),
              icon: Icon(PhosphorIcons.receipt(), size: 18),
              label: const Text('View Payment History'),
              style: TextButton.styleFrom(foregroundColor: KinnectColors.textSecondary),
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}

class _PlanCard extends StatelessWidget {
  const _PlanCard({
    required this.title,
    required this.price,
    required this.isActive,
    required this.features,
    this.badge,
    this.actionLabel,
    this.onAction,
  });

  final String title;
  final String price;
  final bool isActive;
  final List<String> features;
  final String? badge;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: KinnectColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isActive ? KinnectColors.accent : KinnectColors.dividerSubtle,
          width: isActive ? 2 : 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(title, style: KinnectTextStyles.headlineSmall),
              const Spacer(),
              if (isActive)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: KinnectColors.accent,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text('Active', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                ),
              if (badge != null && !isActive)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: KinnectColors.success,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(badge!, style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                ),
            ],
          ),
          const SizedBox(height: 4),
          Text(price, style: const TextStyle(color: KinnectColors.textSecondary, fontSize: 16)),
          const SizedBox(height: 12),
          ...features.map((f) => Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: Row(
              children: [
                Icon(PhosphorIcons.check(), size: 16, color: KinnectColors.success),
                const SizedBox(width: 8),
                Expanded(child: Text(f, style: const TextStyle(color: KinnectColors.textPrimary, fontSize: 14))),
              ],
            ),
          )),
          if (actionLabel != null) ...[
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: onAction != null
                  ? ElevatedButton(
                      onPressed: onAction,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: KinnectColors.accent,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      child: Text(actionLabel!),
                    )
                  : OutlinedButton(
                      onPressed: null,
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      child: Text(actionLabel!),
                    ),
            ),
          ],
        ],
      ),
    );
  }
}

class _CreditOption extends StatelessWidget {
  const _CreditOption({required this.amount, required this.price});

  final String amount;
  final String price;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Purchasing $amount Photplay Credits...'), backgroundColor: KinnectColors.accent),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: KinnectColors.surface,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: KinnectColors.dividerSubtle),
        ),
        child: Column(
          children: [
            Icon(PhosphorIcons.flower(), size: 22, color: KinnectColors.accent),
            const SizedBox(height: 4),
            Text(amount, style: const TextStyle(color: KinnectColors.textPrimary, fontWeight: FontWeight.bold, fontSize: 18)),
            const SizedBox(height: 2),
            Text(price, style: const TextStyle(color: KinnectColors.textSecondary, fontSize: 11)),
          ],
        ),
      ),
    );
  }
}

