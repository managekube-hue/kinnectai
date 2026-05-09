import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:share_plus/share_plus.dart';

import '../cubits/cart_cubit.dart';
import '../cubits/marketplace_cubit.dart';
import '../models/dtos/marketplace_product_dto.dart';
import '../theme/colors.dart';
import '../theme/typography.dart';

/// Product detail with image carousel (carousel_slider), star ratings
/// (flutter_rating_bar), reviews list, add-to-cart, and Stripe checkout.
class MarketplaceProductDetailScreen extends StatefulWidget {
  const MarketplaceProductDetailScreen({super.key, required this.productId});

  final String productId;

  @override
  State<MarketplaceProductDetailScreen> createState() => _MarketplaceProductDetailScreenState();
}

class _MarketplaceProductDetailScreenState extends State<MarketplaceProductDetailScreen> {
  @override
  void initState() {
    super.initState();
    context.read<MarketplaceCubit>().fetchProductDetail(widget.productId);
  }

  String _price(int cents) => cents == 0 ? 'FREE' : '\$${(cents / 100).toStringAsFixed(2)}';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: KinnectColors.background,
      body: BlocConsumer<MarketplaceCubit, MarketplaceState>(
        listener: (context, state) {
          if (state is MarketplaceCheckoutReady) {
            // Payment sheet is initialized -- present it
            context.read<MarketplaceCubit>().presentPaymentSheet();
          }
        },
        builder: (context, state) {
          if (state is MarketplaceLoading) {
            return const Center(child: CircularProgressIndicator(color: KinnectColors.accent));
          }
          if (state is MarketplaceError) {
            return Center(child: Text(state.message, style: TextStyle(color: KinnectColors.textSecondary)));
          }
          if (state is MarketplaceProductDetail) {
            return _ProductDetailBody(
              product: state.product,
              reviews: state.reviews,
              onPrice: _price,
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}

class _ProductDetailBody extends StatelessWidget {
  const _ProductDetailBody({required this.product, required this.reviews, required this.onPrice});

  final MarketplaceProductDTO product;
  final List<ReviewDTO> reviews;
  final String Function(int) onPrice;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        // Collapsing app bar with image carousel
        SliverAppBar(
          expandedHeight: 300,
          pinned: true,
          backgroundColor: KinnectColors.surface,
          leading: IconButton(
            icon: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(color: Colors.black.withOpacity(0.4), shape: BoxShape.circle),
              child: const Icon(Icons.arrow_back, color: Colors.white, size: 20),
            ),
            onPressed: () => Navigator.pop(context),
          ),
          actions: [
            IconButton(
              icon: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(color: Colors.black.withOpacity(0.4), shape: BoxShape.circle),
                child: Icon(PhosphorIcons.shareFat(), color: Colors.white, size: 20),
              ),
              onPressed: () => Share.share('Check out ${product.title} on KinnectAI Marketplace!'),
            ),
            IconButton(
              icon: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(color: Colors.black.withOpacity(0.4), shape: BoxShape.circle),
                child: Icon(PhosphorIcons.heart(), color: Colors.white, size: 20),
              ),
              onPressed: () => context.read<MarketplaceCubit>().toggleWishlist(product.id),
            ),
          ],
          flexibleSpace: FlexibleSpaceBar(
            background: product.images.isNotEmpty
                ? CarouselSlider(
                    options: CarouselOptions(
                      height: 340,
                      viewportFraction: 1.0,
                      enableInfiniteScroll: product.images.length > 1,
                      autoPlay: product.images.length > 1,
                      autoPlayInterval: const Duration(seconds: 5),
                    ),
                    items: product.images.map((img) => Image.network(
                      img.url,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      errorBuilder: (_, __, ___) => _placeholder(),
                    )).toList(),
                  )
                : _placeholder(),
          ),
        ),

        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                Text(product.title, style: KinnectTextStyles.headlineMedium),
                const SizedBox(height: 8),

                // Seller + rating
                Row(
                  children: [
                    Icon(PhosphorIcons.storefront(), size: 16, color: KinnectColors.textSecondary),
                    const SizedBox(width: 6),
                    Expanded(child: Text(product.sellerName ?? 'Unknown', style: TextStyle(color: KinnectColors.textSecondary, fontSize: 14))),
                    RatingBarIndicator(
                      rating: product.ratingAvg,
                      itemBuilder: (_, __) => const Icon(Icons.star, color: KinnectColors.warning),
                      itemCount: 5,
                      itemSize: 16,
                    ),
                    const SizedBox(width: 6),
                    Text('${product.ratingAvg.toStringAsFixed(1)} (${product.ratingCount})',
                        style: TextStyle(color: KinnectColors.textSecondary, fontSize: 12)),
                  ],
                ),
                const SizedBox(height: 16),

                // Category + stats
                Row(
                  children: [
                    _tag(product.category.replaceAll('_', ' ').toUpperCase()),
                    if (product.salesCount > 0) ...[
                      const SizedBox(width: 8),
                      _tag('${product.salesCount} sold'),
                    ],
                    if (product.viewCount > 0) ...[
                      const SizedBox(width: 8),
                      _tag('${product.viewCount} views'),
                    ],
                  ],
                ),
                const SizedBox(height: 20),

                // Price block
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: KinnectColors.surface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: KinnectColors.dividerSubtle),
                  ),
                  child: Row(
                    children: [
                      Text(onPrice(product.priceCents), style: TextStyle(
                        color: product.priceCents == 0 ? KinnectColors.success : KinnectColors.accent,
                        fontSize: 28, fontWeight: FontWeight.bold)),
                      if (product.compareAtCents != null && product.compareAtCents! > 0) ...[
                        const SizedBox(width: 12),
                        Text(onPrice(product.compareAtCents!), style: TextStyle(
                            color: KinnectColors.textMuted, fontSize: 18, decoration: TextDecoration.lineThrough)),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(color: KinnectColors.error, borderRadius: BorderRadius.circular(4)),
                          child: Text(
                            'SAVE ${(((product.compareAtCents! - product.priceCents) / product.compareAtCents!) * 100).round()}%',
                            style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Description
                if (product.description != null && product.description!.isNotEmpty) ...[
                  Text('About this product', style: KinnectTextStyles.titleMedium),
                  const SizedBox(height: 8),
                  Text(product.description!, style: TextStyle(color: KinnectColors.textSecondary, fontSize: 14, height: 1.6)),
                  const SizedBox(height: 24),
                ],

                // Action buttons
                Row(
                  children: [
                    Expanded(
                      child: BlocBuilder<CartCubit, CartState>(
                        builder: (context, cartState) {
                          final inCart = cartState is CartLoaded && cartState.containsProduct(product.id);
                          return ElevatedButton.icon(
                            onPressed: () {
                              context.read<CartCubit>().addProduct(product);
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text(inCart ? 'Updated quantity' : 'Added to cart'),
                                backgroundColor: KinnectColors.success,
                              ));
                            },
                            icon: Icon(PhosphorIcons.shoppingCart()),
                            label: Text(inCart ? 'Add Another' : 'Add to Cart'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: KinnectColors.surface,
                              foregroundColor: KinnectColors.accent,
                              side: const BorderSide(color: KinnectColors.accent),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          context.read<MarketplaceCubit>().initiateCheckout([
                            CheckoutItem(productId: product.id),
                          ]);
                        },
                        icon: Icon(PhosphorIcons.creditCard()),
                        label: const Text('Buy Now'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: KinnectColors.accent,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),

                // Reviews section
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Reviews (${reviews.length})', style: KinnectTextStyles.titleMedium),
                    TextButton(
                      onPressed: () => _showWriteReview(context),
                      child: const Text('Write a Review'),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                if (reviews.isEmpty)
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: KinnectColors.surface,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(child: Text('No reviews yet. Be the first!', style: TextStyle(color: KinnectColors.textMuted))),
                  )
                else
                  ...reviews.map((r) => _ReviewCard(review: r)),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _tag(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: KinnectColors.accent.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(label, style: TextStyle(color: KinnectColors.accent, fontSize: 11, fontWeight: FontWeight.w600)),
    );
  }

  Widget _placeholder() => Container(
    color: KinnectColors.surfaceElevated,
    child: Center(child: Icon(PhosphorIcons.package(), size: 64, color: KinnectColors.textMuted)),
  );

  void _showWriteReview(BuildContext context) {
    double rating = 0;
    final titleCtrl = TextEditingController();
    final bodyCtrl = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: KinnectColors.surface,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => Padding(
        padding: EdgeInsets.fromLTRB(24, 24, 24, MediaQuery.of(ctx).viewInsets.bottom + 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Write a Review', style: KinnectTextStyles.headlineSmall),
            const SizedBox(height: 16),
            Center(
              child: RatingBar.builder(
                initialRating: 0,
                minRating: 1,
                allowHalfRating: false,
                itemCount: 5,
                itemSize: 36,
                unratedColor: KinnectColors.surfaceElevated,
                itemBuilder: (_, __) => const Icon(Icons.star, color: KinnectColors.warning),
                onRatingUpdate: (r) => rating = r,
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: titleCtrl,
              style: const TextStyle(color: KinnectColors.textPrimary),
              decoration: InputDecoration(
                hintText: 'Review title (optional)', hintStyle: TextStyle(color: KinnectColors.textMuted),
                filled: true, fillColor: KinnectColors.surfaceElevated,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: bodyCtrl,
              maxLines: 4,
              style: const TextStyle(color: KinnectColors.textPrimary),
              decoration: InputDecoration(
                hintText: 'Share your experience...', hintStyle: TextStyle(color: KinnectColors.textMuted),
                filled: true, fillColor: KinnectColors.surfaceElevated,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  if (rating > 0) {
                    context.read<MarketplaceCubit>().submitReview(
                      product.id,
                      rating: rating.round(),
                      title: titleCtrl.text.isEmpty ? null : titleCtrl.text,
                      body: bodyCtrl.text.isEmpty ? null : bodyCtrl.text,
                    );
                    Navigator.pop(ctx);
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: KinnectColors.accent, foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('Submit Review'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ReviewCard extends StatelessWidget {
  const _ReviewCard({required this.review});

  final ReviewDTO review;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
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
              RatingBarIndicator(
                rating: review.rating.toDouble(),
                itemBuilder: (_, __) => const Icon(Icons.star, color: KinnectColors.warning),
                itemCount: 5,
                itemSize: 14,
              ),
              const SizedBox(width: 8),
              if (review.verifiedPurchase)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(color: KinnectColors.success.withOpacity(0.15), borderRadius: BorderRadius.circular(4)),
                  child: Text('Verified', style: TextStyle(color: KinnectColors.success, fontSize: 10, fontWeight: FontWeight.w600)),
                ),
              const Spacer(),
              Text(review.reviewerName ?? 'Anonymous', style: TextStyle(color: KinnectColors.textMuted, fontSize: 12)),
            ],
          ),
          if (review.title != null && review.title!.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(review.title!, style: const TextStyle(color: KinnectColors.textPrimary, fontWeight: FontWeight.w600, fontSize: 14)),
          ],
          if (review.body != null && review.body!.isNotEmpty) ...[
            const SizedBox(height: 6),
            Text(review.body!, style: TextStyle(color: KinnectColors.textSecondary, fontSize: 13, height: 1.4)),
          ],
        ],
      ),
    );
  }
}
