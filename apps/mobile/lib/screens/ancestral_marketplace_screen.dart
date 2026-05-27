import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:badges/badges.dart' as badges;
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:shimmer/shimmer.dart';

import '../cubits/cart_cubit.dart';
import '../cubits/marketplace_cubit.dart';
import '../models/dtos/marketplace_product_dto.dart';
import '../router/app_nav.dart';
import '../theme/colors.dart';
import '../theme/typography.dart';

/// Production marketplace screen using shimmer loading, debounced search,
/// category filtering, sort options, and infinite scroll pagination.
class AncestralMarketplaceScreen extends StatefulWidget {
  const AncestralMarketplaceScreen({super.key});

  @override
  State<AncestralMarketplaceScreen> createState() => _AncestralMarketplaceScreenState();
}

class _AncestralMarketplaceScreenState extends State<AncestralMarketplaceScreen> {
  final ScrollController _scrollCtrl = ScrollController();
  final TextEditingController _searchCtrl = TextEditingController();
  bool _showSearch = false;

  @override
  void initState() {
    super.initState();
    context.read<MarketplaceCubit>().load();
    _scrollCtrl.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollCtrl.position.pixels >= _scrollCtrl.position.maxScrollExtent - 200) {
      context.read<MarketplaceCubit>().loadMore();
    }
  }

  @override
  void dispose() {
    _scrollCtrl.dispose();
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: KinnectColors.background,
      appBar: AppBar(
        backgroundColor: KinnectColors.surface,
        title: _showSearch
            ? _SearchField(
                controller: _searchCtrl,
                onChanged: (q) => context.read<MarketplaceCubit>().search(q),
                onClose: () => setState(() {
                  _showSearch = false;
                  _searchCtrl.clear();
                  context.read<MarketplaceCubit>().search('');
                }),
              )
            : const Text('Ancestral Marketplace', style: KinnectTextStyles.headlineSmall),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: KinnectColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          if (!_showSearch)
            IconButton(
              icon: Icon(PhosphorIcons.magnifyingGlass(), color: KinnectColors.textPrimary),
              onPressed: () => setState(() => _showSearch = true),
            ),
          // Cart with badge
          BlocBuilder<CartCubit, CartState>(
            builder: (context, cartState) {
              final count = cartState is CartLoaded ? cartState.itemCount : 0;
              return badges.Badge(
                showBadge: count > 0,
                badgeContent: Text('$count', style: const TextStyle(color: Colors.white, fontSize: 10)),
                badgeStyle: const badges.BadgeStyle(badgeColor: KinnectColors.accent),
                position: badges.BadgePosition.topEnd(top: 4, end: 4),
                child: IconButton(
                  icon: Icon(PhosphorIcons.shoppingCart(), color: KinnectColors.textPrimary),
                  onPressed: () => AppNav.push(context, '/marketplace/cart'),
                ),
              );
            },
          ),
          IconButton(
            icon: Icon(PhosphorIcons.heart(), color: KinnectColors.textPrimary),
            onPressed: () => AppNav.push(context, '/marketplace/wishlist'),
          ),
          IconButton(
            icon: Icon(PhosphorIcons.plus(), color: KinnectColors.accent),
            onPressed: () => AppNav.push(context, '/marketplace/create-listing'),
          ),
        ],
      ),
      body: BlocBuilder<MarketplaceCubit, MarketplaceState>(
        builder: (context, state) {
          if (state is MarketplaceLoading) {
            return _ShimmerProductGrid();
          }

          if (state is MarketplaceError) {
            return _ErrorView(
              message: state.message,
              onRetry: () => context.read<MarketplaceCubit>().load(),
            );
          }

          if (state is MarketplaceLoaded) {
            return Column(
              children: [
                // Category chips
                _CategoryChips(
                  categories: state.categories,
                  selected: state.selectedCategory,
                  onSelected: (cat) => context.read<MarketplaceCubit>().filterByCategory(cat),
                ),
                // Sort bar
                _SortBar(
                  current: state.sortBy,
                  onChanged: (s) => context.read<MarketplaceCubit>().changeSortBy(s),
                  resultCount: state.products.length,
                ),
                // Product grid
                Expanded(
                  child: state.products.isEmpty
                      ? _EmptyState()
                      : GridView.builder(
                          controller: _scrollCtrl,
                          padding: const EdgeInsets.all(12),
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                            childAspectRatio: 0.62,
                          ),
                          itemCount: state.products.length + (state.isLoadingMore ? 2 : 0),
                          itemBuilder: (_, i) {
                            if (i >= state.products.length) {
                              return _ShimmerProductCard();
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
}

// ---------------------------------------------------------------------------
// Search field
// ---------------------------------------------------------------------------

class _SearchField extends StatelessWidget {
  const _SearchField({required this.controller, required this.onChanged, required this.onClose});

  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      autofocus: true,
      onChanged: onChanged,
      style: const TextStyle(color: KinnectColors.textPrimary),
      decoration: InputDecoration(
        hintText: 'Search products...',
        hintStyle: const TextStyle(color: KinnectColors.textMuted),
        border: InputBorder.none,
        suffixIcon: IconButton(
          icon: const Icon(Icons.close, color: KinnectColors.textSecondary),
          onPressed: onClose,
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Sort bar
// ---------------------------------------------------------------------------

class _SortBar extends StatelessWidget {
  const _SortBar({required this.current, required this.onChanged, required this.resultCount});

  final String current;
  final ValueChanged<String> onChanged;
  final int resultCount;

  static const _sortOptions = {
    'featured': 'Featured',
    'newest': 'Newest',
    'price_asc': 'Price: Low-High',
    'price_desc': 'Price: High-Low',
    'rating': 'Top Rated',
    'bestselling': 'Best Selling',
  };

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('$resultCount products', style: const TextStyle(color: KinnectColors.textMuted, fontSize: 12)),
          PopupMenuButton<String>(
            initialValue: current,
            onSelected: onChanged,
            color: KinnectColors.surface,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(PhosphorIcons.funnelSimple(), size: 16, color: KinnectColors.textSecondary),
                const SizedBox(width: 4),
                Text(_sortOptions[current] ?? 'Sort', style: const TextStyle(color: KinnectColors.textSecondary, fontSize: 12)),
              ],
            ),
            itemBuilder: (_) => _sortOptions.entries
                .map((e) => PopupMenuItem(value: e.key, child: Text(e.value, style: const TextStyle(color: KinnectColors.textPrimary))))
                .toList(),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Category chips
// ---------------------------------------------------------------------------

class _CategoryChips extends StatelessWidget {
  const _CategoryChips({required this.categories, required this.selected, required this.onSelected});

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
        itemCount: categories.length + 1,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (_, i) {
          if (i == 0) {
            return _chip(label: 'All', icon: PhosphorIcons.squaresFour, isSelected: selected == null, onTap: () => onSelected(null));
          }
          final cat = categories[i - 1];
          final iconFn = _iconMap[cat.icon] ?? PhosphorIcons.squaresFour;
          return _chip(
            label: '${cat.name} (${cat.count})',
            icon: iconFn,
            isSelected: selected == cat.id,
            onTap: () => onSelected(cat.id),
          );
        },
      ),
    );
  }

  Widget _chip({required String label, required IconData Function() icon, required bool isSelected, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? KinnectColors.accent : KinnectColors.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: isSelected ? KinnectColors.accent : KinnectColors.dividerSubtle),
        ),
        child: Row(
          children: [
            Icon(icon(), size: 16, color: isSelected ? Colors.white : KinnectColors.textSecondary),
            const SizedBox(width: 6),
            Text(label, style: TextStyle(color: isSelected ? Colors.white : KinnectColors.textSecondary, fontSize: 12)),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Product card with discount badge + wishlist heart
// ---------------------------------------------------------------------------

class _ProductCard extends StatelessWidget {
  const _ProductCard({required this.product});

  final MarketplaceProductDTO product;

  String get _priceDisplay {
    if (product.priceCents == 0) return 'FREE';
    return '\$${(product.priceCents / 100).toStringAsFixed(2)}';
  }

  String? get _comparePrice {
    if (product.compareAtCents == null || product.compareAtCents == 0) return null;
    return '\$${(product.compareAtCents! / 100).toStringAsFixed(2)}';
  }

  String? get _primaryImageUrl {
    if (product.images.isEmpty) return null;
    final primary = product.images.where((i) => i.isPrimary);
    return primary.isNotEmpty ? primary.first.url : product.images.first.url;
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
            // Image + badges
            Expanded(
              child: Stack(
                children: [
                  Container(
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: KinnectColors.surfaceElevated,
                      borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                    ),
                    child: _primaryImageUrl != null
                        ? ClipRRect(
                            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                            child: Image.network(_primaryImageUrl!, fit: BoxFit.cover,
                                errorBuilder: (_, _, _) => _imagePlaceholder()),
                          )
                        : _imagePlaceholder(),
                  ),
                  // Featured badge
                  if (product.featured)
                    Positioned(
                      top: 8, left: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(color: KinnectColors.warning, borderRadius: BorderRadius.circular(4)),
                        child: const Text('FEATURED', style: TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  // Discount badge
                  if (_comparePrice != null)
                    Positioned(
                      top: 8, right: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                        decoration: BoxDecoration(color: KinnectColors.error, borderRadius: BorderRadius.circular(4)),
                        child: Text(
                          '${(((product.compareAtCents! - product.priceCents) / product.compareAtCents!) * 100).round()}% OFF',
                          style: const TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  // Wishlist heart
                  Positioned(
                    bottom: 8, right: 8,
                    child: GestureDetector(
                      onTap: () => context.read<MarketplaceCubit>().toggleWishlist(product.id),
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.4),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(PhosphorIcons.heart(), size: 16, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Details
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(product.title,
                      style: const TextStyle(color: KinnectColors.textPrimary, fontWeight: FontWeight.w600, fontSize: 13),
                      maxLines: 2, overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 4),
                  Text(product.sellerName ?? 'Unknown',
                      style: const TextStyle(color: KinnectColors.textSecondary, fontSize: 11)),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Text(_priceDisplay, style: TextStyle(
                          color: product.priceCents == 0 ? KinnectColors.success : KinnectColors.accent,
                          fontWeight: FontWeight.bold, fontSize: 14)),
                      if (_comparePrice != null) ...[
                        const SizedBox(width: 6),
                        Text(_comparePrice!, style: const TextStyle(
                            color: KinnectColors.textMuted, fontSize: 11,
                            decoration: TextDecoration.lineThrough)),
                      ],
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(PhosphorIcons.star(PhosphorIconsStyle.fill), size: 12, color: KinnectColors.warning),
                      const SizedBox(width: 3),
                      Text('${product.ratingAvg.toStringAsFixed(1)} (${product.ratingCount})',
                          style: const TextStyle(color: KinnectColors.textSecondary, fontSize: 11)),
                      const Spacer(),
                      if (product.salesCount > 0)
                        Text('${product.salesCount} sold',
                            style: const TextStyle(color: KinnectColors.textMuted, fontSize: 10)),
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

  Widget _imagePlaceholder() => Center(child: Icon(PhosphorIcons.package(), size: 40, color: KinnectColors.textMuted));
}

// ---------------------------------------------------------------------------
// Shimmer loading skeleton
// ---------------------------------------------------------------------------

class _ShimmerProductGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: KinnectColors.surfaceElevated,
      highlightColor: KinnectColors.surface,
      child: GridView.builder(
        padding: const EdgeInsets.all(12),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, crossAxisSpacing: 10, mainAxisSpacing: 10, childAspectRatio: 0.62,
        ),
        itemCount: 6,
        itemBuilder: (_, _) => _ShimmerProductCard(),
      ),
    );
  }
}

class _ShimmerProductCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: KinnectColors.surface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Expanded(child: Container(
            decoration: const BoxDecoration(
              color: KinnectColors.surfaceElevated,
              borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
            ),
          )),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(height: 14, width: double.infinity, color: KinnectColors.surfaceElevated),
                const SizedBox(height: 6),
                Container(height: 10, width: 80, color: KinnectColors.surfaceElevated),
                const SizedBox(height: 8),
                Container(height: 16, width: 60, color: KinnectColors.surfaceElevated),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Helpers
// ---------------------------------------------------------------------------

class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(PhosphorIcons.warning(), size: 48, color: KinnectColors.error),
            const SizedBox(height: 12),
            Text(message, style: const TextStyle(color: KinnectColors.textSecondary), textAlign: TextAlign.center),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: onRetry,
              style: ElevatedButton.styleFrom(backgroundColor: KinnectColors.accent, foregroundColor: Colors.white),
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(PhosphorIcons.storefront(), size: 64, color: KinnectColors.textMuted),
          const SizedBox(height: 16),
          const Text('No products found', style: TextStyle(color: KinnectColors.textSecondary, fontSize: 16)),
          const SizedBox(height: 8),
          const Text('Try adjusting your search or filters', style: TextStyle(color: KinnectColors.textMuted, fontSize: 13)),
        ],
      ),
    );
  }
}
