import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../router/app_nav.dart';
import '../theme/colors.dart';
import '../theme/typography.dart';

/// PRD Section 00 (Home Top Bar Store) + Addendum 3.0 S7.
/// Ancestral Marketplace: genealogy books, heritage travel, DNA wellness, heirlooms.
/// Affiliate via Impact/ShareASale. 8-15% commission. Stripe Connect for sellers.
class AncestralMarketplaceScreen extends StatefulWidget {
  const AncestralMarketplaceScreen({super.key});

  @override
  State<AncestralMarketplaceScreen> createState() => _AncestralMarketplaceScreenState();
}

class _AncestralMarketplaceScreenState extends State<AncestralMarketplaceScreen> {
  int _selectedCategory = 0;

  static const _categories = [
    _Category(id: 'all', label: 'All', icon: PhosphorIcons.squaresFour),
    _Category(id: 'heritage_travel', label: 'Heritage Travel', icon: PhosphorIcons.globe),
    _Category(id: 'dna_wellness', label: 'DNA Wellness', icon: PhosphorIcons.dna),
    _Category(id: 'genealogy_books', label: 'Books', icon: PhosphorIcons.bookOpen),
    _Category(id: 'heirlooms', label: 'Heirlooms', icon: PhosphorIcons.gift),
  ];

  static final _products = [
    _Product(id: 'p1', title: 'Harrington Family History', category: 'genealogy_books', price: '\$29.99', seller: 'Heritage Press', rating: 4.8),
    _Product(id: 'p2', title: 'Cork County Heritage Tour', category: 'heritage_travel', price: '\$899.00', seller: 'Ancestry Travels', rating: 4.9),
    _Product(id: 'p3', title: 'DNA Wellness Report', category: 'dna_wellness', price: '\$49.99', seller: 'GenomicHealth', rating: 4.5),
    _Product(id: 'p4', title: 'Vintage Family Crest Ring', category: 'heirlooms', price: '\$159.00', seller: 'AncestralCraft', rating: 4.7),
    _Product(id: 'p5', title: 'Kinnect DNA Kit', category: 'dna_wellness', price: 'FREE', seller: 'KinnectAI', rating: 5.0),
    _Product(id: 'p6', title: 'Genealogy Research Guide', category: 'genealogy_books', price: '\$14.99', seller: 'TreeBuilders', rating: 4.3),
    _Product(id: 'p7', title: 'Ellis Island Photo Archive', category: 'heirlooms', price: '\$39.99', seller: 'HistoryVault', rating: 4.6),
    _Product(id: 'p8', title: 'Haplogroup Migration Map Poster', category: 'heirlooms', price: '\$24.99', seller: 'MapCraft', rating: 4.4),
  ];

  List<_Product> get _filtered => _selectedCategory == 0
      ? _products
      : _products.where((p) => p.category == _categories[_selectedCategory].id).toList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: KinnectColors.background,
      appBar: AppBar(
        backgroundColor: KinnectColors.surface,
        title: Text('Ancestral Marketplace', style: KinnectTextStyles.headlineSmall),
        leading: IconButton(icon: const Icon(Icons.arrow_back, color: KinnectColors.textPrimary), onPressed: () => Navigator.pop(context)),
        actions: [
          IconButton(icon: Icon(PhosphorIcons.shoppingCart(), color: KinnectColors.textPrimary), onPressed: () {}),
          IconButton(icon: Icon(PhosphorIcons.plus(), color: KinnectColors.accent), onPressed: _showPostListingSheet),
        ],
      ),
      body: Column(
        children: [
          // Category filter chips
          SizedBox(
            height: 48,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              itemCount: _categories.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (_, i) {
                final selected = i == _selectedCategory;
                return GestureDetector(
                  onTap: () => setState(() => _selectedCategory = i),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                    decoration: BoxDecoration(
                      color: selected ? KinnectColors.accent : KinnectColors.surface,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: selected ? KinnectColors.accent : KinnectColors.dividerSubtle),
                    ),
                    child: Row(
                      children: [
                        Icon(_categories[i].icon(), size: 16, color: selected ? Colors.white : KinnectColors.textSecondary),
                        const SizedBox(width: 6),
                        Text(_categories[i].label, style: TextStyle(color: selected ? Colors.white : KinnectColors.textSecondary, fontSize: 13)),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          // Product grid
          Expanded(
            child: _filtered.isEmpty
                ? Center(child: Text('No products in this category', style: TextStyle(color: KinnectColors.textSecondary)))
                : GridView.builder(
                    padding: const EdgeInsets.all(16),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, crossAxisSpacing: 12, mainAxisSpacing: 12, childAspectRatio: 0.72),
                    itemCount: _filtered.length,
                    itemBuilder: (_, i) => _ProductCard(product: _filtered[i]),
                  ),
          ),
        ],
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
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => Padding(
        padding: EdgeInsets.fromLTRB(24, 24, 24, MediaQuery.of(ctx).viewInsets.bottom + 24),
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
            _field(priceCtrl, 'Price (USD)', keyboardType: TextInputType.number),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Listing submitted for review'), backgroundColor: KinnectColors.success));
                },
                style: ElevatedButton.styleFrom(backgroundColor: KinnectColors.accent, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 14), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                child: const Text('Submit Listing'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _field(TextEditingController ctrl, String hint, {int maxLines = 1, TextInputType? keyboardType}) {
    return TextField(
      controller: ctrl,
      maxLines: maxLines,
      keyboardType: keyboardType,
      style: const TextStyle(color: KinnectColors.textPrimary),
      decoration: InputDecoration(
        hintText: hint, hintStyle: TextStyle(color: KinnectColors.textMuted),
        filled: true, fillColor: KinnectColors.surfaceElevated,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
      ),
    );
  }
}

class _Category {
  const _Category({required this.id, required this.label, required this.icon});
  final String id; final String label; final IconData Function() icon;
}

class _Product {
  const _Product({required this.id, required this.title, required this.category, required this.price, required this.seller, required this.rating});
  final String id, title, category, price, seller;
  final double rating;
}

class _ProductCard extends StatelessWidget {
  const _ProductCard({required this.product});
  final _Product product;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: KinnectColors.surface, borderRadius: BorderRadius.circular(12), border: Border.all(color: KinnectColors.dividerSubtle)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(color: KinnectColors.surfaceElevated, borderRadius: const BorderRadius.vertical(top: Radius.circular(12))),
              child: Center(child: Icon(PhosphorIcons.package(), size: 40, color: KinnectColors.textMuted)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(product.title, style: const TextStyle(color: KinnectColors.textPrimary, fontWeight: FontWeight.w600, fontSize: 13), maxLines: 2, overflow: TextOverflow.ellipsis),
                const SizedBox(height: 4),
                Text(product.seller, style: TextStyle(color: KinnectColors.textSecondary, fontSize: 11)),
                const SizedBox(height: 6),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(product.price, style: TextStyle(color: product.price == 'FREE' ? KinnectColors.success : KinnectColors.accent, fontWeight: FontWeight.bold, fontSize: 14)),
                    Row(children: [Icon(PhosphorIcons.star(), size: 12, color: KinnectColors.warning), const SizedBox(width: 2), Text('${product.rating}', style: TextStyle(color: KinnectColors.textSecondary, fontSize: 11))]),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
