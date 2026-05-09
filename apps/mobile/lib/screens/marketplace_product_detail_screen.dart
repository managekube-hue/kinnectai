import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../cubits/cart_cubit.dart';
import '../cubits/marketplace_cubit.dart';
import '../theme/colors.dart';
import '../theme/spacing.dart';
import '../theme/typography.dart';

/// Product detail page -- reached via /marketplace/product/:id.
class MarketplaceProductDetailScreen extends StatefulWidget {
  const MarketplaceProductDetailScreen({super.key, required this.productId});

  final String productId;

  @override
  State<MarketplaceProductDetailScreen> createState() =>
      _MarketplaceProductDetailScreenState();
}

class _MarketplaceProductDetailScreenState
    extends State<MarketplaceProductDetailScreen> {
  @override
  void initState() {
    super.initState();
    context.read<MarketplaceCubit>().fetchProductDetail(widget.productId);
  }

  String _priceDisplay(int priceCents) {
    if (priceCents == 0) return 'FREE';
    return '\$${(priceCents / 100).toStringAsFixed(2)}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: KinnectColors.background,
      appBar: AppBar(
        backgroundColor: KinnectColors.surface,
        title: Text('Product Details', style: KinnectTextStyles.headlineSmall),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: KinnectColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: BlocBuilder<MarketplaceCubit, MarketplaceState>(
        builder: (context, state) {
          if (state is MarketplaceLoading) {
            return const Center(
              child: CircularProgressIndicator(color: KinnectColors.accent),
            );
          }

          if (state is MarketplaceError) {
            return Center(
              child: Text(state.message,
                  style: TextStyle(color: KinnectColors.textSecondary)),
            );
          }

          if (state is MarketplaceProductDetail) {
            final product = state.product;
            return SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Hero image
                  Container(
                    height: 240,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: KinnectColors.surfaceElevated,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: product.imageUrl != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: Image.network(product.imageUrl!,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => _imagePlaceholder()),
                          )
                        : _imagePlaceholder(),
                  ),
                  const SizedBox(height: 20),

                  // Title
                  Text(product.title,
                      style: KinnectTextStyles.headlineMedium),
                  const SizedBox(height: 8),

                  // Seller row
                  Row(
                    children: [
                      Icon(PhosphorIcons.storefront(),
                          size: 16, color: KinnectColors.textSecondary),
                      const SizedBox(width: 6),
                      Text(product.sellerName ?? 'Unknown Seller',
                          style: TextStyle(
                              color: KinnectColors.textSecondary,
                              fontSize: 14)),
                      if (product.rating != null) ...[
                        const SizedBox(width: 16),
                        Icon(PhosphorIcons.star(),
                            size: 14, color: KinnectColors.warning),
                        const SizedBox(width: 4),
                        Text('${product.rating}',
                            style: TextStyle(
                                color: KinnectColors.textSecondary,
                                fontSize: 14)),
                      ],
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Category badge
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: KinnectColors.accent.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      product.category.replaceAll('_', ' ').toUpperCase(),
                      style: TextStyle(
                          color: KinnectColors.accent,
                          fontSize: 11,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Description
                  if (product.description != null &&
                      product.description!.isNotEmpty) ...[
                    Text('Description',
                        style: KinnectTextStyles.titleMedium),
                    const SizedBox(height: 8),
                    Text(product.description!,
                        style: TextStyle(
                            color: KinnectColors.textSecondary,
                            fontSize: 14,
                            height: 1.5)),
                    const SizedBox(height: 24),
                  ],

                  // Price
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: KinnectColors.surface,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: KinnectColors.dividerSubtle),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Price',
                            style: TextStyle(
                                color: KinnectColors.textSecondary,
                                fontSize: 16)),
                        Text(
                          _priceDisplay(product.priceCents),
                          style: TextStyle(
                            color: product.priceCents == 0
                                ? KinnectColors.success
                                : KinnectColors.accent,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Add to cart button
                  BlocBuilder<CartCubit, CartState>(
                    builder: (context, cartState) {
                      final inCart = cartState is CartLoaded &&
                          cartState.containsProduct(product.id);
                      return SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            context.read<CartCubit>().addProduct(product);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(inCart
                                    ? 'Updated quantity in cart'
                                    : 'Added to cart'),
                                backgroundColor: KinnectColors.success,
                                duration: const Duration(seconds: 2),
                              ),
                            );
                          },
                          icon: Icon(PhosphorIcons.shoppingCart()),
                          label: Text(inCart ? 'Add Another' : 'Add to Cart'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: KinnectColors.accent,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 12),

                  // Buy now button
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () {
                        context
                            .read<MarketplaceCubit>()
                            .placeOrder(product.id);
                      },
                      icon: Icon(PhosphorIcons.creditCard()),
                      label: const Text('Buy Now'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: KinnectColors.accent,
                        side: const BorderSide(color: KinnectColors.accent),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _imagePlaceholder() {
    return Center(
      child: Icon(PhosphorIcons.package(),
          size: 64, color: KinnectColors.textMuted),
    );
  }
}
