package dna

import (
	"bytes"
	"context"
	"encoding/json"
	"fmt"
	"net/http"
	"time"

	"github.com/google/uuid"
	"github.com/jackc/pgx/v5/pgxpool"
)

type Service struct {
	db                *pgxpool.Pool
	sequencingAPIKey  string
	sequencingBaseURL string
	httpClient        *http.Client
}

func NewService(db *pgxpool.Pool, apiKey, baseURL string) *Service {
	return &Service{
		db:                db,
		sequencingAPIKey:  apiKey,
		sequencingBaseURL: baseURL,
		httpClient:        &http.Client{Timeout: 30 * time.Second},
	}
}

type SubmitKitRequest struct {
	KitSource string `json:"kit_source" binding:"required,oneof=sequencing_com kinnect_kit 23andme ancestry myheritage"`
	KitID     string `json:"kit_id"     binding:"required"`
}

type DNAStatusResponse struct {
	UserID           uuid.UUID `json:"user_id"`
	KitSource        string    `json:"kit_source"`
	ProcessingStatus string    `json:"processing_status"`
	HasploGroupM     string    `json:"haplogroup_maternal,omitempty"`
	HasploGroupP     string    `json:"haplogroup_paternal,omitempty"`
	SubmittedAt      time.Time `json:"submitted_at"`
}

// SubmitKit registers a DNA kit for processing via Sequencing.com.
func (s *Service) SubmitKit(ctx context.Context, userID uuid.UUID, req SubmitKitRequest) (*DNAStatusResponse, error) {
	profileID := uuid.New()
	now := time.Now().UTC()

	_, err := s.db.Exec(ctx, `
		INSERT INTO dna_profiles (id, user_id, kit_source, kit_id, processing_status, created_at, updated_at)
		VALUES ($1, $2, $3, $4, 'pending', $5, $5)
		ON CONFLICT DO NOTHING`,
		profileID, userID, req.KitSource, req.KitID, now,
	)
	if err != nil {
		return nil, fmt.Errorf("submit kit: db insert: %w", err)
	}

	// Trigger Sequencing.com API call (async in production via Kafka; sync stub here)
	if req.KitSource == "sequencing_com" && s.sequencingAPIKey != "" {
		go s.triggerSequencingProcessing(context.Background(), userID, req.KitID)
	}

	return &DNAStatusResponse{
		UserID:           userID,
		KitSource:        req.KitSource,
		ProcessingStatus: "pending",
		SubmittedAt:      now,
	}, nil
}

// GetStatus returns the current DNA processing status for a user.
func (s *Service) GetStatus(ctx context.Context, userID uuid.UUID) (*DNAStatusResponse, error) {
	var resp DNAStatusResponse
	err := s.db.QueryRow(ctx, `
		SELECT user_id, kit_source, processing_status,
		       COALESCE(haplogroup_maternal, ''), COALESCE(haplogroup_paternal, ''),
		       created_at
		FROM dna_profiles
		WHERE user_id = $1
		ORDER BY created_at DESC
		LIMIT 1`,
		userID,
	).Scan(&resp.UserID, &resp.KitSource, &resp.ProcessingStatus,
		&resp.HasploGroupM, &resp.HasploGroupP, &resp.SubmittedAt)
	if err != nil {
		return nil, fmt.Errorf("get dna status: %w", err)
	}
	return &resp, nil
}

// triggerSequencingProcessing calls Sequencing.com API to begin analysis.
// Runs asynchronously; updates processing_status when complete.
func (s *Service) triggerSequencingProcessing(ctx context.Context, userID uuid.UUID, kitID string) {
	payload, _ := json.Marshal(map[string]string{
		"kit_id": kitID,
		"app_id": "kinnectai",
	})

	req, err := http.NewRequestWithContext(ctx, http.MethodPost,
		s.sequencingBaseURL+"/v1/analysis/start", bytes.NewBuffer(payload))
	if err != nil {
		fmt.Printf("sequencing api: request build error: %v\n", err)
		return
	}
	req.Header.Set("Authorization", "Bearer "+s.sequencingAPIKey)
	req.Header.Set("Content-Type", "application/json")

	resp, err := s.httpClient.Do(req)
	if err != nil {
		fmt.Printf("sequencing api: call error: %v\n", err)
		return
	}
	defer resp.Body.Close()

	status := "processing"
	if resp.StatusCode != http.StatusOK && resp.StatusCode != http.StatusAccepted {
		status = "error"
	}

	s.db.Exec(ctx, `
		UPDATE dna_profiles SET processing_status = $1, updated_at = NOW()
		WHERE user_id = $2`,
		status, userID,
	)
}
