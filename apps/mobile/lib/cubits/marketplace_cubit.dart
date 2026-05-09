import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

import '../models/dtos/marketplace_product_dto.dart';
import '../repositories/marketplace_repository.dart';

// ---------------------------------------------------------------------------
// States
// ---------------------------------------------------------------------------

sealed class MarketplaceState extends Equatable {
  const MarketplaceState();

  @override
  List<Object?> get props => [];
}

class MarketplaceInitial extends MarketplaceState {}

class MarketplaceLoading extends MarketplaceState {}

class MarketplaceLoaded extends MarketplaceState {
  const MarketplaceLoaded({
    required this.products,
    required this.categories,
    this.selectedCategory,
    this.searchQuery,
    this.sortBy = 'featured',
    this.nextCursor,
    this.hasMore = false,
    this.isLoadingMore = false,
  });

  final List<MarketplaceProductDTO> products;
  final List<MarketplaceCategoryDTO> categories;
  final String? selectedCategory;
  final String? searchQuery;
  final String sortBy;
  final String? nextCursor;
  final bool hasMore;
  final bool isLoadingMore;

  MarketplaceLoaded copyWith({
    List<MarketplaceProductDTO>? products,
    List<MarketplaceCategoryDTO>? categories,
    String? selectedCategory,
    String? searchQuery,
    String? sortBy,
    String? nextCursor,
    bool? hasMore,
    bool? isLoadingMore,
  }) {
    return MarketplaceLoaded(
      products: products ?? this.products,
      categories: categories ?? this.categories,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      searchQuery: searchQuery ?? this.searchQuery,
      sortBy: sortBy ?? this.sortBy,
      nextCursor: nextCursor ?? this.nextCursor,
      hasMore: hasMore ?? this.hasMore,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }

  @override
  List<Object?> get props =>
      [products, categories, selectedCategory, searchQuery, sortBy, nextCursor, hasMore, isLoadingMore];
}

class MarketplaceProductDetail extends MarketplaceState {
  const MarketplaceProductDetail({
    required this.product,
    this.reviews = const [],
    this.isWishlisted = false,
  });

  final MarketplaceProductDTO product;
  final List<ReviewDTO> reviews;
  final bool isWishlisted;

  @override
  List<Object?> get props => [product, reviews, isWishlisted];
}

class MarketplaceCheckoutReady extends MarketplaceState {
  const MarketplaceCheckoutReady(this.session, this.order);

  final CheckoutSessionDTO session;
  final MarketplaceOrderDTO order;

  @override
  List<Object?> get props => [session, order];
}

class MarketplaceOrdersLoaded extends MarketplaceState {
  const MarketplaceOrdersLoaded(this.orders);

  final List<MarketplaceOrderDTO> orders;

  @override
  List<Object?> get props => [orders];
}

class MarketplaceOrderDetail extends MarketplaceState {
  const MarketplaceOrderDetail(this.order);

  final MarketplaceOrderDTO order;

  @override
  List<Object?> get props => [order];
}

class MarketplaceSellerDashboard extends MarketplaceState {
  const MarketplaceSellerDashboard(this.dashboard);

  final SellerDashboardDTO dashboard;

  @override
  List<Object?> get props => [dashboard];
}

class MarketplaceListingCreated extends MarketplaceState {
  const MarketplaceListingCreated(this.product);

  final MarketplaceProductDTO product;

  @override
  List<Object?> get props => [product];
}

class MarketplaceSellerOnboarding extends MarketplaceState {
  const MarketplaceSellerOnboarding(this.onboardUrl);

  final String onboardUrl;

  @override
  List<Object?> get props => [onboardUrl];
}

class MarketplaceWishlistLoaded extends MarketplaceState {
  const MarketplaceWishlistLoaded(this.products);

  final List<MarketplaceProductDTO> products;

  @override
  List<Object?> get props => [products];
}

class MarketplaceError extends MarketplaceState {
  const MarketplaceError(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}

// ---------------------------------------------------------------------------
// Cubit
// ---------------------------------------------------------------------------

class MarketplaceCubit extends Cubit<MarketplaceState> {
  MarketplaceCubit({required MarketplaceRepository repository})
      : _repo = repository,
        super(MarketplaceInitial());

  final MarketplaceRepository _repo;
  Timer? _searchDebounce;

  // -- Product browsing -------------------------------------------------------

  Future<void> load({String? category}) async {
    emit(MarketplaceLoading());
    try {
      final results = await Future.wait([
        _repo.fetchCategories(),
        _repo.searchProducts(category: category),
      ]);
      emit(MarketplaceLoaded(
        products: (results[1] as MarketplaceProductsPage).items,
        categories: results[0] as List<MarketplaceCategoryDTO>,
        selectedCategory: category,
        nextCursor: (results[1] as MarketplaceProductsPage).nextCursor,
        hasMore: (results[1] as MarketplaceProductsPage).hasMore,
      ));
    } catch (e) {
      emit(MarketplaceError('Failed to load marketplace: $e'));
    }
  }

  Future<void> filterByCategory(String? category) async {
    final current = state;
    if (current is! MarketplaceLoaded) return;

    emit(MarketplaceLoading());
    try {
      final page = await _repo.searchProducts(
        category: category,
        query: current.searchQuery,
        sortBy: current.sortBy,
      );
      emit(current.copyWith(
        products: page.items,
        selectedCategory: category,
        nextCursor: page.nextCursor,
        hasMore: page.hasMore,
      ));
    } catch (e) {
      emit(MarketplaceError('Failed to filter: $e'));
    }
  }

  /// Debounced search -- waits 400ms after last keystroke.
  void search(String query) {
    _searchDebounce?.cancel();
    _searchDebounce = Timer(const Duration(milliseconds: 400), () {
      _executeSearch(query);
    });
  }

  Future<void> _executeSearch(String query) async {
    final current = state;
    if (current is! MarketplaceLoaded) return;

    emit(MarketplaceLoading());
    try {
      final page = await _repo.searchProducts(
        query: query.isEmpty ? null : query,
        category: current.selectedCategory,
        sortBy: current.sortBy,
      );
      emit(current.copyWith(
        products: page.items,
        searchQuery: query,
        nextCursor: page.nextCursor,
        hasMore: page.hasMore,
      ));
    } catch (e) {
      emit(MarketplaceError('Search failed: $e'));
    }
  }

  Future<void> changeSortBy(String sortBy) async {
    final current = state;
    if (current is! MarketplaceLoaded) return;

    emit(MarketplaceLoading());
    try {
      final page = await _repo.searchProducts(
        query: current.searchQuery,
        category: current.selectedCategory,
        sortBy: sortBy,
      );
      emit(current.copyWith(
        products: page.items,
        sortBy: sortBy,
        nextCursor: page.nextCursor,
        hasMore: page.hasMore,
      ));
    } catch (e) {
      emit(MarketplaceError('Sort failed: $e'));
    }
  }

  Future<void> loadMore() async {
    final current = state;
    if (current is! MarketplaceLoaded || !current.hasMore || current.isLoadingMore) return;

    emit(current.copyWith(isLoadingMore: true));
    try {
      final page = await _repo.searchProducts(
        query: current.searchQuery,
        category: current.selectedCategory,
        sortBy: current.sortBy,
        cursor: current.nextCursor,
      );
      emit(current.copyWith(
        products: [...current.products, ...page.items],
        nextCursor: page.nextCursor,
        hasMore: page.hasMore,
        isLoadingMore: false,
      ));
    } catch (_) {
      emit(current.copyWith(isLoadingMore: false));
    }
  }

  // -- Product detail ---------------------------------------------------------

  Future<void> fetchProductDetail(String productId) async {
    emit(MarketplaceLoading());
    try {
      final results = await Future.wait([
        _repo.getProduct(productId),
        _repo.listReviews(productId),
      ]);
      emit(MarketplaceProductDetail(
        product: results[0] as MarketplaceProductDTO,
        reviews: results[1] as List<ReviewDTO>,
      ));
    } catch (e) {
      emit(MarketplaceError('Failed to load product: $e'));
    }
  }

  // -- Checkout (Stripe Connect via flutter_stripe) ---------------------------

  Future<void> initiateCheckout(List<CheckoutItem> items) async {
    emit(MarketplaceLoading());
    try {
      final result = await _repo.createCheckout(items);

      // Initialize Stripe payment sheet with the server-side session
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: result.session.clientSecret,
          customerEphemeralKeySecret: result.session.ephemeralKey,
          customerId: result.session.customerId,
          merchantDisplayName: 'KinnectAI Marketplace',
          style: ThemeMode.dark,
        ),
      );

      emit(MarketplaceCheckoutReady(result.session, result.order));
    } catch (e) {
      emit(MarketplaceError('Checkout failed: $e'));
    }
  }

  /// Call after MarketplaceCheckoutReady -- presents the Stripe payment sheet.
  Future<void> presentPaymentSheet() async {
    try {
      await Stripe.instance.presentPaymentSheet();
      // Payment succeeded -- webhook will update order status server-side
    } on StripeException catch (e) {
      emit(MarketplaceError('Payment cancelled: ${e.error.localizedMessage}'));
    }
  }

  // -- Reviews ----------------------------------------------------------------

  Future<void> submitReview(String productId, {required int rating, String? title, String? body}) async {
    try {
      await _repo.createReview(productId, rating: rating, title: title, body: body);
      // Refresh product detail
      fetchProductDetail(productId);
    } catch (e) {
      emit(MarketplaceError('Review failed: $e'));
    }
  }

  // -- Wishlist ---------------------------------------------------------------

  Future<void> toggleWishlist(String productId) async {
    try {
      await _repo.toggleWishlist(productId);
    } catch (_) {
      // Silently fail -- optimistic UI
    }
  }

  Future<void> loadWishlist() async {
    emit(MarketplaceLoading());
    try {
      final products = await _repo.listWishlist();
      emit(MarketplaceWishlistLoaded(products));
    } catch (e) {
      emit(MarketplaceError('Failed to load wishlist: $e'));
    }
  }

  // -- Orders -----------------------------------------------------------------

  Future<void> loadOrders({String role = 'buyer'}) async {
    emit(MarketplaceLoading());
    try {
      final orders = await _repo.listOrders(role: role);
      emit(MarketplaceOrdersLoaded(orders));
    } catch (e) {
      emit(MarketplaceError('Failed to load orders: $e'));
    }
  }

  Future<void> loadOrderDetail(String orderId) async {
    emit(MarketplaceLoading());
    try {
      final order = await _repo.getOrder(orderId);
      emit(MarketplaceOrderDetail(order));
    } catch (e) {
      emit(MarketplaceError('Failed to load order: $e'));
    }
  }

  // -- Seller -----------------------------------------------------------------

  Future<void> loadSellerDashboard() async {
    emit(MarketplaceLoading());
    try {
      final dashboard = await _repo.getSellerDashboard();
      emit(MarketplaceSellerDashboard(dashboard));
    } catch (e) {
      emit(MarketplaceError('Failed to load dashboard: $e'));
    }
  }

  Future<void> createListing({
    required String title,
    required String description,
    required String category,
    required int priceCents,
    List<String> imageUrls = const [],
    List<String> tags = const [],
  }) async {
    emit(MarketplaceLoading());
    try {
      final product = await _repo.createListing(
        title: title,
        description: description,
        category: category,
        priceCents: priceCents,
        imageUrls: imageUrls,
        tags: tags,
      );
      emit(MarketplaceListingCreated(product));
    } catch (e) {
      emit(MarketplaceError('Failed to create listing: $e'));
    }
  }

  Future<void> onboardAsSeller({required String storeName, required String storeSlug}) async {
    emit(MarketplaceLoading());
    try {
      final result = await _repo.onboardSeller(storeName: storeName, storeSlug: storeSlug);
      emit(MarketplaceSellerOnboarding(result.onboardUrl));
    } catch (e) {
      emit(MarketplaceError('Seller onboarding failed: $e'));
    }
  }

  @override
  Future<void> close() {
    _searchDebounce?.cancel();
    return super.close();
  }
}
