package discovery

import (
	"net/http"

	"github.com/gin-gonic/gin"
	"github.com/google/uuid"
	"github.com/kinnectai/backend/pkg/middleware"
)

type Handler struct{}

func NewHandler() *Handler { return &Handler{} }

func (h *Handler) RegisterRoutes(rg *gin.RouterGroup) {
	rg.POST("/candidates", h.fetchCandidates)
	rg.POST("/dismiss", h.dismissCandidate)
	rg.GET("/weekly", h.weeklyBatch)
}

// POST /api/v1/discovery/candidates
func (h *Handler) fetchCandidates(c *gin.Context) {
	userID, ok := middleware.GetUserID(c)
	if !ok {
		c.JSON(http.StatusUnauthorized, gin.H{"error": "unauthorized"})
		return
	}
	uid, _ := uuid.Parse(userID)

	var req struct {
		After   string                 `json:"after"`
		Limit   int                    `json:"limit"`
		Filters map[string]interface{} `json:"filters"`
	}
	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}
	if req.Limit == 0 {
		req.Limit = 10
	}

	// TODO: Query discovery-service Redis sorted set
	c.JSON(http.StatusOK, gin.H{
		"data": gin.H{
			"items":       []interface{}{},
			"next_cursor": nil,
			"has_more":    false,
		},
		"meta": gin.H{"user_id": uid.String()},
	})
}

// POST /api/v1/discovery/dismiss
func (h *Handler) dismissCandidate(c *gin.Context) {
	_, ok := middleware.GetUserID(c)
	if !ok {
		c.JSON(http.StatusUnauthorized, gin.H{"error": "unauthorized"})
		return
	}
	var req struct {
		UserID string `json:"user_id" binding:"required"`
	}
	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}
	// TODO: Apply score *= 0.30 penalty in Redis, exclude for 30 days
	c.JSON(http.StatusOK, gin.H{"status": "dismissed"})
}

// GET /api/v1/discovery/weekly
func (h *Handler) weeklyBatch(c *gin.Context) {
	_, ok := middleware.GetUserID(c)
	if !ok {
		c.JSON(http.StatusUnauthorized, gin.H{"error": "unauthorized"})
		return
	}
	// TODO: Return max 10 cards from Redis pool, Sunday reset
	c.JSON(http.StatusOK, gin.H{
		"data": gin.H{
			"items":    []interface{}{},
			"has_more": false,
		},
	})
}
