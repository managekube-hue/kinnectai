// SRS §23.1 Category 5 — Discovery Service types
package discovery

import (
	"time"

	"github.com/google/uuid"
)

// DiscoveryMatch is a ranked potential relative surfaced by the discovery engine.
type DiscoveryMatch struct {
	MatchID         uuid.UUID       `json:"match_id"`
	UserID          uuid.UUID       `json:"user_id"`
	TargetUserID    uuid.UUID       `json:"target_user_id"`
	KinScore        float64         `json:"kin_score"`
	DisplayScore    int             `json:"display_score"` // 0–100
	LikelyRelation  string          `json:"likely_relationship"`
	ConfidenceLevel string          `json:"confidence_level"` // low | medium | high
	Reasons         []DiscoveryReason `json:"reasons"`
	SurfacedAt      time.Time       `json:"surfaced_at"`
}

// DiscoveryCard is the UI-ready representation of a discovery match.
type DiscoveryCard struct {
	MatchID       uuid.UUID `json:"match_id"`
	DisplayName   string    `json:"display_name"`
	AvatarURL     string    `json:"avatar_url,omitempty"`
	DisplayScore  int       `json:"display_score"`
	Relation      string    `json:"relation"`
	PathSummary   string    `json:"path_summary"`
	SurfacedAt    time.Time `json:"surfaced_at"`
}

// DiscoveryList is the paginated response of discovery candidates.
type DiscoveryList struct {
	Candidates []DiscoveryCard `json:"candidates"`
	NextCursor string          `json:"next_cursor,omitempty"`
	HasMore    bool            `json:"has_more"`
	GeneratedAt time.Time      `json:"generated_at"`
}

// DiscoveryDismissPostRequest is the body for dismissing a discovery candidate.
type DiscoveryDismissPostRequest struct {
	TargetUserID uuid.UUID `json:"target_user_id" binding:"required"`
	Reason       string    `json:"reason,omitempty"` // not_related | known | other
}

// DiscoveryRanking holds model scoring metadata for a match.
type DiscoveryRanking struct {
	ModelVersion string    `json:"model_version"`
	Score        float64   `json:"raw_score"`
	RankedAt     time.Time `json:"ranked_at"`
}

// DiscoveryModifier adjusts the base score based on contextual signals.
type DiscoveryModifier struct {
	Type   string  `json:"type"`  // shared_surname | shared_location | dna_overlap
	Weight float64 `json:"weight"`
	Label  string  `json:"label"`
}

// DiscoveryReason is a human-readable explanation for a match.
type DiscoveryReason struct {
	Code  string `json:"code"`
	Label string `json:"label"`
}

// DiscoveryExposureBudget tracks how many times a candidate can be shown.
type DiscoveryExposureBudget struct {
	UserID       uuid.UUID `json:"user_id"`
	TargetUserID uuid.UUID `json:"target_user_id"`
	MaxShows     int       `json:"max_shows"`
	ShownCount   int       `json:"shown_count"`
	ResetAt      time.Time `json:"reset_at"`
}

// DiscoveryFeedbackLoopMetrics aggregates signal quality for model retraining.
type DiscoveryFeedbackLoopMetrics struct {
	ExperimentID      string    `json:"experiment_id"`
	AcceptRate        float64   `json:"accept_rate"`
	DismissRate       float64   `json:"dismiss_rate"`
	ConversionRate    float64   `json:"conversion_rate"`
	SampleSize        int       `json:"sample_size"`
	MeasuredAt        time.Time `json:"measured_at"`
}
