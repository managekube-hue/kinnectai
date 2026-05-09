package interaction

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

var ensureInteractionSchemaOnce sync.Once

func (h *Handler) ensureSchema() {
	ensureInteractionSchemaOnce.Do(func() {
		_, _ = h.db.Exec(context.Background(), `
			CREATE TABLE IF NOT EXISTS interaction_events (
				id UUID PRIMARY KEY,
				user_id UUID NOT NULL,
				memory_id UUID NOT NULL,
				action TEXT NOT NULL,
				event_time TIMESTAMPTZ NOT NULL DEFAULT NOW(),
				payload JSONB
			);
			CREATE INDEX IF NOT EXISTS idx_interaction_events_memory ON interaction_events(memory_id, event_time DESC);
			CREATE TABLE IF NOT EXISTS interaction_comments (
				id UUID PRIMARY KEY,
				memory_id UUID NOT NULL,
				user_id UUID NOT NULL,
				text TEXT NOT NULL,
				reply_to_id UUID,
				kin_score DOUBLE PRECISION NOT NULL DEFAULT 0,
				created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
			);
			CREATE INDEX IF NOT EXISTS idx_interaction_comments_memory_score ON interaction_comments(memory_id, kin_score DESC, created_at DESC);
		`)
	})
}

func (h *Handler) RegisterRoutes(rg *gin.RouterGroup) {
	rg.POST("/pulse/add", h.addPulse)
	rg.POST("/pulse/remove", h.removePulse)
	rg.GET("/comments/:memoryId", h.getComments)
	rg.POST("/comments", h.addComment)
	rg.POST("/share", h.shareMemory)
	rg.POST("/repost", h.repostMemory)
	rg.POST("/strands/add", h.addToStrand)
	rg.POST("/strands/remove", h.removeFromStrand)
}

func (h *Handler) addPulse(c *gin.Context) {
	h.ensureSchema()
	userID, ok := middleware.GetUserID(c)
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
	uid, uErr := uuid.Parse(userID)
	memID, mErr := uuid.Parse(req.MemoryID)
	if uErr != nil || mErr != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "invalid user_id or memory_id"})
		return
	}
	_, err := h.db.Exec(c.Request.Context(), `
		INSERT INTO interaction_events (id, user_id, memory_id, action, event_time, payload)
		VALUES ($1,$2,$3,'pulse_add',$4,$5::jsonb)
	`, uuid.New(), uid, memID, time.Now().UTC(), `{}`)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "failed to write interaction event"})
		return
	}
	c.JSON(http.StatusOK, gin.H{"status": "pulsed", "user_id": userID})
}

func (h *Handler) removePulse(c *gin.Context) {
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
	c.JSON(http.StatusOK, gin.H{"status": "unpulsed"})
}

func (h *Handler) getComments(c *gin.Context) {
	h.ensureSchema()
	_, ok := middleware.GetUserID(c)
	if !ok {
		c.JSON(http.StatusUnauthorized, gin.H{"error": "unauthorized"})
		return
	}
	memoryID := c.Param("memoryId")
	sort := c.DefaultQuery("sort", "kin_score")
	rows, err := h.db.Query(c.Request.Context(), `
		SELECT id, user_id, text, reply_to_id, kin_score, created_at
		FROM interaction_comments
		WHERE memory_id = $1
		ORDER BY kin_score DESC, created_at DESC
		LIMIT 100
	`, memoryID)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "failed to load comments"})
		return
	}
	defer rows.Close()
	items := make([]gin.H, 0)
	for rows.Next() {
		var id, userID, text string
		var replyTo *string
		var kinScore float64
		var createdAt time.Time
		if scanErr := rows.Scan(&id, &userID, &text, &replyTo, &kinScore, &createdAt); scanErr != nil {
			c.JSON(http.StatusInternalServerError, gin.H{"error": "failed to parse comments"})
			return
		}
		item := gin.H{"id": id, "user_id": userID, "text": text, "kin_score": kinScore, "created_at": createdAt.Format(time.RFC3339)}
		if replyTo != nil {
			item["reply_to_id"] = *replyTo
		}
		items = append(items, item)
	}
	c.JSON(http.StatusOK, gin.H{
		"items":     items,
		"memory_id": memoryID,
		"sort":      sort,
	})
}

func (h *Handler) addComment(c *gin.Context) {
	h.ensureSchema()
	userID, ok := middleware.GetUserID(c)
	if !ok {
		c.JSON(http.StatusUnauthorized, gin.H{"error": "unauthorized"})
		return
	}
	var req struct {
		MemoryID  string `json:"memory_id" binding:"required"`
		Text      string `json:"text" binding:"required"`
		ReplyToID string `json:"reply_to_id"`
	}
	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}
	uid, uErr := uuid.Parse(userID)
	memID, mErr := uuid.Parse(req.MemoryID)
	if uErr != nil || mErr != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "invalid user_id or memory_id"})
		return
	}
	commentID := uuid.New()
	_, err := h.db.Exec(c.Request.Context(), `
		INSERT INTO interaction_comments (id, memory_id, user_id, text, reply_to_id, kin_score)
		VALUES ($1,$2,$3,$4,NULLIF($5,'')::uuid,0)
	`, commentID, memID, uid, req.Text, req.ReplyToID)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "failed to add comment"})
		return
	}
	c.JSON(http.StatusCreated, gin.H{
		"id":        commentID.String(),
		"user_id":   userID,
		"memory_id": req.MemoryID,
		"text":      req.Text,
	})
}

func (h *Handler) shareMemory(c *gin.Context) {
	_, ok := middleware.GetUserID(c)
	if !ok {
		c.JSON(http.StatusUnauthorized, gin.H{"error": "unauthorized"})
		return
	}
	c.JSON(http.StatusOK, gin.H{"status": "shared"})
}

func (h *Handler) repostMemory(c *gin.Context) {
	_, ok := middleware.GetUserID(c)
	if !ok {
		c.JSON(http.StatusUnauthorized, gin.H{"error": "unauthorized"})
		return
	}
	c.JSON(http.StatusOK, gin.H{"status": "reposted"})
}

func (h *Handler) addToStrand(c *gin.Context) {
	_, ok := middleware.GetUserID(c)
	if !ok {
		c.JSON(http.StatusUnauthorized, gin.H{"error": "unauthorized"})
		return
	}
	c.JSON(http.StatusOK, gin.H{"status": "added_to_strand"})
}

func (h *Handler) removeFromStrand(c *gin.Context) {
	_, ok := middleware.GetUserID(c)
	if !ok {
		c.JSON(http.StatusUnauthorized, gin.H{"error": "unauthorized"})
		return
	}
	c.JSON(http.StatusOK, gin.H{"status": "removed_from_strand"})
}
