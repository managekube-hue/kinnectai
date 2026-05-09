import '../models/dtos/marketplace_product_dto.dart';

/// Contract for marketplace data access.
/// Maps 1:1 to Go backend /api/v1/marketplace/* endpoints.
abstract class MarketplaceRepository {
  // -- Products --
  Future<MarketplaceProductsPage> searchProducts({
    String? query,
    String? category,
    int? minPrice,
    int? maxPrice,
    double? minRating,
    String sortBy = 'featured',
    String? cursor,
    int limit = 20,
  });

  Future<MarketplaceProductDTO> getProduct(String id);

  Future<MarketplaceProductDTO> createListing({
    required String title,
    required String description,
    required String category,
    required int priceCents,
    String currency = 'USD',
    List<String> imageUrls = const [],
    List<String> tags = const [],
  });

  // -- Categories --
  Future<List<MarketplaceCategoryDTO>> fetchCategories();

  // -- Checkout (Stripe Connect) --
  Future<CheckoutResult> createCheckout(List<CheckoutItem> items);

  // -- Orders --
  Future<List<MarketplaceOrderDTO>> listOrders({String role = 'buyer'});
  Future<MarketplaceOrderDTO> getOrder(String orderId);

  // -- Reviews --
  Future<List<ReviewDTO>> listReviews(String productId, {String? cursor, int limit = 20});
  Future<ReviewDTO> createReview(String productId, {required int rating, String? title, String? body});

  // -- Wishlist --
  Future<bool> toggleWishlist(String productId);
  Future<List<MarketplaceProductDTO>> listWishlist();

  // -- Seller --
  Future<SellerDashboardDTO> getSellerDashboard();
  Future<SellerOnboardResult> onboardSeller({required String storeName, required String storeSlug});
}

class MarketplaceProductsPage {
  const MarketplaceProductsPage({
    required this.items,
    this.nextCursor,
    this.hasMore = false,
  });

  final List<MarketplaceProductDTO> items;
  final String? nextCursor;
  final bool hasMore;
}

class CheckoutItem {
  const CheckoutItem({required this.productId, this.quantity = 1});

  final String productId;
  final int quantity;

  Map<String, dynamic> toJson() => {'product_id': productId, 'quantity': quantity};
}

class CheckoutResult {
  const CheckoutResult({required this.session, required this.order});

  final CheckoutSessionDTO session;
  final MarketplaceOrderDTO order;
}

class SellerOnboardResult {
  const SellerOnboardResult({required this.dashboard, required this.onboardUrl});

  final SellerDashboardDTO dashboard;
  final String onboardUrl;
}
