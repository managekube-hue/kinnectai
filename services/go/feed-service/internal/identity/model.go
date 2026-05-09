// SRS §23.1 Category 13 — Identity Resolution types
package identity

import (
	"time"

	"github.com/google/uuid"
)

// IdentityMatch is a resolved identity match between a user and an external record.
type IdentityMatch struct {
	MatchID        uuid.UUID `json:"match_id"`
	UserID         uuid.UUID `json:"user_id"`
	ExternalRecordID string  `json:"external_record_id"`
	Source         string    `json:"source"` // whitepages | lexisnexis | internal
	Confidence     float64   `json:"confidence"`
	MatchedFields  []string  `json:"matched_fields"`
	MatchedAt      time.Time `json:"matched_at"`
}

// NameMap maps a surname variant to its canonical form.
type NameMap struct {
	Variant   string `json:"variant"`
	Canonical string `json:"canonical"`
	Language  string `json:"language,omitempty"`
	Region    string `json:"region,omitempty"`
}

// AddressOverlap records a shared address between two identity records.
type AddressOverlap struct {
	UserAID    uuid.UUID `json:"user_a_id"`
	UserBID    uuid.UUID `json:"user_b_id"`
	AddressHash string   `json:"address_hash"` // hashed for privacy
	OverlapType string   `json:"overlap_type"` // current | historical
	VerifiedAt time.Time `json:"verified_at"`
}

// RelativeCandidate is a potential relative surfaced by the identity resolution engine.
type RelativeCandidate struct {
	CandidateID    uuid.UUID `json:"candidate_id"`
	SourceUserID   uuid.UUID `json:"source_user_id"`
	CandidateName  string    `json:"candidate_name"`
	MatchedFields  []string  `json:"matched_fields"`
	Confidence     float64   `json:"confidence"`
	DataSource     string    `json:"data_source"`
	ProposedAt     time.Time `json:"proposed_at"`
}

// IdentityConfidence is the aggregated confidence score for an identity resolution result.
type IdentityConfidence struct {
	UserID         uuid.UUID `json:"user_id"`
	OverallScore   float64   `json:"overall_score"` // 0.0–1.0
	ComponentScores map[string]float64 `json:"component_scores"`
	Tier           string    `json:"tier"` // unverified | probable | confirmed
	UpdatedAt      time.Time `json:"updated_at"`
}

// WhitepagesResolution holds a resolved Whitepages identity record.
type WhitepagesResolution struct {
	ResolutionID  uuid.UUID `json:"resolution_id"`
	UserID        uuid.UUID `json:"user_id"`
	WhitepagesID  string    `json:"whitepages_id"`
	FullName      string    `json:"full_name"`
	ResolvedAt    time.Time `json:"resolved_at"`
	Confidence    float64   `json:"confidence"`
}

// LexisNexisResolution holds a resolved LexisNexis identity record.
type LexisNexisResolution struct {
	ResolutionID   uuid.UUID `json:"resolution_id"`
	UserID         uuid.UUID `json:"user_id"`
	LexisNexisRef  string    `json:"lexis_nexis_ref"`
	FullName       string    `json:"full_name"`
	ResolvedAt     time.Time `json:"resolved_at"`
	Confidence     float64   `json:"confidence"`
}

// IdentityAudit records an identity resolution query for compliance.
type IdentityAudit struct {
	AuditID    uuid.UUID `json:"audit_id"`
	UserID     uuid.UUID `json:"user_id"`
	Source     string    `json:"source"`
	QueryHash  string    `json:"query_hash"`
	ResultsCount int     `json:"results_count"`
	OccurredAt time.Time `json:"occurred_at"`
}
