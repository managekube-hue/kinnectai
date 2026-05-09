import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../cubits/cart_cubit.dart';
import '../cubits/marketplace_cubit.dart';
import '../models/dtos/cart_item_dto.dart';
import '../repositories/marketplace_repository.dart';
import '../theme/colors.dart';
import '../theme/typography.dart';

/// Production cart screen with flutter_slidable swipe-to-delete,
/// quantity steppers, and Stripe Connect checkout via MarketplaceCubit.
class MarketplaceCartScreen extends StatelessWidget {
  const MarketplaceCartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: KinnectColors.background,
      appBar: AppBar(
        backgroundColor: KinnectColors.surface,
        title: Text('Your Cart', style: KinnectTextStyles.headlineSmall),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: KinnectColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          BlocBuilder<CartCubit, CartState>(
            builder: (context, state) {
              if (state is CartLoaded && state.items.isNotEmpty) {
                return TextButton(
                  onPressed: () => _confirmClear(context),
                  child: const Text('Clear All', style: TextStyle(color: KinnectColors.error)),
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
      body: BlocConsumer<MarketplaceCubit, MarketplaceState>(
        listener: (context, mpState) {
          if (mpState is MarketplaceCheckoutReady) {
            context.read<MarketplaceCubit>().presentPaymentSheet();
          } else if (mpState is MarketplaceCheckoutCompleted) {
            context.read<CartCubit>().clear();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Checkout completed successfully.'),
                backgroundColor: KinnectColors.success,
              ),
            );
          }
        },
        builder: (context, mpState) {
          return BlocBuilder<CartCubit, CartState>(
            builder: (context, state) {
              if (state is! CartLoaded || state.items.isEmpty) {
                return _EmptyCart();
              }
              return Column(
                children: [
                  Expanded(
                    child: SlidableAutoCloseBehavior(
                      child: ListView.separated(
                        padding: const EdgeInsets.all(16),
                        itemCount: state.items.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 10),
                        itemBuilder: (_, i) => _CartItemTile(item: state.items[i]),
                      ),
                    ),
                  ),
                  _CheckoutBar(state: state, isLoading: mpState is MarketplaceLoading),
                ],
              );
            },
          );
        },
      ),
    );
  }

  void _confirmClear(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: KinnectColors.surface,
        title: const Text('Clear cart?', style: TextStyle(color: KinnectColors.textPrimary)),
        content: const Text('This will remove all items from your cart.',
            style: TextStyle(color: KinnectColors.textSecondary)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              context.read<CartCubit>().clear();
              Navigator.pop(ctx);
            },
            child: const Text('Clear', style: TextStyle(color: KinnectColors.error)),
          ),
        ],
      ),
    );
  }
}

class _CartItemTile extends StatelessWidget {
  const _CartItemTile({required this.item});

  final CartItemDTO item;

  String get _lineTotal => '\$${(item.priceCents * item.quantity / 100).toStringAsFixed(2)}';
  String get _unitPrice => '\$${(item.priceCents / 100).toStringAsFixed(2)}';

  @override
  Widget build(BuildContext context) {
    return Slidable(
      key: ValueKey(item.productId),
      endActionPane: ActionPane(
        motion: const BehindMotion(),
        dismissible: DismissiblePane(
          onDismissed: () => context.read<CartCubit>().removeProduct(item.productId),
        ),
        children: [
          SlidableAction(
            onPressed: (_) => context.read<CartCubit>().removeProduct(item.productId),
            backgroundColor: KinnectColors.error,
            foregroundColor: Colors.white,
            icon: PhosphorIcons.trash(),
            label: 'Remove',
            borderRadius: BorderRadius.circular(12),
          ),
        ],
      ),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: KinnectColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: KinnectColors.dividerSubtle),
        ),
        child: Row(
          children: [
            // Thumbnail
            Container(
              width: 64, height: 64,
              decoration: BoxDecoration(
                color: KinnectColors.surfaceElevated,
                borderRadius: BorderRadius.circular(8),
              ),
              child: item.imageUrl != null
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(item.imageUrl!, fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => _placeholder()),
                    )
                  : _placeholder(),
            ),
            const SizedBox(width: 12),
            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item.title,
                      style: const TextStyle(color: KinnectColors.textPrimary, fontWeight: FontWeight.w600, fontSize: 14),
                      maxLines: 2, overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 2),
                  if (item.sellerName != null)
                    Text(item.sellerName!, style: TextStyle(color: KinnectColors.textMuted, fontSize: 11)),
                  const SizedBox(height: 8),
                  Text(_unitPrice, style: TextStyle(color: KinnectColors.textSecondary, fontSize: 12)),
                ],
              ),
            ),
            // Quantity + total
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(_lineTotal, style: const TextStyle(color: KinnectColors.accent, fontWeight: FontWeight.bold, fontSize: 15)),
                const SizedBox(height: 8),
                _QuantityStepper(
                  quantity: item.quantity,
                  onDecrement: () => context.read<CartCubit>().updateQuantity(item.productId, item.quantity - 1),
                  onIncrement: () => context.read<CartCubit>().updateQuantity(item.productId, item.quantity + 1),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _placeholder() => Center(child: Icon(PhosphorIcons.package(), size: 24, color: KinnectColors.textMuted));
}

class _QuantityStepper extends StatelessWidget {
  const _QuantityStepper({required this.quantity, required this.onDecrement, required this.onIncrement});

  final int quantity;
  final VoidCallback onDecrement;
  final VoidCallback onIncrement;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: KinnectColors.surfaceElevated,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _btn(PhosphorIcons.minus, onDecrement),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Text('$quantity', style: const TextStyle(color: KinnectColors.textPrimary, fontWeight: FontWeight.bold, fontSize: 14)),
          ),
          _btn(PhosphorIcons.plus, onIncrement),
        ],
      ),
    );
  }

  Widget _btn(IconData Function() icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Icon(icon(), size: 14, color: KinnectColors.textPrimary),
      ),
    );
  }
}

class _CheckoutBar extends StatelessWidget {
  const _CheckoutBar({required this.state, required this.isLoading});

  final CartLoaded state;
  final bool isLoading;

  String get _total => '\$${(state.totalCents / 100).toStringAsFixed(2)}';

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
      decoration: BoxDecoration(
        color: KinnectColors.surface,
        border: const Border(top: BorderSide(color: KinnectColors.dividerSubtle)),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, -4))],
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Line items summary
            ...state.items.map((item) => Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(child: Text('${item.title} x${item.quantity}',
                      style: TextStyle(color: KinnectColors.textMuted, fontSize: 12), overflow: TextOverflow.ellipsis)),
                  Text('\$${(item.priceCents * item.quantity / 100).toStringAsFixed(2)}',
                      style: TextStyle(color: KinnectColors.textSecondary, fontSize: 12)),
                ],
              ),
            )),
            const Divider(color: KinnectColors.dividerSubtle),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('${state.itemCount} item${state.itemCount == 1 ? '' : 's'}',
                    style: TextStyle(color: KinnectColors.textSecondary, fontSize: 14)),
                Text(_total, style: const TextStyle(color: KinnectColors.textPrimary, fontWeight: FontWeight.bold, fontSize: 22)),
              ],
            ),
            const SizedBox(height: 14),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: isLoading
                    ? null
                    : () {
                        final items = state.items
                            .map((i) => CheckoutItem(productId: i.productId, quantity: i.quantity))
                            .toList();
                        context.read<MarketplaceCubit>().initiateCheckout(items);
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: KinnectColors.accent, foregroundColor: Colors.white,
                  disabledBackgroundColor: KinnectColors.accent.withOpacity(0.5),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: isLoading
                    ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(PhosphorIcons.lockSimple(), size: 18),
                          const SizedBox(width: 8),
                          const Text('Secure Checkout', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                        ],
                      ),
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(PhosphorIcons.shieldCheck(), size: 14, color: KinnectColors.textMuted),
                const SizedBox(width: 6),
                Text('Powered by Stripe Connect', style: TextStyle(color: KinnectColors.textMuted, fontSize: 11)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyCart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(PhosphorIcons.shoppingCart(), size: 64, color: KinnectColors.textMuted),
          const SizedBox(height: 16),
          Text('Your cart is empty', style: TextStyle(color: KinnectColors.textSecondary, fontSize: 16)),
          const SizedBox(height: 8),
          Text('Browse the marketplace to find ancestral treasures',
              style: TextStyle(color: KinnectColors.textMuted, fontSize: 13)),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: KinnectColors.accent, foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text('Browse Marketplace'),
          ),
        ],
      ),
    );
  }
}
