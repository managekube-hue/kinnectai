package vault

import (
	"net/http"

	"github.com/gin-gonic/gin"
	"github.com/google/uuid"
	"github.com/kinnectai/backend/pkg/middleware"
)

type Handler struct{}

func NewHandler() *Handler { return &Handler{} }

func (h *Handler) RegisterRoutes(rg *gin.RouterGroup) {
	rg.GET("/vault", h.listVault)
	rg.POST("/seal", h.sealMemory)
	rg.POST("/revoke", h.revokeTrigger)
	rg.GET("/vault/:id", h.getVaultItem)
	rg.POST("/export", h.requestExport)
}

// GET /api/v1/memories/vault
func (h *Handler) listVault(c *gin.Context) {
	userID, ok := middleware.GetUserID(c)
	if !ok {
		c.JSON(http.StatusUnauthorized, gin.H{"error": "unauthorized"})
		return
	}
	uid, _ := uuid.Parse(userID)
	// TODO: Query memory_box table WHERE user_id = uid
	c.JSON(http.StatusOK, gin.H{
		"data": gin.H{"items": []interface{}{}},
		"meta": gin.H{"user_id": uid.String(), "storage_used": 0.0},
	})
}

// POST /api/v1/memories/seal
func (h *Handler) sealMemory(c *gin.Context) {
	userID, ok := middleware.GetUserID(c)
	if !ok {
		c.JSON(http.StatusUnauthorized, gin.H{"error": "unauthorized"})
		return
	}
	uid, _ := uuid.Parse(userID)

	var req struct {
		MemoryID      string                 `json:"memory_id" binding:"required"`
		TriggerConfig map[string]interface{} `json:"trigger_config" binding:"required"`
		RecipientID   string                 `json:"recipient_id" binding:"required"`
	}
	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	// TODO: Encrypt + seal via AES-256-GCM, store in S3, wrap key with KMS
	c.JSON(http.StatusCreated, gin.H{
		"data": gin.H{
			"memory_id":    req.MemoryID,
			"sealed_at":    "2026-05-09T01:00:00Z",
			"trigger_type": req.TriggerConfig["type"],
			"recipient_id": req.RecipientID,
			"user_id":      uid.String(),
		},
	})
}

// POST /api/v1/memories/revoke
func (h *Handler) revokeTrigger(c *gin.Context) {
	_, ok := middleware.GetUserID(c)
	if !ok {
		c.JSON(http.StatusUnauthorized, gin.H{"error": "unauthorized"})
		return
	}
	var req struct {
		MemoryID string `json:"memory_id" binding:"required"`
	}
	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}
	// TODO: Remove trigger, keep sealed
	c.JSON(http.StatusOK, gin.H{"status": "trigger_revoked"})
}

// GET /api/v1/memories/vault/:id
func (h *Handler) getVaultItem(c *gin.Context) {
	_, ok := middleware.GetUserID(c)
	if !ok {
		c.JSON(http.StatusUnauthorized, gin.H{"error": "unauthorized"})
		return
	}
	c.JSON(http.StatusOK, gin.H{
		"data": gin.H{
			"id":     c.Param("id"),
			"status": "sealed",
		},
	})
}

// POST /api/v1/memories/export
func (h *Handler) requestExport(c *gin.Context) {
	userID, ok := middleware.GetUserID(c)
	if !ok {
		c.JSON(http.StatusUnauthorized, gin.H{"error": "unauthorized"})
		return
	}
	// TODO: Queue GDPR export job
	c.JSON(http.StatusAccepted, gin.H{
		"data": gin.H{
			"export_id":          uuid.New().String(),
			"user_id":            userID,
			"estimated_ready_at": "2026-05-10T01:00:00Z",
		},
	})
}
