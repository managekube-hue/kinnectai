import 'package:freezed_annotation/freezed_annotation.dart';

part 'cart_item_dto.freezed.dart';
part 'cart_item_dto.g.dart';

/// Local cart item stored in Hive. Maps a product snapshot to a quantity.
@freezed
abstract class CartItemDTO with _$CartItemDTO {
  const factory CartItemDTO({
    @JsonKey(name: 'product_id') required String productId,
    required String title,
    @JsonKey(name: 'price_cents') required int priceCents,
    @Default('USD') String currency,
    @JsonKey(name: 'seller_name') String? sellerName,
    @JsonKey(name: 'image_url') String? imageUrl,
    @Default(1) int quantity,
  }) = _CartItemDTO;

  factory CartItemDTO.fromJson(Map<String, dynamic> json) =>
      _$CartItemDTOFromJson(json);
}
