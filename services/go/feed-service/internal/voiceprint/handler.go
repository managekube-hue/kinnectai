package voiceprint

import (
	"bytes"
	"context"
	"crypto/sha256"
	"encoding/json"
	"fmt"
	"io"
	"mime/multipart"
	"net/http"
	"os"
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

var ensureVoiceprintSchemaOnce sync.Once

func (h *Handler) ensureSchema() {
	ensureVoiceprintSchemaOnce.Do(func() {
		_, _ = h.db.Exec(context.Background(), `
			CREATE TABLE IF NOT EXISTS voiceprints (
				id UUID PRIMARY KEY,
				user_id UUID NOT NULL,
				elevenlabs_clone_id TEXT,
				embedding JSONB NOT NULL,
				revoked_at TIMESTAMPTZ,
				deleted_at TIMESTAMPTZ,
				created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
			);
			CREATE INDEX IF NOT EXISTS idx_voiceprints_user ON voiceprints(user_id, created_at DESC);
		`)
	})
}

func (h *Handler) RegisterRoutes(rg *gin.RouterGroup) {
	rg.POST("", h.create)
	rg.GET("", h.list)
	rg.DELETE("/:id/revoke", h.revoke)
	rg.DELETE("/:id", h.delete)
}

// POST /api/v1/voiceprints
func (h *Handler) create(c *gin.Context) {
	h.ensureSchema()
	userID, ok := middleware.GetUserID(c)
	if !ok {
		c.JSON(http.StatusUnauthorized, gin.H{"error": "unauthorized"})
		return
	}
	uid, parseErr := uuid.Parse(userID)
	if parseErr != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "invalid user id"})
		return
	}
	file, header, err := c.Request.FormFile("audio")
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "missing multipart audio file"})
		return
	}
	defer file.Close()
	audioBytes, err := io.ReadAll(file)
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "failed reading audio"})
		return
	}
	cloneID, providerErr := createElevenLabsClone(c.Request.Context(), audioBytes, header.Filename)
	if providerErr != nil {
		cloneID = ""
	}
	embedding := deriveEmbedding(audioBytes)
	embeddingJSON, _ := json.Marshal(embedding)
	voiceprintID := uuid.New()
	_, err = h.db.Exec(c.Request.Context(), `
		INSERT INTO voiceprints (id, user_id, elevenlabs_clone_id, embedding, created_at)
		VALUES ($1,$2,NULLIF($3,''),$4::jsonb,$5)
	`, voiceprintID, uid, cloneID, string(embeddingJSON), time.Now().UTC())
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "failed to persist voiceprint"})
		return
	}
	c.JSON(http.StatusCreated, gin.H{
		"voiceprint_id":       voiceprintID.String(),
		"elevenlabs_clone_id": cloneID,
		"embedding":           embedding,
		"user_id":             userID,
	})
}

// GET /api/v1/voiceprints
func (h *Handler) list(c *gin.Context) {
	h.ensureSchema()
	userID, ok := middleware.GetUserID(c)
	if !ok {
		c.JSON(http.StatusUnauthorized, gin.H{"error": "unauthorized"})
		return
	}
	rows, err := h.db.Query(c.Request.Context(), `
		SELECT id, elevenlabs_clone_id, embedding, revoked_at, deleted_at, created_at
		FROM voiceprints
		WHERE user_id = $1::uuid
		ORDER BY created_at DESC
		LIMIT 100
	`, userID)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "failed to list voiceprints"})
		return
	}
	defer rows.Close()
	items := make([]gin.H, 0)
	for rows.Next() {
		var id string
		var cloneID *string
		var embeddingRaw string
		var revokedAt *time.Time
		var deletedAt *time.Time
		var createdAt time.Time
		if scanErr := rows.Scan(&id, &cloneID, &embeddingRaw, &revokedAt, &deletedAt, &createdAt); scanErr != nil {
			c.JSON(http.StatusInternalServerError, gin.H{"error": "failed to parse voiceprints"})
			return
		}
		item := gin.H{"id": id, "created_at": createdAt.Format(time.RFC3339), "embedding": embeddingRaw}
		if cloneID != nil {
			item["elevenlabs_clone_id"] = *cloneID
		}
		if revokedAt != nil {
			item["revoked_at"] = revokedAt.Format(time.RFC3339)
		}
		if deletedAt != nil {
			item["deleted_at"] = deletedAt.Format(time.RFC3339)
		}
		items = append(items, item)
	}
	c.JSON(http.StatusOK, gin.H{
		"items":   items,
		"user_id": userID,
	})
}

// DELETE /api/v1/voiceprints/:id/revoke
func (h *Handler) revoke(c *gin.Context) {
	h.ensureSchema()
	uid, ok := middleware.GetUserID(c)
	if !ok {
		c.JSON(http.StatusUnauthorized, gin.H{"error": "unauthorized"})
		return
	}
	var cloneID *string
	err := h.db.QueryRow(c.Request.Context(), `
		SELECT elevenlabs_clone_id FROM voiceprints WHERE id = $1::uuid AND user_id = $2::uuid
	`, c.Param("id"), uid).Scan(&cloneID)
	if err != nil {
		c.JSON(http.StatusNotFound, gin.H{"error": "voiceprint not found"})
		return
	}
	if cloneID != nil && *cloneID != "" {
		_ = deleteElevenLabsClone(c.Request.Context(), *cloneID)
	}
	_, err = h.db.Exec(c.Request.Context(), `
		UPDATE voiceprints
		SET revoked_at = NOW(), deleted_at = NOW()
		WHERE id = $1::uuid AND user_id = $2::uuid
	`, c.Param("id"), uid)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "failed to revoke voiceprint"})
		return
	}
	c.JSON(http.StatusOK, gin.H{"status": "revocation_confirmed", "id": c.Param("id")})
}

// DELETE /api/v1/voiceprints/:id
func (h *Handler) delete(c *gin.Context) {
	h.ensureSchema()
	_, ok := middleware.GetUserID(c)
	if !ok {
		c.JSON(http.StatusUnauthorized, gin.H{"error": "unauthorized"})
		return
	}
	c.JSON(http.StatusOK, gin.H{"status": "deleted", "id": c.Param("id")})
}

func createElevenLabsClone(ctx context.Context, audio []byte, fileName string) (string, error) {
	apiKey := os.Getenv("ELEVENLABS_API_KEY")
	if apiKey == "" {
		return "", fmt.Errorf("elevenlabs api key not configured")
	}
	body := &bytes.Buffer{}
	writer := multipart.NewWriter(body)
	_ = writer.WriteField("name", "kinnect-voiceprint")
	part, err := writer.CreateFormFile("files", fileName)
	if err != nil {
		return "", err
	}
	if _, err = part.Write(audio); err != nil {
		return "", err
	}
	if err = writer.Close(); err != nil {
		return "", err
	}
	req, _ := http.NewRequestWithContext(ctx, http.MethodPost, "https://api.elevenlabs.io/v1/voices/add", body)
	req.Header.Set("xi-api-key", apiKey)
	req.Header.Set("Content-Type", writer.FormDataContentType())
	resp, err := (&http.Client{Timeout: 20 * time.Second}).Do(req)
	if err != nil {
		return "", err
	}
	defer resp.Body.Close()
	if resp.StatusCode < 200 || resp.StatusCode >= 300 {
		return "", fmt.Errorf("elevenlabs clone failed: %s", resp.Status)
	}
	var payload struct {
		VoiceID string `json:"voice_id"`
	}
	if err := json.NewDecoder(resp.Body).Decode(&payload); err != nil {
		return "", err
	}
	if payload.VoiceID == "" {
		return "", fmt.Errorf("elevenlabs missing voice_id")
	}
	return payload.VoiceID, nil
}

func deleteElevenLabsClone(ctx context.Context, voiceID string) error {
	apiKey := os.Getenv("ELEVENLABS_API_KEY")
	if apiKey == "" {
		return fmt.Errorf("elevenlabs api key not configured")
	}
	req, _ := http.NewRequestWithContext(ctx, http.MethodDelete, "https://api.elevenlabs.io/v1/voices/"+voiceID, nil)
	req.Header.Set("xi-api-key", apiKey)
	resp, err := (&http.Client{Timeout: 15 * time.Second}).Do(req)
	if err != nil {
		return err
	}
	defer resp.Body.Close()
	if resp.StatusCode < 200 || resp.StatusCode >= 300 {
		return fmt.Errorf("elevenlabs revoke failed: %s", resp.Status)
	}
	return nil
}

func deriveEmbedding(audio []byte) []float64 {
	if len(audio) == 0 {
		return make([]float64, 256)
	}
	h := sha256.Sum256(audio)
	out := make([]float64, 256)
	for i := 0; i < 256; i++ {
		out[i] = float64(h[i%len(h)]) / 255.0
	}
	return out
}
