import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
    this.nextCursor,
    this.hasMore = false,
    this.isLoadingMore = false,
  });

  final List<MarketplaceProductDTO> products;
  final List<MarketplaceCategoryDTO> categories;
  final String? selectedCategory;
  final String? nextCursor;
  final bool hasMore;
  final bool isLoadingMore;

  MarketplaceLoaded copyWith({
    List<MarketplaceProductDTO>? products,
    List<MarketplaceCategoryDTO>? categories,
    String? selectedCategory,
    String? nextCursor,
    bool? hasMore,
    bool? isLoadingMore,
  }) {
    return MarketplaceLoaded(
      products: products ?? this.products,
      categories: categories ?? this.categories,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      nextCursor: nextCursor ?? this.nextCursor,
      hasMore: hasMore ?? this.hasMore,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }

  @override
  List<Object?> get props =>
      [products, categories, selectedCategory, nextCursor, hasMore, isLoadingMore];
}

class MarketplaceProductDetail extends MarketplaceState {
  const MarketplaceProductDetail(this.product);

  final MarketplaceProductDTO product;

  @override
  List<Object?> get props => [product];
}

class MarketplaceListingCreated extends MarketplaceState {
  const MarketplaceListingCreated(this.product);

  final MarketplaceProductDTO product;

  @override
  List<Object?> get props => [product];
}

class MarketplaceOrderCreated extends MarketplaceState {
  const MarketplaceOrderCreated(this.order);

  final MarketplaceOrderDTO order;

  @override
  List<Object?> get props => [order];
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
      : _repository = repository,
        super(MarketplaceInitial());

  final MarketplaceRepository _repository;

  /// Load categories and the initial product page.
  Future<void> load({String? category}) async {
    emit(MarketplaceLoading());
    try {
      final results = await Future.wait([
        _repository.fetchCategories(),
        _repository.fetchProducts(category: category),
      ]);

      final categories = results[0] as List<MarketplaceCategoryDTO>;
      final page = results[1] as MarketplaceProductsPage;

      emit(MarketplaceLoaded(
        products: page.items,
        categories: categories,
        selectedCategory: category,
        nextCursor: page.nextCursor,
        hasMore: page.hasMore,
      ));
    } catch (e) {
      emit(MarketplaceError('Failed to load marketplace: $e'));
    }
  }

  /// Filter by category. Pass null for "All".
  Future<void> filterByCategory(String? category) async {
    final current = state;
    if (current is! MarketplaceLoaded) return;

    emit(MarketplaceLoading());
    try {
      final page = await _repository.fetchProducts(category: category);
      emit(current.copyWith(
        products: page.items,
        selectedCategory: category,
        nextCursor: page.nextCursor,
        hasMore: page.hasMore,
      ));
    } catch (e) {
      emit(MarketplaceError('Failed to filter products: $e'));
    }
  }

  /// Infinite scroll: load more products.
  Future<void> loadMore() async {
    final current = state;
    if (current is! MarketplaceLoaded || !current.hasMore || current.isLoadingMore) return;

    emit(current.copyWith(isLoadingMore: true));
    try {
      final page = await _repository.fetchProducts(
        category: current.selectedCategory,
        cursor: current.nextCursor,
      );
      emit(current.copyWith(
        products: [...current.products, ...page.items],
        nextCursor: page.nextCursor,
        hasMore: page.hasMore,
        isLoadingMore: false,
      ));
    } catch (e) {
      emit(current.copyWith(isLoadingMore: false));
    }
  }

  /// Fetch a single product's details.
  Future<void> fetchProductDetail(String productId) async {
    emit(MarketplaceLoading());
    try {
      final product = await _repository.fetchProduct(productId);
      emit(MarketplaceProductDetail(product));
    } catch (e) {
      emit(MarketplaceError('Failed to load product: $e'));
    }
  }

  /// Create a seller listing.
  Future<void> createListing({
    required String title,
    required String description,
    required String category,
    required int priceCents,
    String currency = 'USD',
    String? imageUrl,
  }) async {
    emit(MarketplaceLoading());
    try {
      final product = await _repository.createListing(
        title: title,
        description: description,
        category: category,
        priceCents: priceCents,
        currency: currency,
        imageUrl: imageUrl,
      );
      emit(MarketplaceListingCreated(product));
    } catch (e) {
      emit(MarketplaceError('Failed to create listing: $e'));
    }
  }

  /// Place an order (redirects to Stripe checkout).
  Future<void> placeOrder(String productId) async {
    emit(MarketplaceLoading());
    try {
      final order = await _repository.createOrder(productId);
      emit(MarketplaceOrderCreated(order));
    } catch (e) {
      emit(MarketplaceError('Failed to place order: $e'));
    }
  }
}
