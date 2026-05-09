package messaging

import (
	"net/http"

	"github.com/gin-gonic/gin"
	"github.com/google/uuid"
	"github.com/kinnectai/backend/pkg/middleware"
)

type Handler struct{}

func NewHandler() *Handler { return &Handler{} }

func (h *Handler) RegisterRoutes(rg *gin.RouterGroup) {
	rg.GET("/threads", h.listThreads)
	rg.GET("/threads/:threadId", h.getMessages)
	rg.POST("", h.sendMessage)
	rg.DELETE("/:messageId", h.deleteMessage)
	rg.POST("/threads/:threadId/read", h.markRead)
}

func (h *Handler) listThreads(c *gin.Context) {
	_, ok := middleware.GetUserID(c)
	if !ok {
		c.JSON(http.StatusUnauthorized, gin.H{"error": "unauthorized"})
		return
	}
	c.JSON(http.StatusOK, gin.H{"items": []interface{}{}})
}

func (h *Handler) getMessages(c *gin.Context) {
	_, ok := middleware.GetUserID(c)
	if !ok {
		c.JSON(http.StatusUnauthorized, gin.H{"error": "unauthorized"})
		return
	}
	c.JSON(http.StatusOK, gin.H{
		"items":     []interface{}{},
		"thread_id": c.Param("threadId"),
	})
}

func (h *Handler) sendMessage(c *gin.Context) {
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
	// TODO: Store encrypted payload in S3, metadata in Postgres
	c.JSON(http.StatusCreated, gin.H{
		"message_id":      uuid.New().String(),
		"server_timestamp": "2026-05-09T01:00:00Z",
		"delivery_status": "sent",
		"sender_id":       userID,
	})
}

func (h *Handler) deleteMessage(c *gin.Context) {
	_, ok := middleware.GetUserID(c)
	if !ok {
		c.JSON(http.StatusUnauthorized, gin.H{"error": "unauthorized"})
		return
	}
	// TODO: Cryptographic key shred + tombstone marker
	c.JSON(http.StatusOK, gin.H{"status": "deleted", "message_id": c.Param("messageId")})
}

func (h *Handler) markRead(c *gin.Context) {
	_, ok := middleware.GetUserID(c)
	if !ok {
		c.JSON(http.StatusUnauthorized, gin.H{"error": "unauthorized"})
		return
	}
	c.JSON(http.StatusOK, gin.H{"status": "read", "thread_id": c.Param("threadId")})
}
