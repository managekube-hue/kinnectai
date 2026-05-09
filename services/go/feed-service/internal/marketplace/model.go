package marketplace

import "time"

type Product struct {
	ProductID      string    `json:"id"`
	SellerID       string    `json:"seller_id"`
	Title          string    `json:"title"`
	Description    string    `json:"description,omitempty"`
	CategoryID     string    `json:"category"`
	PriceCents     int       `json:"price_cents"`
	CompareAtCents *int      `json:"compare_at_cents,omitempty"`
	Currency       string    `json:"currency"`
	SKU            string    `json:"sku,omitempty"`
	InventoryCount int       `json:"inventory_count"`
	Status         string    `json:"status"`
	Tags           []string  `json:"tags,omitempty"`
	RatingAvg      float64   `json:"rating_avg"`
	RatingCount    int       `json:"rating_count"`
	SalesCount     int       `json:"sales_count"`
	ViewCount      int       `json:"view_count"`
	Featured       bool      `json:"featured"`
	SellerName     string    `json:"seller_name,omitempty"`
	CommissionRate float64   `json:"commission_percent,omitempty"`
	Images         []Image   `json:"images,omitempty"`
	CreatedAt      time.Time `json:"created_at"`
	UpdatedAt      time.Time `json:"updated_at"`
}

type Image struct {
	ImageID   string `json:"id"`
	URL       string `json:"url"`
	AltText   string `json:"alt_text,omitempty"`
	SortOrder int    `json:"sort_order"`
	IsPrimary bool   `json:"is_primary"`
}

type Category struct {
	CategoryID string `json:"id"`
	Name       string `json:"name"`
	Icon       string `json:"icon"`
	SortOrder  int    `json:"sort_order"`
	ParentID   string `json:"parent_id,omitempty"`
	Count      int    `json:"count"`
}

type Order struct {
	OrderID              string     `json:"order_id"`
	BuyerID              string     `json:"buyer_id"`
	SellerID             string     `json:"seller_id"`
	Status               string     `json:"status"`
	SubtotalCents        int        `json:"subtotal_cents"`
	CommissionCents      int        `json:"commission_cents"`
	SellerPayoutCents    int        `json:"seller_payout_cents"`
	ShippingCents        int        `json:"shipping_cents"`
	TaxCents             int        `json:"tax_cents"`
	TotalCents           int        `json:"total_cents"`
	Currency             string     `json:"currency"`
	StripePaymentIntent  string     `json:"stripe_payment_intent_id,omitempty"`
	TrackingNumber       string     `json:"tracking_number,omitempty"`
	TrackingURL          string     `json:"tracking_url,omitempty"`
	Items                []OrderItem `json:"items,omitempty"`
	CreatedAt            time.Time  `json:"created_at"`
	PaidAt               *time.Time `json:"paid_at,omitempty"`
	ShippedAt            *time.Time `json:"shipped_at,omitempty"`
	DeliveredAt          *time.Time `json:"delivered_at,omitempty"`
}

type OrderItem struct {
	ItemID     string `json:"item_id"`
	ProductID  string `json:"product_id"`
	Title      string `json:"title"`
	PriceCents int    `json:"price_cents"`
	Quantity   int    `json:"quantity"`
	ImageURL   string `json:"image_url,omitempty"`
}

type Review struct {
	ReviewID     string    `json:"review_id"`
	ProductID    string    `json:"product_id"`
	ReviewerID   string    `json:"reviewer_id"`
	ReviewerName string    `json:"reviewer_name,omitempty"`
	OrderID      string    `json:"order_id,omitempty"`
	Rating       int       `json:"rating"`
	Title        string    `json:"title,omitempty"`
	Body         string    `json:"body,omitempty"`
	HelpfulCount int       `json:"helpful_count"`
	Verified     bool      `json:"verified_purchase"`
	CreatedAt    time.Time `json:"created_at"`
}

type SellerProfile struct {
	SellerID         string  `json:"seller_id"`
	StoreName        string  `json:"store_name"`
	StoreSlug        string  `json:"store_slug"`
	Description      string  `json:"description,omitempty"`
	LogoURL          string  `json:"logo_url,omitempty"`
	StripeAccountID  string  `json:"stripe_account_id,omitempty"`
	StripeOnboarded  bool    `json:"stripe_onboarded"`
	CommissionRate   float64 `json:"commission_rate"`
	RatingAvg        float64 `json:"rating_avg"`
	RatingCount      int     `json:"rating_count"`
	Status           string  `json:"status"`
	ActiveListings   int     `json:"active_listings"`
	TotalSales       int     `json:"total_sales"`
	TotalEarnings    int     `json:"total_earnings_cents"`
	PendingOrders    int     `json:"pending_orders"`
}

type CheckoutSession struct {
	SessionID            string `json:"session_id"`
	ClientSecret         string `json:"client_secret"`
	StripePaymentIntent  string `json:"stripe_payment_intent_id"`
	EphemeralKey         string `json:"ephemeral_key"`
	CustomerID           string `json:"customer_id"`
	TotalCents           int    `json:"total_cents"`
	Currency             string `json:"currency"`
}

type CreateListingRequest struct {
	Title       string   `json:"title" binding:"required,min=3,max=300"`
	Description string   `json:"description" binding:"required,min=10"`
	CategoryID  string   `json:"category" binding:"required"`
	PriceCents  int      `json:"price_cents" binding:"required,min=0"`
	Currency    string   `json:"currency"`
	ImageURLs   []string `json:"image_urls"`
	Tags        []string `json:"tags"`
	SKU         string   `json:"sku"`
}

type CheckoutRequest struct {
	Items []CheckoutItem `json:"items" binding:"required,min=1"`
}

type CheckoutItem struct {
	ProductID string `json:"product_id" binding:"required"`
	Quantity  int    `json:"quantity" binding:"required,min=1"`
}

type ReviewRequest struct {
	Rating int    `json:"rating" binding:"required,min=1,max=5"`
	Title  string `json:"title"`
	Body   string `json:"body"`
}

type SearchRequest struct {
	Query    string `json:"query"`
	Category string `json:"category"`
	MinPrice *int   `json:"min_price"`
	MaxPrice *int   `json:"max_price"`
	MinRating *float64 `json:"min_rating"`
	SortBy   string `json:"sort_by"`  // relevance, price_asc, price_desc, rating, newest, bestselling
	Cursor   string `json:"cursor"`
	Limit    int    `json:"limit"`
}
