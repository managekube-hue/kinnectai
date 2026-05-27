import 'package:dio/dio.dart';

import '../models/dtos/marketplace_product_dto.dart';
import 'marketplace_repository.dart';

class MarketplaceRepositoryImpl implements MarketplaceRepository {
  MarketplaceRepositoryImpl({required Dio dio, this.basePath = '/v1'})
      : _dio = dio;

  final Dio _dio;
  final String basePath;

  // ---------------------------------------------------------------------------
  // Products
  // ---------------------------------------------------------------------------

  @override
  Future<MarketplaceProductsPage> searchProducts({
    String? query,
    String? category,
    int? minPrice,
    int? maxPrice,
    double? minRating,
    String sortBy = 'featured',
    String? cursor,
    int limit = 20,
  }) async {
    final response = await _dio.get<Map<String, dynamic>>(
      '$basePath/marketplace/products',
      queryParameters: {
        if (query != null && query.isNotEmpty) 'query': query,
        if (category != null && category.isNotEmpty) 'category': category,
        'min_price': ?minPrice,
        'max_price': ?maxPrice,
        'min_rating': ?minRating,
        'sort_by': sortBy,
        if (cursor != null && cursor.isNotEmpty) 'after': cursor,
        'limit': limit,
      },
    );

    final data = (response.data?['data'] as Map<String, dynamic>?) ?? <String, dynamic>{};
    final items = ((data['items'] as List?) ?? const <dynamic>[])
        .whereType<Map<String, dynamic>>()
        .map(MarketplaceProductDTO.fromJson)
        .toList();

    return MarketplaceProductsPage(
      items: items,
      nextCursor: data['next_cursor']?.toString(),
      hasMore: data['has_more'] as bool? ?? false,
    );
  }

  @override
  Future<MarketplaceProductDTO> getProduct(String id) async {
    final response = await _dio.get<Map<String, dynamic>>(
      '$basePath/marketplace/products/$id',
    );
    final data = (response.data?['data'] as Map<String, dynamic>?) ?? response.data ?? <String, dynamic>{};
    return MarketplaceProductDTO.fromJson(data);
  }

  @override
  Future<MarketplaceProductDTO> createListing({
    required String title,
    required String description,
    required String category,
    required int priceCents,
    String currency = 'USD',
    List<String> imageUrls = const [],
    List<String> tags = const [],
  }) async {
    final response = await _dio.post<Map<String, dynamic>>(
      '$basePath/marketplace/products',
      data: {
        'title': title,
        'description': description,
        'category': category,
        'price_cents': priceCents,
        'currency': currency,
        'image_urls': imageUrls,
        'tags': tags,
      },
    );
    final data = (response.data?['data'] as Map<String, dynamic>?) ?? response.data ?? <String, dynamic>{};
    return MarketplaceProductDTO.fromJson(data);
  }

  // ---------------------------------------------------------------------------
  // Categories
  // ---------------------------------------------------------------------------

  @override
  Future<List<MarketplaceCategoryDTO>> fetchCategories() async {
    final response = await _dio.get<Map<String, dynamic>>('$basePath/marketplace/categories');
    final data = (response.data?['data'] as List?) ?? const <dynamic>[];
    return data.whereType<Map<String, dynamic>>().map(MarketplaceCategoryDTO.fromJson).toList();
  }

  // ---------------------------------------------------------------------------
  // Checkout (Stripe Connect)
  // ---------------------------------------------------------------------------

  @override
  Future<CheckoutResult> createCheckout(List<CheckoutItem> items) async {
    final response = await _dio.post<Map<String, dynamic>>(
      '$basePath/marketplace/checkout',
      data: {'items': items.map((i) => i.toJson()).toList()},
    );
    final data = (response.data?['data'] as Map<String, dynamic>?) ?? <String, dynamic>{};
    return CheckoutResult(
      session: CheckoutSessionDTO.fromJson(data['session'] as Map<String, dynamic>),
      order: MarketplaceOrderDTO.fromJson(data['order'] as Map<String, dynamic>),
    );
  }

  // ---------------------------------------------------------------------------
  // Orders
  // ---------------------------------------------------------------------------

  @override
  Future<List<MarketplaceOrderDTO>> listOrders({String role = 'buyer'}) async {
    final response = await _dio.get<Map<String, dynamic>>(
      '$basePath/marketplace/orders',
      queryParameters: {'role': role},
    );
    final data = (response.data?['data'] as Map<String, dynamic>?) ?? <String, dynamic>{};
    return ((data['items'] as List?) ?? const <dynamic>[])
        .whereType<Map<String, dynamic>>()
        .map(MarketplaceOrderDTO.fromJson)
        .toList();
  }

  @override
  Future<MarketplaceOrderDTO> getOrder(String orderId) async {
    final response = await _dio.get<Map<String, dynamic>>('$basePath/marketplace/orders/$orderId');
    final data = (response.data?['data'] as Map<String, dynamic>?) ?? response.data ?? <String, dynamic>{};
    return MarketplaceOrderDTO.fromJson(data);
  }

  // ---------------------------------------------------------------------------
  // Reviews
  // ---------------------------------------------------------------------------

  @override
  Future<List<ReviewDTO>> listReviews(String productId, {String? cursor, int limit = 20}) async {
    final response = await _dio.get<Map<String, dynamic>>(
      '$basePath/marketplace/products/$productId/reviews',
      queryParameters: {
        'after': ?cursor,
        'limit': limit,
      },
    );
    final data = (response.data?['data'] as List?) ?? const <dynamic>[];
    return data.whereType<Map<String, dynamic>>().map(ReviewDTO.fromJson).toList();
  }

  @override
  Future<ReviewDTO> createReview(String productId, {required int rating, String? title, String? body}) async {
    final response = await _dio.post<Map<String, dynamic>>(
      '$basePath/marketplace/products/$productId/reviews',
      data: {
        'rating': rating,
        'title': ?title,
        'body': ?body,
      },
    );
    final data = (response.data?['data'] as Map<String, dynamic>?) ?? response.data ?? <String, dynamic>{};
    return ReviewDTO.fromJson(data);
  }

  // ---------------------------------------------------------------------------
  // Wishlist
  // ---------------------------------------------------------------------------

  @override
  Future<bool> toggleWishlist(String productId) async {
    final response = await _dio.post<Map<String, dynamic>>('$basePath/marketplace/wishlist/$productId');
    return response.data?['wishlisted'] as bool? ?? false;
  }

  @override
  Future<List<MarketplaceProductDTO>> listWishlist() async {
    final response = await _dio.get<Map<String, dynamic>>('$basePath/marketplace/wishlist');
    final data = (response.data?['data'] as List?) ?? const <dynamic>[];
    return data.whereType<Map<String, dynamic>>().map(MarketplaceProductDTO.fromJson).toList();
  }

  // ---------------------------------------------------------------------------
  // Seller
  // ---------------------------------------------------------------------------

  @override
  Future<SellerDashboardDTO> getSellerDashboard() async {
    final response = await _dio.get<Map<String, dynamic>>('$basePath/marketplace/seller/dashboard');
    final data = (response.data?['data'] as Map<String, dynamic>?) ?? response.data ?? <String, dynamic>{};
    return SellerDashboardDTO.fromJson(data);
  }

  @override
  Future<SellerOnboardResult> onboardSeller({required String storeName, required String storeSlug}) async {
    final response = await _dio.post<Map<String, dynamic>>(
      '$basePath/marketplace/seller/onboard',
      data: {'store_name': storeName, 'store_slug': storeSlug},
    );
    final data = (response.data?['data'] as Map<String, dynamic>?) ?? <String, dynamic>{};
    return SellerOnboardResult(
      dashboard: SellerDashboardDTO.fromJson(data['profile'] as Map<String, dynamic>),
      onboardUrl: data['onboard_url'] as String,
    );
  }
}
