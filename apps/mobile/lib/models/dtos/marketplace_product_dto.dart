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
    @JsonKey(name: 'compare_at_cents') int? compareAtCents,
    @Default('USD') String currency,
    @JsonKey(name: 'seller_id') String? sellerId,
    @JsonKey(name: 'seller_name') String? sellerName,
    @JsonKey(name: 'commission_percent') double? commissionPercent,
    @JsonKey(name: 'rating_avg') @Default(0) double ratingAvg,
    @JsonKey(name: 'rating_count') @Default(0) int ratingCount,
    @JsonKey(name: 'sales_count') @Default(0) int salesCount,
    @JsonKey(name: 'view_count') @Default(0) int viewCount,
    @Default(false) bool featured,
    @Default([]) List<ProductImageDTO> images,
    String? status,
    @JsonKey(name: 'created_at') DateTime? createdAt,
  }) = _MarketplaceProductDTO;

  factory MarketplaceProductDTO.fromJson(Map<String, dynamic> json) =>
      _$MarketplaceProductDTOFromJson(json);
}

@freezed
abstract class ProductImageDTO with _$ProductImageDTO {
  const factory ProductImageDTO({
    String? id,
    required String url,
    @JsonKey(name: 'alt_text') String? altText,
    @JsonKey(name: 'sort_order') @Default(0) int sortOrder,
    @JsonKey(name: 'is_primary') @Default(false) bool isPrimary,
  }) = _ProductImageDTO;

  factory ProductImageDTO.fromJson(Map<String, dynamic> json) =>
      _$ProductImageDTOFromJson(json);
}

@freezed
abstract class MarketplaceCategoryDTO with _$MarketplaceCategoryDTO {
  const factory MarketplaceCategoryDTO({
    required String id,
    required String name,
    required String icon,
    @JsonKey(name: 'sort_order') @Default(0) int sortOrder,
    @JsonKey(name: 'parent_id') String? parentId,
    @Default(0) int count,
  }) = _MarketplaceCategoryDTO;

  factory MarketplaceCategoryDTO.fromJson(Map<String, dynamic> json) =>
      _$MarketplaceCategoryDTOFromJson(json);
}

@freezed
abstract class MarketplaceOrderDTO with _$MarketplaceOrderDTO {
  const factory MarketplaceOrderDTO({
    @JsonKey(name: 'order_id') required String orderId,
    @JsonKey(name: 'buyer_id') String? buyerId,
    @JsonKey(name: 'seller_id') String? sellerId,
    required String status,
    @JsonKey(name: 'subtotal_cents') @Default(0) int subtotalCents,
    @JsonKey(name: 'commission_cents') @Default(0) int commissionCents,
    @JsonKey(name: 'seller_payout_cents') @Default(0) int sellerPayoutCents,
    @JsonKey(name: 'shipping_cents') @Default(0) int shippingCents,
    @JsonKey(name: 'total_cents') @Default(0) int totalCents,
    @Default('USD') String currency,
    @JsonKey(name: 'tracking_number') String? trackingNumber,
    @JsonKey(name: 'tracking_url') String? trackingUrl,
    @Default([]) List<OrderItemDTO> items,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(name: 'paid_at') DateTime? paidAt,
    @JsonKey(name: 'shipped_at') DateTime? shippedAt,
    @JsonKey(name: 'delivered_at') DateTime? deliveredAt,
  }) = _MarketplaceOrderDTO;

  factory MarketplaceOrderDTO.fromJson(Map<String, dynamic> json) =>
      _$MarketplaceOrderDTOFromJson(json);
}

@freezed
abstract class OrderItemDTO with _$OrderItemDTO {
  const factory OrderItemDTO({
    @JsonKey(name: 'item_id') String? itemId,
    @JsonKey(name: 'product_id') required String productId,
    required String title,
    @JsonKey(name: 'price_cents') required int priceCents,
    @Default(1) int quantity,
    @JsonKey(name: 'image_url') String? imageUrl,
  }) = _OrderItemDTO;

  factory OrderItemDTO.fromJson(Map<String, dynamic> json) =>
      _$OrderItemDTOFromJson(json);
}

@freezed
abstract class ReviewDTO with _$ReviewDTO {
  const factory ReviewDTO({
    @JsonKey(name: 'review_id') required String reviewId,
    @JsonKey(name: 'product_id') required String productId,
    @JsonKey(name: 'reviewer_id') String? reviewerId,
    @JsonKey(name: 'reviewer_name') String? reviewerName,
    required int rating,
    String? title,
    String? body,
    @JsonKey(name: 'helpful_count') @Default(0) int helpfulCount,
    @JsonKey(name: 'verified_purchase') @Default(false) bool verifiedPurchase,
    @JsonKey(name: 'created_at') DateTime? createdAt,
  }) = _ReviewDTO;

  factory ReviewDTO.fromJson(Map<String, dynamic> json) =>
      _$ReviewDTOFromJson(json);
}

@freezed
abstract class SellerDashboardDTO with _$SellerDashboardDTO {
  const factory SellerDashboardDTO({
    @JsonKey(name: 'seller_id') String? sellerId,
    @JsonKey(name: 'store_name') String? storeName,
    @JsonKey(name: 'store_slug') String? storeSlug,
    String? description,
    @JsonKey(name: 'logo_url') String? logoUrl,
    @JsonKey(name: 'stripe_onboarded') @Default(false) bool stripeOnboarded,
    @JsonKey(name: 'commission_rate') @Default(12.0) double commissionRate,
    @JsonKey(name: 'rating_avg') @Default(0) double ratingAvg,
    @JsonKey(name: 'rating_count') @Default(0) int ratingCount,
    @Default('pending') String status,
    @JsonKey(name: 'active_listings') @Default(0) int activeListings,
    @JsonKey(name: 'total_sales') @Default(0) int totalSales,
    @JsonKey(name: 'total_earnings_cents') @Default(0) int totalEarningsCents,
    @JsonKey(name: 'pending_orders') @Default(0) int pendingOrders,
  }) = _SellerDashboardDTO;

  factory SellerDashboardDTO.fromJson(Map<String, dynamic> json) =>
      _$SellerDashboardDTOFromJson(json);
}

@freezed
abstract class CheckoutSessionDTO with _$CheckoutSessionDTO {
  const factory CheckoutSessionDTO({
    @JsonKey(name: 'session_id') required String sessionId,
    @JsonKey(name: 'client_secret') required String clientSecret,
    @JsonKey(name: 'ephemeral_key') required String ephemeralKey,
    @JsonKey(name: 'customer_id') required String customerId,
    @JsonKey(name: 'total_cents') required int totalCents,
    @Default('USD') String currency,
  }) = _CheckoutSessionDTO;

  factory CheckoutSessionDTO.fromJson(Map<String, dynamic> json) =>
      _$CheckoutSessionDTOFromJson(json);
}
