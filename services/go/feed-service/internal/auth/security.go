// SRS §23.1 Category 2 — Auth / Security extended types
// Extends the existing auth package with security-specific models.
package auth

import (
	"time"

	"github.com/google/uuid"
)

// JwtClaims is the canonical JWT payload for KinnectAI tokens.
type JwtClaims struct {
	UserID    uuid.UUID `json:"user_id"`
	Username  string    `json:"username"`
	Email     string    `json:"email"`
	Scopes    []string  `json:"scopes"`
	SessionID string    `json:"session_id"`
	IssuedAt  int64     `json:"iat"`
	ExpiresAt int64     `json:"exp"`
}

// AuthErrorResponse is a structured auth-specific error.
type AuthErrorResponse struct {
	Code      string `json:"code"`    // AUTH_INVALID_TOKEN | AUTH_EXPIRED | etc.
	Message   string `json:"message"`
	Retryable bool   `json:"retryable"`
}

// ConsentFlags tracks which consent agreements a user has accepted.
type ConsentFlags struct {
	UserID          uuid.UUID  `json:"user_id"`
	TermsAccepted   bool       `json:"terms_accepted"`
	PrivacyAccepted bool       `json:"privacy_accepted"`
	DNAConsent      bool       `json:"dna_consent"`
	BiometricConsent bool      `json:"biometric_consent"`
	MarketingConsent bool      `json:"marketing_consent"`
	AcceptedAt      time.Time  `json:"accepted_at"`
	UpdatedAt       *time.Time `json:"updated_at,omitempty"`
}

// ScopeValidation checks whether a token has a required scope.
type ScopeValidation struct {
	RequiredScope string `json:"required_scope"`
	Granted       bool   `json:"granted"`
	TokenID       string `json:"token_id"`
}

// StepUpAuth is issued when a sensitive action requires re-authentication.
type StepUpAuth struct {
	ChallengeID  uuid.UUID `json:"challenge_id"`
	UserID       uuid.UUID `json:"user_id"`
	Method       string    `json:"method"`     // totp | sms | biometric
	Reason       string    `json:"reason"`
	ExpiresAt    time.Time `json:"expires_at"`
	Completed    bool      `json:"completed"`
}

// SessionMetadata holds server-side session context.
type SessionMetadata struct {
	SessionID   string    `json:"session_id"`
	UserID      uuid.UUID `json:"user_id"`
	DeviceID    string    `json:"device_id"`
	IPAddress   string    `json:"ip_address"`
	CreatedAt   time.Time `json:"created_at"`
	LastSeenAt  time.Time `json:"last_seen_at"`
	ExpiresAt   time.Time `json:"expires_at"`
	IsRevoked   bool      `json:"is_revoked"`
}

// RevokedJwt tracks an invalidated JWT until its natural expiry.
type RevokedJwt struct {
	JTI        string    `json:"jti"`
	UserID     uuid.UUID `json:"user_id"`
	RevokedAt  time.Time `json:"revoked_at"`
	ExpiresAt  time.Time `json:"expires_at"`
	Reason     string    `json:"reason"`
}

// DeviceAttestation holds platform attestation evidence (iOS DeviceCheck / Android SafetyNet).
type DeviceAttestation struct {
	DeviceID    string    `json:"device_id"`
	Platform    string    `json:"platform"` // ios | android
	Attestation string    `json:"attestation_token"`
	Verified    bool      `json:"verified"`
	VerifiedAt  time.Time `json:"verified_at"`
}

// ConsentAuditLog records a single consent event.
type ConsentAuditLog struct {
	ID         uuid.UUID `json:"id"`
	UserID     uuid.UUID `json:"user_id"`
	ConsentKey string    `json:"consent_key"`
	Action     string    `json:"action"` // granted | revoked | updated
	IPAddress  string    `json:"ip_address"`
	OccurredAt time.Time `json:"occurred_at"`
}

// MFAChallenge represents an active multi-factor auth challenge.
type MFAChallenge struct {
	ChallengeID uuid.UUID `json:"challenge_id"`
	UserID      uuid.UUID `json:"user_id"`
	Method      string    `json:"method"` // totp | sms_otp | email_otp
	IssuedAt    time.Time `json:"issued_at"`
	ExpiresAt   time.Time `json:"expires_at"`
	Verified    bool      `json:"verified"`
}

// BiometricVerification holds a biometric check result.
type BiometricVerification struct {
	VerificationID  uuid.UUID `json:"verification_id"`
	UserID          uuid.UUID `json:"user_id"`
	BiometricType   string    `json:"biometric_type"` // face | fingerprint | voice
	ConfidenceScore float64   `json:"confidence_score"`
	Passed          bool      `json:"passed"`
	CheckedAt       time.Time `json:"checked_at"`
}

// JITAccessGrant is a just-in-time privilege elevation grant.
type JITAccessGrant struct {
	GrantID     uuid.UUID `json:"grant_id"`
	UserID      uuid.UUID `json:"user_id"`
	Resource    string    `json:"resource"`
	Permissions []string  `json:"permissions"`
	GrantedBy   string    `json:"granted_by"`
	ExpiresAt   time.Time `json:"expires_at"`
	Reason      string    `json:"reason"`
}

// KMSAccessAudit records KMS key-access events.
type KMSAccessAudit struct {
	ID        uuid.UUID `json:"id"`
	KeyID     string    `json:"key_id"`
	ActorID   uuid.UUID `json:"actor_id"`
	Operation string    `json:"operation"` // encrypt | decrypt | rotate
	Resource  string    `json:"resource"`
	Success   bool      `json:"success"`
	Timestamp time.Time `json:"timestamp"`
}

// SecurityIncident records a detected security event.
type SecurityIncident struct {
	ID          uuid.UUID `json:"id"`
	Severity    string    `json:"severity"` // low | medium | high | critical
	Type        string    `json:"incident_type"`
	Description string    `json:"description"`
	AffectedID  string    `json:"affected_resource_id,omitempty"`
	DetectedAt  time.Time `json:"detected_at"`
	ResolvedAt  *time.Time `json:"resolved_at,omitempty"`
}

// ComplianceViolation records a policy or regulatory violation.
type ComplianceViolation struct {
	ID          uuid.UUID `json:"id"`
	PolicyID    string    `json:"policy_id"`
	Description string    `json:"description"`
	Severity    string    `json:"severity"`
	ActorID     uuid.UUID `json:"actor_id,omitempty"`
	DetectedAt  time.Time `json:"detected_at"`
}
