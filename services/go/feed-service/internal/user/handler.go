package user

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
	rg.GET("/me", h.getMe)
	rg.PATCH("/me", h.updateMe)
	rg.GET("/:id", h.getProfile)
	rg.GET("/surname-map", h.surnameMap)
}

// GET /api/v1/users/me
func (h *Handler) getMe(c *gin.Context) {
	userID, ok := middleware.GetUserID(c)
	if !ok {
		c.JSON(http.StatusUnauthorized, gin.H{"error": "unauthorized"})
		return
	}
	uid, err := uuid.Parse(userID)
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "invalid user id"})
		return
	}
	profile, err := h.service.GetProfile(c.Request.Context(), uid)
	if err != nil {
		c.JSON(http.StatusNotFound, gin.H{"error": "user not found"})
		return
	}
	c.JSON(http.StatusOK, profile)
}

// PATCH /api/v1/users/me
func (h *Handler) updateMe(c *gin.Context) {
	userID, ok := middleware.GetUserID(c)
	if !ok {
		c.JSON(http.StatusUnauthorized, gin.H{"error": "unauthorized"})
		return
	}
	uid, _ := uuid.Parse(userID)

	var req UpdateProfileRequest
	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	profile, err := h.service.UpdateProfile(c.Request.Context(), uid, req)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "update failed"})
		return
	}
	c.JSON(http.StatusOK, profile)
}

// GET /api/v1/users/:id
func (h *Handler) getProfile(c *gin.Context) {
	uid, err := uuid.Parse(c.Param("id"))
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "invalid user id"})
		return
	}
	profile, err := h.service.GetProfile(c.Request.Context(), uid)
	if err != nil {
		c.JSON(http.StatusNotFound, gin.H{"error": "user not found"})
		return
	}
	c.JSON(http.StatusOK, profile)
}

// GET /api/v1/users/surname-map?surname=O'Sullivan
func (h *Handler) surnameMap(c *gin.Context) {
	surname := c.Query("surname")
	if surname == "" {
		c.JSON(http.StatusBadRequest, gin.H{"error": "surname query param required"})
		return
	}
	result, err := h.service.SurnameMap(c.Request.Context(), surname)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "surname map failed"})
		return
	}
	c.JSON(http.StatusOK, result)
}
