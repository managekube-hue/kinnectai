// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cart_item_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CartItemDTO _$CartItemDTOFromJson(Map<String, dynamic> json) => _CartItemDTO(
  productId: json['product_id'] as String,
  title: json['title'] as String,
  priceCents: (json['price_cents'] as num).toInt(),
  currency: json['currency'] as String? ?? 'USD',
  sellerName: json['seller_name'] as String?,
  imageUrl: json['image_url'] as String?,
  quantity: (json['quantity'] as num?)?.toInt() ?? 1,
);

Map<String, dynamic> _$CartItemDTOToJson(_CartItemDTO instance) =>
    <String, dynamic>{
      'product_id': instance.productId,
      'title': instance.title,
      'price_cents': instance.priceCents,
      'currency': instance.currency,
      'seller_name': instance.sellerName,
      'image_url': instance.imageUrl,
      'quantity': instance.quantity,
    };
