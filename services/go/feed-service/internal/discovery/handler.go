package discovery

import (
	"fmt"
	"net/http"
	"time"

	"github.com/gin-gonic/gin"
	"github.com/google/uuid"
	"github.com/kinnectai/backend/pkg/middleware"
	"github.com/redis/go-redis/v9"
)

type Handler struct {
	redis *redis.Client
}

func NewHandler(redisClient *redis.Client) *Handler {
	return &Handler{redis: redisClient}
}

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

	key := fmt.Sprintf("discovery:candidates:%s", uid.String())
	members, err := h.redis.ZRevRangeWithScores(c.Request.Context(), key, 0, int64(req.Limit-1)).Result()
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "failed to fetch candidates"})
		return
	}

	items := make([]gin.H, 0, len(members))
	for _, m := range members {
		items = append(items, gin.H{
			"user_id": m.Member,
			"score":   m.Score,
		})
	}

	c.JSON(http.StatusOK, gin.H{
		"data": gin.H{
			"items":       items,
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
	ctx := c.Request.Context()
	ownerID, _ := middleware.GetUserID(c)
	candidateKey := fmt.Sprintf("discovery:candidates:%s", ownerID)
	current, err := h.redis.ZScore(ctx, candidateKey, req.UserID).Result()
	if err == nil {
		_ = h.redis.ZAdd(ctx, candidateKey, redis.Z{Member: req.UserID, Score: current * 0.30}).Err()
	}
	excludeKey := fmt.Sprintf("discovery:excluded:%s", ownerID)
	_ = h.redis.Set(ctx, excludeKey+":"+req.UserID, "1", 30*24*time.Hour).Err()
	c.JSON(http.StatusOK, gin.H{"status": "dismissed"})
}

// GET /api/v1/discovery/weekly
func (h *Handler) weeklyBatch(c *gin.Context) {
	_, ok := middleware.GetUserID(c)
	if !ok {
		c.JSON(http.StatusUnauthorized, gin.H{"error": "unauthorized"})
		return
	}
	uid, _ := middleware.GetUserID(c)
	week := time.Now().UTC().Format("2006-01-02")
	key := fmt.Sprintf("discovery:weekly:%s:%s", uid, week)
	members, err := h.redis.ZRevRangeWithScores(c.Request.Context(), key, 0, 9).Result()
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "failed to fetch weekly pool"})
		return
	}
	items := make([]gin.H, 0, len(members))
	for _, m := range members {
		items = append(items, gin.H{"user_id": m.Member, "score": m.Score})
	}
	c.JSON(http.StatusOK, gin.H{
		"data": gin.H{
			"items":    items,
			"has_more": false,
		},
	})
}
