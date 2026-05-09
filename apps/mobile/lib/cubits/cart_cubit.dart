import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';

import '../models/dtos/cart_item_dto.dart';
import '../models/dtos/marketplace_product_dto.dart';

// ---------------------------------------------------------------------------
// States
// ---------------------------------------------------------------------------

sealed class CartState extends Equatable {
  const CartState();

  @override
  List<Object?> get props => [];
}

class CartInitial extends CartState {}

class CartLoaded extends CartState {
  const CartLoaded(this.items);

  final List<CartItemDTO> items;

  int get totalCents =>
      items.fold(0, (sum, item) => sum + item.priceCents * item.quantity);

  int get itemCount => items.fold(0, (sum, item) => sum + item.quantity);

  bool containsProduct(String productId) =>
      items.any((item) => item.productId == productId);

  @override
  List<Object?> get props => [items];
}

// ---------------------------------------------------------------------------
// Cubit — persists to Hive box 'marketplace_cart'
// ---------------------------------------------------------------------------

class CartCubit extends Cubit<CartState> {
  CartCubit() : super(CartInitial());

  static const _boxName = 'marketplace_cart';
  static const _key = 'cart_items';

  /// Load cart from Hive on startup.
  Future<void> load() async {
    final box = await Hive.openBox<String>(_boxName);
    final raw = box.get(_key);
    if (raw == null || raw.isEmpty) {
      emit(const CartLoaded([]));
      return;
    }
    try {
      final decoded = (jsonDecode(raw) as List)
          .whereType<Map<String, dynamic>>()
          .map(CartItemDTO.fromJson)
          .toList();
      emit(CartLoaded(decoded));
    } catch (_) {
      emit(const CartLoaded([]));
    }
  }

  /// Add a marketplace product to the cart.
  void addProduct(MarketplaceProductDTO product, {int quantity = 1}) {
    final current = _currentItems;
    final index = current.indexWhere((i) => i.productId == product.id);

    List<CartItemDTO> updated;
    if (index >= 0) {
      // Increment quantity
      final existing = current[index];
      updated = [...current];
      updated[index] = existing.copyWith(quantity: existing.quantity + quantity);
    } else {
      updated = [
        ...current,
        CartItemDTO(
          productId: product.id,
          title: product.title,
          priceCents: product.priceCents,
          currency: product.currency,
          sellerName: product.sellerName,
          imageUrl: product.imageUrl,
          quantity: quantity,
        ),
      ];
    }
    _emitAndPersist(updated);
  }

  /// Remove a product entirely from the cart.
  void removeProduct(String productId) {
    final updated = _currentItems.where((i) => i.productId != productId).toList();
    _emitAndPersist(updated);
  }

  /// Update quantity. If quantity <= 0, the item is removed.
  void updateQuantity(String productId, int quantity) {
    if (quantity <= 0) {
      removeProduct(productId);
      return;
    }
    final current = _currentItems;
    final index = current.indexWhere((i) => i.productId == productId);
    if (index < 0) return;

    final updated = [...current];
    updated[index] = current[index].copyWith(quantity: quantity);
    _emitAndPersist(updated);
  }

  /// Clear the entire cart (e.g. after successful checkout).
  void clear() => _emitAndPersist([]);

  // Helpers -------------------------------------------------------------------

  List<CartItemDTO> get _currentItems {
    final s = state;
    return s is CartLoaded ? List.of(s.items) : [];
  }

  void _emitAndPersist(List<CartItemDTO> items) {
    emit(CartLoaded(items));
    _persist(items);
  }

  Future<void> _persist(List<CartItemDTO> items) async {
    final box = await Hive.openBox<String>(_boxName);
    final encoded = jsonEncode(items.map((i) => i.toJson()).toList());
    await box.put(_key, encoded);
  }
}
