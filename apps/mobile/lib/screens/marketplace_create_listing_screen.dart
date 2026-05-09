import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../cubits/marketplace_cubit.dart';
import '../theme/colors.dart';
import '../theme/typography.dart';

/// Full product upload / create listing screen.
/// Allows sellers to submit products with title, description, category,
/// price, images, and tags for marketplace review.
class MarketplaceCreateListingScreen extends StatefulWidget {
  const MarketplaceCreateListingScreen({super.key});

  @override
  State<MarketplaceCreateListingScreen> createState() => _State();
}

class _State extends State<MarketplaceCreateListingScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  final _priceCtrl = TextEditingController();
  final _tagsCtrl = TextEditingController();
  String _selectedCategory = 'genealogy_books';
  final List<String> _imageUrls = [];
  bool _isSubmitting = false;

  final _imagePicker = ImagePicker();

  /// Pick an image from gallery or camera, upload to the media service,
  /// return the S3 URL. Returns null if user cancelled or upload failed.
  Future<String?> _pickAndUploadImage() async {
    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      backgroundColor: KinnectColors.surface,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(PhosphorIcons.camera(), color: KinnectColors.accent),
              title: const Text('Take Photo', style: TextStyle(color: KinnectColors.textPrimary)),
              onTap: () => Navigator.pop(ctx, ImageSource.camera),
            ),
            ListTile(
              leading: Icon(PhosphorIcons.image(), color: KinnectColors.accent),
              title: const Text('Choose from Gallery', style: TextStyle(color: KinnectColors.textPrimary)),
              onTap: () => Navigator.pop(ctx, ImageSource.gallery),
            ),
          ],
        ),
      ),
    );

    if (source == null) return null;

    final picked = await _imagePicker.pickImage(
      source: source,
      maxWidth: 1200,
      maxHeight: 1200,
      imageQuality: 85,
    );
    if (picked == null) return null;

    try {
      // Upload to backend media service which stores in S3
      final dio = Dio();
      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(picked.path, filename: picked.name),
        'type': 'marketplace_product',
      });
      final response = await dio.post<Map<String, dynamic>>(
        '/v1/media/upload',
        data: formData,
      );
      return response.data?['data']?['url'] as String?;
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Image upload failed: $e'),
          backgroundColor: KinnectColors.error,
        ));
      }
      return null;
    }
  }

  static const _categories = {
    'heritage_travel': 'Heritage Travel',
    'dna_wellness': 'DNA Wellness',
    'genealogy_books': 'Genealogy Books',
    'heirlooms': 'Heirlooms & Craft',
    'kinnect_kit': 'Kinnect Kit',
  };

  @override
  void dispose() {
    _titleCtrl.dispose();
    _descCtrl.dispose();
    _priceCtrl.dispose();
    _tagsCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: KinnectColors.background,
      appBar: AppBar(
        backgroundColor: KinnectColors.surface,
        title: Text('Create Listing', style: KinnectTextStyles.headlineSmall),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: KinnectColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: BlocListener<MarketplaceCubit, MarketplaceState>(
        listener: (context, state) {
          if (state is MarketplaceListingCreated) {
            setState(() => _isSubmitting = false);
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text('Listing submitted for review!'),
              backgroundColor: KinnectColors.success,
            ));
            Navigator.pop(context);
          } else if (state is MarketplaceError) {
            setState(() => _isSubmitting = false);
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(state.message),
              backgroundColor: KinnectColors.error,
            ));
          }
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image upload area
                Text('Product Images', style: KinnectTextStyles.titleMedium),
                const SizedBox(height: 8),
                _ImageUploadArea(
                  imageUrls: _imageUrls,
                  onAdd: () async {
                    // Open image picker, upload to S3 via media service, get URL back
                    final url = await _pickAndUploadImage();
                    if (url != null) {
                      setState(() => _imageUrls.add(url));
                    }
                  },
                  onRemove: (i) => setState(() => _imageUrls.removeAt(i)),
                ),
                const SizedBox(height: 24),

                // Title
                Text('Product Title', style: KinnectTextStyles.titleMedium),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _titleCtrl,
                  style: const TextStyle(color: KinnectColors.textPrimary),
                  validator: (v) => v == null || v.length < 3 ? 'Title must be at least 3 characters' : null,
                  decoration: _inputDecor('e.g. Harrington Family History Book'),
                ),
                const SizedBox(height: 20),

                // Description
                Text('Description', style: KinnectTextStyles.titleMedium),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _descCtrl,
                  maxLines: 5,
                  style: const TextStyle(color: KinnectColors.textPrimary),
                  validator: (v) => v == null || v.length < 10 ? 'Description must be at least 10 characters' : null,
                  decoration: _inputDecor('Describe your product in detail...'),
                ),
                const SizedBox(height: 20),

                // Category
                Text('Category', style: KinnectTextStyles.titleMedium),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  decoration: BoxDecoration(
                    color: KinnectColors.surface,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: _selectedCategory,
                      isExpanded: true,
                      dropdownColor: KinnectColors.surface,
                      style: const TextStyle(color: KinnectColors.textPrimary),
                      items: _categories.entries.map((e) => DropdownMenuItem(
                        value: e.key,
                        child: Text(e.value),
                      )).toList(),
                      onChanged: (v) => setState(() => _selectedCategory = v ?? _selectedCategory),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Price
                Text('Price (USD)', style: KinnectTextStyles.titleMedium),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _priceCtrl,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  style: const TextStyle(color: KinnectColors.textPrimary),
                  validator: (v) {
                    if (v == null || v.isEmpty) return 'Price is required';
                    final price = double.tryParse(v);
                    if (price == null || price < 0) return 'Enter a valid price';
                    return null;
                  },
                  decoration: _inputDecor('0.00').copyWith(
                    prefixText: '\$ ',
                    prefixStyle: const TextStyle(color: KinnectColors.accent, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 20),

                // Tags
                Text('Tags (comma separated)', style: KinnectTextStyles.titleMedium),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _tagsCtrl,
                  style: const TextStyle(color: KinnectColors.textPrimary),
                  decoration: _inputDecor('genealogy, family history, DNA'),
                ),
                const SizedBox(height: 12),
                Text(
                  'Tags help buyers find your product via search.',
                  style: TextStyle(color: KinnectColors.textMuted, fontSize: 12),
                ),
                const SizedBox(height: 32),

                // Commission notice
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: KinnectColors.accent.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: KinnectColors.accent.withOpacity(0.2)),
                  ),
                  child: Row(
                    children: [
                      Icon(PhosphorIcons.info(), size: 20, color: KinnectColors.accent),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'KinnectAI charges 8-15% commission on sales. Payouts are sent directly to your Stripe Connect account.',
                          style: TextStyle(color: KinnectColors.textSecondary, fontSize: 12, height: 1.4),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Submit
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isSubmitting ? null : _submit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: KinnectColors.accent,
                      foregroundColor: Colors.white,
                      disabledBackgroundColor: KinnectColors.accent.withOpacity(0.5),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: _isSubmitting
                        ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                        : const Text('Submit for Review', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                  ),
                ),
                const SizedBox(height: 12),
                Center(
                  child: Text(
                    'Your listing will be reviewed within 24 hours',
                    style: TextStyle(color: KinnectColors.textMuted, fontSize: 12),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecor(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: KinnectColors.textMuted),
      filled: true,
      fillColor: KinnectColors.surface,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
      errorStyle: const TextStyle(color: KinnectColors.error),
    );
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    final priceCents = ((double.tryParse(_priceCtrl.text) ?? 0) * 100).round();
    final tags = _tagsCtrl.text.split(',').map((t) => t.trim()).where((t) => t.isNotEmpty).toList();

    setState(() => _isSubmitting = true);

    context.read<MarketplaceCubit>().createListing(
      title: _titleCtrl.text.trim(),
      description: _descCtrl.text.trim(),
      category: _selectedCategory,
      priceCents: priceCents,
      imageUrls: _imageUrls,
      tags: tags,
    );
  }
}

class _ImageUploadArea extends StatelessWidget {
  const _ImageUploadArea({required this.imageUrls, required this.onAdd, required this.onRemove});

  final List<String> imageUrls;
  final VoidCallback onAdd;
  final void Function(int) onRemove;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          ...imageUrls.asMap().entries.map((e) => Padding(
            padding: const EdgeInsets.only(right: 10),
            child: Stack(
              children: [
                Container(
                  width: 100, height: 100,
                  decoration: BoxDecoration(
                    color: KinnectColors.surfaceElevated,
                    borderRadius: BorderRadius.circular(12),
                    border: e.key == 0
                        ? Border.all(color: KinnectColors.accent, width: 2)
                        : Border.all(color: KinnectColors.dividerSubtle),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.network(e.value, fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Center(
                            child: Icon(PhosphorIcons.image(), size: 32, color: KinnectColors.textMuted))),
                  ),
                ),
                Positioned(
                  top: 4, right: 4,
                  child: GestureDetector(
                    onTap: () => onRemove(e.key),
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(color: KinnectColors.error, shape: BoxShape.circle),
                      child: const Icon(Icons.close, size: 12, color: Colors.white),
                    ),
                  ),
                ),
                if (e.key == 0)
                  Positioned(
                    bottom: 4, left: 4,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(color: KinnectColors.accent, borderRadius: BorderRadius.circular(4)),
                      child: const Text('Cover', style: TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold)),
                    ),
                  ),
              ],
            ),
          )),
          // Add button
          GestureDetector(
            onTap: onAdd,
            child: Container(
              width: 100, height: 100,
              decoration: BoxDecoration(
                color: KinnectColors.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: KinnectColors.dividerSubtle, style: BorderStyle.solid),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(PhosphorIcons.camera(), size: 28, color: KinnectColors.textMuted),
                  const SizedBox(height: 4),
                  Text('Add Photo', style: TextStyle(color: KinnectColors.textMuted, fontSize: 11)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
