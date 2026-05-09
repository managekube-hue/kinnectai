package marketplace

import (
	"encoding/json"
	"io"
	"log/slog"
	"net/http"
	"strconv"

	"github.com/gin-gonic/gin"
	"github.com/kinnectai/backend/pkg/middleware"
	"github.com/stripe/stripe-go/v78/webhook"
)

type Handler struct {
	svc             *Service
	webhookSecret   string
}

func NewHandler(svc *Service, webhookSecret string) *Handler {
	return &Handler{svc: svc, webhookSecret: webhookSecret}
}

func (h *Handler) RegisterRoutes(rg *gin.RouterGroup) {
	// Public
	rg.GET("/products", h.searchProducts)
	rg.GET("/products/:id", h.getProduct)
	rg.GET("/products/:id/reviews", h.listReviews)
	rg.GET("/categories", h.listCategories)

	// Authenticated buyer
	rg.POST("/checkout", h.createCheckout)
	rg.GET("/orders", h.listOrders)
	rg.GET("/orders/:id", h.getOrder)
	rg.POST("/products/:id/reviews", h.createReview)
	rg.POST("/wishlist/:productId", h.toggleWishlist)
	rg.GET("/wishlist", h.listWishlist)

	// Authenticated seller
	rg.POST("/products", h.createListing)
	rg.GET("/seller/dashboard", h.sellerDashboard)
	rg.POST("/seller/onboard", h.onboardSeller)
	rg.POST("/seller/onboard/complete", h.completeSeller)

	// Stripe webhook (no auth -- validated by signature)
	rg.POST("/webhook/stripe", h.stripeWebhook)
}

// GET /api/v1/marketplace/products?query=&category=&min_price=&max_price=&sort_by=&after=&limit=
func (h *Handler) searchProducts(c *gin.Context) {
	limit, _ := strconv.Atoi(c.DefaultQuery("limit", "20"))
	var minPrice, maxPrice *int
	var minRating *float64

	if v := c.Query("min_price"); v != "" {
		p, _ := strconv.Atoi(v)
		minPrice = &p
	}
	if v := c.Query("max_price"); v != "" {
		p, _ := strconv.Atoi(v)
		maxPrice = &p
	}
	if v := c.Query("min_rating"); v != "" {
		r, _ := strconv.ParseFloat(v, 64)
		minRating = &r
	}

	req := SearchRequest{
		Query:     c.Query("query"),
		Category:  c.Query("category"),
		MinPrice:  minPrice,
		MaxPrice:  maxPrice,
		MinRating: minRating,
		SortBy:    c.DefaultQuery("sort_by", "featured"),
		Cursor:    c.Query("after"),
		Limit:     limit,
	}

	products, nextCursor, hasMore, err := h.svc.SearchProducts(c.Request.Context(), req)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, gin.H{
		"data": gin.H{
			"items":       products,
			"next_cursor": nextCursor,
			"has_more":    hasMore,
		},
	})
}

// GET /api/v1/marketplace/products/:id
func (h *Handler) getProduct(c *gin.Context) {
	product, err := h.svc.GetProduct(c.Request.Context(), c.Param("id"))
	if err != nil {
		c.JSON(http.StatusNotFound, gin.H{"error": "product not found"})
		return
	}
	c.JSON(http.StatusOK, gin.H{"data": product})
}

// GET /api/v1/marketplace/categories
func (h *Handler) listCategories(c *gin.Context) {
	categories, err := h.svc.ListCategories(c.Request.Context())
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}
	c.JSON(http.StatusOK, gin.H{"data": categories})
}

// POST /api/v1/marketplace/checkout
func (h *Handler) createCheckout(c *gin.Context) {
	userID, ok := middleware.GetUserID(c)
	if !ok {
		c.JSON(http.StatusUnauthorized, gin.H{"error": "unauthorized"})
		return
	}
	var req CheckoutRequest
	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	session, order, err := h.svc.CreateCheckoutSession(c.Request.Context(), userID, req)
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusCreated, gin.H{
		"data": gin.H{
			"session":  session,
			"order":    order,
		},
	})
}

// POST /api/v1/marketplace/products
func (h *Handler) createListing(c *gin.Context) {
	userID, ok := middleware.GetUserID(c)
	if !ok {
		c.JSON(http.StatusUnauthorized, gin.H{"error": "unauthorized"})
		return
	}
	var req CreateListingRequest
	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	product, err := h.svc.CreateListing(c.Request.Context(), userID, req)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusCreated, gin.H{"data": product})
}

// GET /api/v1/marketplace/orders
func (h *Handler) listOrders(c *gin.Context) {
	userID, ok := middleware.GetUserID(c)
	if !ok {
		c.JSON(http.StatusUnauthorized, gin.H{"error": "unauthorized"})
		return
	}
	role := c.DefaultQuery("role", "buyer")
	orders, err := h.svc.ListOrders(c.Request.Context(), userID, role)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}
	c.JSON(http.StatusOK, gin.H{"data": gin.H{"items": orders}})
}

// GET /api/v1/marketplace/orders/:id
func (h *Handler) getOrder(c *gin.Context) {
	userID, ok := middleware.GetUserID(c)
	if !ok {
		c.JSON(http.StatusUnauthorized, gin.H{"error": "unauthorized"})
		return
	}
	order, err := h.svc.GetOrder(c.Request.Context(), c.Param("id"), userID)
	if err != nil {
		c.JSON(http.StatusNotFound, gin.H{"error": "order not found"})
		return
	}
	c.JSON(http.StatusOK, gin.H{"data": order})
}

// GET /api/v1/marketplace/products/:id/reviews
func (h *Handler) listReviews(c *gin.Context) {
	cursor := c.Query("after")
	limit, _ := strconv.Atoi(c.DefaultQuery("limit", "20"))
	reviews, err := h.svc.ListReviews(c.Request.Context(), c.Param("id"), cursor, limit)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}
	c.JSON(http.StatusOK, gin.H{"data": reviews})
}

// POST /api/v1/marketplace/products/:id/reviews
func (h *Handler) createReview(c *gin.Context) {
	userID, ok := middleware.GetUserID(c)
	if !ok {
		c.JSON(http.StatusUnauthorized, gin.H{"error": "unauthorized"})
		return
	}
	var req ReviewRequest
	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}
	review, err := h.svc.CreateReview(c.Request.Context(), c.Param("id"), userID, req)
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}
	c.JSON(http.StatusCreated, gin.H{"data": review})
}

// POST /api/v1/marketplace/wishlist/:productId
func (h *Handler) toggleWishlist(c *gin.Context) {
	userID, ok := middleware.GetUserID(c)
	if !ok {
		c.JSON(http.StatusUnauthorized, gin.H{"error": "unauthorized"})
		return
	}
	added, err := h.svc.ToggleWishlist(c.Request.Context(), userID, c.Param("productId"))
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}
	c.JSON(http.StatusOK, gin.H{"wishlisted": added})
}

// GET /api/v1/marketplace/wishlist
func (h *Handler) listWishlist(c *gin.Context) {
	userID, ok := middleware.GetUserID(c)
	if !ok {
		c.JSON(http.StatusUnauthorized, gin.H{"error": "unauthorized"})
		return
	}
	products, err := h.svc.ListWishlist(c.Request.Context(), userID)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}
	c.JSON(http.StatusOK, gin.H{"data": products})
}

// GET /api/v1/marketplace/seller/dashboard
func (h *Handler) sellerDashboard(c *gin.Context) {
	userID, ok := middleware.GetUserID(c)
	if !ok {
		c.JSON(http.StatusUnauthorized, gin.H{"error": "unauthorized"})
		return
	}
	dashboard, err := h.svc.GetSellerDashboard(c.Request.Context(), userID)
	if err != nil {
		c.JSON(http.StatusNotFound, gin.H{"error": "seller profile not found"})
		return
	}
	c.JSON(http.StatusOK, gin.H{"data": dashboard})
}

// POST /api/v1/marketplace/seller/onboard
func (h *Handler) onboardSeller(c *gin.Context) {
	userID, ok := middleware.GetUserID(c)
	if !ok {
		c.JSON(http.StatusUnauthorized, gin.H{"error": "unauthorized"})
		return
	}
	var req struct {
		StoreName string `json:"store_name" binding:"required"`
		StoreSlug string `json:"store_slug" binding:"required"`
	}
	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}
	profile, onboardURL, err := h.svc.OnboardSeller(c.Request.Context(), userID, req.StoreName, req.StoreSlug)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}
	c.JSON(http.StatusCreated, gin.H{
		"data": gin.H{
			"profile":     profile,
			"onboard_url": onboardURL,
		},
	})
}

// POST /api/v1/marketplace/seller/onboard/complete
// Called when seller returns from Stripe Express onboarding.
// Checks charges_enabled + payouts_enabled (bank/ACH verified).
func (h *Handler) completeSeller(c *gin.Context) {
	userID, ok := middleware.GetUserID(c)
	if !ok {
		c.JSON(http.StatusUnauthorized, gin.H{"error": "unauthorized"})
		return
	}
	profile, err := h.svc.CompleteSellerOnboarding(c.Request.Context(), userID)
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}
	c.JSON(http.StatusOK, gin.H{
		"data": gin.H{
			"profile":          profile,
			"payouts_enabled":  profile.StripeOnboarded,
			"bank_connected":   profile.StripeOnboarded,
		},
	})
}

// POST /api/v1/marketplace/webhook/stripe
func (h *Handler) stripeWebhook(c *gin.Context) {
	body, err := io.ReadAll(c.Request.Body)
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "read body failed"})
		return
	}

	event, err := webhook.ConstructEvent(body, c.GetHeader("Stripe-Signature"), h.webhookSecret)
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "invalid signature"})
		return
	}

	switch event.Type {
	case "payment_intent.succeeded":
		var pi struct {
			ID string `json:"id"`
		}
		if err := json.Unmarshal(event.Data.Raw, &pi); err == nil {
			if err := h.svc.HandlePaymentSuccess(c.Request.Context(), pi.ID); err != nil {
				slog.Error("handle payment success", "err", err, "pi", pi.ID)
			}
		}
	}

	c.JSON(http.StatusOK, gin.H{"received": true})
}
