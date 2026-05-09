// SRS §23.1 Category 14 — Behavioral Service types
package behavioral

import (
	"time"

	"github.com/google/uuid"
)

// BehavioralEvent is a single user interaction event captured for ML signals.
type BehavioralEvent struct {
	EventID     uuid.UUID         `json:"event_id"`
	UserID      uuid.UUID         `json:"user_id"`
	EventType   string            `json:"event_type"` // view | tap | swipe | play | pause | share
	TargetID    string            `json:"target_id"`
	TargetType  string            `json:"target_type"` // memory_card | discovery | room | post
	SessionID   string            `json:"session_id"`
	Properties  map[string]string `json:"properties,omitempty"`
	OccurredAt  time.Time         `json:"occurred_at"`
}

// Pulse is a lightweight sentiment/reaction event.
type Pulse struct {
	PulseID    uuid.UUID `json:"pulse_id"`
	UserID     uuid.UUID `json:"user_id"`
	TargetID   string    `json:"target_id"`
	TargetType string    `json:"target_type"`
	PulseType  string    `json:"pulse_type"` // like | love | moved | curious
	OccurredAt time.Time `json:"occurred_at"`
}

// BehavioralAggregate is a pre-computed rollup of behavioral signals for a user.
type BehavioralAggregate struct {
	UserID              uuid.UUID         `json:"user_id"`
	PeriodDays          int               `json:"period_days"`
	TotalEvents         int               `json:"total_events"`
	EventTypeBreakdown  map[string]int    `json:"event_type_breakdown"`
	TopTargetTypes      []string          `json:"top_target_types"`
	EngagementScore     float64           `json:"engagement_score"`
	ComputedAt          time.Time         `json:"computed_at"`
}

// InteractionEvent is an explicit social interaction (follow, message, accept).
type InteractionEvent struct {
	EventID     uuid.UUID `json:"event_id"`
	ActorID     uuid.UUID `json:"actor_id"`
	SubjectID   uuid.UUID `json:"subject_id"`
	Action      string    `json:"action"` // follow | unfollow | message | accept | decline
	OccurredAt  time.Time `json:"occurred_at"`
}

// SentimentResult is the output of a sentiment analysis call on user content.
type SentimentResult struct {
	ContentID   string    `json:"content_id"`
	ContentType string    `json:"content_type"`
	Sentiment   string    `json:"sentiment"` // positive | neutral | negative
	Score       float64   `json:"score"`     // -1.0 to 1.0
	ModelVersion string   `json:"model_version"`
	AnalyzedAt  time.Time `json:"analyzed_at"`
}

// BehavioralDrift tracks change in a user's behavior profile over time.
type BehavioralDrift struct {
	UserID          uuid.UUID `json:"user_id"`
	DriftScore      float64   `json:"drift_score"` // 0.0 = stable, 1.0 = major shift
	DriftedFeatures []string  `json:"drifted_features"`
	DetectedAt      time.Time `json:"detected_at"`
}

// DiscoveryInfluenceMetric quantifies how much a behavioral signal influenced discovery ranking.
type DiscoveryInfluenceMetric struct {
	UserID          uuid.UUID `json:"user_id"`
	TargetUserID    uuid.UUID `json:"target_user_id"`
	InfluenceType   string    `json:"influence_type"` // positive | suppressed | neutral
	ContributingEvents []string `json:"contributing_event_ids"`
	InfluenceScore  float64   `json:"influence_score"`
	ComputedAt      time.Time `json:"computed_at"`
}
