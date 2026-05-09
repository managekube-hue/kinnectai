import 'package:dio/dio.dart';

import '../models/dtos/marketplace_product_dto.dart';
import 'marketplace_repository.dart';

class MarketplaceRepositoryImpl implements MarketplaceRepository {
  MarketplaceRepositoryImpl({required Dio dio, this.basePath = '/v1'})
      : _dio = dio;

  final Dio _dio;
  final String basePath;

  @override
  Future<MarketplaceProductsPage> fetchProducts({
    String? category,
    String? cursor,
    int limit = 20,
  }) async {
    final response = await _dio.get<Map<String, dynamic>>(
      '$basePath/marketplace/products',
      queryParameters: {
        if (category != null && category.isNotEmpty) 'category': category,
        if (cursor != null && cursor.isNotEmpty) 'after': cursor,
        'limit': limit,
      },
    );

    final data = (response.data?['data'] as Map<String, dynamic>?) ??
        <String, dynamic>{};

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
  Future<MarketplaceProductDTO> fetchProduct(String id) async {
    final response = await _dio.get<Map<String, dynamic>>(
      '$basePath/marketplace/products/$id',
    );

    final data = (response.data?['data'] as Map<String, dynamic>?) ??
        response.data ??
        <String, dynamic>{};

    return MarketplaceProductDTO.fromJson(data);
  }

  @override
  Future<List<MarketplaceCategoryDTO>> fetchCategories() async {
    final response = await _dio.get<Map<String, dynamic>>(
      '$basePath/marketplace/categories',
    );

    final data = (response.data?['data'] as List?) ?? const <dynamic>[];

    return data
        .whereType<Map<String, dynamic>>()
        .map(MarketplaceCategoryDTO.fromJson)
        .toList();
  }

  @override
  Future<MarketplaceProductDTO> createListing({
    required String title,
    required String description,
    required String category,
    required int priceCents,
    String currency = 'USD',
    String? imageUrl,
  }) async {
    final response = await _dio.post<Map<String, dynamic>>(
      '$basePath/marketplace/products',
      data: {
        'title': title,
        'description': description,
        'category': category,
        'price_cents': priceCents,
        'currency': currency,
        if (imageUrl != null) 'image_url': imageUrl,
      },
    );

    final data = (response.data?['data'] as Map<String, dynamic>?) ??
        response.data ??
        <String, dynamic>{};

    return MarketplaceProductDTO.fromJson(data);
  }

  @override
  Future<MarketplaceOrderDTO> createOrder(String productId) async {
    final response = await _dio.post<Map<String, dynamic>>(
      '$basePath/marketplace/orders',
      data: {'product_id': productId},
    );

    final data = (response.data?['data'] as Map<String, dynamic>?) ??
        response.data ??
        <String, dynamic>{};

    return MarketplaceOrderDTO.fromJson(data);
  }

  @override
  Future<List<MarketplaceOrderDTO>> fetchOrders() async {
    final response = await _dio.get<Map<String, dynamic>>(
      '$basePath/marketplace/orders',
    );

    final data = (response.data?['data'] as Map<String, dynamic>?) ??
        <String, dynamic>{};

    return ((data['items'] as List?) ?? const <dynamic>[])
        .whereType<Map<String, dynamic>>()
        .map(MarketplaceOrderDTO.fromJson)
        .toList();
  }

  @override
  Future<SellerDashboardDTO> fetchSellerDashboard() async {
    final response = await _dio.get<Map<String, dynamic>>(
      '$basePath/marketplace/seller/dashboard',
    );

    final data = (response.data?['data'] as Map<String, dynamic>?) ??
        response.data ??
        <String, dynamic>{};

    return SellerDashboardDTO.fromJson(data);
  }
}
