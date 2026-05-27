import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../cubits/marketplace_cubit.dart';
import '../models/dtos/marketplace_product_dto.dart';
import '../router/app_nav.dart';
import '../theme/colors.dart';
import '../theme/typography.dart';

/// Order history and tracking screen.
class MarketplaceOrdersScreen extends StatefulWidget {
  const MarketplaceOrdersScreen({super.key});

  @override
  State<MarketplaceOrdersScreen> createState() => _MarketplaceOrdersScreenState();
}

class _MarketplaceOrdersScreenState extends State<MarketplaceOrdersScreen> {
  @override
  void initState() {
    super.initState();
    context.read<MarketplaceCubit>().loadOrders();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: KinnectColors.background,
      appBar: AppBar(
        backgroundColor: KinnectColors.surface,
        title: const Text('My Orders', style: KinnectTextStyles.headlineSmall),
        leading: IconButton(icon: const Icon(Icons.arrow_back, color: KinnectColors.textPrimary), onPressed: () => Navigator.pop(context)),
      ),
      body: BlocBuilder<MarketplaceCubit, MarketplaceState>(
        builder: (context, state) {
          if (state is MarketplaceLoading) {
            return const Center(child: CircularProgressIndicator(color: KinnectColors.accent));
          }
          if (state is MarketplaceError) {
            return Center(child: Text(state.message, style: const TextStyle(color: KinnectColors.textSecondary)));
          }
          if (state is MarketplaceOrdersLoaded) {
            if (state.orders.isEmpty) {
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(PhosphorIcons.receipt(), size: 64, color: KinnectColors.textMuted),
                    const SizedBox(height: 16),
                    const Text('No orders yet', style: TextStyle(color: KinnectColors.textSecondary, fontSize: 16)),
                  ],
                ),
              );
            }
            return ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: state.orders.length,
              separatorBuilder: (_, _) => const SizedBox(height: 12),
              itemBuilder: (_, i) => _OrderCard(order: state.orders[i]),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}

class _OrderCard extends StatelessWidget {
  const _OrderCard({required this.order});

  final MarketplaceOrderDTO order;

  Color get _statusColor {
    switch (order.status) {
      case 'paid': case 'completed': case 'delivered': return KinnectColors.success;
      case 'shipped': return KinnectColors.accent;
      case 'cancelled': case 'refunded': case 'disputed': return KinnectColors.error;
      default: return KinnectColors.warning;
    }
  }

  IconData Function() get _statusIcon {
    switch (order.status) {
      case 'paid': return PhosphorIcons.checkCircle;
      case 'shipped': return PhosphorIcons.truck;
      case 'delivered': return PhosphorIcons.package;
      case 'completed': return PhosphorIcons.sealCheck;
      case 'cancelled': case 'refunded': return PhosphorIcons.xCircle;
      default: return PhosphorIcons.clock;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => AppNav.push(context, '/marketplace/orders/${order.orderId}'),
      child: Container(
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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Order #${order.orderId.substring(0, 8)}',
                    style: const TextStyle(color: KinnectColors.textPrimary, fontWeight: FontWeight.w600, fontSize: 14)),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(color: _statusColor.withOpacity(0.15), borderRadius: BorderRadius.circular(12)),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(_statusIcon(), size: 14, color: _statusColor),
                      const SizedBox(width: 4),
                      Text(order.status.replaceAll('_', ' ').toUpperCase(),
                          style: TextStyle(color: _statusColor, fontSize: 11, fontWeight: FontWeight.w600)),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (order.items.isNotEmpty)
              ...order.items.take(3).map((item) => Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Text('${item.title} x${item.quantity}',
                    style: const TextStyle(color: KinnectColors.textSecondary, fontSize: 13), overflow: TextOverflow.ellipsis),
              )),
            if (order.items.length > 3)
              Text('+${order.items.length - 3} more items', style: const TextStyle(color: KinnectColors.textMuted, fontSize: 12)),
            const SizedBox(height: 8),
            const Divider(color: KinnectColors.dividerSubtle),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (order.createdAt != null)
                  Text(_formatDate(order.createdAt!), style: const TextStyle(color: KinnectColors.textMuted, fontSize: 12)),
                Text('\$${(order.totalCents / 100).toStringAsFixed(2)}',
                    style: const TextStyle(color: KinnectColors.accent, fontWeight: FontWeight.bold, fontSize: 16)),
              ],
            ),
            if (order.trackingNumber != null && order.trackingNumber!.isNotEmpty) ...[
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(PhosphorIcons.mapPin(), size: 14, color: KinnectColors.textSecondary),
                  const SizedBox(width: 6),
                  Text('Tracking: ${order.trackingNumber}', style: const TextStyle(color: KinnectColors.textSecondary, fontSize: 12)),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime dt) {
    return '${dt.month}/${dt.day}/${dt.year}';
  }
}
