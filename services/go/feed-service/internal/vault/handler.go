package vault

import (
	"context"
	"crypto/aes"
	"crypto/cipher"
	"crypto/rand"
	"encoding/base64"
	"encoding/json"
	"fmt"
	"io"
	"net/http"
	"os"
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

var ensureVaultSchemaOnce sync.Once

func (h *Handler) ensureSchema() {
	ensureVaultSchemaOnce.Do(func() {
		_, _ = h.db.Exec(
			context.Background(),
			`CREATE TABLE IF NOT EXISTS memory_box (
				id UUID PRIMARY KEY,
				memory_id UUID NOT NULL,
				user_id UUID NOT NULL,
				recipient_id UUID,
				trigger_type TEXT,
				trigger_config JSONB,
				trigger_revoked BOOLEAN NOT NULL DEFAULT FALSE,
				status TEXT NOT NULL DEFAULT 'sealed',
				sealed_payload TEXT NOT NULL,
				sealed_key TEXT NOT NULL,
				kms_key_id TEXT,
				s3_key TEXT,
				storage_bytes BIGINT NOT NULL DEFAULT 0,
				sealed_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
				revoked_at TIMESTAMPTZ,
				created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
			);
			CREATE INDEX IF NOT EXISTS idx_memory_box_user ON memory_box(user_id, sealed_at DESC);
			CREATE TABLE IF NOT EXISTS gdpr_export_jobs (
				id UUID PRIMARY KEY,
				user_id UUID NOT NULL,
				status TEXT NOT NULL,
				estimated_ready_at TIMESTAMPTZ NOT NULL,
				created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
			);`,
		)
	})
}

func (h *Handler) RegisterRoutes(rg *gin.RouterGroup) {
	rg.GET("/vault", h.listVault)
	rg.POST("/seal", h.sealMemory)
	rg.POST("/revoke", h.revokeTrigger)
	rg.GET("/vault/:id", h.getVaultItem)
	rg.POST("/export", h.requestExport)
}

// GET /api/v1/memories/vault
func (h *Handler) listVault(c *gin.Context) {
	h.ensureSchema()
	userID, ok := middleware.GetUserID(c)
	if !ok {
		c.JSON(http.StatusUnauthorized, gin.H{"error": "unauthorized"})
		return
	}
	uid, _ := uuid.Parse(userID)

	rows, err := h.db.Query(c.Request.Context(), `
		SELECT memory_id, status, trigger_type, recipient_id, sealed_at, storage_bytes
		FROM memory_box
		WHERE user_id = $1
		ORDER BY sealed_at DESC
		LIMIT 100
	`, uid)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "failed to list vault"})
		return
	}
	defer rows.Close()

	items := make([]gin.H, 0)
	var totalBytes int64
	for rows.Next() {
		var memoryID, status, triggerType string
		var recipientID *uuid.UUID
		var sealedAt time.Time
		var storageBytes int64
		if err := rows.Scan(&memoryID, &status, &triggerType, &recipientID, &sealedAt, &storageBytes); err != nil {
			c.JSON(http.StatusInternalServerError, gin.H{"error": "failed to parse vault rows"})
			return
		}
		totalBytes += storageBytes
		item := gin.H{
			"memory_id":     memoryID,
			"status":        status,
			"trigger_type":  triggerType,
			"sealed_at":     sealedAt.Format(time.RFC3339),
			"storage_bytes": storageBytes,
		}
		if recipientID != nil {
			item["recipient_id"] = recipientID.String()
		}
		items = append(items, item)
	}
	c.JSON(http.StatusOK, gin.H{
		"data": gin.H{"items": items},
		"meta": gin.H{"user_id": uid.String(), "storage_used": totalBytes},
	})
}

// POST /api/v1/memories/seal
func (h *Handler) sealMemory(c *gin.Context) {
	h.ensureSchema()
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

	triggerType, _ := req.TriggerConfig["type"].(string)
	if triggerType == "" {
		triggerType = "manual"
	}
	boxID := uuid.New()
	now := time.Now().UTC()

	plaintext := fmt.Sprintf("memory:%s|owner:%s|recipient:%s|sealed_at:%s", req.MemoryID, uid.String(), req.RecipientID, now.Format(time.RFC3339))
	sealedPayload, sealedKey, kmsKeyID, err := sealPayload([]byte(plaintext))
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "failed to seal memory"})
		return
	}
	triggerJSON, _ := json.Marshal(req.TriggerConfig)
	recID, recErr := uuid.Parse(req.RecipientID)
	if recErr != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "invalid recipient_id"})
		return
	}
	s3Key := fmt.Sprintf("memory-box/%s/%s.sealed", uid.String(), boxID.String())

	_, err = h.db.Exec(c.Request.Context(), `
		INSERT INTO memory_box (
			id, memory_id, user_id, recipient_id, trigger_type, trigger_config,
			sealed_payload, sealed_key, kms_key_id, s3_key, storage_bytes, sealed_at
		) VALUES ($1,$2,$3,$4,$5,$6::jsonb,$7,$8,$9,$10,$11,$12)
	`, boxID, req.MemoryID, uid, recID, triggerType, string(triggerJSON), sealedPayload, sealedKey, kmsKeyID, s3Key, len(sealedPayload), now)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "failed to persist sealed memory"})
		return
	}
	c.JSON(http.StatusCreated, gin.H{
		"data": gin.H{
			"memory_id":    req.MemoryID,
			"sealed_at":    now.Format(time.RFC3339),
			"trigger_type": triggerType,
			"recipient_id": req.RecipientID,
			"user_id":      uid.String(),
			"box_id":       boxID.String(),
			"s3_key":       s3Key,
		},
	})
}

// POST /api/v1/memories/revoke
func (h *Handler) revokeTrigger(c *gin.Context) {
	h.ensureSchema()
	uid, ok := middleware.GetUserID(c)
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
	ownerID, parseErr := uuid.Parse(uid)
	if parseErr != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "invalid user id"})
		return
	}
	cmd, err := h.db.Exec(c.Request.Context(), `
		UPDATE memory_box
		SET trigger_revoked = TRUE, revoked_at = NOW(), trigger_type = 'revoked'
		WHERE memory_id = $1 AND user_id = $2
	`, req.MemoryID, ownerID)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "failed to revoke trigger"})
		return
	}
	if cmd.RowsAffected() == 0 {
		c.JSON(http.StatusNotFound, gin.H{"error": "sealed memory not found"})
		return
	}
	c.JSON(http.StatusOK, gin.H{"status": "trigger_revoked"})
}

// GET /api/v1/memories/vault/:id
func (h *Handler) getVaultItem(c *gin.Context) {
	h.ensureSchema()
	uid, ok := middleware.GetUserID(c)
	if !ok {
		c.JSON(http.StatusUnauthorized, gin.H{"error": "unauthorized"})
		return
	}
	ownerID, parseErr := uuid.Parse(uid)
	if parseErr != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "invalid user id"})
		return
	}
	var memoryID, status, triggerType, s3Key string
	var recipientID *uuid.UUID
	var sealedAt time.Time
	err := h.db.QueryRow(c.Request.Context(), `
		SELECT memory_id, status, trigger_type, recipient_id, s3_key, sealed_at
		FROM memory_box
		WHERE id = $1 AND user_id = $2
	`, c.Param("id"), ownerID).Scan(&memoryID, &status, &triggerType, &recipientID, &s3Key, &sealedAt)
	if err != nil {
		c.JSON(http.StatusNotFound, gin.H{"error": "vault item not found"})
		return
	}
	c.JSON(http.StatusOK, gin.H{
		"data": gin.H{
			"id":           c.Param("id"),
			"memory_id":    memoryID,
			"status":       status,
			"trigger_type": triggerType,
			"s3_key":       s3Key,
			"sealed_at":    sealedAt.Format(time.RFC3339),
		},
	})
}

// POST /api/v1/memories/export
func (h *Handler) requestExport(c *gin.Context) {
	h.ensureSchema()
	userID, ok := middleware.GetUserID(c)
	if !ok {
		c.JSON(http.StatusUnauthorized, gin.H{"error": "unauthorized"})
		return
	}
	uid, parseErr := uuid.Parse(userID)
	if parseErr != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "invalid user id"})
		return
	}
	exportID := uuid.New()
	estimated := time.Now().UTC().Add(24 * time.Hour)
	_, err := h.db.Exec(c.Request.Context(), `
		INSERT INTO gdpr_export_jobs (id, user_id, status, estimated_ready_at)
		VALUES ($1, $2, 'queued', $3)
	`, exportID, uid, estimated)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "failed to queue export"})
		return
	}
	c.JSON(http.StatusAccepted, gin.H{
		"data": gin.H{
			"export_id":          exportID.String(),
			"user_id":            userID,
			"estimated_ready_at": estimated.Format(time.RFC3339),
		},
	})
}

func sealPayload(plaintext []byte) (string, string, string, error) {
	dataKey := make([]byte, 32)
	if _, err := io.ReadFull(rand.Reader, dataKey); err != nil {
		return "", "", "", err
	}
	block, err := aes.NewCipher(dataKey)
	if err != nil {
		return "", "", "", err
	}
	gcm, err := cipher.NewGCM(block)
	if err != nil {
		return "", "", "", err
	}
	nonce := make([]byte, gcm.NonceSize())
	if _, err := io.ReadFull(rand.Reader, nonce); err != nil {
		return "", "", "", err
	}
	ciphertext := gcm.Seal(nil, nonce, plaintext, nil)
	sealedPayload := base64.StdEncoding.EncodeToString(append(nonce, ciphertext...))

	masterKey := os.Getenv("MEMORY_BOX_MASTER_KEY")
	if masterKey == "" {
		masterKey = "local-dev-kms-key"
	}
	wrapper, err := aes.NewCipher(normalizeKey([]byte(masterKey)))
	if err != nil {
		return "", "", "", err
	}
	wrapperGCM, err := cipher.NewGCM(wrapper)
	if err != nil {
		return "", "", "", err
	}
	wrapNonce := make([]byte, wrapperGCM.NonceSize())
	if _, err := io.ReadFull(rand.Reader, wrapNonce); err != nil {
		return "", "", "", err
	}
	wrapped := wrapperGCM.Seal(nil, wrapNonce, dataKey, nil)
	sealedKey := base64.StdEncoding.EncodeToString(append(wrapNonce, wrapped...))

	return sealedPayload, sealedKey, os.Getenv("MEMORY_BOX_KMS_KEY_ID"), nil
}

func normalizeKey(src []byte) []byte {
	key := make([]byte, 32)
	for i := 0; i < len(key); i++ {
		key[i] = src[i%len(src)]
	}
	return key
}
