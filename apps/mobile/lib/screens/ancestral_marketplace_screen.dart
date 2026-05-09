import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../cubits/cart_cubit.dart';
import '../cubits/marketplace_cubit.dart';
import '../models/dtos/marketplace_product_dto.dart';
import '../router/app_nav.dart';
import '../theme/colors.dart';
import '../theme/spacing.dart';
import '../theme/typography.dart';

/// PRD Section 00 (Home Top Bar Store) + Addendum 3.0 S7.
/// Ancestral Marketplace: genealogy books, heritage travel, DNA wellness, heirlooms.
/// Affiliate via Impact/ShareASale. 8-15% commission. Stripe Connect for sellers.
class AncestralMarketplaceScreen extends StatefulWidget {
  const AncestralMarketplaceScreen({super.key});

  @override
  State<AncestralMarketplaceScreen> createState() =>
      _AncestralMarketplaceScreenState();
}

class _AncestralMarketplaceScreenState
    extends State<AncestralMarketplaceScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    context.read<MarketplaceCubit>().load();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      context.read<MarketplaceCubit>().loadMore();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: KinnectColors.background,
      appBar: AppBar(
        backgroundColor: KinnectColors.surface,
        title: Text('Ancestral Marketplace', style: KinnectTextStyles.headlineSmall),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: KinnectColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          BlocBuilder<CartCubit, CartState>(
            builder: (context, cartState) {
              final count = cartState is CartLoaded ? cartState.itemCount : 0;
              return Stack(
                alignment: Alignment.center,
                children: [
                  IconButton(
                    icon: Icon(PhosphorIcons.shoppingCart(),
                        color: KinnectColors.textPrimary),
                    onPressed: () => AppNav.push(context, '/marketplace/cart'),
                  ),
                  if (count > 0)
                    Positioned(
                      right: 6,
                      top: 6,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: KinnectColors.accent,
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          '$count',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
          IconButton(
            icon: Icon(PhosphorIcons.plus(), color: KinnectColors.accent),
            onPressed: _showPostListingSheet,
          ),
        ],
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
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(PhosphorIcons.warning(), size: 48, color: KinnectColors.error),
                  const SizedBox(height: 12),
                  Text(state.message,
                      style: TextStyle(color: KinnectColors.textSecondary),
                      textAlign: TextAlign.center),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => context.read<MarketplaceCubit>().load(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: KinnectColors.accent,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (state is MarketplaceLoaded) {
            return Column(
              children: [
                _CategoryChips(
                  categories: state.categories,
                  selected: state.selectedCategory,
                  onSelected: (cat) =>
                      context.read<MarketplaceCubit>().filterByCategory(cat),
                ),
                Expanded(
                  child: state.products.isEmpty
                      ? Center(
                          child: Text('No products in this category',
                              style: TextStyle(
                                  color: KinnectColors.textSecondary)))
                      : GridView.builder(
                          controller: _scrollController,
                          padding: const EdgeInsets.all(16),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                            childAspectRatio: 0.68,
                          ),
                          itemCount: state.products.length +
                              (state.isLoadingMore ? 1 : 0),
                          itemBuilder: (_, i) {
                            if (i >= state.products.length) {
                              return const Center(
                                child: Padding(
                                  padding: EdgeInsets.all(16),
                                  child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: KinnectColors.accent),
                                ),
                              );
                            }
                            return _ProductCard(product: state.products[i]);
                          },
                        ),
                ),
              ],
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  void _showPostListingSheet() {
    final titleCtrl = TextEditingController();
    final descCtrl = TextEditingController();
    final priceCtrl = TextEditingController();
    String category = 'genealogy_books';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: KinnectColors.surface,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => Padding(
        padding: EdgeInsets.fromLTRB(
            24, 24, 24, MediaQuery.of(ctx).viewInsets.bottom + 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Post to Marketplace', style: KinnectTextStyles.headlineSmall),
            const SizedBox(height: 16),
            _field(titleCtrl, 'Product Title'),
            const SizedBox(height: 12),
            _field(descCtrl, 'Description', maxLines: 3),
            const SizedBox(height: 12),
            _field(priceCtrl, 'Price (USD)',
                keyboardType: TextInputType.number),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  final cents =
                      ((double.tryParse(priceCtrl.text) ?? 0) * 100).round();
                  context.read<MarketplaceCubit>().createListing(
                        title: titleCtrl.text,
                        description: descCtrl.text,
                        category: category,
                        priceCents: cents,
                      );
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text('Listing submitted for review'),
                    backgroundColor: KinnectColors.success,
                  ));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: KinnectColors.accent,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('Submit Listing'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _field(TextEditingController ctrl, String hint,
      {int maxLines = 1, TextInputType? keyboardType}) {
    return TextField(
      controller: ctrl,
      maxLines: maxLines,
      keyboardType: keyboardType,
      style: const TextStyle(color: KinnectColors.textPrimary),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: KinnectColors.textMuted),
        filled: true,
        fillColor: KinnectColors.surfaceElevated,
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Category chips
// ---------------------------------------------------------------------------

class _CategoryChips extends StatelessWidget {
  const _CategoryChips({
    required this.categories,
    required this.selected,
    required this.onSelected,
  });

  final List<MarketplaceCategoryDTO> categories;
  final String? selected;
  final ValueChanged<String?> onSelected;

  static const _iconMap = <String, IconData Function()>{
    'globe': PhosphorIcons.globe,
    'dna': PhosphorIcons.dna,
    'book': PhosphorIcons.bookOpen,
    'gift': PhosphorIcons.gift,
    'package': PhosphorIcons.package,
  };

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        itemCount: categories.length + 1, // +1 for "All"
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (_, i) {
          if (i == 0) {
            final isAll = selected == null;
            return _chip(
              label: 'All',
              icon: PhosphorIcons.squaresFour,
              isSelected: isAll,
              onTap: () => onSelected(null),
            );
          }
          final cat = categories[i - 1];
          final isSelected = selected == cat.id;
          final iconFn = _iconMap[cat.icon] ?? PhosphorIcons.squaresFour;
          return _chip(
            label: cat.name,
            icon: iconFn,
            isSelected: isSelected,
            onTap: () => onSelected(cat.id),
          );
        },
      ),
    );
  }

  Widget _chip({
    required String label,
    required IconData Function() icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? KinnectColors.accent : KinnectColors.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
              color: isSelected
                  ? KinnectColors.accent
                  : KinnectColors.dividerSubtle),
        ),
        child: Row(
          children: [
            Icon(icon(), size: 16,
                color: isSelected ? Colors.white : KinnectColors.textSecondary),
            const SizedBox(width: 6),
            Text(label,
                style: TextStyle(
                    color: isSelected
                        ? Colors.white
                        : KinnectColors.textSecondary,
                    fontSize: 13)),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Product card
// ---------------------------------------------------------------------------

class _ProductCard extends StatelessWidget {
  const _ProductCard({required this.product});

  final MarketplaceProductDTO product;

  String get _priceDisplay {
    if (product.priceCents == 0) return 'FREE';
    final dollars = product.priceCents / 100;
    return '\$${dollars.toStringAsFixed(2)}';
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => AppNav.push(context, '/marketplace/product/${product.id}'),
      child: Container(
        decoration: BoxDecoration(
          color: KinnectColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: KinnectColors.dividerSubtle),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image placeholder
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: KinnectColors.surfaceElevated,
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(12)),
                ),
                child: product.imageUrl != null
                    ? ClipRRect(
                        borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(12)),
                        child: Image.network(product.imageUrl!,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Center(
                                child: Icon(PhosphorIcons.package(),
                                    size: 40,
                                    color: KinnectColors.textMuted))),
                      )
                    : Center(
                        child: Icon(PhosphorIcons.package(),
                            size: 40, color: KinnectColors.textMuted)),
              ),
            ),
            // Details
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(product.title,
                      style: const TextStyle(
                          color: KinnectColors.textPrimary,
                          fontWeight: FontWeight.w600,
                          fontSize: 13),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 4),
                  Text(product.sellerName ?? 'Unknown Seller',
                      style: TextStyle(
                          color: KinnectColors.textSecondary, fontSize: 11)),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(_priceDisplay,
                          style: TextStyle(
                              color: product.priceCents == 0
                                  ? KinnectColors.success
                                  : KinnectColors.accent,
                              fontWeight: FontWeight.bold,
                              fontSize: 14)),
                      if (product.rating != null)
                        Row(children: [
                          Icon(PhosphorIcons.star(),
                              size: 12, color: KinnectColors.warning),
                          const SizedBox(width: 2),
                          Text('${product.rating}',
                              style: TextStyle(
                                  color: KinnectColors.textSecondary,
                                  fontSize: 11)),
                        ]),
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
}
