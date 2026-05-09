import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:kinnectai_app/cubits/marketplace_cubit.dart';
import 'package:kinnectai_app/cubits/error_cubit.dart';
import 'package:kinnectai_app/models/dtos/marketplace_product_dto.dart';
import 'package:kinnectai_app/repositories/marketplace_repository.dart';

class MockMarketplaceRepository extends Mock implements MarketplaceRepository {}

class FakeCheckoutItem extends Fake implements CheckoutItem {}

void main() {
  late MockMarketplaceRepository mockRepo;

  setUpAll(() {
    registerFallbackValue(FakeCheckoutItem());
  });

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
      ratingAvg: 4.5,
      ratingCount: 12,
      salesCount: 50,
    ),
    const MarketplaceProductDTO(
      id: 'p2',
      title: 'Heritage Tour',
      category: 'travel',
      priceCents: 89900,
      currency: 'USD',
      sellerName: 'Travel Co',
      ratingAvg: 4.9,
      ratingCount: 28,
      featured: true,
    ),
  ];

  final samplePage = MarketplaceProductsPage(
    items: sampleProducts,
    nextCursor: null,
    hasMore: false,
  );

  final sampleReviews = [
    ReviewDTO(
      reviewId: 'r1',
      productId: 'p1',
      reviewerName: 'Alice',
      rating: 5,
      title: 'Great book',
      body: 'Loved the family history details.',
      verifiedPurchase: true,
      createdAt: DateTime(2024, 1, 1),
    ),
  ];

  setUp(() {
    mockRepo = MockMarketplaceRepository();
  });

  group('MarketplaceCubit', () {
    blocTest<MarketplaceCubit, MarketplaceState>(
      'emits [Loading, Loaded] when load succeeds',
      build: () {
        when(() => mockRepo.fetchCategories()).thenAnswer((_) async => sampleCategories);
        when(() => mockRepo.searchProducts(
          query: any(named: 'query'),
          category: any(named: 'category'),
          minPrice: any(named: 'minPrice'),
          maxPrice: any(named: 'maxPrice'),
          minRating: any(named: 'minRating'),
          sortBy: any(named: 'sortBy'),
          cursor: any(named: 'cursor'),
          limit: any(named: 'limit'),
        )).thenAnswer((_) async => samplePage);
        return MarketplaceCubit(repository: mockRepo, errorCubit: ErrorCubit());
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
        when(() => mockRepo.fetchCategories()).thenThrow(Exception('network error'));
        when(() => mockRepo.searchProducts(
          query: any(named: 'query'),
          category: any(named: 'category'),
          minPrice: any(named: 'minPrice'),
          maxPrice: any(named: 'maxPrice'),
          minRating: any(named: 'minRating'),
          sortBy: any(named: 'sortBy'),
          cursor: any(named: 'cursor'),
          limit: any(named: 'limit'),
        )).thenAnswer((_) async => samplePage);
        return MarketplaceCubit(repository: mockRepo, errorCubit: ErrorCubit());
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
        when(() => mockRepo.getProduct('p1')).thenAnswer((_) async => sampleProducts[0]);
        when(() => mockRepo.listReviews('p1', cursor: any(named: 'cursor'), limit: any(named: 'limit')))
            .thenAnswer((_) async => sampleReviews);
        return MarketplaceCubit(repository: mockRepo, errorCubit: ErrorCubit());
      },
      act: (cubit) => cubit.fetchProductDetail('p1'),
      expect: () => [
        isA<MarketplaceLoading>(),
        isA<MarketplaceProductDetail>()
            .having((s) => s.product.id, 'product id', 'p1')
            .having((s) => s.reviews.length, 'review count', 1),
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
          imageUrls: any(named: 'imageUrls'),
          tags: any(named: 'tags'),
        )).thenAnswer((_) async => sampleProducts[0]);
        return MarketplaceCubit(repository: mockRepo, errorCubit: ErrorCubit());
      },
      act: (cubit) => cubit.createListing(
        title: 'New Book',
        description: 'A great book about genealogy',
        category: 'books',
        priceCents: 1999,
      ),
      expect: () => [
        isA<MarketplaceLoading>(),
        isA<MarketplaceListingCreated>(),
      ],
    );

    blocTest<MarketplaceCubit, MarketplaceState>(
      'emits [Loading, OrdersLoaded] when loadOrders succeeds',
      build: () {
        when(() => mockRepo.listOrders(role: any(named: 'role'))).thenAnswer((_) async => [
          const MarketplaceOrderDTO(orderId: 'ord_1', status: 'paid', totalCents: 2999),
        ]);
        return MarketplaceCubit(repository: mockRepo, errorCubit: ErrorCubit());
      },
      act: (cubit) => cubit.loadOrders(),
      expect: () => [
        isA<MarketplaceLoading>(),
        isA<MarketplaceOrdersLoaded>().having((s) => s.orders.length, 'order count', 1),
      ],
    );

    blocTest<MarketplaceCubit, MarketplaceState>(
      'emits [Loading, WishlistLoaded] when loadWishlist succeeds',
      build: () {
        when(() => mockRepo.listWishlist()).thenAnswer((_) async => [sampleProducts[0]]);
        return MarketplaceCubit(repository: mockRepo, errorCubit: ErrorCubit());
      },
      act: (cubit) => cubit.loadWishlist(),
      expect: () => [
        isA<MarketplaceLoading>(),
        isA<MarketplaceWishlistLoaded>().having((s) => s.products.length, 'wishlist count', 1),
      ],
    );

    blocTest<MarketplaceCubit, MarketplaceState>(
      'emits [Loading, SellerDashboard] when loadSellerDashboard succeeds',
      build: () {
        when(() => mockRepo.getSellerDashboard()).thenAnswer((_) async => const SellerDashboardDTO(
          storeName: 'Heritage Press',
          activeListings: 5,
          totalSales: 100,
          totalEarningsCents: 250000,
          pendingOrders: 3,
          stripeOnboarded: true,
        ));
        return MarketplaceCubit(repository: mockRepo, errorCubit: ErrorCubit());
      },
      act: (cubit) => cubit.loadSellerDashboard(),
      expect: () => [
        isA<MarketplaceLoading>(),
        isA<MarketplaceSellerDashboard>()
            .having((s) => s.dashboard.storeName, 'store name', 'Heritage Press')
            .having((s) => s.dashboard.activeListings, 'listings', 5),
      ],
    );
  });
}
