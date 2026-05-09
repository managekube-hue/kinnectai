import '../models/dtos/marketplace_product_dto.dart';

/// Contract for marketplace data access.
/// Backend endpoints: GET /marketplace/products, GET /marketplace/products/:id,
/// POST /marketplace/products, GET /marketplace/categories,
/// POST /marketplace/orders, GET /marketplace/orders,
/// GET /marketplace/seller/dashboard.
abstract class MarketplaceRepository {
  /// Fetch paginated product list, optionally filtered by [category].
  Future<MarketplaceProductsPage> fetchProducts({
    String? category,
    String? cursor,
    int limit = 20,
  });

  /// Fetch a single product by [id].
  Future<MarketplaceProductDTO> fetchProduct(String id);

  /// List marketplace categories.
  Future<List<MarketplaceCategoryDTO>> fetchCategories();

  /// Create a new seller listing.
  Future<MarketplaceProductDTO> createListing({
    required String title,
    required String description,
    required String category,
    required int priceCents,
    String currency = 'USD',
    String? imageUrl,
  });

  /// Place an order for a product, returns a checkout URL.
  Future<MarketplaceOrderDTO> createOrder(String productId);

  /// Fetch current user's orders.
  Future<List<MarketplaceOrderDTO>> fetchOrders();

  /// Fetch seller dashboard stats.
  Future<SellerDashboardDTO> fetchSellerDashboard();
}

/// Lightweight page wrapper for marketplace products.
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
