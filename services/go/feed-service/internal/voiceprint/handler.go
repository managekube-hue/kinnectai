package voiceprint

import (
	"net/http"

	"github.com/gin-gonic/gin"
	"github.com/google/uuid"
	"github.com/kinnectai/backend/pkg/middleware"
)

type Handler struct{}

func NewHandler() *Handler { return &Handler{} }

func (h *Handler) RegisterRoutes(rg *gin.RouterGroup) {
	rg.POST("", h.create)
	rg.GET("", h.list)
	rg.DELETE("/:id/revoke", h.revoke)
	rg.DELETE("/:id", h.delete)
}

// POST /api/v1/voiceprints
func (h *Handler) create(c *gin.Context) {
	userID, ok := middleware.GetUserID(c)
	if !ok {
		c.JSON(http.StatusUnauthorized, gin.H{"error": "unauthorized"})
		return
	}
	// TODO: Accept multipart audio, forward to ElevenLabs, store clone_id + embedding
	c.JSON(http.StatusCreated, gin.H{
		"voiceprint_id":      uuid.New().String(),
		"elevenlabs_clone_id": "clone_placeholder",
		"embedding":          make([]float64, 256),
		"user_id":            userID,
	})
}

// GET /api/v1/voiceprints
func (h *Handler) list(c *gin.Context) {
	userID, ok := middleware.GetUserID(c)
	if !ok {
		c.JSON(http.StatusUnauthorized, gin.H{"error": "unauthorized"})
		return
	}
	c.JSON(http.StatusOK, gin.H{
		"items":   []interface{}{},
		"user_id": userID,
	})
}

// DELETE /api/v1/voiceprints/:id/revoke
func (h *Handler) revoke(c *gin.Context) {
	_, ok := middleware.GetUserID(c)
	if !ok {
		c.JSON(http.StatusUnauthorized, gin.H{"error": "unauthorized"})
		return
	}
	// TODO: DELETE to ElevenLabs /v1/voices/{voice_id}, mark deleted in pgvector
	c.JSON(http.StatusOK, gin.H{"status": "revocation_confirmed", "id": c.Param("id")})
}

// DELETE /api/v1/voiceprints/:id
func (h *Handler) delete(c *gin.Context) {
	_, ok := middleware.GetUserID(c)
	if !ok {
		c.JSON(http.StatusUnauthorized, gin.H{"error": "unauthorized"})
		return
	}
	c.JSON(http.StatusOK, gin.H{"status": "deleted", "id": c.Param("id")})
}
