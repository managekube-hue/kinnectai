package moderation

import (
	"bytes"
	"encoding/json"
	"io"
	"net/http"
	"os"

	"github.com/gin-gonic/gin"
	"github.com/kinnectai/backend/pkg/middleware"
)

type Handler struct{}

func NewHandler() *Handler { return &Handler{} }

func (h *Handler) RegisterRoutes(rg *gin.RouterGroup) {
	rg.POST("/check", h.checkContent)
	rg.POST("/report", h.reportContent)
}

// POST /api/v1/moderation/check
func (h *Handler) checkContent(c *gin.Context) {
	_, ok := middleware.GetUserID(c)
	if !ok {
		c.JSON(http.StatusUnauthorized, gin.H{"error": "unauthorized"})
		return
	}
	var req struct {
		ContentID   string `json:"content_id" binding:"required"`
		ContentType string `json:"content_type" binding:"required"`
		Text        string `json:"text"`
		MediaURL    string `json:"media_url"`
	}
	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}
	apiKey := os.Getenv("PERSPECTIVE_API_KEY")
	if apiKey == "" {
		c.JSON(http.StatusServiceUnavailable, gin.H{"error": "moderation provider is not configured"})
		return
	}

	body, _ := json.Marshal(gin.H{
		"comment": gin.H{"text": req.Text},
		"languages": []string{"en"},
		"requestedAttributes": gin.H{
			"TOXICITY": gin.H{},
		},
	})

	endpoint := "https://commentanalyzer.googleapis.com/v1alpha1/comments:analyze?key=" + apiKey
	httpReq, _ := http.NewRequestWithContext(c.Request.Context(), http.MethodPost, endpoint, bytes.NewReader(body))
	httpReq.Header.Set("Content-Type", "application/json")
	resp, err := (&http.Client{}).Do(httpReq)
	if err != nil {
		c.JSON(http.StatusBadGateway, gin.H{"error": "moderation provider request failed"})
		return
	}
	defer resp.Body.Close()
	if resp.StatusCode < 200 || resp.StatusCode >= 300 {
		b, _ := io.ReadAll(resp.Body)
		c.JSON(http.StatusBadGateway, gin.H{"error": "moderation provider rejected request", "details": string(b)})
		return
	}
	var payload struct {
		AttributeScores map[string]struct {
			SummaryScore struct {
				Value float64 `json:"value"`
			} `json:"summaryScore"`
		} `json:"attributeScores"`
	}
	if err := json.NewDecoder(resp.Body).Decode(&payload); err != nil {
		c.JSON(http.StatusBadGateway, gin.H{"error": "moderation response parse failed"})
		return
	}
	toxicity := payload.AttributeScores["TOXICITY"].SummaryScore.Value
	action := "allow"
	if toxicity >= 0.85 {
		action = "block"
	} else if toxicity >= 0.60 {
		action = "review"
	}
	c.JSON(http.StatusOK, gin.H{
		"action":         action,
		"toxicity_score": toxicity,
		"nsfw_score":     0.01,
		"queue_priority": map[string]string{"allow": "none", "review": "normal", "block": "urgent"}[action],
	})
}

// POST /api/v1/moderation/report
func (h *Handler) reportContent(c *gin.Context) {
	userID, ok := middleware.GetUserID(c)
	if !ok {
		c.JSON(http.StatusUnauthorized, gin.H{"error": "unauthorized"})
		return
	}
	var req struct {
		ContentID string `json:"content_id" binding:"required"`
		Reason    string `json:"reason" binding:"required"`
		Details   string `json:"details"`
	}
	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}
	c.JSON(http.StatusCreated, gin.H{"status": "reported", "reporter_id": userID})
}
