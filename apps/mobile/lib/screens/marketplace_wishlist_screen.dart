import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../cubits/cart_cubit.dart';
import '../cubits/marketplace_cubit.dart';
import '../models/dtos/marketplace_product_dto.dart';
import '../router/app_nav.dart';
import '../theme/colors.dart';
import '../theme/typography.dart';

/// Wishlist screen -- products the user has hearted.
class MarketplaceWishlistScreen extends StatefulWidget {
  const MarketplaceWishlistScreen({super.key});

  @override
  State<MarketplaceWishlistScreen> createState() => _State();
}

class _State extends State<MarketplaceWishlistScreen> {
  @override
  void initState() {
    super.initState();
    context.read<MarketplaceCubit>().loadWishlist();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: KinnectColors.background,
      appBar: AppBar(
        backgroundColor: KinnectColors.surface,
        title: Text('Wishlist', style: KinnectTextStyles.headlineSmall),
        leading: IconButton(icon: const Icon(Icons.arrow_back, color: KinnectColors.textPrimary), onPressed: () => Navigator.pop(context)),
      ),
      body: BlocBuilder<MarketplaceCubit, MarketplaceState>(
        builder: (context, state) {
          if (state is MarketplaceLoading) {
            return const Center(child: CircularProgressIndicator(color: KinnectColors.accent));
          }
          if (state is MarketplaceWishlistLoaded) {
            if (state.products.isEmpty) {
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(PhosphorIcons.heart(), size: 64, color: KinnectColors.textMuted),
                    const SizedBox(height: 16),
                    Text('Your wishlist is empty', style: TextStyle(color: KinnectColors.textSecondary, fontSize: 16)),
                    const SizedBox(height: 8),
                    Text('Tap the heart icon on products to add them to your Wishlist',
                        style: TextStyle(color: KinnectColors.textMuted, fontSize: 13)),
                  ],
                ),
              );
            }
            return ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: state.products.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (_, i) => _WishlistTile(product: state.products[i]),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}

class _WishlistTile extends StatelessWidget {
  const _WishlistTile({required this.product});

  final MarketplaceProductDTO product;

  String get _price => product.priceCents == 0 ? 'FREE' : '\$${(product.priceCents / 100).toStringAsFixed(2)}';

  String? get _imageUrl {
    if (product.images.isEmpty) return null;
    final primary = product.images.where((i) => i.isPrimary);
    return primary.isNotEmpty ? primary.first.url : product.images.first.url;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => AppNav.push(context, '/marketplace/product/${product.id}'),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: KinnectColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: KinnectColors.dividerSubtle),
        ),
        child: Row(
          children: [
            Container(
              width: 72, height: 72,
              decoration: BoxDecoration(color: KinnectColors.surfaceElevated, borderRadius: BorderRadius.circular(8)),
              child: _imageUrl != null
                  ? ClipRRect(borderRadius: BorderRadius.circular(8),
                      child: Image.network(_imageUrl!, fit: BoxFit.cover, errorBuilder: (_, __, ___) => _ph()))
                  : _ph(),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(product.title, style: const TextStyle(color: KinnectColors.textPrimary, fontWeight: FontWeight.w600, fontSize: 14),
                      maxLines: 2, overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 4),
                  Text(product.sellerName ?? '', style: TextStyle(color: KinnectColors.textSecondary, fontSize: 12)),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Text(_price, style: TextStyle(color: KinnectColors.accent, fontWeight: FontWeight.bold, fontSize: 15)),
                      const Spacer(),
                      // Add to cart shortcut
                      GestureDetector(
                        onTap: () {
                          context.read<CartCubit>().addProduct(product);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Added to cart'), backgroundColor: KinnectColors.success),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(color: KinnectColors.accent.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
                          child: Icon(PhosphorIcons.shoppingCart(), size: 18, color: KinnectColors.accent),
                        ),
                      ),
                      const SizedBox(width: 8),
                      // Remove from wishlist
                      GestureDetector(
                        onTap: () {
                          context.read<MarketplaceCubit>().toggleWishlist(product.id);
                          context.read<MarketplaceCubit>().loadWishlist(); // Refresh
                        },
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(color: KinnectColors.error.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
                          child: Icon(PhosphorIcons.heartBreak(), size: 18, color: KinnectColors.error),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _ph() => Center(child: Icon(PhosphorIcons.package(), size: 28, color: KinnectColors.textMuted));
}
