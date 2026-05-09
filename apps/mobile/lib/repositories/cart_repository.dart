import '../models/dtos/cart_item_dto.dart';

abstract class CartRepository {
  Future<List<CartItemDTO>> load();
  Future<void> save(List<CartItemDTO> items);
  Future<void> clear();
}
