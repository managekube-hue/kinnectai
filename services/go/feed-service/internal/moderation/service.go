package moderation

import (
	"context"
	"encoding/json"
	"fmt"
	"time"

	"github.com/google/uuid"
	"github.com/jackc/pgx/v5/pgconn"
	"github.com/jackc/pgx/v5/pgxpool"
	"github.com/segmentio/kafka-go"
)

const (
	reportPriorityUrgent  = "urgent"
	reportPriorityHigh    = "high"
	reportPriorityNormal  = "normal"
	reportPriorityLow     = "low"
	reportStatusPending   = "pending"
	reportStatusUnderReview = "under_review"
	reportStatusResolved  = "resolved"
	reportStatusDismissed = "dismissed"
)

// Service handles moderation report persistence and task queuing.
type Service struct {
	db          reportStore
	kafkaWriter kafkaMessageWriter
	kafkaTopic string
}

type reportStore interface {
	Exec(ctx context.Context, sql string, arguments ...interface{}) (pgconn.CommandTag, error)
}

type kafkaMessageWriter interface {
	WriteMessages(ctx context.Context, msgs ...kafka.Message) error
}

// NewService creates a new moderation service.
func NewService(db *pgxpool.Pool, kafkaWriter *kafka.Writer, kafkaTopic string) *Service {
	return &Service{
		db:          db,
		kafkaWriter: kafkaWriter,
		kafkaTopic: kafkaTopic,
	}
}

// CreateReport persists a moderation report and queues it for moderator review.
func (s *Service) CreateReport(ctx context.Context, reporterID uuid.UUID, req CreateReportRequest) (*ReportResponse, error) {
	reportID := uuid.New()
	now := time.Now().UTC()

	// Determine priority based on reason
	priority := s.determinePriority(req.Reason)

	// Insert report into database
	_, err := s.db.Exec(ctx, `
		INSERT INTO moderation_reports (id, content_id, content_type, reporter_id, reason, details, 
		                                  status, priority, created_at, updated_at)
		VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $9)
	`, reportID, req.ContentID, "memory", reporterID, req.Reason, req.Details,
		reportStatusPending, priority, now)
	if err != nil {
		return nil, fmt.Errorf("failed to insert moderation report: %w", err)
	}

	// Queue moderator review task
	if err := s.queueModeratorTask(ctx, reportID, reporterID, req, priority); err != nil {
		// Log error but don't fail the request - DB write succeeded
		fmt.Printf("WARN: failed to queue moderator task for report %s: %v\n", reportID, err)
	}

	return &ReportResponse{
		ReportID:   reportID,
		Status:     reportStatusPending,
		ReporterID: reporterID,
	}, nil
}

// queueModeratorTask publishes a task to Kafka for moderator review.
func (s *Service) queueModeratorTask(ctx context.Context, reportID, reporterID uuid.UUID, req CreateReportRequest, priority string) error {
	task := map[string]interface{}{
		"task_type":    "moderation_review",
		"report_id":   reportID.String(),
		"content_id":  req.ContentID,
		"reporter_id": reporterID.String(),
		"reason":      req.Reason,
		"details":     req.Details,
		"priority":    priority,
		"created_at":  time.Now().UTC().Format(time.RFC3339),
	}

	taskBytes, err := json.Marshal(task)
	if err != nil {
		return fmt.Errorf("failed to marshal moderator task: %w", err)
	}

	message := kafka.Message{
		Key:   []byte(reportID.String()),
		Value: taskBytes,
		Time:  time.Now(),
	}

	if err := s.kafkaWriter.WriteMessages(ctx, message); err != nil {
		return fmt.Errorf("failed to write moderator task to kafka: %w", err)
	}

	return nil
}

// determinePriority assigns priority based on report reason.
func (s *Service) determinePriority(reason string) string {
	switch reason {
	case "harassment", "hate_speech", "violence", "self_harm", "child_safety":
		return reportPriorityUrgent
	case "spam", "impersonation", "misinformation":
		return reportPriorityHigh
	case "inappropriate_content", "privacy_violation":
		return reportPriorityNormal
	default:
		return reportPriorityLow
	}
}
