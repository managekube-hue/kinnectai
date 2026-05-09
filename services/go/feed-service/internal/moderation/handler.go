package moderation

import (
	"net/http"

	"github.com/gin-gonic/gin"
	"github.com/kinnectai/backend/pkg/middleware"
)

type Handler struct{}

func NewHandler() *Handler { return &Handler{} }

func (h *Handler) RegisterRoutes(rg *gin.RouterGroup) {
	rg.POST("/check", h.checkContent)
	rg.POST("/report", h.reportContent)
}

// POST /api/v1/moderation/check
func (h *Handler) checkContent(c *gin.Context) {
	_, ok := middleware.GetUserID(c)
	if !ok {
		c.JSON(http.StatusUnauthorized, gin.H{"error": "unauthorized"})
		return
	}
	var req struct {
		ContentID   string `json:"content_id" binding:"required"`
		ContentType string `json:"content_type" binding:"required"`
		Text        string `json:"text"`
		MediaURL    string `json:"media_url"`
	}
	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}
	// TODO: Forward to Perspective API + CLIP for scoring
	c.JSON(http.StatusOK, gin.H{
		"action":         "allow",
		"toxicity_score": 0.05,
		"nsfw_score":     0.01,
		"queue_priority": nil,
	})
}

// POST /api/v1/moderation/report
func (h *Handler) reportContent(c *gin.Context) {
	userID, ok := middleware.GetUserID(c)
	if !ok {
		c.JSON(http.StatusUnauthorized, gin.H{"error": "unauthorized"})
		return
	}
	var req struct {
		ContentID string `json:"content_id" binding:"required"`
		Reason    string `json:"reason" binding:"required"`
		Details   string `json:"details"`
	}
	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}
	c.JSON(http.StatusCreated, gin.H{"status": "reported", "reporter_id": userID})
}
