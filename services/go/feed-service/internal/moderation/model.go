package moderation

import (
	"time"

	"github.com/google/uuid"
)

// Report represents a user-reported content moderation request.
type Report struct {
	ID           uuid.UUID `json:"id"`
	ContentID    string    `json:"content_id"`
	ContentType  string    `json:"content_type"`
	ReporterID   uuid.UUID `json:"reporter_id"`
	Reason       string    `json:"reason"`
	Details      string    `json:"details"`
	Status       string    `json:"status"` // pending, under_review, resolved, dismissed
	Priority     string    `json:"priority"` // low, normal, high, urgent
	ReviewedBy   *uuid.UUID `json:"reviewed_by,omitempty"`
	ReviewedAt   *time.Time `json:"reviewed_at,omitempty"`
	Resolution   string    `json:"resolution,omitempty"`
	CreatedAt    time.Time `json:"created_at"`
	UpdatedAt    time.Time `json:"updated_at"`
}

// CreateReportRequest is the payload for reporting content.
type CreateReportRequest struct {
	ContentID   string `json:"content_id" binding:"required"`
	Reason      string `json:"reason" binding:"required"`
	Details     string `json:"details"`
}

// ReportResponse is the response after creating a report.
type ReportResponse struct {
	ReportID   uuid.UUID `json:"report_id"`
	Status     string    `json:"status"`
	ReporterID uuid.UUID `json:"reporter_id"`
}
