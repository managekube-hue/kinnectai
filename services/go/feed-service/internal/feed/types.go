// SRS §23.1 Category 4 — Feed Service extended types
package feed

import (
	"time"

	"github.com/google/uuid"
)

// FeedItem is a single item rendered in the personalised feed.
type FeedItem struct {
	ItemID          uuid.UUID         `json:"item_id"`
	ItemType        string            `json:"item_type"` // memory_card | discovery | pulse | bloom
	Payload         interface{}       `json:"payload"`
	RankScore       float64           `json:"rank_score"`
	InjectionReason FeedInjectionReason `json:"injection_reason,omitempty"`
	ExperimentVariant *FeedExperimentVariant `json:"experiment_variant,omitempty"`
	InsertedAt      time.Time         `json:"inserted_at"`
}

// FeedCursor holds the state needed to fetch the next page.
type FeedCursor struct {
	EncodedCursor string    `json:"cursor"`
	LastItemID    uuid.UUID `json:"last_item_id"`
	GeneratedAt   time.Time `json:"generated_at"`
}

// FeedFallbackMetadata describes why a fallback feed was served.
type FeedFallbackMetadata struct {
	Reason       string    `json:"reason"`        // cold_start | low_signal | model_failure
	FallbackType string    `json:"fallback_type"` // popular | regional | seeded
	TriggeredAt  time.Time `json:"triggered_at"`
}

// FeedRanking captures the model output that produced this feed ordering.
type FeedRanking struct {
	ModelVersion  string    `json:"model_version"`
	FeatureVector []float64 `json:"feature_vector,omitempty"`
	Score         float64   `json:"score"`
	RankedAt      time.Time `json:"ranked_at"`
}

// FeedInjectionReason explains why an item was injected into the feed.
type FeedInjectionReason struct {
	Code    string `json:"code"`    // organic | promoted | steward_triggered | discovery_boost
	Label   string `json:"label"`
	PolicyID string `json:"policy_id,omitempty"`
}

// FeedSuppressionReason records why a candidate was excluded from the feed.
type FeedSuppressionReason struct {
	ItemID    uuid.UUID `json:"item_id"`
	Reason    string    `json:"reason"` // blocked | already_seen | low_quality | moderation_hold
	SuppressedAt time.Time `json:"suppressed_at"`
}

// FeedExperimentVariant captures which A/B test variant influenced this feed.
type FeedExperimentVariant struct {
	ExperimentID string `json:"experiment_id"`
	VariantID    string `json:"variant_id"`
	VariantName  string `json:"variant_name"`
}
