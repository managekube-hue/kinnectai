package graph

import (
	"net/http"

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
	rg.GET("/kin-score/:targetID", h.getKinScore)
	rg.POST("/kinnections", h.requestKinnection)
	rg.PATCH("/kinnections/:id/confirm", h.confirmKinnection)
}

// GET /api/v1/graph/kin-score/:targetID
func (h *Handler) getKinScore(c *gin.Context) {
	requesterID, ok := middleware.GetUserID(c)
	if !ok {
		c.JSON(http.StatusUnauthorized, gin.H{"error": "unauthorized"})
		return
	}
	targetID := c.Param("targetID")

	aUID, err := uuid.Parse(requesterID)
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "invalid requester id"})
		return
	}
	bUID, err := uuid.Parse(targetID)
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "invalid target id"})
		return
	}

	result, err := h.service.GetKinScore(c.Request.Context(), aUID, bUID)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "kin score computation failed"})
		return
	}
	c.JSON(http.StatusOK, result)
}

// POST /api/v1/graph/kinnections
func (h *Handler) requestKinnection(c *gin.Context) {
	requesterID, ok := middleware.GetUserID(c)
	if !ok {
		c.JSON(http.StatusUnauthorized, gin.H{"error": "unauthorized"})
		return
	}
	uid, _ := uuid.Parse(requesterID)

	var req KinnectionRequest
	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	resp, err := h.service.RequestKinnection(c.Request.Context(), uid, req)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "request failed"})
		return
	}
	c.JSON(http.StatusCreated, resp)
}

// PATCH /api/v1/graph/kinnections/:id/confirm
func (h *Handler) confirmKinnection(c *gin.Context) {
	userID, ok := middleware.GetUserID(c)
	if !ok {
		c.JSON(http.StatusUnauthorized, gin.H{"error": "unauthorized"})
		return
	}
	kinnectionID, err := uuid.Parse(c.Param("id"))
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "invalid kinnection id"})
		return
	}
	uid, _ := uuid.Parse(userID)

	resp, err := h.service.ConfirmKinnection(c.Request.Context(), kinnectionID, uid)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "confirm failed"})
		return
	}
	c.JSON(http.StatusOK, resp)
}
