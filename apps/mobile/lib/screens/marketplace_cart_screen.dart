import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../cubits/cart_cubit.dart';
import '../cubits/marketplace_cubit.dart';
import '../models/dtos/cart_item_dto.dart';
import '../theme/colors.dart';
import '../theme/typography.dart';

/// Shopping cart screen for the Ancestral Marketplace.
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
      ),
      body: BlocBuilder<CartCubit, CartState>(
        builder: (context, state) {
          if (state is! CartLoaded || state.items.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(PhosphorIcons.shoppingCart(),
                      size: 64, color: KinnectColors.textMuted),
                  const SizedBox(height: 16),
                  Text('Your cart is empty',
                      style: TextStyle(
                          color: KinnectColors.textSecondary, fontSize: 16)),
                  const SizedBox(height: 8),
                  Text('Browse the marketplace to find ancestral treasures',
                      style: TextStyle(
                          color: KinnectColors.textMuted, fontSize: 13)),
                ],
              ),
            );
          }

          return Column(
            children: [
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: state.items.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (_, i) => _CartItemTile(item: state.items[i]),
                ),
              ),
              // Order summary + checkout
              _CheckoutBar(state: state),
            ],
          );
        },
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Cart item tile
// ---------------------------------------------------------------------------

class _CartItemTile extends StatelessWidget {
  const _CartItemTile({required this.item});

  final CartItemDTO item;

  String get _price =>
      '\$${(item.priceCents * item.quantity / 100).toStringAsFixed(2)}';

  @override
  Widget build(BuildContext context) {
    return Container(
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
            width: 60,
            height: 60,
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
                    style: const TextStyle(
                        color: KinnectColors.textPrimary,
                        fontWeight: FontWeight.w600,
                        fontSize: 14),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis),
                const SizedBox(height: 4),
                Text(item.sellerName ?? '',
                    style: TextStyle(
                        color: KinnectColors.textSecondary, fontSize: 12)),
                const SizedBox(height: 8),
                // Quantity stepper
                Row(
                  children: [
                    _stepperButton(
                      icon: PhosphorIcons.minus,
                      onTap: () => context
                          .read<CartCubit>()
                          .updateQuantity(item.productId, item.quantity - 1),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Text('${item.quantity}',
                          style: const TextStyle(
                              color: KinnectColors.textPrimary,
                              fontWeight: FontWeight.bold)),
                    ),
                    _stepperButton(
                      icon: PhosphorIcons.plus,
                      onTap: () => context
                          .read<CartCubit>()
                          .updateQuantity(item.productId, item.quantity + 1),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Price + remove
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(_price,
                  style: const TextStyle(
                      color: KinnectColors.accent,
                      fontWeight: FontWeight.bold,
                      fontSize: 15)),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: () =>
                    context.read<CartCubit>().removeProduct(item.productId),
                child: Icon(PhosphorIcons.trash(),
                    size: 18, color: KinnectColors.error),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _placeholder() {
    return Center(
        child: Icon(PhosphorIcons.package(),
            size: 24, color: KinnectColors.textMuted));
  }

  Widget _stepperButton(
      {required IconData Function() icon, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: KinnectColors.surfaceElevated,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Icon(icon(), size: 14, color: KinnectColors.textPrimary),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Checkout bar
// ---------------------------------------------------------------------------

class _CheckoutBar extends StatelessWidget {
  const _CheckoutBar({required this.state});

  final CartLoaded state;

  String get _total =>
      '\$${(state.totalCents / 100).toStringAsFixed(2)}';

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
      decoration: BoxDecoration(
        color: KinnectColors.surface,
        border: const Border(
            top: BorderSide(color: KinnectColors.dividerSubtle)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('${state.itemCount} item${state.itemCount == 1 ? '' : 's'}',
                  style: TextStyle(
                      color: KinnectColors.textSecondary, fontSize: 14)),
              Text(_total,
                  style: const TextStyle(
                      color: KinnectColors.textPrimary,
                      fontWeight: FontWeight.bold,
                      fontSize: 20)),
            ],
          ),
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                // In production this triggers Stripe Connect checkout for each
                // seller in the cart. For now, show a confirmation snackbar.
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text('Redirecting to checkout...'),
                  backgroundColor: KinnectColors.accent,
                ));
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: KinnectColors.accent,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text('Proceed to Checkout',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            ),
          ),
        ],
      ),
    );
  }
}
