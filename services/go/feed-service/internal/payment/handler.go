package payment

import (
	"net/http"
	"os"
	"time"

	"github.com/gin-gonic/gin"
	"github.com/kinnectai/backend/pkg/middleware"
	"github.com/stripe/stripe-go/v78"
	"github.com/stripe/stripe-go/v78/paymentintent"
)

type Handler struct{}

func NewHandler() *Handler { return &Handler{} }

func (h *Handler) RegisterRoutes(rg *gin.RouterGroup) {
	rg.POST("/checkout", h.initCheckout)
	rg.POST("/complete", h.completePurchase)
	rg.GET("/history", h.getHistory)
	rg.POST("/restore", h.restorePurchases)
	rg.GET("/balance", h.getBalance)
}

// POST /api/v1/payments/checkout
func (h *Handler) initCheckout(c *gin.Context) {
	userID, ok := middleware.GetUserID(c)
	if !ok {
		c.JSON(http.StatusUnauthorized, gin.H{"error": "unauthorized"})
		return
	}
	var req struct {
		ProductID string `json:"product_id" binding:"required"`
		Currency  string `json:"currency" binding:"required"`
	}
	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}
	stripeKey := os.Getenv("STRIPE_SECRET_KEY")
	if stripeKey == "" {
		c.JSON(http.StatusServiceUnavailable, gin.H{"error": "stripe is not configured"})
		return
	}
	stripe.Key = stripeKey
	intent, err := paymentintent.New(&stripe.PaymentIntentParams{
		Amount:   stripe.Int64(899),
		Currency: stripe.String(req.Currency),
		Metadata: map[string]string{
			"user_id":    userID,
			"product_id": req.ProductID,
		},
		AutomaticPaymentMethods: &stripe.PaymentIntentAutomaticPaymentMethodsParams{Enabled: stripe.Bool(true)},
	})
	if err != nil {
		c.JSON(http.StatusBadGateway, gin.H{"error": "failed to create payment session"})
		return
	}
	c.JSON(http.StatusCreated, gin.H{
		"data": gin.H{
			"session_id":  intent.ID,
			"product_id":  req.ProductID,
			"currency":    req.Currency,
			"amount_cents": 899,
			"status":      "pending",
			"created_at":  time.Now().Format(time.RFC3339),
			"user_id":     userID,
			"client_secret": intent.ClientSecret,
		},
	})
}

// POST /api/v1/payments/complete
func (h *Handler) completePurchase(c *gin.Context) {
	_, ok := middleware.GetUserID(c)
	if !ok {
		c.JSON(http.StatusUnauthorized, gin.H{"error": "unauthorized"})
		return
	}
	c.JSON(http.StatusOK, gin.H{"status": "completed"})
}

// GET /api/v1/payments/history
func (h *Handler) getHistory(c *gin.Context) {
	_, ok := middleware.GetUserID(c)
	if !ok {
		c.JSON(http.StatusUnauthorized, gin.H{"error": "unauthorized"})
		return
	}
	c.JSON(http.StatusOK, gin.H{"items": []interface{}{}})
}

// POST /api/v1/payments/restore
func (h *Handler) restorePurchases(c *gin.Context) {
	_, ok := middleware.GetUserID(c)
	if !ok {
		c.JSON(http.StatusUnauthorized, gin.H{"error": "unauthorized"})
		return
	}
	c.JSON(http.StatusOK, gin.H{"status": "restored"})
}

// GET /api/v1/payments/balance
func (h *Handler) getBalance(c *gin.Context) {
	_, ok := middleware.GetUserID(c)
	if !ok {
		c.JSON(http.StatusUnauthorized, gin.H{"error": "unauthorized"})
		return
	}
	c.JSON(http.StatusOK, gin.H{"bloom_credits": 12, "vault_plus_active": true})
}
