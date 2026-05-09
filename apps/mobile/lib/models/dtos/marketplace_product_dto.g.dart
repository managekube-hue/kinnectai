// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'marketplace_product_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_MarketplaceProductDTO _$MarketplaceProductDTOFromJson(
  Map<String, dynamic> json,
) => _MarketplaceProductDTO(
  id: json['id'] as String,
  title: json['title'] as String,
  description: json['description'] as String?,
  category: json['category'] as String,
  priceCents: (json['price_cents'] as num).toInt(),
  compareAtCents: (json['compare_at_cents'] as num?)?.toInt(),
  currency: json['currency'] as String? ?? 'USD',
  sellerId: json['seller_id'] as String?,
  sellerName: json['seller_name'] as String?,
  commissionPercent: (json['commission_percent'] as num?)?.toDouble(),
  ratingAvg: (json['rating_avg'] as num?)?.toDouble() ?? 0,
  ratingCount: (json['rating_count'] as num?)?.toInt() ?? 0,
  salesCount: (json['sales_count'] as num?)?.toInt() ?? 0,
  viewCount: (json['view_count'] as num?)?.toInt() ?? 0,
  featured: json['featured'] as bool? ?? false,
  images:
      (json['images'] as List<dynamic>?)
          ?.map((e) => ProductImageDTO.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  status: json['status'] as String?,
  createdAt: json['created_at'] == null
      ? null
      : DateTime.parse(json['created_at'] as String),
);

Map<String, dynamic> _$MarketplaceProductDTOToJson(
  _MarketplaceProductDTO instance,
) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'description': instance.description,
  'category': instance.category,
  'price_cents': instance.priceCents,
  'compare_at_cents': instance.compareAtCents,
  'currency': instance.currency,
  'seller_id': instance.sellerId,
  'seller_name': instance.sellerName,
  'commission_percent': instance.commissionPercent,
  'rating_avg': instance.ratingAvg,
  'rating_count': instance.ratingCount,
  'sales_count': instance.salesCount,
  'view_count': instance.viewCount,
  'featured': instance.featured,
  'images': instance.images,
  'status': instance.status,
  'created_at': instance.createdAt?.toIso8601String(),
};

_ProductImageDTO _$ProductImageDTOFromJson(Map<String, dynamic> json) =>
    _ProductImageDTO(
      id: json['id'] as String?,
      url: json['url'] as String,
      altText: json['alt_text'] as String?,
      sortOrder: (json['sort_order'] as num?)?.toInt() ?? 0,
      isPrimary: json['is_primary'] as bool? ?? false,
    );

Map<String, dynamic> _$ProductImageDTOToJson(_ProductImageDTO instance) =>
    <String, dynamic>{
      'id': instance.id,
      'url': instance.url,
      'alt_text': instance.altText,
      'sort_order': instance.sortOrder,
      'is_primary': instance.isPrimary,
    };

_MarketplaceCategoryDTO _$MarketplaceCategoryDTOFromJson(
  Map<String, dynamic> json,
) => _MarketplaceCategoryDTO(
  id: json['id'] as String,
  name: json['name'] as String,
  icon: json['icon'] as String,
  sortOrder: (json['sort_order'] as num?)?.toInt() ?? 0,
  parentId: json['parent_id'] as String?,
  count: (json['count'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$MarketplaceCategoryDTOToJson(
  _MarketplaceCategoryDTO instance,
) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'icon': instance.icon,
  'sort_order': instance.sortOrder,
  'parent_id': instance.parentId,
  'count': instance.count,
};

_MarketplaceOrderDTO _$MarketplaceOrderDTOFromJson(Map<String, dynamic> json) =>
    _MarketplaceOrderDTO(
      orderId: json['order_id'] as String,
      buyerId: json['buyer_id'] as String?,
      sellerId: json['seller_id'] as String?,
      status: json['status'] as String,
      subtotalCents: (json['subtotal_cents'] as num?)?.toInt() ?? 0,
      commissionCents: (json['commission_cents'] as num?)?.toInt() ?? 0,
      sellerPayoutCents: (json['seller_payout_cents'] as num?)?.toInt() ?? 0,
      shippingCents: (json['shipping_cents'] as num?)?.toInt() ?? 0,
      totalCents: (json['total_cents'] as num?)?.toInt() ?? 0,
      currency: json['currency'] as String? ?? 'USD',
      trackingNumber: json['tracking_number'] as String?,
      trackingUrl: json['tracking_url'] as String?,
      items:
          (json['items'] as List<dynamic>?)
              ?.map((e) => OrderItemDTO.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      paidAt: json['paid_at'] == null
          ? null
          : DateTime.parse(json['paid_at'] as String),
      shippedAt: json['shipped_at'] == null
          ? null
          : DateTime.parse(json['shipped_at'] as String),
      deliveredAt: json['delivered_at'] == null
          ? null
          : DateTime.parse(json['delivered_at'] as String),
    );

Map<String, dynamic> _$MarketplaceOrderDTOToJson(
  _MarketplaceOrderDTO instance,
) => <String, dynamic>{
  'order_id': instance.orderId,
  'buyer_id': instance.buyerId,
  'seller_id': instance.sellerId,
  'status': instance.status,
  'subtotal_cents': instance.subtotalCents,
  'commission_cents': instance.commissionCents,
  'seller_payout_cents': instance.sellerPayoutCents,
  'shipping_cents': instance.shippingCents,
  'total_cents': instance.totalCents,
  'currency': instance.currency,
  'tracking_number': instance.trackingNumber,
  'tracking_url': instance.trackingUrl,
  'items': instance.items,
  'created_at': instance.createdAt?.toIso8601String(),
  'paid_at': instance.paidAt?.toIso8601String(),
  'shipped_at': instance.shippedAt?.toIso8601String(),
  'delivered_at': instance.deliveredAt?.toIso8601String(),
};

_OrderItemDTO _$OrderItemDTOFromJson(Map<String, dynamic> json) =>
    _OrderItemDTO(
      itemId: json['item_id'] as String?,
      productId: json['product_id'] as String,
      title: json['title'] as String,
      priceCents: (json['price_cents'] as num).toInt(),
      quantity: (json['quantity'] as num?)?.toInt() ?? 1,
      imageUrl: json['image_url'] as String?,
    );

Map<String, dynamic> _$OrderItemDTOToJson(_OrderItemDTO instance) =>
    <String, dynamic>{
      'item_id': instance.itemId,
      'product_id': instance.productId,
      'title': instance.title,
      'price_cents': instance.priceCents,
      'quantity': instance.quantity,
      'image_url': instance.imageUrl,
    };

_ReviewDTO _$ReviewDTOFromJson(Map<String, dynamic> json) => _ReviewDTO(
  reviewId: json['review_id'] as String,
  productId: json['product_id'] as String,
  reviewerId: json['reviewer_id'] as String?,
  reviewerName: json['reviewer_name'] as String?,
  rating: (json['rating'] as num).toInt(),
  title: json['title'] as String?,
  body: json['body'] as String?,
  helpfulCount: (json['helpful_count'] as num?)?.toInt() ?? 0,
  verifiedPurchase: json['verified_purchase'] as bool? ?? false,
  createdAt: json['created_at'] == null
      ? null
      : DateTime.parse(json['created_at'] as String),
);

Map<String, dynamic> _$ReviewDTOToJson(_ReviewDTO instance) =>
    <String, dynamic>{
      'review_id': instance.reviewId,
      'product_id': instance.productId,
      'reviewer_id': instance.reviewerId,
      'reviewer_name': instance.reviewerName,
      'rating': instance.rating,
      'title': instance.title,
      'body': instance.body,
      'helpful_count': instance.helpfulCount,
      'verified_purchase': instance.verifiedPurchase,
      'created_at': instance.createdAt?.toIso8601String(),
    };

_SellerDashboardDTO _$SellerDashboardDTOFromJson(Map<String, dynamic> json) =>
    _SellerDashboardDTO(
      sellerId: json['seller_id'] as String?,
      storeName: json['store_name'] as String?,
      storeSlug: json['store_slug'] as String?,
      description: json['description'] as String?,
      logoUrl: json['logo_url'] as String?,
      stripeOnboarded: json['stripe_onboarded'] as bool? ?? false,
      commissionRate: (json['commission_rate'] as num?)?.toDouble() ?? 12.0,
      ratingAvg: (json['rating_avg'] as num?)?.toDouble() ?? 0,
      ratingCount: (json['rating_count'] as num?)?.toInt() ?? 0,
      status: json['status'] as String? ?? 'pending',
      activeListings: (json['active_listings'] as num?)?.toInt() ?? 0,
      totalSales: (json['total_sales'] as num?)?.toInt() ?? 0,
      totalEarningsCents: (json['total_earnings_cents'] as num?)?.toInt() ?? 0,
      pendingOrders: (json['pending_orders'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$SellerDashboardDTOToJson(_SellerDashboardDTO instance) =>
    <String, dynamic>{
      'seller_id': instance.sellerId,
      'store_name': instance.storeName,
      'store_slug': instance.storeSlug,
      'description': instance.description,
      'logo_url': instance.logoUrl,
      'stripe_onboarded': instance.stripeOnboarded,
      'commission_rate': instance.commissionRate,
      'rating_avg': instance.ratingAvg,
      'rating_count': instance.ratingCount,
      'status': instance.status,
      'active_listings': instance.activeListings,
      'total_sales': instance.totalSales,
      'total_earnings_cents': instance.totalEarningsCents,
      'pending_orders': instance.pendingOrders,
    };

_CheckoutSessionDTO _$CheckoutSessionDTOFromJson(Map<String, dynamic> json) =>
    _CheckoutSessionDTO(
      sessionId: json['session_id'] as String,
      clientSecret: json['client_secret'] as String,
      ephemeralKey: json['ephemeral_key'] as String,
      customerId: json['customer_id'] as String,
      totalCents: (json['total_cents'] as num).toInt(),
      currency: json['currency'] as String? ?? 'USD',
    );

Map<String, dynamic> _$CheckoutSessionDTOToJson(_CheckoutSessionDTO instance) =>
    <String, dynamic>{
      'session_id': instance.sessionId,
      'client_secret': instance.clientSecret,
      'ephemeral_key': instance.ephemeralKey,
      'customer_id': instance.customerId,
      'total_cents': instance.totalCents,
      'currency': instance.currency,
    };
