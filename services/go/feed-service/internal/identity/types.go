package identity

import (
	"time"
)

// IdentityMatch represents a potential identity match.
type IdentityMatch struct {
	MatchID          string    `json:"match_id"`
	UserID           string    `json:"user_id"`
	MatchedUserID    string    `json:"matched_user_id"`
	MatchScore       float64   `json:"match_score"` // 0-1
	MatchType        string    `json:"match_type"` // "EXACT", "PROBABLE", "POSSIBLE"
	MatchedFields    []string  `json:"matched_fields"` // name, address, email, etc
	CreatedAt        time.Time `json:"created_at"`
	ExpiresAt        *time.Time `json:"expires_at,omitempty"`
	Status           string    `json:"status"` // "PENDING", "CONFIRMED", "DISMISSED"
}

// NameMap represents a name mapping/variation.
type NameMap struct {
	MapID            string    `json:"map_id"`
	UserID           string    `json:"user_id"`
	CanonicalName    string    `json:"canonical_name"`
	NameVariations   []string  `json:"name_variations"`
	AliasNames       []string  `json:"alias_names,omitempty"`
	Language         string    `json:"language,omitempty"`
	LastUpdatedAt    time.Time `json:"last_updated_at"`
}

// AddressOverlap represents address data overlap analysis.
type AddressOverlap struct {
	OverlapID        string    `json:"overlap_id"`
	UserID           string    `json:"user_id"`
	Address1         string    `json:"address_1"`
	Address2         string    `json:"address_2"`
	OverlapScore     float64   `json:"overlap_score"` // 0-1
	SharedLocation   bool      `json:"shared_location"`
	TimeOverlapDays  int       `json:"time_overlap_days,omitempty"`
	Confidence       float64   `json:"confidence"`
	AnalyzedAt       time.Time `json:"analyzed_at"`
}

// RelativeCandidate represents a potential relative match from third-party data.
type RelativeCandidate struct {
	CandidateID      string    `json:"candidate_id"`
	UserID           string    `json:"user_id"`
	CandidateName    string    `json:"candidate_name"`
	RelationType     string    `json:"relation_type"` // "PARENT", "SIBLING", "CHILD", "COUSIN"
	Source           string    `json:"source"` // "GENEALOGY_DB", "CENSUS", "YEARBOOK"
	ScoreRelevance   float64   `json:"score_relevance"`
	SourceURL        string    `json:"source_url,omitempty"`
	CreatedAt        time.Time `json:"created_at"`
}

// IdentityConfidence represents overall identity matching confidence.
type IdentityConfidence struct {
	ConfidenceID     string    `json:"confidence_id"`
	UserID           string    `json:"user_id"`
	OverallScore     float64   `json:"overall_score"` // 0-1
	DocumentScore    float64   `json:"document_score"`
	BiometricScore   float64   `json:"biometric_score"`
	AuditScore       float64   `json:"audit_score"`
	ConsistencyScore float64   `json:"consistency_score"`
	AnalyzedAt       time.Time `json:"analyzed_at"`
	FlaggedForReview bool      `json:"flagged_for_review"`
}

// WhitepagesResolution represents Whitepages third-party resolution data.
type WhitepagesResolution struct {
	ResolutionID     string    `json:"resolution_id"`
	UserID           string    `json:"user_id"`
	Name             string    `json:"name"`
	Phone            string    `json:"phone,omitempty"`
	Address          string    `json:"address,omitempty"`
	AgeRange         string    `json:"age_range,omitempty"`
	Confidence       float64   `json:"confidence"`
	PossibleRelatives []string `json:"possible_relatives,omitempty"`
	ResolvedAt       time.Time `json:"resolved_at"`
	ExpiresAt        *time.Time `json:"expires_at,omitempty"`
}

// LexisNexisResolution represents LexisNexis third-party resolution data.
type LexisNexisResolution struct {
	ResolutionID     string    `json:"resolution_id"`
	UserID           string    `json:"user_id"`
	RiskScore        float64   `json:"risk_score"` // 0-1
	VerificationStatus string  `json:"verification_status"` // "VERIFIED", "DECLINED", "NO_MATCH"
	AddressHistory   []string  `json:"address_history,omitempty"`
	PhoneHistory     []string  `json:"phone_history,omitempty"`
	OccupationHistory []string `json:"occupation_history,omitempty"`
	ResolvedAt       time.Time `json:"resolved_at"`
}

// IdentityAudit represents audit trail for identity resolution.
type IdentityAudit struct {
	AuditID          string    `json:"audit_id"`
	UserID           string    `json:"user_id"`
	ResolutionType   string    `json:"resolution_type"` // "WHITEPAGES", "LEXISNEXIS", "MANUAL"
	Action           string    `json:"action"` // "QUERY", "MATCH", "VERIFY"
	Result           string    `json:"result"`
	Timestamp        time.Time `json:"timestamp"`
	AuditedBy        string    `json:"audited_by"`
}
