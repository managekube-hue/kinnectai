import 'package:freezed_annotation/freezed_annotation.dart';

part 'marketplace_product_dto.freezed.dart';
part 'marketplace_product_dto.g.dart';

@freezed
abstract class MarketplaceProductDTO with _$MarketplaceProductDTO {
  const factory MarketplaceProductDTO({
    required String id,
    required String title,
    String? description,
    required String category,
    @JsonKey(name: 'price_cents') required int priceCents,
    @Default('USD') String currency,
    @JsonKey(name: 'seller_name') String? sellerName,
    @JsonKey(name: 'seller_id') String? sellerId,
    @JsonKey(name: 'image_url') String? imageUrl,
    @JsonKey(name: 'commission_percent') int? commissionPercent,
    double? rating,
    String? status,
  }) = _MarketplaceProductDTO;

  factory MarketplaceProductDTO.fromJson(Map<String, dynamic> json) =>
      _$MarketplaceProductDTOFromJson(json);
}

@freezed
abstract class MarketplaceCategoryDTO with _$MarketplaceCategoryDTO {
  const factory MarketplaceCategoryDTO({
    required String id,
    required String name,
    required String icon,
    @Default(0) int count,
  }) = _MarketplaceCategoryDTO;

  factory MarketplaceCategoryDTO.fromJson(Map<String, dynamic> json) =>
      _$MarketplaceCategoryDTOFromJson(json);
}

@freezed
abstract class MarketplaceSellerDTO with _$MarketplaceSellerDTO {
  const factory MarketplaceSellerDTO({
    required String id,
    required String name,
    double? rating,
  }) = _MarketplaceSellerDTO;

  factory MarketplaceSellerDTO.fromJson(Map<String, dynamic> json) =>
      _$MarketplaceSellerDTOFromJson(json);
}

@freezed
abstract class MarketplaceOrderDTO with _$MarketplaceOrderDTO {
  const factory MarketplaceOrderDTO({
    @JsonKey(name: 'order_id') required String orderId,
    @JsonKey(name: 'product_id') required String productId,
    @JsonKey(name: 'buyer_id') String? buyerId,
    required String status,
    @JsonKey(name: 'checkout_url') String? checkoutUrl,
  }) = _MarketplaceOrderDTO;

  factory MarketplaceOrderDTO.fromJson(Map<String, dynamic> json) =>
      _$MarketplaceOrderDTOFromJson(json);
}

@freezed
abstract class SellerDashboardDTO with _$SellerDashboardDTO {
  const factory SellerDashboardDTO({
    @JsonKey(name: 'total_sales') @Default(0) int totalSales,
    @JsonKey(name: 'total_earnings') @Default(0) int totalEarnings,
    @JsonKey(name: 'active_listings') @Default(0) int activeListings,
    @JsonKey(name: 'pending_orders') @Default(0) int pendingOrders,
  }) = _SellerDashboardDTO;

  factory SellerDashboardDTO.fromJson(Map<String, dynamic> json) =>
      _$SellerDashboardDTOFromJson(json);
}
