package marketplace

import (
	"net/http"
	"time"

	"github.com/gin-gonic/gin"
	"github.com/google/uuid"
	"github.com/kinnectai/backend/pkg/middleware"
)

type Handler struct{}

func NewHandler() *Handler { return &Handler{} }

func (h *Handler) RegisterRoutes(rg *gin.RouterGroup) {
	rg.GET("/products", h.listProducts)
	rg.GET("/products/:id", h.getProduct)
	rg.POST("/products", h.createListing)
	rg.GET("/categories", h.listCategories)
	rg.POST("/orders", h.createOrder)
	rg.GET("/orders", h.listOrders)
	rg.GET("/seller/dashboard", h.sellerDashboard)
}

// GET /api/v1/marketplace/products
func (h *Handler) listProducts(c *gin.Context) {
	category := c.Query("category")
	cursor := c.Query("after")
	// TODO: Query marketplace_products table
	c.JSON(http.StatusOK, gin.H{
		"data": gin.H{
			"items": []gin.H{
				{"id": "prod_1", "title": "Harrington Family History Book", "category": "genealogy_books", "price_cents": 2999, "currency": "USD", "seller_name": "Heritage Press", "image_url": "https://placeholder.com/book.jpg", "commission_percent": 12},
				{"id": "prod_2", "title": "Cork County Heritage Tour", "category": "heritage_travel", "price_cents": 89900, "currency": "USD", "seller_name": "Ancestry Travels", "image_url": "https://placeholder.com/tour.jpg", "commission_percent": 10},
				{"id": "prod_3", "title": "DNA Wellness Report", "category": "dna_wellness", "price_cents": 4999, "currency": "USD", "seller_name": "GenomicHealth", "image_url": "https://placeholder.com/dna.jpg", "commission_percent": 15},
				{"id": "prod_4", "title": "Vintage Family Crest Ring", "category": "heirlooms", "price_cents": 15900, "currency": "USD", "seller_name": "AncestralCraft", "image_url": "https://placeholder.com/ring.jpg", "commission_percent": 8},
			},
			"next_cursor": nil,
			"has_more":    false,
		},
		"meta": gin.H{"category": category, "cursor": cursor},
	})
}

// GET /api/v1/marketplace/products/:id
func (h *Handler) getProduct(c *gin.Context) {
	c.JSON(http.StatusOK, gin.H{
		"data": gin.H{
			"id":          c.Param("id"),
			"title":       "Product Details",
			"description": "Full product description",
			"category":    "genealogy_books",
			"price_cents": 2999,
			"currency":    "USD",
			"seller":      gin.H{"id": "seller_1", "name": "Heritage Press", "rating": 4.8},
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
	var req struct {
		Title       string `json:"title" binding:"required"`
		Description string `json:"description" binding:"required"`
		Category    string `json:"category" binding:"required"`
		PriceCents  int    `json:"price_cents" binding:"required"`
		Currency    string `json:"currency"`
		ImageURL    string `json:"image_url"`
	}
	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}
	c.JSON(http.StatusCreated, gin.H{
		"data": gin.H{
			"id":         uuid.New().String(),
			"title":      req.Title,
			"category":   req.Category,
			"price_cents": req.PriceCents,
			"seller_id":  userID,
			"status":     "pending_review",
			"created_at": time.Now().Format(time.RFC3339),
		},
	})
}

// GET /api/v1/marketplace/categories
func (h *Handler) listCategories(c *gin.Context) {
	c.JSON(http.StatusOK, gin.H{
		"data": []gin.H{
			{"id": "heritage_travel", "name": "Heritage Travel", "icon": "globe", "count": 24},
			{"id": "dna_wellness", "name": "DNA Wellness", "icon": "dna", "count": 18},
			{"id": "genealogy_books", "name": "Genealogy Books", "icon": "book", "count": 42},
			{"id": "heirlooms", "name": "Heirlooms & Craft", "icon": "gift", "count": 31},
			{"id": "kinnect_kit", "name": "Kinnect Kit", "icon": "package", "count": 1},
		},
	})
}

// POST /api/v1/marketplace/orders
func (h *Handler) createOrder(c *gin.Context) {
	userID, ok := middleware.GetUserID(c)
	if !ok {
		c.JSON(http.StatusUnauthorized, gin.H{"error": "unauthorized"})
		return
	}
	var req struct {
		ProductID string `json:"product_id" binding:"required"`
	}
	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}
	// TODO: Create Stripe Connect checkout session
	c.JSON(http.StatusCreated, gin.H{
		"data": gin.H{
			"order_id":    uuid.New().String(),
			"product_id":  req.ProductID,
			"buyer_id":    userID,
			"status":      "processing",
			"checkout_url": "https://checkout.stripe.com/placeholder",
		},
	})
}

// GET /api/v1/marketplace/orders
func (h *Handler) listOrders(c *gin.Context) {
	_, ok := middleware.GetUserID(c)
	if !ok {
		c.JSON(http.StatusUnauthorized, gin.H{"error": "unauthorized"})
		return
	}
	c.JSON(http.StatusOK, gin.H{"data": gin.H{"items": []interface{}{}}})
}

// GET /api/v1/marketplace/seller/dashboard
func (h *Handler) sellerDashboard(c *gin.Context) {
	_, ok := middleware.GetUserID(c)
	if !ok {
		c.JSON(http.StatusUnauthorized, gin.H{"error": "unauthorized"})
		return
	}
	c.JSON(http.StatusOK, gin.H{
		"data": gin.H{
			"total_sales":    0,
			"total_earnings": 0,
			"active_listings": 0,
			"pending_orders":  0,
		},
	})
}
