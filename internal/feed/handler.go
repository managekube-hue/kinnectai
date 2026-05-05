package feed

import (
	"net/http"
	"strconv"

	"github.com/gin-gonic/gin"
	"github.com/google/uuid"
	"github.com/kinnectai/backend/pkg/middleware"
)

type Handler struct {
	service *Service
}

func NewHandler(service *Service) *Handler {
	return &Handler{service: service}
}

func (h *Handler) RegisterRoutes(rg *gin.RouterGroup) {
	rg.GET("/line", h.getLine)
	rg.POST("/memories", h.createMemory)
	rg.POST("/memories/:id/pulse", h.pulseMemory)
}

// GET /api/v1/feed/line?page=1
func (h *Handler) getLine(c *gin.Context) {
	viewerID, ok := middleware.GetUserID(c)
	if !ok {
		c.JSON(http.StatusUnauthorized, gin.H{"error": "unauthorized"})
		return
	}
	uid, _ := uuid.Parse(viewerID)

	page, _ := strconv.Atoi(c.DefaultQuery("page", "1"))

	resp, err := h.service.GetLine(c.Request.Context(), uid, page)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "feed unavailable"})
		return
	}
	c.JSON(http.StatusOK, resp)
}

// POST /api/v1/feed/memories
func (h *Handler) createMemory(c *gin.Context) {
	creatorID, ok := middleware.GetUserID(c)
	if !ok {
		c.JSON(http.StatusUnauthorized, gin.H{"error": "unauthorized"})
		return
	}
	uid, _ := uuid.Parse(creatorID)

	var req CreateMemoryRequest
	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	item, err := h.service.CreateMemory(c.Request.Context(), uid, req)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "post failed"})
		return
	}
	c.JSON(http.StatusCreated, item)
}

// POST /api/v1/feed/memories/:id/pulse
func (h *Handler) pulseMemory(c *gin.Context) {
	userID, ok := middleware.GetUserID(c)
	if !ok {
		c.JSON(http.StatusUnauthorized, gin.H{"error": "unauthorized"})
		return
	}
	uid, _ := uuid.Parse(userID)
	memID, err := uuid.Parse(c.Param("id"))
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "invalid memory id"})
		return
	}

	pulseType := c.DefaultQuery("type", "pulse")
	if err := h.service.PulseMemory(c.Request.Context(), uid, memID, pulseType); err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "pulse failed"})
		return
	}
	c.JSON(http.StatusOK, gin.H{"status": "pulsed"})
}
