import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

import '../models/dtos/marketplace_product_dto.dart';
import '../repositories/marketplace_repository.dart';
import '../services/error_boundary_service.dart';
import '../utils/audit_logger.dart';
import '../utils/error_handler.dart';
import 'error_cubit.dart';

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

class MarketplaceCheckoutCompleted extends MarketplaceState {
  const MarketplaceCheckoutCompleted(this.order);

  final MarketplaceOrderDTO order;

  @override
  List<Object?> get props => [order];
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
  const MarketplaceError(this.message, {this.errorType});

  final String message;
  final ErrorType? errorType;

  @override
  List<Object?> get props => [message, errorType];
}

// ---------------------------------------------------------------------------
// Cubit -- wired into ErrorCubit + ErrorBoundaryService + AuditLogger
// ---------------------------------------------------------------------------

class MarketplaceCubit extends Cubit<MarketplaceState> {
  MarketplaceCubit({
    required MarketplaceRepository repository,
    required this.errorCubit,
  })  : _repo = repository,
        super(MarketplaceInitial());

  final MarketplaceRepository _repo;
  final ErrorCubit errorCubit;
  Timer? _searchDebounce;
  CheckoutResult? _pendingCheckout;

  /// Wraps all marketplace operations with ErrorBoundaryService classification,
  /// NetworkErrorHandler retry, and ErrorCubit reporting.
  Future<T?> _execute<T>(
    String operation,
    Future<T> Function() action, {
    bool retry = true,
  }) async {
    try {
      if (retry) {
        return await NetworkErrorHandler.executeWithRetry(
          request: action,
          shouldRetry: NetworkErrorHandler.isRetryable,
        );
      }
      return await action();
    } catch (e, stack) {
      final classified = ErrorBoundaryService.classify(e);
      final userMsg = NetworkErrorHandler.getUserMessage(e);

      // Report to global error cubit for snackbar/banner display
      errorCubit.report(
        message: userMsg,
        code: classified.statusCode?.toString() ?? classified.type.name,
        source: 'MarketplaceCubit.$operation',
        error: e,
        stackTrace: stack,
      );

      emit(MarketplaceError(userMsg, errorType: classified.type));
      return null;
    }
  }

  // -- Product browsing -------------------------------------------------------

  Future<void> load({String? category}) async {
    emit(MarketplaceLoading());
    final results = await _execute('load', () => Future.wait([
      _repo.fetchCategories(),
      _repo.searchProducts(category: category),
    ]));
    if (results == null) return;

    emit(MarketplaceLoaded(
      products: (results[1] as MarketplaceProductsPage).items,
      categories: results[0] as List<MarketplaceCategoryDTO>,
      selectedCategory: category,
      nextCursor: (results[1] as MarketplaceProductsPage).nextCursor,
      hasMore: (results[1] as MarketplaceProductsPage).hasMore,
    ));
  }

  Future<void> filterByCategory(String? category) async {
    final current = state;
    if (current is! MarketplaceLoaded) return;

    emit(MarketplaceLoading());
    final page = await _execute('filterByCategory', () => _repo.searchProducts(
      category: category,
      query: current.searchQuery,
      sortBy: current.sortBy,
    ));
    if (page == null) return;

    emit(current.copyWith(
      products: page.items,
      selectedCategory: category,
      nextCursor: page.nextCursor,
      hasMore: page.hasMore,
    ));
  }

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
    final page = await _execute('search', () => _repo.searchProducts(
      query: query.isEmpty ? null : query,
      category: current.selectedCategory,
      sortBy: current.sortBy,
    ));
    if (page == null) return;

    emit(current.copyWith(
      products: page.items,
      searchQuery: query,
      nextCursor: page.nextCursor,
      hasMore: page.hasMore,
    ));
  }

  Future<void> changeSortBy(String sortBy) async {
    final current = state;
    if (current is! MarketplaceLoaded) return;

    emit(MarketplaceLoading());
    final page = await _execute('changeSortBy', () => _repo.searchProducts(
      query: current.searchQuery,
      category: current.selectedCategory,
      sortBy: sortBy,
    ));
    if (page == null) return;

    emit(current.copyWith(
      products: page.items,
      sortBy: sortBy,
      nextCursor: page.nextCursor,
      hasMore: page.hasMore,
    ));
  }

  Future<void> loadMore() async {
    final current = state;
    if (current is! MarketplaceLoaded || !current.hasMore || current.isLoadingMore) return;

    emit(current.copyWith(isLoadingMore: true));
    final page = await _execute('loadMore', () => _repo.searchProducts(
      query: current.searchQuery,
      category: current.selectedCategory,
      sortBy: current.sortBy,
      cursor: current.nextCursor,
    ), retry: false);

    if (page == null) {
      emit(current.copyWith(isLoadingMore: false));
      return;
    }

    emit(current.copyWith(
      products: [...current.products, ...page.items],
      nextCursor: page.nextCursor,
      hasMore: page.hasMore,
      isLoadingMore: false,
    ));
  }

  // -- Product detail ---------------------------------------------------------

  Future<void> fetchProductDetail(String productId) async {
    emit(MarketplaceLoading());
    final results = await _execute('fetchProductDetail', () => Future.wait([
      _repo.getProduct(productId),
      _repo.listReviews(productId),
    ]));
    if (results == null) return;

    emit(MarketplaceProductDetail(
      product: results[0] as MarketplaceProductDTO,
      reviews: results[1] as List<ReviewDTO>,
    ));
  }

  // -- Checkout (Stripe Connect via flutter_stripe) ---------------------------

  Future<void> initiateCheckout(List<CheckoutItem> items) async {
    emit(MarketplaceLoading());

    // Audit: checkout initiated
    AuditLogger.logDataOperation(
      userId: 'current_user',
      operation: 'marketplace_checkout_initiated',
      dataType: 'order',
      metadata: {'item_count': items.length},
    );

    final result = await _execute('initiateCheckout', () => _repo.createCheckout(items));
    if (result == null) return;

    try {
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: result.session.clientSecret,
          customerEphemeralKeySecret: result.session.ephemeralKey,
          customerId: result.session.customerId,
          merchantDisplayName: 'KinnectAI Marketplace',
          style: ThemeMode.dark,
        ),
      );

      _pendingCheckout = result;
      emit(MarketplaceCheckoutReady(result.session, result.order));
    } catch (e, stack) {
      errorCubit.report(
        message: 'Payment setup failed',
        code: 'stripe_init',
        source: 'MarketplaceCubit.initiateCheckout',
        error: e,
        stackTrace: stack,
      );
      emit(MarketplaceError('Payment setup failed. Please try again.'));
    }
  }

  Future<void> presentPaymentSheet() async {
    try {
      await Stripe.instance.presentPaymentSheet();

      // Audit: payment completed
      AuditLogger.logDataOperation(
        userId: 'current_user',
        operation: 'marketplace_payment_completed',
        dataType: 'order',
      );

      final checkout = _pendingCheckout;
      if (checkout != null) {
        emit(MarketplaceCheckoutCompleted(checkout.order));
      }
    } on StripeException catch (e) {
      // Audit: payment cancelled/failed
      AuditLogger.logDataOperation(
        userId: 'current_user',
        operation: 'marketplace_payment_cancelled',
        dataType: 'order',
        metadata: {'reason': e.error.localizedMessage ?? 'unknown'},
      );

      errorCubit.report(
        message: 'Payment cancelled',
        code: e.error.code.name,
        source: 'MarketplaceCubit.presentPaymentSheet',
        error: e,
      );
      emit(MarketplaceError('Payment cancelled: ${e.error.localizedMessage}'));
    } finally {
      _pendingCheckout = null;
    }
  }

  // -- Reviews ----------------------------------------------------------------

  Future<void> submitReview(String productId, {required int rating, String? title, String? body}) async {
    final result = await _execute('submitReview', () =>
        _repo.createReview(productId, rating: rating, title: title, body: body),
        retry: false);
    if (result == null) return;

    AuditLogger.logDataOperation(
      userId: 'current_user',
      operation: 'marketplace_review_submitted',
      dataType: 'review',
      metadata: {'product_id': productId, 'rating': rating},
    );

    fetchProductDetail(productId);
  }

  // -- Wishlist ---------------------------------------------------------------

  Future<void> toggleWishlist(String productId) async {
    // Fire-and-forget with error reporting
    await _execute('toggleWishlist', () => _repo.toggleWishlist(productId), retry: false);
  }

  Future<void> loadWishlist() async {
    emit(MarketplaceLoading());
    final products = await _execute('loadWishlist', () => _repo.listWishlist());
    if (products == null) return;
    emit(MarketplaceWishlistLoaded(products));
  }

  // -- Orders -----------------------------------------------------------------

  Future<void> loadOrders({String role = 'buyer'}) async {
    emit(MarketplaceLoading());
    final orders = await _execute('loadOrders', () => _repo.listOrders(role: role));
    if (orders == null) return;
    emit(MarketplaceOrdersLoaded(orders));
  }

  Future<void> loadOrderDetail(String orderId) async {
    emit(MarketplaceLoading());
    final order = await _execute('loadOrderDetail', () => _repo.getOrder(orderId));
    if (order == null) return;
    emit(MarketplaceOrderDetail(order));
  }

  // -- Seller -----------------------------------------------------------------

  Future<void> loadSellerDashboard() async {
    emit(MarketplaceLoading());
    final dashboard = await _execute('loadSellerDashboard', () => _repo.getSellerDashboard());
    if (dashboard == null) return;
    emit(MarketplaceSellerDashboard(dashboard));
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
    final product = await _execute('createListing', () => _repo.createListing(
      title: title,
      description: description,
      category: category,
      priceCents: priceCents,
      imageUrls: imageUrls,
      tags: tags,
    ), retry: false);
    if (product == null) return;

    // Audit: listing created
    AuditLogger.logDataOperation(
      userId: 'current_user',
      operation: 'marketplace_listing_created',
      dataType: 'product',
      metadata: {'product_id': product.id, 'category': category, 'price_cents': priceCents},
    );

    emit(MarketplaceListingCreated(product));
  }

  Future<void> onboardAsSeller({required String storeName, required String storeSlug}) async {
    emit(MarketplaceLoading());
    final result = await _execute('onboardAsSeller', () =>
        _repo.onboardSeller(storeName: storeName, storeSlug: storeSlug), retry: false);
    if (result == null) return;

    AuditLogger.logSecurity(
      userId: 'current_user',
      action: 'marketplace_seller_onboard',
      metadata: {'store_name': storeName},
    );

    emit(MarketplaceSellerOnboarding(result.onboardUrl));
  }

  @override
  Future<void> close() {
    _searchDebounce?.cancel();
    return super.close();
  }
}
