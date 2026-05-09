package settings

import (
	"net/http"

	"github.com/gin-gonic/gin"
	"github.com/kinnectai/backend/pkg/middleware"
)

type Handler struct{}

func NewHandler() *Handler { return &Handler{} }

func (h *Handler) RegisterRoutes(rg *gin.RouterGroup) {
	rg.GET("", h.getSettings)
	rg.PUT("/push", h.togglePush)
	rg.PUT("/privacy", h.updatePrivacy)
	rg.PUT("/preferences", h.updatePreferences)
	rg.POST("/export", h.requestDataExport)
	rg.DELETE("/account", h.deleteAccount)
}

func (h *Handler) getSettings(c *gin.Context) {
	_, ok := middleware.GetUserID(c)
	if !ok {
		c.JSON(http.StatusUnauthorized, gin.H{"error": "unauthorized"})
		return
	}
	c.JSON(http.StatusOK, gin.H{
		"data": gin.H{
			"push_enabled":      true,
			"private_account":   true,
			"discovery_enabled": true,
		},
	})
}

func (h *Handler) togglePush(c *gin.Context) {
	_, ok := middleware.GetUserID(c)
	if !ok {
		c.JSON(http.StatusUnauthorized, gin.H{"error": "unauthorized"})
		return
	}
	var req struct {
		Enabled bool `json:"enabled"`
	}
	c.ShouldBindJSON(&req)
	c.JSON(http.StatusOK, gin.H{"data": gin.H{"push_enabled": req.Enabled, "private_account": true, "discovery_enabled": true}})
}

func (h *Handler) updatePrivacy(c *gin.Context) {
	_, ok := middleware.GetUserID(c)
	if !ok {
		c.JSON(http.StatusUnauthorized, gin.H{"error": "unauthorized"})
		return
	}
	c.JSON(http.StatusOK, gin.H{"data": gin.H{"push_enabled": true, "private_account": true, "discovery_enabled": true}})
}

func (h *Handler) updatePreferences(c *gin.Context) {
	_, ok := middleware.GetUserID(c)
	if !ok {
		c.JSON(http.StatusUnauthorized, gin.H{"error": "unauthorized"})
		return
	}
	c.JSON(http.StatusOK, gin.H{"status": "preferences_updated"})
}

func (h *Handler) requestDataExport(c *gin.Context) {
	userID, ok := middleware.GetUserID(c)
	if !ok {
		c.JSON(http.StatusUnauthorized, gin.H{"error": "unauthorized"})
		return
	}
	c.JSON(http.StatusAccepted, gin.H{
		"export_id":          "exp_" + userID[:8],
		"estimated_ready_at": "2026-05-10T01:00:00Z",
	})
}

func (h *Handler) deleteAccount(c *gin.Context) {
	_, ok := middleware.GetUserID(c)
	if !ok {
		c.JSON(http.StatusUnauthorized, gin.H{"error": "unauthorized"})
		return
	}
	// TODO: Queue account deletion, notify Stewards, 30-day purge
	c.JSON(http.StatusOK, gin.H{"status": "deletion_initiated"})
}
