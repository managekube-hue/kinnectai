package marketplace

import (
	"context"
	"fmt"
	"math"
	"strings"

	"github.com/google/uuid"
	"github.com/jackc/pgx/v5/pgxpool"
	"github.com/stripe/stripe-go/v78"
	"github.com/stripe/stripe-go/v78/account"
	"github.com/stripe/stripe-go/v78/accountlink"
	"github.com/stripe/stripe-go/v78/customer"
	"github.com/stripe/stripe-go/v78/ephemeralkey"
	"github.com/stripe/stripe-go/v78/paymentintent"
	"github.com/stripe/stripe-go/v78/transfer"
)

type Service struct {
	db              *pgxpool.Pool
	stripeKey       string
	platformFeeRate float64
}

func NewService(db *pgxpool.Pool, stripeKey string) *Service {
	stripe.Key = stripeKey
	return &Service{
		db:              db,
		stripeKey:       stripeKey,
		platformFeeRate: 0.12, // 12% default
	}
}

// ---------------------------------------------------------------------------
// Products
// ---------------------------------------------------------------------------

func (s *Service) SearchProducts(ctx context.Context, req SearchRequest) ([]Product, string, bool, error) {
	if req.Limit <= 0 || req.Limit > 50 {
		req.Limit = 20
	}

	var conditions []string
	var args []interface{}
	argIdx := 1

	conditions = append(conditions, "p.status = 'active'")

	if req.Query != "" {
		conditions = append(conditions, fmt.Sprintf(
			"to_tsvector('english', p.title || ' ' || COALESCE(p.description, '')) @@ plainto_tsquery('english', $%d)", argIdx))
		args = append(args, req.Query)
		argIdx++
	}
	if req.Category != "" {
		conditions = append(conditions, fmt.Sprintf("p.category_id = $%d", argIdx))
		args = append(args, req.Category)
		argIdx++
	}
	if req.MinPrice != nil {
		conditions = append(conditions, fmt.Sprintf("p.price_cents >= $%d", argIdx))
		args = append(args, *req.MinPrice)
		argIdx++
	}
	if req.MaxPrice != nil {
		conditions = append(conditions, fmt.Sprintf("p.price_cents <= $%d", argIdx))
		args = append(args, *req.MaxPrice)
		argIdx++
	}
	if req.MinRating != nil {
		conditions = append(conditions, fmt.Sprintf("p.rating_avg >= $%d", argIdx))
		args = append(args, *req.MinRating)
		argIdx++
	}

	orderClause := "p.featured DESC, p.created_at DESC"
	switch req.SortBy {
	case "price_asc":
		orderClause = "p.price_cents ASC"
	case "price_desc":
		orderClause = "p.price_cents DESC"
	case "rating":
		orderClause = "p.rating_avg DESC, p.rating_count DESC"
	case "newest":
		orderClause = "p.created_at DESC"
	case "bestselling":
		orderClause = "p.sales_count DESC"
	}

	if req.Cursor != "" {
		conditions = append(conditions, fmt.Sprintf("p.product_id > $%d", argIdx))
		args = append(args, req.Cursor)
		argIdx++
	}

	where := strings.Join(conditions, " AND ")
	query := fmt.Sprintf(`
		SELECT p.product_id, p.seller_id, p.title, p.description, p.category_id,
			p.price_cents, p.compare_at_cents, p.currency, p.status, p.rating_avg,
			p.rating_count, p.sales_count, p.view_count, p.featured,
			p.created_at, p.updated_at,
			sp.store_name, sp.commission_rate,
			COALESCE((SELECT url FROM product_images pi WHERE pi.product_id = p.product_id AND pi.is_primary ORDER BY pi.sort_order LIMIT 1), '') as image_url
		FROM marketplace_products p
		JOIN seller_profiles sp ON sp.seller_id = p.seller_id
		WHERE %s
		ORDER BY %s
		LIMIT $%d
	`, where, orderClause, argIdx)
	args = append(args, req.Limit+1)

	rows, err := s.db.Query(ctx, query, args...)
	if err != nil {
		return nil, "", false, fmt.Errorf("search products: %w", err)
	}
	defer rows.Close()

	var products []Product
	for rows.Next() {
		var p Product
		var compareAt *int
		var imageURL string
		err := rows.Scan(
			&p.ProductID, &p.SellerID, &p.Title, &p.Description, &p.CategoryID,
			&p.PriceCents, &compareAt, &p.Currency, &p.Status, &p.RatingAvg,
			&p.RatingCount, &p.SalesCount, &p.ViewCount, &p.Featured,
			&p.CreatedAt, &p.UpdatedAt,
			&p.SellerName, &p.CommissionRate, &imageURL,
		)
		if err != nil {
			return nil, "", false, fmt.Errorf("scan product: %w", err)
		}
		p.CompareAtCents = compareAt
		if imageURL != "" {
			p.Images = []Image{{URL: imageURL, IsPrimary: true}}
		}
		products = append(products, p)
	}

	hasMore := len(products) > req.Limit
	if hasMore {
		products = products[:req.Limit]
	}
	var nextCursor string
	if hasMore && len(products) > 0 {
		nextCursor = products[len(products)-1].ProductID
	}

	return products, nextCursor, hasMore, nil
}

func (s *Service) GetProduct(ctx context.Context, productID string) (*Product, error) {
	var p Product
	var compareAt *int
	err := s.db.QueryRow(ctx, `
		SELECT p.product_id, p.seller_id, p.title, p.description, p.category_id,
			p.price_cents, p.compare_at_cents, p.currency, p.status, p.rating_avg,
			p.rating_count, p.sales_count, p.view_count, p.featured,
			p.created_at, p.updated_at,
			sp.store_name, sp.commission_rate
		FROM marketplace_products p
		JOIN seller_profiles sp ON sp.seller_id = p.seller_id
		WHERE p.product_id = $1
	`, productID).Scan(
		&p.ProductID, &p.SellerID, &p.Title, &p.Description, &p.CategoryID,
		&p.PriceCents, &compareAt, &p.Currency, &p.Status, &p.RatingAvg,
		&p.RatingCount, &p.SalesCount, &p.ViewCount, &p.Featured,
		&p.CreatedAt, &p.UpdatedAt,
		&p.SellerName, &p.CommissionRate,
	)
	if err != nil {
		return nil, fmt.Errorf("get product: %w", err)
	}
	p.CompareAtCents = compareAt

	// Fetch images
	imgRows, err := s.db.Query(ctx, `
		SELECT image_id, url, COALESCE(alt_text,''), sort_order, is_primary
		FROM product_images WHERE product_id = $1 ORDER BY sort_order
	`, productID)
	if err == nil {
		defer imgRows.Close()
		for imgRows.Next() {
			var img Image
			imgRows.Scan(&img.ImageID, &img.URL, &img.AltText, &img.SortOrder, &img.IsPrimary)
			p.Images = append(p.Images, img)
		}
	}

	// Increment view count asynchronously
	go func() {
		s.db.Exec(context.Background(), `UPDATE marketplace_products SET view_count = view_count + 1 WHERE product_id = $1`, productID)
	}()

	return &p, nil
}

func (s *Service) CreateListing(ctx context.Context, sellerID string, req CreateListingRequest) (*Product, error) {
	productID := uuid.New().String()
	currency := req.Currency
	if currency == "" {
		currency = "USD"
	}

	_, err := s.db.Exec(ctx, `
		INSERT INTO marketplace_products (product_id, seller_id, title, description, category_id, price_cents, currency, sku, tags, status)
		VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, 'pending_review')
	`, productID, sellerID, req.Title, req.Description, req.CategoryID, req.PriceCents, currency, req.SKU, req.Tags)
	if err != nil {
		return nil, fmt.Errorf("create listing: %w", err)
	}

	// Insert images
	for i, url := range req.ImageURLs {
		s.db.Exec(ctx, `
			INSERT INTO product_images (product_id, url, sort_order, is_primary)
			VALUES ($1, $2, $3, $4)
		`, productID, url, i, i == 0)
	}

	return &Product{
		ProductID:  productID,
		SellerID:   sellerID,
		Title:      req.Title,
		CategoryID: req.CategoryID,
		PriceCents: req.PriceCents,
		Currency:   currency,
		Status:     "pending_review",
	}, nil
}

// ---------------------------------------------------------------------------
// Categories
// ---------------------------------------------------------------------------

func (s *Service) ListCategories(ctx context.Context) ([]Category, error) {
	rows, err := s.db.Query(ctx, `
		SELECT c.category_id, c.name, c.icon, c.sort_order,
			COALESCE(c.parent_id, ''),
			COUNT(p.product_id) as product_count
		FROM marketplace_categories c
		LEFT JOIN marketplace_products p ON p.category_id = c.category_id AND p.status = 'active'
		WHERE c.is_active = true
		GROUP BY c.category_id, c.name, c.icon, c.sort_order, c.parent_id
		ORDER BY c.sort_order
	`)
	if err != nil {
		return nil, fmt.Errorf("list categories: %w", err)
	}
	defer rows.Close()

	var categories []Category
	for rows.Next() {
		var c Category
		rows.Scan(&c.CategoryID, &c.Name, &c.Icon, &c.SortOrder, &c.ParentID, &c.Count)
		categories = append(categories, c)
	}
	return categories, nil
}

// ---------------------------------------------------------------------------
// Checkout (Stripe Connect)
// ---------------------------------------------------------------------------

func (s *Service) CreateCheckoutSession(ctx context.Context, buyerID string, req CheckoutRequest) (*CheckoutSession, *Order, error) {
	// 1. Validate all items exist and are active, calculate totals
	var totalCents int
	var items []OrderItem
	var sellerID string

	for _, ci := range req.Items {
		var p Product
		var sid string
		err := s.db.QueryRow(ctx, `
			SELECT p.product_id, p.title, p.price_cents, p.currency, p.seller_id, p.inventory_count,
				COALESCE((SELECT url FROM product_images WHERE product_id = p.product_id AND is_primary LIMIT 1), '')
			FROM marketplace_products p WHERE p.product_id = $1 AND p.status = 'active'
		`, ci.ProductID).Scan(&p.ProductID, &p.Title, &p.PriceCents, &p.Currency, &sid, &p.InventoryCount, nil)
		if err != nil {
			return nil, nil, fmt.Errorf("product %s not found or unavailable", ci.ProductID)
		}

		// Check inventory
		if p.InventoryCount >= 0 && p.InventoryCount < ci.Quantity {
			return nil, nil, fmt.Errorf("insufficient inventory for %s", p.Title)
		}

		if sellerID == "" {
			sellerID = sid
		}

		items = append(items, OrderItem{
			ProductID:  p.ProductID,
			Title:      p.Title,
			PriceCents: p.PriceCents,
			Quantity:   ci.Quantity,
		})
		totalCents += p.PriceCents * ci.Quantity
	}

	// 2. Calculate commission
	var commissionRate float64
	s.db.QueryRow(ctx, `SELECT commission_rate FROM seller_profiles WHERE seller_id = $1`, sellerID).Scan(&commissionRate)
	if commissionRate <= 0 {
		commissionRate = s.platformFeeRate * 100
	}
	commissionCents := int(math.Round(float64(totalCents) * commissionRate / 100))
	sellerPayoutCents := totalCents - commissionCents

	// 3. Get or create Stripe customer for buyer
	var stripeCustomerID string
	err := s.db.QueryRow(ctx, `SELECT stripe_customer_id FROM users WHERE user_id = $1`, buyerID).Scan(&stripeCustomerID)
	if err != nil || stripeCustomerID == "" {
		// Create Stripe customer
		params := &stripe.CustomerParams{}
		params.AddMetadata("kinnect_user_id", buyerID)
		c, err := customer.New(params)
		if err != nil {
			return nil, nil, fmt.Errorf("stripe customer create: %w", err)
		}
		stripeCustomerID = c.ID
		s.db.Exec(ctx, `UPDATE users SET stripe_customer_id = $1 WHERE user_id = $2`, stripeCustomerID, buyerID)
	}

	// 4. Get seller's Stripe Connect account
	var stripeAccountID string
	s.db.QueryRow(ctx, `SELECT stripe_account_id FROM seller_profiles WHERE seller_id = $1 AND stripe_onboarded = true`, sellerID).Scan(&stripeAccountID)

	// 5. Create PaymentIntent with application_fee_amount (Stripe Connect)
	piParams := &stripe.PaymentIntentParams{
		Amount:   stripe.Int64(int64(totalCents)),
		Currency: stripe.String("usd"),
		Customer: stripe.String(stripeCustomerID),
		AutomaticPaymentMethods: &stripe.PaymentIntentAutomaticPaymentMethodsParams{
			Enabled: stripe.Bool(true),
		},
	}

	if stripeAccountID != "" {
		// Direct charge with Stripe Connect -- platform takes commission as application fee
		piParams.ApplicationFeeAmount = stripe.Int64(int64(commissionCents))
		piParams.TransferData = &stripe.PaymentIntentTransferDataParams{
			Destination: stripe.String(stripeAccountID),
		}
	}

	piParams.AddMetadata("kinnect_buyer_id", buyerID)
	piParams.AddMetadata("kinnect_seller_id", sellerID)

	pi, err := paymentintent.New(piParams)
	if err != nil {
		return nil, nil, fmt.Errorf("stripe payment intent: %w", err)
	}

	// 6. Create ephemeral key for mobile SDK
	ekParams := &stripe.EphemeralKeyParams{
		Customer:      stripe.String(stripeCustomerID),
		StripeVersion: stripe.String("2024-06-20"),
	}
	ek, err := ephemeralkey.New(ekParams)
	if err != nil {
		return nil, nil, fmt.Errorf("stripe ephemeral key: %w", err)
	}

	// 7. Create order in DB
	orderID := uuid.New().String()
	_, err = s.db.Exec(ctx, `
		INSERT INTO marketplace_orders (order_id, buyer_id, seller_id, status, subtotal_cents,
			commission_cents, seller_payout_cents, total_cents, currency, stripe_payment_intent_id)
		VALUES ($1, $2, $3, 'payment_processing', $4, $5, $6, $7, 'USD', $8)
	`, orderID, buyerID, sellerID, totalCents, commissionCents, sellerPayoutCents, totalCents, pi.ID)
	if err != nil {
		return nil, nil, fmt.Errorf("create order: %w", err)
	}

	// Insert order items
	for _, item := range items {
		s.db.Exec(ctx, `
			INSERT INTO order_items (order_id, product_id, title, price_cents, quantity)
			VALUES ($1, $2, $3, $4, $5)
		`, orderID, item.ProductID, item.Title, item.PriceCents, item.Quantity)
	}

	order := &Order{
		OrderID:             orderID,
		BuyerID:             buyerID,
		SellerID:            sellerID,
		Status:              "payment_processing",
		SubtotalCents:       totalCents,
		CommissionCents:     commissionCents,
		SellerPayoutCents:   sellerPayoutCents,
		TotalCents:          totalCents,
		Currency:            "USD",
		StripePaymentIntent: pi.ID,
		Items:               items,
	}

	session := &CheckoutSession{
		SessionID:           orderID,
		ClientSecret:        pi.ClientSecret,
		StripePaymentIntent: pi.ID,
		EphemeralKey:        ek.Secret,
		CustomerID:          stripeCustomerID,
		TotalCents:          totalCents,
		Currency:            "USD",
	}

	return session, order, nil
}

// ---------------------------------------------------------------------------
// Orders
// ---------------------------------------------------------------------------

func (s *Service) ListOrders(ctx context.Context, userID string, role string) ([]Order, error) {
	var query string
	if role == "seller" {
		query = `SELECT order_id, buyer_id, seller_id, status, subtotal_cents, commission_cents,
			seller_payout_cents, shipping_cents, tax_cents, total_cents, currency,
			COALESCE(tracking_number,''), COALESCE(tracking_url,''),
			created_at, paid_at, shipped_at, delivered_at
			FROM marketplace_orders WHERE seller_id = $1 ORDER BY created_at DESC LIMIT 50`
	} else {
		query = `SELECT order_id, buyer_id, seller_id, status, subtotal_cents, commission_cents,
			seller_payout_cents, shipping_cents, tax_cents, total_cents, currency,
			COALESCE(tracking_number,''), COALESCE(tracking_url,''),
			created_at, paid_at, shipped_at, delivered_at
			FROM marketplace_orders WHERE buyer_id = $1 ORDER BY created_at DESC LIMIT 50`
	}

	rows, err := s.db.Query(ctx, query, userID)
	if err != nil {
		return nil, fmt.Errorf("list orders: %w", err)
	}
	defer rows.Close()

	var orders []Order
	for rows.Next() {
		var o Order
		rows.Scan(&o.OrderID, &o.BuyerID, &o.SellerID, &o.Status, &o.SubtotalCents,
			&o.CommissionCents, &o.SellerPayoutCents, &o.ShippingCents, &o.TaxCents,
			&o.TotalCents, &o.Currency, &o.TrackingNumber, &o.TrackingURL,
			&o.CreatedAt, &o.PaidAt, &o.ShippedAt, &o.DeliveredAt)
		orders = append(orders, o)
	}
	return orders, nil
}

func (s *Service) GetOrder(ctx context.Context, orderID string, userID string) (*Order, error) {
	var o Order
	err := s.db.QueryRow(ctx, `
		SELECT order_id, buyer_id, seller_id, status, subtotal_cents, commission_cents,
			seller_payout_cents, shipping_cents, tax_cents, total_cents, currency,
			COALESCE(stripe_payment_intent_id,''), COALESCE(tracking_number,''), COALESCE(tracking_url,''),
			created_at, paid_at, shipped_at, delivered_at
		FROM marketplace_orders WHERE order_id = $1 AND (buyer_id = $2 OR seller_id = $2)
	`, orderID, userID).Scan(&o.OrderID, &o.BuyerID, &o.SellerID, &o.Status, &o.SubtotalCents,
		&o.CommissionCents, &o.SellerPayoutCents, &o.ShippingCents, &o.TaxCents,
		&o.TotalCents, &o.Currency, &o.StripePaymentIntent, &o.TrackingNumber, &o.TrackingURL,
		&o.CreatedAt, &o.PaidAt, &o.ShippedAt, &o.DeliveredAt)
	if err != nil {
		return nil, fmt.Errorf("get order: %w", err)
	}

	// Fetch items
	itemRows, _ := s.db.Query(ctx, `
		SELECT item_id, product_id, title, price_cents, quantity, COALESCE(image_url,'')
		FROM order_items WHERE order_id = $1
	`, orderID)
	if itemRows != nil {
		defer itemRows.Close()
		for itemRows.Next() {
			var it OrderItem
			itemRows.Scan(&it.ItemID, &it.ProductID, &it.Title, &it.PriceCents, &it.Quantity, &it.ImageURL)
			o.Items = append(o.Items, it)
		}
	}
	return &o, nil
}

// ---------------------------------------------------------------------------
// Reviews
// ---------------------------------------------------------------------------

func (s *Service) ListReviews(ctx context.Context, productID string, cursor string, limit int) ([]Review, error) {
	if limit <= 0 || limit > 50 {
		limit = 20
	}

	rows, err := s.db.Query(ctx, `
		SELECT r.review_id, r.product_id, r.reviewer_id, u.display_name, COALESCE(r.order_id::text,''),
			r.rating, COALESCE(r.title,''), COALESCE(r.body,''), r.helpful_count,
			(r.order_id IS NOT NULL) as verified, r.created_at
		FROM product_reviews r
		JOIN users u ON u.user_id = r.reviewer_id
		WHERE r.product_id = $1 AND r.status = 'published'
		ORDER BY r.created_at DESC
		LIMIT $2
	`, productID, limit)
	if err != nil {
		return nil, fmt.Errorf("list reviews: %w", err)
	}
	defer rows.Close()

	var reviews []Review
	for rows.Next() {
		var r Review
		rows.Scan(&r.ReviewID, &r.ProductID, &r.ReviewerID, &r.ReviewerName, &r.OrderID,
			&r.Rating, &r.Title, &r.Body, &r.HelpfulCount, &r.Verified, &r.CreatedAt)
		reviews = append(reviews, r)
	}
	return reviews, nil
}

func (s *Service) CreateReview(ctx context.Context, productID string, userID string, req ReviewRequest) (*Review, error) {
	reviewID := uuid.New().String()

	// Check if user purchased this product (verified review)
	var orderID *string
	s.db.QueryRow(ctx, `
		SELECT o.order_id FROM marketplace_orders o
		JOIN order_items oi ON oi.order_id = o.order_id
		WHERE o.buyer_id = $1 AND oi.product_id = $2 AND o.status IN ('completed','delivered')
		LIMIT 1
	`, userID, productID).Scan(&orderID)

	_, err := s.db.Exec(ctx, `
		INSERT INTO product_reviews (review_id, product_id, reviewer_id, order_id, rating, title, body)
		VALUES ($1, $2, $3, $4, $5, $6, $7)
	`, reviewID, productID, userID, orderID, req.Rating, req.Title, req.Body)
	if err != nil {
		return nil, fmt.Errorf("create review: %w", err)
	}

	// Update product rating aggregate
	s.db.Exec(ctx, `
		UPDATE marketplace_products SET
			rating_avg = (SELECT AVG(rating)::DECIMAL(3,2) FROM product_reviews WHERE product_id = $1 AND status = 'published'),
			rating_count = (SELECT COUNT(*) FROM product_reviews WHERE product_id = $1 AND status = 'published')
		WHERE product_id = $1
	`, productID)

	return &Review{
		ReviewID:   reviewID,
		ProductID:  productID,
		ReviewerID: userID,
		Rating:     req.Rating,
		Title:      req.Title,
		Body:       req.Body,
		Verified:   orderID != nil,
	}, nil
}

// ---------------------------------------------------------------------------
// Wishlist
// ---------------------------------------------------------------------------

func (s *Service) ToggleWishlist(ctx context.Context, userID, productID string) (bool, error) {
	var exists bool
	s.db.QueryRow(ctx, `SELECT EXISTS(SELECT 1 FROM wishlists WHERE user_id = $1 AND product_id = $2)`, userID, productID).Scan(&exists)

	if exists {
		s.db.Exec(ctx, `DELETE FROM wishlists WHERE user_id = $1 AND product_id = $2`, userID, productID)
		return false, nil
	}
	s.db.Exec(ctx, `INSERT INTO wishlists (user_id, product_id) VALUES ($1, $2) ON CONFLICT DO NOTHING`, userID, productID)
	return true, nil
}

func (s *Service) ListWishlist(ctx context.Context, userID string) ([]Product, error) {
	rows, err := s.db.Query(ctx, `
		SELECT p.product_id, p.seller_id, p.title, p.description, p.category_id,
			p.price_cents, p.currency, p.status, p.rating_avg, p.rating_count,
			sp.store_name,
			COALESCE((SELECT url FROM product_images pi WHERE pi.product_id = p.product_id AND pi.is_primary LIMIT 1), '')
		FROM wishlists w
		JOIN marketplace_products p ON p.product_id = w.product_id
		JOIN seller_profiles sp ON sp.seller_id = p.seller_id
		WHERE w.user_id = $1
		ORDER BY w.created_at DESC
	`, userID)
	if err != nil {
		return nil, fmt.Errorf("list wishlist: %w", err)
	}
	defer rows.Close()

	var products []Product
	for rows.Next() {
		var p Product
		var imageURL string
		rows.Scan(&p.ProductID, &p.SellerID, &p.Title, &p.Description, &p.CategoryID,
			&p.PriceCents, &p.Currency, &p.Status, &p.RatingAvg, &p.RatingCount,
			&p.SellerName, &imageURL)
		if imageURL != "" {
			p.Images = []Image{{URL: imageURL, IsPrimary: true}}
		}
		products = append(products, p)
	}
	return products, nil
}

// ---------------------------------------------------------------------------
// Seller onboarding (Stripe Connect)
// ---------------------------------------------------------------------------

func (s *Service) OnboardSeller(ctx context.Context, userID string, storeName, storeSlug string) (*SellerProfile, string, error) {
	// Create Stripe Connect Express account.
	// Express accounts collect:
	// - Identity verification (SSN last 4, DOB, address)
	// - Bank account (routing + account number) for ACH payouts
	// - Tax information (W-9 / 1099 reporting)
	// Stripe handles all KYC/AML compliance.
	params := &stripe.AccountParams{
		Type:    stripe.String("express"),
		Country: stripe.String("US"),
		Capabilities: &stripe.AccountCapabilitiesParams{
			CardPayments: &stripe.AccountCapabilitiesCardPaymentsParams{Requested: stripe.Bool(true)},
			Transfers:    &stripe.AccountCapabilitiesTransfersParams{Requested: stripe.Bool(true)},
		},
		BusinessType: stripe.String("individual"),
		// Stripe Express onboarding collects payout schedule and bank info directly.
	}
	params.AddMetadata("kinnect_user_id", userID)
	params.AddMetadata("kinnect_store_name", storeName)

	acct, err := account.New(params)
	if err != nil {
		return nil, "", fmt.Errorf("stripe connect account creation failed: %w", err)
	}

	// Upsert seller profile with the Stripe account ID
	_, err = s.db.Exec(ctx, `
		INSERT INTO seller_profiles (seller_id, store_name, store_slug, stripe_account_id, status)
		VALUES ($1, $2, $3, $4, 'pending')
		ON CONFLICT (seller_id) DO UPDATE SET
			store_name = $2, store_slug = $3, stripe_account_id = $4
	`, userID, storeName, storeSlug, acct.ID)
	if err != nil {
		return nil, "", fmt.Errorf("upsert seller profile: %w", err)
	}

	// Create account link for the Express onboarding flow.
	// This is the URL where Stripe collects:
	// 1. Legal name + DOB
	// 2. SSN (last 4 or full depending on volume)
	// 3. Home address
	// 4. Bank account (routing number + account number) for ACH payouts
	// 5. Terms of service acceptance
	linkParams := &stripe.AccountLinkParams{
		Account:    stripe.String(acct.ID),
		RefreshURL: stripe.String("https://kinnect.ai/seller/onboard/refresh"),
		ReturnURL:  stripe.String("https://kinnect.ai/seller/onboard/complete"),
		Type:       stripe.String("account_onboarding"),
		Collect:    stripe.String("eventually_due"),
	}
	link, err := accountlink.New(linkParams)
	if err != nil {
		return nil, "", fmt.Errorf("stripe account link creation failed: %w", err)
	}

	return &SellerProfile{
		SellerID:        userID,
		StoreName:       storeName,
		StoreSlug:       storeSlug,
		StripeAccountID: acct.ID,
		Status:          "pending",
	}, link.URL, nil
}

// CompleteSellerOnboarding is called when the seller returns from Stripe Express.
// It checks the account's charges_enabled + payouts_enabled status and updates
// the seller profile accordingly. The bank account (ACH) is now on file.
func (s *Service) CompleteSellerOnboarding(ctx context.Context, userID string) (*SellerProfile, error) {
	var stripeAccountID string
	err := s.db.QueryRow(ctx,
		`SELECT stripe_account_id FROM seller_profiles WHERE seller_id = $1`, userID,
	).Scan(&stripeAccountID)
	if err != nil {
		return nil, fmt.Errorf("seller not found: %w", err)
	}

	// Retrieve the account to check onboarding status
	acct, err := account.GetByID(stripeAccountID, nil)
	if err != nil {
		return nil, fmt.Errorf("stripe account retrieval failed: %w", err)
	}

	// charges_enabled = can accept payments
	// payouts_enabled = bank account (ACH) is verified and payouts will work
	onboarded := acct.ChargesEnabled && acct.PayoutsEnabled
	status := "pending"
	if onboarded {
		status = "active"
	}

	s.db.Exec(ctx, `
		UPDATE seller_profiles SET stripe_onboarded = $1, status = $2, updated_at = NOW()
		WHERE seller_id = $3
	`, onboarded, status, userID)

	return &SellerProfile{
		SellerID:         userID,
		StripeAccountID:  stripeAccountID,
		StripeOnboarded:  onboarded,
		Status:           status,
	}, nil
}

func (s *Service) GetSellerDashboard(ctx context.Context, sellerID string) (*SellerProfile, error) {
	var sp SellerProfile
	err := s.db.QueryRow(ctx, `
		SELECT sp.seller_id, sp.store_name, sp.store_slug, COALESCE(sp.description,''),
			COALESCE(sp.logo_url,''), COALESCE(sp.stripe_account_id,''), sp.stripe_onboarded,
			sp.commission_rate, sp.rating_avg, sp.rating_count, sp.status,
			(SELECT COUNT(*) FROM marketplace_products WHERE seller_id = sp.seller_id AND status = 'active'),
			(SELECT COALESCE(SUM(total_cents),0) FROM marketplace_orders WHERE seller_id = sp.seller_id AND status IN ('completed','delivered')),
			(SELECT COALESCE(SUM(seller_payout_cents),0) FROM marketplace_orders WHERE seller_id = sp.seller_id AND status IN ('completed','delivered')),
			(SELECT COUNT(*) FROM marketplace_orders WHERE seller_id = sp.seller_id AND status IN ('paid','shipped'))
		FROM seller_profiles sp WHERE sp.seller_id = $1
	`, sellerID).Scan(
		&sp.SellerID, &sp.StoreName, &sp.StoreSlug, &sp.Description,
		&sp.LogoURL, &sp.StripeAccountID, &sp.StripeOnboarded,
		&sp.CommissionRate, &sp.RatingAvg, &sp.RatingCount, &sp.Status,
		&sp.ActiveListings, &sp.TotalSales, &sp.TotalEarnings, &sp.PendingOrders,
	)
	if err != nil {
		return nil, fmt.Errorf("seller dashboard: %w", err)
	}
	return &sp, nil
}

// ---------------------------------------------------------------------------
// Stripe webhook: payment confirmation + seller payout
// ---------------------------------------------------------------------------

func (s *Service) HandlePaymentSuccess(ctx context.Context, paymentIntentID string) error {
	// Find the order
	var orderID, sellerID string
	var sellerPayoutCents int
	var stripeAccountID string

	err := s.db.QueryRow(ctx, `
		SELECT o.order_id, o.seller_id, o.seller_payout_cents, COALESCE(sp.stripe_account_id,'')
		FROM marketplace_orders o
		JOIN seller_profiles sp ON sp.seller_id = o.seller_id
		WHERE o.stripe_payment_intent_id = $1
	`, paymentIntentID).Scan(&orderID, &sellerID, &sellerPayoutCents, &stripeAccountID)
	if err != nil {
		return fmt.Errorf("find order for payment %s: %w", paymentIntentID, err)
	}

	// Update order status
	s.db.Exec(ctx, `UPDATE marketplace_orders SET status = 'paid', paid_at = NOW() WHERE order_id = $1`, orderID)

	// Update sales counts
	s.db.Exec(ctx, `
		UPDATE marketplace_products SET sales_count = sales_count + oi.quantity
		FROM order_items oi WHERE oi.order_id = $1 AND marketplace_products.product_id = oi.product_id
	`, orderID)

	// If no Connect account, do manual transfer later
	if stripeAccountID != "" {
		// Create transfer to seller via Stripe Connect
		transferParams := &stripe.TransferParams{
			Amount:      stripe.Int64(int64(sellerPayoutCents)),
			Currency:    stripe.String("usd"),
			Destination: stripe.String(stripeAccountID),
		}
		transferParams.AddMetadata("kinnect_order_id", orderID)

		t, err := transfer.New(transferParams)
		if err != nil {
			// Log but don't fail -- retry via background job
			return fmt.Errorf("stripe transfer: %w", err)
		}

		s.db.Exec(ctx, `UPDATE marketplace_orders SET stripe_transfer_id = $1 WHERE order_id = $2`, t.ID, orderID)
		s.db.Exec(ctx, `
			INSERT INTO seller_payouts (seller_id, order_id, amount_cents, stripe_transfer_id, status)
			VALUES ($1, $2, $3, $4, 'completed')
		`, sellerID, orderID, sellerPayoutCents, t.ID)
	}

	return nil
}
