// SRS §23.1 Category 16 — Moderation / Trust & Safety extended types
// Extends the existing moderation package.
package moderation

import (
	"time"

	"github.com/google/uuid"
)

// ModerationQueueItem is an item awaiting human or automated review.
type ModerationQueueItem struct {
	ItemID      uuid.UUID  `json:"item_id"`
	ContentID   string     `json:"content_id"`
	ContentType string     `json:"content_type"`
	ReporterID  *uuid.UUID `json:"reporter_id,omitempty"`
	ToxicityScore float64  `json:"toxicity_score"`
	Priority    string     `json:"priority"` // low | normal | high | urgent
	Status      string     `json:"status"`   // pending | under_review | resolved | escalated
	AssignedTo  *uuid.UUID `json:"assigned_to,omitempty"`
	QueuedAt    time.Time  `json:"queued_at"`
}

// AbuseReport is a user-submitted abuse report.
type AbuseReport struct {
	ReportID    uuid.UUID `json:"report_id"`
	ReporterID  uuid.UUID `json:"reporter_id"`
	SubjectID   uuid.UUID `json:"subject_id"`
	ContentID   string    `json:"content_id,omitempty"`
	AbuseType   string    `json:"abuse_type"` // harassment | spam | hate_speech | csam | impersonation
	Description string    `json:"description"`
	Status      string    `json:"status"` // pending | actioned | dismissed
	CreatedAt   time.Time `json:"created_at"`
}

// CSAMDetectionResult records a CSAM (child sexual abuse material) scan result.
type CSAMDetectionResult struct {
	ScanID      uuid.UUID `json:"scan_id"`
	ContentID   string    `json:"content_id"`
	IsFlagged   bool      `json:"is_flagged"`
	HashMatch   bool      `json:"hash_match"` // PhotoDNA or NCMEC hash match
	ModelScore  float64   `json:"model_score,omitempty"`
	ReportedAt  *time.Time `json:"reported_at,omitempty"`
	ScannedAt   time.Time `json:"scanned_at"`
}

// DeepfakeDetectionResult records a deepfake scan result on user media.
type DeepfakeDetectionResult struct {
	ScanID       uuid.UUID `json:"scan_id"`
	ContentID    string    `json:"content_id"`
	IsFake       bool      `json:"is_fake"`
	Confidence   float64   `json:"confidence"`
	DetectorModel string   `json:"detector_model"`
	ScannedAt    time.Time `json:"scanned_at"`
}

// TrustScore is a computed trust level for a user or piece of content.
type TrustScore struct {
	SubjectID   string    `json:"subject_id"`
	SubjectType string    `json:"subject_type"` // user | content
	Score       float64   `json:"score"`        // 0.0–1.0
	Level       string    `json:"level"`        // untrusted | low | medium | high
	ComputedAt  time.Time `json:"computed_at"`
}

// TraumaFlag records trauma-sensitive content flags.
type TraumaFlag struct {
	FlagID      uuid.UUID `json:"flag_id"`
	ContentID   string    `json:"content_id"`
	FlagType    string    `json:"flag_type"` // grief | loss | abuse | medical
	Confidence  float64   `json:"confidence"`
	FlaggedAt   time.Time `json:"flagged_at"`
}

// SyntheticDNAFlag records a suspicion that DNA data may be artificially generated.
type SyntheticDNAFlag struct {
	FlagID     uuid.UUID `json:"flag_id"`
	UserID     uuid.UUID `json:"user_id"`
	UploadID   uuid.UUID `json:"upload_id"`
	Confidence float64   `json:"confidence"`
	Signals    []string  `json:"signals"`
	FlaggedAt  time.Time `json:"flagged_at"`
}

// ReviewerAudit tracks a human moderator's decision on a moderation queue item.
type ReviewerAudit struct {
	AuditID     uuid.UUID `json:"audit_id"`
	ItemID      uuid.UUID `json:"item_id"`
	ReviewerID  uuid.UUID `json:"reviewer_id"`
	Decision    string    `json:"decision"` // approve | remove | escalate | dismiss
	Notes       string    `json:"notes,omitempty"`
	ReviewedAt  time.Time `json:"reviewed_at"`
}
