import 'dart:convert';

import 'package:hive/hive.dart';

import '../models/dtos/cart_item_dto.dart';
import 'cart_repository.dart';

class HiveCartRepository implements CartRepository {
  HiveCartRepository({this.boxName = 'marketplace_cart', this.key = 'cart_items'});

  final String boxName;
  final String key;

  @override
  Future<List<CartItemDTO>> load() async {
    final box = await Hive.openBox<String>(boxName);
    final raw = box.get(key);
    if (raw == null || raw.isEmpty) return const [];
    try {
      final decoded = (jsonDecode(raw) as List)
          .whereType<Map<String, dynamic>>()
          .map(CartItemDTO.fromJson)
          .toList();
      return decoded;
    } catch (_) {
      return const [];
    }
  }

  @override
  Future<void> save(List<CartItemDTO> items) async {
    final box = await Hive.openBox<String>(boxName);
    final encoded = jsonEncode(
      items
          .map((i) => (i as dynamic).toJson() as Map<String, dynamic>)
          .toList(),
    );
    await box.put(key, encoded);
  }

  @override
  Future<void> clear() async {
    final box = await Hive.openBox<String>(boxName);
    await box.delete(key);
  }
}
