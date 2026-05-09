import 'dart:io';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';

import 'package:kinnectai_app/cubits/cart_cubit.dart';
import 'package:kinnectai_app/models/dtos/marketplace_product_dto.dart';

void main() {
  setUp(() async {
    // Use a temp directory for Hive in tests
    final tempDir = await Directory.systemTemp.createTemp('hive_test');
    Hive.init(tempDir.path);
  });

  tearDown(() async {
    await Hive.deleteFromDisk();
    await Hive.close();
  });

  const product1 = MarketplaceProductDTO(
    id: 'p1',
    title: 'Test Product',
    category: 'books',
    priceCents: 2999,
    currency: 'USD',
    sellerName: 'Seller A',
  );

  const product2 = MarketplaceProductDTO(
    id: 'p2',
    title: 'Another Product',
    category: 'travel',
    priceCents: 5999,
    currency: 'USD',
    sellerName: 'Seller B',
  );

  group('CartCubit', () {
    blocTest<CartCubit, CartState>(
      'emits CartLoaded([]) on initial load with empty cart',
      build: () => CartCubit(),
      act: (cubit) => cubit.load(),
      expect: () => [
        isA<CartLoaded>().having((s) => s.items.length, 'items', 0),
      ],
    );

    blocTest<CartCubit, CartState>(
      'adds a product to the cart',
      build: () => CartCubit(),
      act: (cubit) async {
        await cubit.load();
        cubit.addProduct(product1);
      },
      expect: () => [
        isA<CartLoaded>().having((s) => s.items.length, 'items', 0),
        isA<CartLoaded>()
            .having((s) => s.items.length, 'items', 1)
            .having((s) => s.items.first.productId, 'productId', 'p1')
            .having((s) => s.totalCents, 'totalCents', 2999),
      ],
    );

    blocTest<CartCubit, CartState>(
      'increments quantity when adding same product twice',
      build: () => CartCubit(),
      act: (cubit) async {
        await cubit.load();
        cubit.addProduct(product1);
        cubit.addProduct(product1);
      },
      expect: () => [
        isA<CartLoaded>().having((s) => s.items.length, 'items', 0),
        isA<CartLoaded>().having((s) => s.itemCount, 'count', 1),
        isA<CartLoaded>()
            .having((s) => s.itemCount, 'count', 2)
            .having((s) => s.totalCents, 'totalCents', 5998),
      ],
    );

    blocTest<CartCubit, CartState>(
      'removes a product from the cart',
      build: () => CartCubit(),
      act: (cubit) async {
        await cubit.load();
        cubit.addProduct(product1);
        cubit.addProduct(product2);
        cubit.removeProduct('p1');
      },
      expect: () => [
        isA<CartLoaded>().having((s) => s.items.length, 'items', 0),
        isA<CartLoaded>().having((s) => s.items.length, 'items', 1),
        isA<CartLoaded>().having((s) => s.items.length, 'items', 2),
        isA<CartLoaded>()
            .having((s) => s.items.length, 'items', 1)
            .having((s) => s.items.first.productId, 'productId', 'p2'),
      ],
    );

    blocTest<CartCubit, CartState>(
      'clears the cart',
      build: () => CartCubit(),
      act: (cubit) async {
        await cubit.load();
        cubit.addProduct(product1);
        cubit.clear();
      },
      expect: () => [
        isA<CartLoaded>().having((s) => s.items.length, 'items', 0),
        isA<CartLoaded>().having((s) => s.items.length, 'items', 1),
        isA<CartLoaded>().having((s) => s.items.length, 'items', 0),
      ],
    );
  });
}
