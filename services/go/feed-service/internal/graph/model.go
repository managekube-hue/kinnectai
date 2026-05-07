package graph

import (
	"github.com/google/uuid"
)

// KinScoreResult is the CR score between two users.
type KinScoreResult struct {
	UserAID          uuid.UUID `json:"user_a_id"`
	UserBID          uuid.UUID `json:"user_b_id"`
	KinScore         float64   `json:"kin_score"`          // 0.0 – 1.0 (CR coefficient)
	DisplayScore     int       `json:"display_score"`      // 0–100 user-facing scale
	RelationshipType string    `json:"relationship_type"`  // 'sibling', 'first_cousin', etc.
	Confidence       float64   `json:"confidence"`
	DegreesOfSep     int       `json:"degrees_of_separation"`
	FromCache        bool      `json:"from_cache"`
}

// KinnectionRequest asks to confirm a biological link.
type KinnectionRequest struct {
	TargetUserID     uuid.UUID `json:"target_user_id"     binding:"required"`
	RelationshipType string    `json:"relationship_type"  binding:"required"`
}

// KinnectionResponse holds a pending or confirmed kinnection.
type KinnectionResponse struct {
	ID               uuid.UUID `json:"id"`
	UserAID          uuid.UUID `json:"user_a_id"`
	UserBID          uuid.UUID `json:"user_b_id"`
	RelationshipType string    `json:"relationship_type"`
	Status           string    `json:"status"`
	KinScore         float64   `json:"kin_score"`
}

// DiscoveryCard is a potential Kinnection surfaced for the user.
type DiscoveryCard struct {
	User         interface{} `json:"user"`
	KinScore     float64     `json:"kin_score"`
	DisplayScore int         `json:"display_score"`
	Relationship string      `json:"likely_relationship"`
	PathSummary  string      `json:"path_summary"` // "3rd cousin via Sullivan line"
}
