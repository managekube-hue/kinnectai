import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../cubits/marketplace_cubit.dart';
import '../models/dtos/marketplace_product_dto.dart';
import '../router/app_nav.dart';
import '../theme/colors.dart';
import '../theme/typography.dart';

/// Seller dashboard with revenue stats, active listings, pending orders,
/// and Stripe Connect onboarding status.
class MarketplaceSellerDashboardScreen extends StatefulWidget {
  const MarketplaceSellerDashboardScreen({super.key});

  @override
  State<MarketplaceSellerDashboardScreen> createState() => _State();
}

class _State extends State<MarketplaceSellerDashboardScreen> {
  @override
  void initState() {
    super.initState();
    context.read<MarketplaceCubit>().loadSellerDashboard();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: KinnectColors.background,
      appBar: AppBar(
        backgroundColor: KinnectColors.surface,
        title: Text('Seller Dashboard', style: KinnectTextStyles.headlineSmall),
        leading: IconButton(icon: const Icon(Icons.arrow_back, color: KinnectColors.textPrimary), onPressed: () => Navigator.pop(context)),
        actions: [
          IconButton(
            icon: Icon(PhosphorIcons.plus(), color: KinnectColors.accent),
            onPressed: () => AppNav.push(context, '/marketplace/create-listing'),
          ),
        ],
      ),
      body: BlocConsumer<MarketplaceCubit, MarketplaceState>(
        listener: (context, state) {
          if (state is MarketplaceSellerOnboarding) {
            // Open Stripe Connect onboarding in webview
            AppNav.push(context, '/marketplace/seller/onboard?url=${Uri.encodeComponent(state.onboardUrl)}');
          }
        },
        builder: (context, state) {
          if (state is MarketplaceLoading) {
            return const Center(child: CircularProgressIndicator(color: KinnectColors.accent));
          }
          if (state is MarketplaceError) {
            // No seller profile yet -- show onboarding
            return _SellerOnboarding();
          }
          if (state is MarketplaceSellerDashboard) {
            return _DashboardBody(dashboard: state.dashboard);
          }
          return _SellerOnboarding();
        },
      ),
    );
  }
}

class _DashboardBody extends StatelessWidget {
  const _DashboardBody({required this.dashboard});

  final SellerDashboardDTO dashboard;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Store info
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: KinnectColors.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: KinnectColors.dividerSubtle),
            ),
            child: Row(
              children: [
                Container(
                  width: 48, height: 48,
                  decoration: BoxDecoration(
                    color: KinnectColors.accent.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(PhosphorIcons.storefront(), color: KinnectColors.accent),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(dashboard.storeName ?? 'Your Store',
                          style: const TextStyle(color: KinnectColors.textPrimary, fontWeight: FontWeight.bold, fontSize: 16)),
                      Row(
                        children: [
                          Container(
                            width: 8, height: 8,
                            decoration: BoxDecoration(
                              color: dashboard.stripeOnboarded ? KinnectColors.success : KinnectColors.warning,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(dashboard.stripeOnboarded ? 'Stripe Connected' : 'Stripe Pending',
                              style: TextStyle(color: KinnectColors.textSecondary, fontSize: 12)),
                        ],
                      ),
                    ],
                  ),
                ),
                if (dashboard.ratingAvg > 0)
                  Row(
                    children: [
                      Icon(PhosphorIcons.star(PhosphorIconsStyle.fill), size: 16, color: KinnectColors.warning),
                      const SizedBox(width: 4),
                      Text('${dashboard.ratingAvg.toStringAsFixed(1)}',
                          style: const TextStyle(color: KinnectColors.textPrimary, fontWeight: FontWeight.bold)),
                    ],
                  ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Stats grid
          Row(
            children: [
              Expanded(child: _StatCard(
                label: 'Total Sales',
                value: '\$${(dashboard.totalEarningsCents / 100).toStringAsFixed(2)}',
                icon: PhosphorIcons.currencyDollar,
                color: KinnectColors.success,
              )),
              const SizedBox(width: 12),
              Expanded(child: _StatCard(
                label: 'Active Listings',
                value: '${dashboard.activeListings}',
                icon: PhosphorIcons.tag,
                color: KinnectColors.accent,
              )),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: _StatCard(
                label: 'Pending Orders',
                value: '${dashboard.pendingOrders}',
                icon: PhosphorIcons.clock,
                color: KinnectColors.warning,
              )),
              const SizedBox(width: 12),
              Expanded(child: _StatCard(
                label: 'Commission Rate',
                value: '${dashboard.commissionRate}%',
                icon: PhosphorIcons.percent,
                color: KinnectColors.textSecondary,
              )),
            ],
          ),
          const SizedBox(height: 24),

          // Actions
          Text('Quick Actions', style: KinnectTextStyles.titleMedium),
          const SizedBox(height: 12),
          _ActionTile(icon: PhosphorIcons.package, label: 'My Listings', subtitle: '${dashboard.activeListings} active',
              onTap: () => AppNav.push(context, '/marketplace')),
          _ActionTile(icon: PhosphorIcons.receipt, label: 'Seller Orders', subtitle: '${dashboard.pendingOrders} pending',
              onTap: () => context.read<MarketplaceCubit>().loadOrders(role: 'seller')),
          _ActionTile(icon: PhosphorIcons.chartLine, label: 'Sales Analytics', subtitle: '${dashboard.totalSales} total',
              onTap: () {}),
          if (!dashboard.stripeOnboarded)
            _ActionTile(icon: PhosphorIcons.creditCard, label: 'Complete Stripe Setup', subtitle: 'Required to receive payouts',
                onTap: () {}, highlight: true),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({required this.label, required this.value, required this.icon, required this.color});

  final String label;
  final String value;
  final IconData Function() icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: KinnectColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: KinnectColors.dividerSubtle),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon(), size: 20, color: color),
          const SizedBox(height: 12),
          Text(value, style: TextStyle(color: KinnectColors.textPrimary, fontWeight: FontWeight.bold, fontSize: 20)),
          const SizedBox(height: 4),
          Text(label, style: TextStyle(color: KinnectColors.textSecondary, fontSize: 12)),
        ],
      ),
    );
  }
}

class _ActionTile extends StatelessWidget {
  const _ActionTile({required this.icon, required this.label, required this.subtitle, required this.onTap, this.highlight = false});

  final IconData Function() icon;
  final String label;
  final String subtitle;
  final VoidCallback onTap;
  final bool highlight;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: highlight ? KinnectColors.accent.withOpacity(0.1) : KinnectColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: highlight ? KinnectColors.accent : KinnectColors.dividerSubtle),
        ),
        child: Row(
          children: [
            Icon(icon(), size: 20, color: highlight ? KinnectColors.accent : KinnectColors.textSecondary),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label, style: TextStyle(color: KinnectColors.textPrimary, fontWeight: FontWeight.w600, fontSize: 14)),
                  Text(subtitle, style: TextStyle(color: KinnectColors.textMuted, fontSize: 12)),
                ],
              ),
            ),
            Icon(PhosphorIcons.caretRight(), size: 16, color: KinnectColors.textMuted),
          ],
        ),
      ),
    );
  }
}

class _SellerOnboarding extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final nameCtrl = TextEditingController();
    final slugCtrl = TextEditingController();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          const SizedBox(height: 40),
          Icon(PhosphorIcons.storefront(), size: 80, color: KinnectColors.accent),
          const SizedBox(height: 24),
          Text('Start Selling', style: KinnectTextStyles.headlineMedium),
          const SizedBox(height: 8),
          Text('Set up your store and start selling ancestral products to the Kinnect community.',
              style: TextStyle(color: KinnectColors.textSecondary, fontSize: 14), textAlign: TextAlign.center),
          const SizedBox(height: 32),
          TextField(
            controller: nameCtrl,
            style: const TextStyle(color: KinnectColors.textPrimary),
            decoration: InputDecoration(
              labelText: 'Store Name', labelStyle: TextStyle(color: KinnectColors.textMuted),
              filled: true, fillColor: KinnectColors.surface,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
            ),
          ),
          const SizedBox(height: 14),
          TextField(
            controller: slugCtrl,
            style: const TextStyle(color: KinnectColors.textPrimary),
            decoration: InputDecoration(
              labelText: 'Store URL slug (e.g. heritage-press)', labelStyle: TextStyle(color: KinnectColors.textMuted),
              filled: true, fillColor: KinnectColors.surface,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
                if (nameCtrl.text.isNotEmpty && slugCtrl.text.isNotEmpty) {
                  context.read<MarketplaceCubit>().onboardAsSeller(
                    storeName: nameCtrl.text,
                    storeSlug: slugCtrl.text,
                  );
                }
              },
              icon: Icon(PhosphorIcons.creditCard()),
              label: const Text('Set Up with Stripe Connect'),
              style: ElevatedButton.styleFrom(
                backgroundColor: KinnectColors.accent, foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text('You\'ll be redirected to Stripe to verify your identity and set up payouts.',
              style: TextStyle(color: KinnectColors.textMuted, fontSize: 12), textAlign: TextAlign.center),
        ],
      ),
    );
  }
}
