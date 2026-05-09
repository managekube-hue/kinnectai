package room

import (
	"net/http"

	"github.com/gin-gonic/gin"
	"github.com/google/uuid"
	"github.com/kinnectai/backend/pkg/middleware"
)

type Handler struct{}

func NewHandler() *Handler { return &Handler{} }

func (h *Handler) RegisterRoutes(rg *gin.RouterGroup) {
	rg.POST("", h.createRoom)
	rg.GET("/active", h.listActive)
	rg.GET("/scheduled", h.listScheduled)
	rg.POST("/:id/join", h.joinRoom)
	rg.POST("/:id/leave", h.leaveRoom)
	rg.GET("/:id", h.getRoomDetails)
	rg.POST("/:id/recording/start", h.startRecording)
	rg.POST("/:id/recording/stop", h.stopRecording)
	rg.POST("/:id/live", h.goLive)
	rg.POST("/:id/participants/:pid/mute", h.muteParticipant)
	rg.POST("/:id/participants/:pid/remove", h.removeParticipant)
}

func (h *Handler) createRoom(c *gin.Context) {
	userID, ok := middleware.GetUserID(c)
	if !ok {
		c.JSON(http.StatusUnauthorized, gin.H{"error": "unauthorized"})
		return
	}
	var req struct {
		Name         string   `json:"name" binding:"required"`
		IsPrivate    bool     `json:"is_private"`
		KinScoreGate *float64 `json:"kin_score_gate"`
		InvitedKinIDs []string `json:"invited_kin_ids"`
	}
	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}
	c.JSON(http.StatusCreated, gin.H{
		"room_id":      uuid.New().String(),
		"name":         req.Name,
		"originator":   userID,
		"sfu_token":    "placeholder_mediasoup_token",
	})
}

func (h *Handler) listActive(c *gin.Context) {
	_, ok := middleware.GetUserID(c)
	if !ok {
		c.JSON(http.StatusUnauthorized, gin.H{"error": "unauthorized"})
		return
	}
	c.JSON(http.StatusOK, gin.H{"items": []interface{}{}})
}

func (h *Handler) listScheduled(c *gin.Context) {
	_, ok := middleware.GetUserID(c)
	if !ok {
		c.JSON(http.StatusUnauthorized, gin.H{"error": "unauthorized"})
		return
	}
	c.JSON(http.StatusOK, gin.H{"items": []interface{}{}})
}

func (h *Handler) joinRoom(c *gin.Context) {
	_, ok := middleware.GetUserID(c)
	if !ok {
		c.JSON(http.StatusUnauthorized, gin.H{"error": "unauthorized"})
		return
	}
	c.JSON(http.StatusOK, gin.H{"room_id": c.Param("id"), "sfu_token": "placeholder"})
}

func (h *Handler) leaveRoom(c *gin.Context) {
	_, ok := middleware.GetUserID(c)
	if !ok {
		c.JSON(http.StatusUnauthorized, gin.H{"error": "unauthorized"})
		return
	}
	c.JSON(http.StatusOK, gin.H{"status": "left"})
}

func (h *Handler) getRoomDetails(c *gin.Context) {
	_, ok := middleware.GetUserID(c)
	if !ok {
		c.JSON(http.StatusUnauthorized, gin.H{"error": "unauthorized"})
		return
	}
	c.JSON(http.StatusOK, gin.H{"room_id": c.Param("id"), "participants": []interface{}{}})
}

func (h *Handler) startRecording(c *gin.Context) {
	_, ok := middleware.GetUserID(c)
	if !ok {
		c.JSON(http.StatusUnauthorized, gin.H{"error": "unauthorized"})
		return
	}
	c.JSON(http.StatusOK, gin.H{"recording_id": uuid.New().String(), "status": "recording"})
}

func (h *Handler) stopRecording(c *gin.Context) {
	_, ok := middleware.GetUserID(c)
	if !ok {
		c.JSON(http.StatusUnauthorized, gin.H{"error": "unauthorized"})
		return
	}
	c.JSON(http.StatusOK, gin.H{"status": "stopped"})
}

func (h *Handler) goLive(c *gin.Context) {
	_, ok := middleware.GetUserID(c)
	if !ok {
		c.JSON(http.StatusUnauthorized, gin.H{"error": "unauthorized"})
		return
	}
	c.JSON(http.StatusOK, gin.H{"status": "live", "hls_url": "placeholder"})
}

func (h *Handler) muteParticipant(c *gin.Context) {
	_, ok := middleware.GetUserID(c)
	if !ok {
		c.JSON(http.StatusUnauthorized, gin.H{"error": "unauthorized"})
		return
	}
	c.JSON(http.StatusOK, gin.H{"status": "muted", "participant": c.Param("pid")})
}

func (h *Handler) removeParticipant(c *gin.Context) {
	_, ok := middleware.GetUserID(c)
	if !ok {
		c.JSON(http.StatusUnauthorized, gin.H{"error": "unauthorized"})
		return
	}
	c.JSON(http.StatusOK, gin.H{"status": "removed", "participant": c.Param("pid")})
}
