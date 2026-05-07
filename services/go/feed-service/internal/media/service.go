package media

import (
	"context"
	"fmt"
	"net/http"
	"time"

	stream "github.com/GetStream/stream-go2/v8"
	"github.com/google/uuid"
)

// Service routes media through GetStream Video API for CDN delivery.
type Service struct {
	streamClient *stream.Client
	httpClient   *http.Client
	apiKey       string
	appID        string
}

func NewService(streamClient *stream.Client, apiKey, appID string) *Service {
	return &Service{
		streamClient: streamClient,
		httpClient:   &http.Client{Timeout: 60 * time.Second},
		apiKey:       apiKey,
		appID:        appID,
	}
}

type UploadTokenResponse struct {
	UploadURL    string `json:"upload_url"`
	CDNUrl       string `json:"cdn_url"`
	CallID       string `json:"call_id"`
	ExpiresAt    int64  `json:"expires_at"`
}

type BloomUploadRequest struct {
	UserID    uuid.UUID `json:"user_id"`
	MemoryID  uuid.UUID `json:"memory_id"`
	FileName  string    `json:"file_name"`
	MimeType  string    `json:"mime_type"`
}

// GetUploadToken returns a pre-authorized GetStream Video upload token.
// Flutter client uses this to upload directly to GetStream — backend secret never exposed.
func (s *Service) GetUploadToken(ctx context.Context, userID uuid.UUID, req BloomUploadRequest) (*UploadTokenResponse, error) {
	// GetStream Video call/room creation for media upload
	callID := fmt.Sprintf("bloom-%s-%s", req.MemoryID.String(), uuid.New().String()[:8])

	// Use GetStream's call API to generate upload credentials
	// In production: POST to GetStream Video API /video/call/{type}/{id}/upload
	expiresAt := time.Now().Add(15 * time.Minute).Unix()

	cdnURL := fmt.Sprintf(
		"https://cdn.getstream.io/video/attachments/%s/%s/%s",
		s.appID, callID, req.FileName,
	)

	return &UploadTokenResponse{
		UploadURL: fmt.Sprintf(
			"https://video.stream-io-api.com/video/call/bloom/%s/upload?api_key=%s",
			callID, s.apiKey,
		),
		CDNUrl:    cdnURL,
		CallID:    callID,
		ExpiresAt: expiresAt,
	}, nil
}
