package interaction

import (
	"net/http"

	"github.com/gin-gonic/gin"
	"github.com/google/uuid"
	"github.com/kinnectai/backend/pkg/middleware"
)

type Handler struct{}

func NewHandler() *Handler { return &Handler{} }

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
	// TODO: Write to Cassandra interactions table
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
	_, ok := middleware.GetUserID(c)
	if !ok {
		c.JSON(http.StatusUnauthorized, gin.H{"error": "unauthorized"})
		return
	}
	memoryID := c.Param("memoryId")
	sort := c.DefaultQuery("sort", "kin_score")
	// TODO: SELECT * FROM comments WHERE memory_id=$1 ORDER BY kin_score DESC
	c.JSON(http.StatusOK, gin.H{
		"items":     []interface{}{},
		"memory_id": memoryID,
		"sort":      sort,
	})
}

func (h *Handler) addComment(c *gin.Context) {
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
	c.JSON(http.StatusCreated, gin.H{
		"id":        uuid.New().String(),
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
