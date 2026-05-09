// SRS §23.1 Category 3 — User Domain extended types
package user

import (
	"time"

	"github.com/google/uuid"
)

// UserSettings stores per-user application preferences.
type UserSettings struct {
	UserID               uuid.UUID `json:"user_id"`
	NotificationsEnabled bool      `json:"notifications_enabled"`
	EmailDigest          string    `json:"email_digest"` // daily | weekly | never
	PrivacyLevel         string    `json:"privacy_level"` // public | connections | private
	Language             string    `json:"language"`
	Timezone             string    `json:"timezone"`
	Theme                string    `json:"theme"` // light | dark | system
	UpdatedAt            time.Time `json:"updated_at"`
}

// Steward is a trusted person designated to manage a user's vault on their behalf.
type Steward struct {
	StewardID    uuid.UUID  `json:"steward_id"`
	UserID       uuid.UUID  `json:"user_id"`
	StewardUserID uuid.UUID `json:"steward_user_id"`
	RelationLabel string    `json:"relation_label"`
	ConsentGiven  bool      `json:"consent_given"`
	ConsentAt     *time.Time `json:"consent_at,omitempty"`
	RevokedAt     *time.Time `json:"revoked_at,omitempty"`
	Permissions   []string   `json:"permissions"`
}

// UserTrustScore is the computed trust and safety score for a user.
type UserTrustScore struct {
	UserID          uuid.UUID `json:"user_id"`
	Score           float64   `json:"score"`           // 0.0–1.0
	Level           string    `json:"level"`           // low | medium | high | verified
	Flags           []string  `json:"flags,omitempty"` // fraud_risk | bot_suspected | etc.
	LastComputedAt  time.Time `json:"last_computed_at"`
}

// UserPresence tracks real-time presence state.
type UserPresence struct {
	UserID    uuid.UUID  `json:"user_id"`
	Status    string     `json:"status"` // online | away | offline
	LastSeenAt time.Time `json:"last_seen_at"`
	ActiveRoomID *string `json:"active_room_id,omitempty"`
}

// UserRegion stores the user's declared and detected geographic region.
type UserRegion struct {
	UserID          uuid.UUID `json:"user_id"`
	DeclaredRegion  string    `json:"declared_region"`
	DetectedRegion  string    `json:"detected_region"`
	DataResidency   string    `json:"data_residency"` // us | eu | apac
	LastUpdated     time.Time `json:"last_updated"`
}

// UserRelationshipPreference stores match and discovery preferences.
type UserRelationshipPreference struct {
	UserID              uuid.UUID `json:"user_id"`
	SeekingRelationships []string `json:"seeking_relationships"` // sibling | cousin | ancestor
	AgeRangeMin         int       `json:"age_range_min,omitempty"`
	AgeRangeMax         int       `json:"age_range_max,omitempty"`
	GeographicRadius    int       `json:"geographic_radius_km,omitempty"`
	UpdatedAt           time.Time `json:"updated_at"`
}

// UserBehaviorProfile aggregates behavioral signals for personalization.
type UserBehaviorProfile struct {
	UserID            uuid.UUID         `json:"user_id"`
	EngagementScore   float64           `json:"engagement_score"`
	SessionFrequency  float64           `json:"session_frequency_per_week"`
	ContentAffinities map[string]float64 `json:"content_affinities"`
	LastUpdated       time.Time         `json:"last_updated"`
}

// UserRiskProfile stores fraud and abuse risk signals.
type UserRiskProfile struct {
	UserID       uuid.UUID  `json:"user_id"`
	RiskScore    float64    `json:"risk_score"` // 0.0–1.0
	RiskLevel    string     `json:"risk_level"` // low | medium | high | critical
	SignalFlags  []string   `json:"signal_flags,omitempty"`
	ReviewedBy   *uuid.UUID `json:"reviewed_by,omitempty"`
	ReviewedAt   *time.Time `json:"reviewed_at,omitempty"`
	UpdatedAt    time.Time  `json:"updated_at"`
}

// UserLifecycleState tracks the user's account lifecycle stage.
type UserLifecycleState struct {
	UserID      uuid.UUID  `json:"user_id"`
	State       string     `json:"state"` // onboarding | active | suspended | churned | deleted
	Reason      string     `json:"reason,omitempty"`
	TransitionedAt time.Time `json:"transitioned_at"`
	DeletedAt   *time.Time `json:"deleted_at,omitempty"`
}
