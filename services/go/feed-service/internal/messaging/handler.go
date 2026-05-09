package messaging

import (
	"context"
	"fmt"
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

var ensureMessagingSchemaOnce sync.Once

func (h *Handler) ensureSchema() {
	ensureMessagingSchemaOnce.Do(func() {
		_, _ = h.db.Exec(context.Background(), `
			CREATE TABLE IF NOT EXISTS message_threads (
				id UUID PRIMARY KEY,
				created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
				updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
			);
			CREATE TABLE IF NOT EXISTS messages (
				id UUID PRIMARY KEY,
				thread_id UUID NOT NULL,
				sender_id UUID NOT NULL,
				sender_device_id INT,
				encrypted_payload TEXT,
				s3_key TEXT,
				key_state TEXT NOT NULL DEFAULT 'active',
				tombstone BOOLEAN NOT NULL DEFAULT FALSE,
				created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
				deleted_at TIMESTAMPTZ,
				read_at TIMESTAMPTZ
			);
			CREATE INDEX IF NOT EXISTS idx_messages_thread_created ON messages(thread_id, created_at DESC);
		`)
	})
}

func (h *Handler) RegisterRoutes(rg *gin.RouterGroup) {
	rg.GET("/threads", h.listThreads)
	rg.GET("/threads/:threadId", h.getMessages)
	rg.POST("", h.sendMessage)
	rg.DELETE("/:messageId", h.deleteMessage)
	rg.POST("/threads/:threadId/read", h.markRead)
}

func (h *Handler) listThreads(c *gin.Context) {
	h.ensureSchema()
	uid, ok := middleware.GetUserID(c)
	if !ok {
		c.JSON(http.StatusUnauthorized, gin.H{"error": "unauthorized"})
		return
	}
	rows, err := h.db.Query(c.Request.Context(), `
		SELECT thread_id, MAX(created_at) as last_message_at, COUNT(*) as message_count
		FROM messages
		WHERE sender_id = $1::uuid
		GROUP BY thread_id
		ORDER BY MAX(created_at) DESC
		LIMIT 100
	`, uid)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "failed to list threads"})
		return
	}
	defer rows.Close()
	items := make([]gin.H, 0)
	for rows.Next() {
		var threadID string
		var lastMessageAt time.Time
		var messageCount int64
		if scanErr := rows.Scan(&threadID, &lastMessageAt, &messageCount); scanErr != nil {
			c.JSON(http.StatusInternalServerError, gin.H{"error": "failed to parse threads"})
			return
		}
		items = append(items, gin.H{"thread_id": threadID, "last_message_at": lastMessageAt.Format(time.RFC3339), "message_count": messageCount})
	}
	c.JSON(http.StatusOK, gin.H{"items": items})
}

func (h *Handler) getMessages(c *gin.Context) {
	h.ensureSchema()
	_, ok := middleware.GetUserID(c)
	if !ok {
		c.JSON(http.StatusUnauthorized, gin.H{"error": "unauthorized"})
		return
	}
	rows, err := h.db.Query(c.Request.Context(), `
		SELECT id, sender_id, sender_device_id, encrypted_payload, s3_key, key_state, tombstone, created_at, deleted_at
		FROM messages
		WHERE thread_id = $1::uuid
		ORDER BY created_at DESC
		LIMIT 200
	`, c.Param("threadId"))
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "failed to load messages"})
		return
	}
	defer rows.Close()
	items := make([]gin.H, 0)
	for rows.Next() {
		var id, senderID string
		var senderDeviceID *int
		var encryptedPayload, s3Key, keyState *string
		var tombstone bool
		var createdAt time.Time
		var deletedAt *time.Time
		if scanErr := rows.Scan(&id, &senderID, &senderDeviceID, &encryptedPayload, &s3Key, &keyState, &tombstone, &createdAt, &deletedAt); scanErr != nil {
			c.JSON(http.StatusInternalServerError, gin.H{"error": "failed to parse messages"})
			return
		}
		item := gin.H{"id": id, "sender_id": senderID, "tombstone": tombstone, "created_at": createdAt.Format(time.RFC3339)}
		if senderDeviceID != nil {
			item["sender_device_id"] = *senderDeviceID
		}
		if encryptedPayload != nil {
			item["encrypted_payload"] = *encryptedPayload
		}
		if s3Key != nil {
			item["s3_key"] = *s3Key
		}
		if keyState != nil {
			item["key_state"] = *keyState
		}
		if deletedAt != nil {
			item["deleted_at"] = deletedAt.Format(time.RFC3339)
		}
		items = append(items, item)
	}
	c.JSON(http.StatusOK, gin.H{
		"items":     items,
		"thread_id": c.Param("threadId"),
	})
}

func (h *Handler) sendMessage(c *gin.Context) {
	h.ensureSchema()
	userID, ok := middleware.GetUserID(c)
	if !ok {
		c.JSON(http.StatusUnauthorized, gin.H{"error": "unauthorized"})
		return
	}
	var req struct {
		ThreadID         string `json:"thread_id" binding:"required"`
		EncryptedPayload string `json:"encrypted_payload" binding:"required"`
		SenderDeviceID   int    `json:"sender_device_id"`
	}
	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}
	uid, uErr := uuid.Parse(userID)
	threadID, tErr := uuid.Parse(req.ThreadID)
	if uErr != nil || tErr != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "invalid sender or thread id"})
		return
	}
	msgID := uuid.New()
	now := time.Now().UTC()
	s3Key := fmt.Sprintf("messages/%s/%s.enc", req.ThreadID, msgID.String())

	if _, err := h.db.Exec(c.Request.Context(), `
		INSERT INTO message_threads (id, created_at, updated_at)
		VALUES ($1, $2, $2)
		ON CONFLICT (id) DO UPDATE SET updated_at = EXCLUDED.updated_at
	`, threadID, now); err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "failed to upsert thread"})
		return
	}

	_, err := h.db.Exec(c.Request.Context(), `
		INSERT INTO messages (id, thread_id, sender_id, sender_device_id, encrypted_payload, s3_key, key_state, tombstone, created_at)
		VALUES ($1,$2,$3,$4,$5,$6,'active',FALSE,$7)
	`, msgID, threadID, uid, req.SenderDeviceID, req.EncryptedPayload, s3Key, now)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "failed to persist message"})
		return
	}
	c.JSON(http.StatusCreated, gin.H{
		"message_id":      msgID.String(),
		"server_timestamp": now.Format(time.RFC3339),
		"delivery_status": "sent",
		"sender_id":       userID,
		"s3_key":          s3Key,
	})
}

func (h *Handler) deleteMessage(c *gin.Context) {
	h.ensureSchema()
	_, ok := middleware.GetUserID(c)
	if !ok {
		c.JSON(http.StatusUnauthorized, gin.H{"error": "unauthorized"})
		return
	}
	cmd, err := h.db.Exec(c.Request.Context(), `
		UPDATE messages
		SET encrypted_payload = NULL,
			key_state = 'shredded',
			tombstone = TRUE,
			deleted_at = NOW()
		WHERE id = $1::uuid
	`, c.Param("messageId"))
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "failed to delete message"})
		return
	}
	if cmd.RowsAffected() == 0 {
		c.JSON(http.StatusNotFound, gin.H{"error": "message not found"})
		return
	}
	c.JSON(http.StatusOK, gin.H{"status": "deleted", "message_id": c.Param("messageId")})
}

func (h *Handler) markRead(c *gin.Context) {
	h.ensureSchema()
	_, ok := middleware.GetUserID(c)
	if !ok {
		c.JSON(http.StatusUnauthorized, gin.H{"error": "unauthorized"})
		return
	}
	_, _ = h.db.Exec(c.Request.Context(), `UPDATE messages SET read_at = NOW() WHERE thread_id = $1::uuid AND read_at IS NULL`, c.Param("threadId"))
	c.JSON(http.StatusOK, gin.H{"status": "read", "thread_id": c.Param("threadId")})
}
