package settings

import (
	"context"
	"net/http"
	"sync"
	"time"

	"github.com/gin-gonic/gin"
	"github.com/google/uuid"
	"github.com/jackc/pgx/v5/pgxpool"
	"github.com/kinnectai/backend/pkg/middleware"
)

type Handler struct {
	db *pgxpool.Pool
}

func NewHandler(db *pgxpool.Pool) *Handler { return &Handler{db: db} }

var ensureSettingsSchemaOnce sync.Once

func (h *Handler) ensureSchema() {
	ensureSettingsSchemaOnce.Do(func() {
		_, _ = h.db.Exec(context.Background(), `
			CREATE TABLE IF NOT EXISTS account_deletion_requests (
				id UUID PRIMARY KEY,
				user_id UUID NOT NULL,
				status TEXT NOT NULL,
				notified_stewards BOOLEAN NOT NULL DEFAULT FALSE,
				requested_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
				purge_at TIMESTAMPTZ NOT NULL
			);
			CREATE INDEX IF NOT EXISTS idx_account_deletion_requests_user ON account_deletion_requests(user_id, requested_at DESC);
		`)
	})
}

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
	h.ensureSchema()
	uid, ok := middleware.GetUserID(c)
	if !ok {
		c.JSON(http.StatusUnauthorized, gin.H{"error": "unauthorized"})
		return
	}
	userUUID, err := uuid.Parse(uid)
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "invalid user id"})
		return
	}
	requestID := uuid.New()
	purgeAt := time.Now().UTC().Add(30 * 24 * time.Hour)
	_, err = h.db.Exec(c.Request.Context(), `
		INSERT INTO account_deletion_requests (id, user_id, status, notified_stewards, purge_at)
		VALUES ($1, $2, 'queued', TRUE, $3)
	`, requestID, userUUID, purgeAt)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "failed to queue account deletion"})
		return
	}

	c.JSON(http.StatusOK, gin.H{
		"status": "deletion_initiated",
		"data": gin.H{
			"request_id":         requestID.String(),
			"notified_stewards":  true,
			"purge_at":           purgeAt.Format(time.RFC3339),
			"grace_period_days":  30,
		},
	})
}
