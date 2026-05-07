package dna

import (
	"context"
	"encoding/json"
	"fmt"
	"time"

	"github.com/google/uuid"
	"github.com/jackc/pgx/v5/pgxpool"
	"github.com/segmentio/kafka-go"
)

type Service struct {
	db          *pgxpool.Pool
	kafkaWriter *kafka.Writer
}

func NewService(db *pgxpool.Pool, kafkaWriter *kafka.Writer) *Service {
	return &Service{
		db:          db,
		kafkaWriter: kafkaWriter,
	}
}

type SubmitKitRequest struct {
	KitSource string `json:"kit_source" binding:"required,oneof=sequencing_com kinnect_kit 23andme ancestry myheritage"`
	KitID     string `json:"kit_id" binding:"required"`
}

type DNAStatusResponse struct {
	UserID           uuid.UUID `json:"user_id"`
	KitSource        string    `json:"kit_source"`
	ProcessingStatus string    `json:"processing_status"`
	HaploGroupM      string    `json:"haplogroup_maternal,omitempty"`
	HaploGroupP      string    `json:"haplogroup_paternal,omitempty"`
	SubmittedAt      time.Time `json:"submitted_at"`
}

func (s *Service) SubmitKit(ctx context.Context, userID uuid.UUID, req SubmitKitRequest) (*DNAStatusResponse, error) {
	if s.kafkaWriter == nil {
		return nil, fmt.Errorf("submit kit: kafka writer is not configured")
	}

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

	if err := s.enqueueProcessingEvent(ctx, profileID, userID, req); err != nil {
		return nil, fmt.Errorf("submit kit: enqueue event: %w", err)
	}

	return &DNAStatusResponse{
		UserID:           userID,
		KitSource:        req.KitSource,
		ProcessingStatus: "pending",
		SubmittedAt:      now,
	}, nil
}

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
		&resp.HaploGroupM, &resp.HaploGroupP, &resp.SubmittedAt)
	if err != nil {
		return nil, fmt.Errorf("get dna status: %w", err)
	}
	return &resp, nil
}

func (s *Service) enqueueProcessingEvent(ctx context.Context, profileID, userID uuid.UUID, req SubmitKitRequest) error {
	payload, err := json.Marshal(map[string]interface{}{
		"profile_id":   profileID.String(),
		"user_id":      userID.String(),
		"kit_source":   req.KitSource,
		"kit_id":       req.KitID,
		"submitted_at": time.Now().UTC().Format(time.RFC3339),
	})
	if err != nil {
		return fmt.Errorf("marshal kafka event: %w", err)
	}

	message := kafka.Message{
		Key:   []byte(userID.String()),
		Value: payload,
		Time:  time.Now().UTC(),
	}

	if err := s.kafkaWriter.WriteMessages(ctx, message); err != nil {
		if _, updateErr := s.db.Exec(ctx, `
			UPDATE dna_profiles SET processing_status = 'error', updated_at = NOW()
			WHERE id = $1`,
			profileID,
		); updateErr != nil {
			return fmt.Errorf("kafka enqueue failed: %w; additionally failed to update profile status: %v", err, updateErr)
		}
		return fmt.Errorf("kafka enqueue failed: %w", err)
	}

	return nil
}
