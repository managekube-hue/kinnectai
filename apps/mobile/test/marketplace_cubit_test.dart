import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:kinnectai_app/cubits/marketplace_cubit.dart';
import 'package:kinnectai_app/models/dtos/marketplace_product_dto.dart';
import 'package:kinnectai_app/repositories/marketplace_repository.dart';

class MockMarketplaceRepository extends Mock implements MarketplaceRepository {}

void main() {
  late MockMarketplaceRepository mockRepo;

  final sampleCategories = [
    const MarketplaceCategoryDTO(id: 'books', name: 'Books', icon: 'book', count: 5),
    const MarketplaceCategoryDTO(id: 'travel', name: 'Travel', icon: 'globe', count: 3),
  ];

  final sampleProducts = [
    const MarketplaceProductDTO(
      id: 'p1',
      title: 'Test Book',
      category: 'books',
      priceCents: 2999,
      currency: 'USD',
      sellerName: 'Test Seller',
      rating: 4.5,
    ),
    const MarketplaceProductDTO(
      id: 'p2',
      title: 'Heritage Tour',
      category: 'travel',
      priceCents: 89900,
      currency: 'USD',
      sellerName: 'Travel Co',
      rating: 4.9,
    ),
  ];

  final samplePage = MarketplaceProductsPage(
    items: sampleProducts,
    nextCursor: null,
    hasMore: false,
  );

  setUp(() {
    mockRepo = MockMarketplaceRepository();
  });

  group('MarketplaceCubit', () {
    blocTest<MarketplaceCubit, MarketplaceState>(
      'emits [Loading, Loaded] when load succeeds',
      build: () {
        when(() => mockRepo.fetchCategories())
            .thenAnswer((_) async => sampleCategories);
        when(() => mockRepo.fetchProducts(category: any(named: 'category')))
            .thenAnswer((_) async => samplePage);
        return MarketplaceCubit(repository: mockRepo);
      },
      act: (cubit) => cubit.load(),
      expect: () => [
        isA<MarketplaceLoading>(),
        isA<MarketplaceLoaded>()
            .having((s) => s.products.length, 'product count', 2)
            .having((s) => s.categories.length, 'category count', 2)
            .having((s) => s.hasMore, 'hasMore', false),
      ],
    );

    blocTest<MarketplaceCubit, MarketplaceState>(
      'emits [Loading, Error] when load fails',
      build: () {
        when(() => mockRepo.fetchCategories())
            .thenThrow(Exception('network error'));
        when(() => mockRepo.fetchProducts(category: any(named: 'category')))
            .thenAnswer((_) async => samplePage);
        return MarketplaceCubit(repository: mockRepo);
      },
      act: (cubit) => cubit.load(),
      expect: () => [
        isA<MarketplaceLoading>(),
        isA<MarketplaceError>(),
      ],
    );

    blocTest<MarketplaceCubit, MarketplaceState>(
      'emits [Loading, ProductDetail] when fetchProductDetail succeeds',
      build: () {
        when(() => mockRepo.fetchProduct('p1'))
            .thenAnswer((_) async => sampleProducts[0]);
        return MarketplaceCubit(repository: mockRepo);
      },
      act: (cubit) => cubit.fetchProductDetail('p1'),
      expect: () => [
        isA<MarketplaceLoading>(),
        isA<MarketplaceProductDetail>()
            .having((s) => s.product.id, 'product id', 'p1'),
      ],
    );

    blocTest<MarketplaceCubit, MarketplaceState>(
      'emits [Loading, ListingCreated] when createListing succeeds',
      build: () {
        when(() => mockRepo.createListing(
              title: any(named: 'title'),
              description: any(named: 'description'),
              category: any(named: 'category'),
              priceCents: any(named: 'priceCents'),
              currency: any(named: 'currency'),
              imageUrl: any(named: 'imageUrl'),
            )).thenAnswer((_) async => sampleProducts[0]);
        return MarketplaceCubit(repository: mockRepo);
      },
      act: (cubit) => cubit.createListing(
        title: 'New Book',
        description: 'A great book',
        category: 'books',
        priceCents: 1999,
      ),
      expect: () => [
        isA<MarketplaceLoading>(),
        isA<MarketplaceListingCreated>(),
      ],
    );

    blocTest<MarketplaceCubit, MarketplaceState>(
      'emits [Loading, OrderCreated] when placeOrder succeeds',
      build: () {
        when(() => mockRepo.createOrder('p1')).thenAnswer((_) async =>
            const MarketplaceOrderDTO(
              orderId: 'ord_1',
              productId: 'p1',
              status: 'processing',
              checkoutUrl: 'https://checkout.example.com',
            ));
        return MarketplaceCubit(repository: mockRepo);
      },
      act: (cubit) => cubit.placeOrder('p1'),
      expect: () => [
        isA<MarketplaceLoading>(),
        isA<MarketplaceOrderCreated>()
            .having((s) => s.order.orderId, 'order id', 'ord_1'),
      ],
    );
  });
}
