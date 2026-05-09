package auth

import (
	"time"
)

// JwtClaims represents standard JWT payload claims.
type JwtClaims struct {
	Sub            string    `json:"sub"`
	Email          string    `json:"email"`
	EmailVerified  bool      `json:"email_verified"`
	Scopes         []string  `json:"scopes"`
	IssuedAt       time.Time `json:"iat"`
	ExpiresAt      time.Time `json:"exp"`
	NotBefore      time.Time `json:"nbf"`
	Issuer         string    `json:"iss"`
	Audience       []string  `json:"aud"`
	JTI            string    `json:"jti"`
	DeviceID       string    `json:"device_id,omitempty"`
	SessionID      string    `json:"session_id,omitempty"`
	DeviceAttest   bool      `json:"device_attest"`
	MFAVerified    bool      `json:"mfa_verified"`
	StepUpRequired bool      `json:"step_up_required"`
	Metadata       map[string]interface{} `json:"metadata,omitempty"`
}

// AuthErrorResponse represents an authentication-specific error.
type AuthErrorResponse struct {
	Code        string    `json:"code"` // "INVALID_CREDENTIALS", "MFA_REQUIRED", "TOKEN_EXPIRED"
	Message     string    `json:"message"`
	RequestID   string    `json:"request_id"`
	Timestamp   time.Time `json:"timestamp"`
	RetryAfter  int       `json:"retry_after,omitempty"` // seconds
	ChallengeID string    `json:"challenge_id,omitempty"`
}

// ConsentFlags represents user consent status for various features.
type ConsentFlags struct {
	UserID                  string    `json:"user_id"`
	ConsentToTerms          bool      `json:"consent_to_terms"`
	ConsentToPrivacy        bool      `json:"consent_to_privacy"`
	ConsentToAnalytics      bool      `json:"consent_to_analytics"`
	ConsentToThirdParty     bool      `json:"consent_to_third_party"`
	ConsentToGenomicSharing bool      `json:"consent_to_genomic_sharing"`
	ConsentToE2EE           bool      `json:"consent_to_e2ee"`
	ConsentToRecording      bool      `json:"consent_to_recording"`
	ConsentUpdatedAt        time.Time `json:"consent_updated_at"`
	ConsentVersion          string    `json:"consent_version"`
}

// ScopeValidation validates OAuth scope requests.
type ScopeValidation struct {
	Scope         string   `json:"scope"`
	IsValid       bool     `json:"is_valid"`
	RequiredScopes []string `json:"required_scopes,omitempty"`
	RequestedScopes []string `json:"requested_scopes"`
	MissingScopes []string `json:"missing_scopes,omitempty"`
}

// StepUpAuth represents stepped-up authentication challenge.
type StepUpAuth struct {
	ChallengeID     string    `json:"challenge_id"`
	UserID          string    `json:"user_id"`
	Method          string    `json:"method"` // "OTP", "BIOMETRIC", "SECURITY_KEY"
	Status          string    `json:"status"` // "PENDING", "VERIFIED", "EXPIRED"
	CreatedAt       time.Time `json:"created_at"`
	ExpiresAt       time.Time `json:"expires_at"`
	AttemptCount    int       `json:"attempt_count"`
	MaxAttempts     int       `json:"max_attempts"`
	RequiredAction  string    `json:"required_action"`
}

// SessionMetadata represents session tracking information.
type SessionMetadata struct {
	SessionID      string    `json:"session_id"`
	UserID         string    `json:"user_id"`
	CreatedAt      time.Time `json:"created_at"`
	ExpiresAt      time.Time `json:"expires_at"`
	LastActivityAt time.Time `json:"last_activity_at"`
	DeviceID       string    `json:"device_id"`
	IPAddress      string    `json:"ip_address"`
	UserAgent      string    `json:"user_agent"`
	Region         string    `json:"region"`
	IsActive       bool      `json:"is_active"`
}

// RevokedJwt represents a revoked JWT token.
type RevokedJwt struct {
	JTI       string    `json:"jti"`
	UserID    string    `json:"user_id"`
	RevokedAt time.Time `json:"revoked_at"`
	Reason    string    `json:"reason"` // "LOGOUT", "PASSWORD_CHANGE", "SECURITY_ALERT"
	ExpiresAt time.Time `json:"expires_at"`
}

// DeviceAttestation represents device attestation proof.
type DeviceAttestation struct {
	DeviceID      string    `json:"device_id"`
	AttestationID string    `json:"attestation_id"`
	PublicKey     string    `json:"public_key"`
	Signature     string    `json:"signature"`
	VerifiedAt    time.Time `json:"verified_at"`
	ExpiresAt     time.Time `json:"expires_at"`
	IsValid       bool      `json:"is_valid"`
}

// ConsentAuditLog represents consent tracking for compliance.
type ConsentAuditLog struct {
	ID              string    `json:"id"`
	UserID          string    `json:"user_id"`
	ConsentType     string    `json:"consent_type"`
	Granted         bool      `json:"granted"`
	GrantedAt       time.Time `json:"granted_at"`
	RevokedAt       *time.Time `json:"revoked_at,omitempty"`
	ConsentVersion  string    `json:"consent_version"`
	IPAddress       string    `json:"ip_address"`
	UserAgent       string    `json:"user_agent"`
	Jurisdiction    string    `json:"jurisdiction"`
}

// MFAChallenge represents a multi-factor authentication challenge.
type MFAChallenge struct {
	ChallengeID   string    `json:"challenge_id"`
	UserID        string    `json:"user_id"`
	Method        string    `json:"method"` // "TOTP", "SMS", "EMAIL", "PUSH"
	Status        string    `json:"status"` // "PENDING", "VERIFIED", "FAILED", "EXPIRED"
	CreatedAt     time.Time `json:"created_at"`
	ExpiresAt     time.Time `json:"expires_at"`
	AttemptCount  int       `json:"attempt_count"`
	MaxAttempts   int       `json:"max_attempts"`
	BackupCodeUsed bool     `json:"backup_code_used,omitempty"`
}

// BiometricVerification represents biometric authentication result.
type BiometricVerification struct {
	ID            string    `json:"id"`
	UserID        string    `json:"user_id"`
	Type          string    `json:"type"` // "FINGERPRINT", "FACE", "IRIS"
	Status        string    `json:"status"` // "VERIFIED", "FAILED", "TIMEOUT"
	Confidence    float64   `json:"confidence"` // 0-1
	VerifiedAt    time.Time `json:"verified_at"`
	DeviceID      string    `json:"device_id"`
	AttestationKey string   `json:"attestation_key,omitempty"`
}

// JITAccessGrant represents just-in-time privileged access.
type JITAccessGrant struct {
	GrantID       string    `json:"grant_id"`
	UserID        string    `json:"user_id"`
	Resource      string    `json:"resource"`
	Permission    string    `json:"permission"`
	GrantedAt     time.Time `json:"granted_at"`
	ExpiresAt     time.Time `json:"expires_at"`
	RequestReason string    `json:"request_reason,omitempty"`
	ApprovedBy    string    `json:"approved_by,omitempty"`
	ApprovedAt    *time.Time `json:"approved_at,omitempty"`
}

// KMSAccessAudit represents KMS key access tracking.
type KMSAccessAudit struct {
	ID        string    `json:"id"`
	KeyID     string    `json:"key_id"`
	UserID    string    `json:"user_id"`
	Action    string    `json:"action"` // "ENCRYPT", "DECRYPT", "ROTATE"
	Status    string    `json:"status"` // "SUCCESS", "DENIED"
	Reason    string    `json:"reason,omitempty"`
	Timestamp time.Time `json:"timestamp"`
	IPAddress string    `json:"ip_address"`
}

// SecurityIncident represents a security event or incident.
type SecurityIncident struct {
	ID          string    `json:"id"`
	Type        string    `json:"type"` // "SUSPICIOUS_LOGIN", "BRUTE_FORCE", "DATA_EXFIL"
	Severity    string    `json:"severity"` // "LOW", "MEDIUM", "HIGH", "CRITICAL"
	UserID      string    `json:"user_id,omitempty"`
	Description string    `json:"description"`
	DetectedAt  time.Time `json:"detected_at"`
	Status      string    `json:"status"` // "OPEN", "INVESTIGATING", "RESOLVED"
	ResolutionNotes string `json:"resolution_notes,omitempty"`
}

// ComplianceViolation represents a policy breach.
type ComplianceViolation struct {
	ID              string    `json:"id"`
	ViolationType   string    `json:"violation_type"`
	EntityType      string    `json:"entity_type"`
	EntityID        string    `json:"entity_id"`
	DetectedAt      time.Time `json:"detected_at"`
	Policy          string    `json:"policy"` // "GDPR", "HIPAA", etc
	SeverityLevel   string    `json:"severity_level"`
	Description     string    `json:"description"`
	RecommendedAction string  `json:"recommended_action"`
	ResolutionDeadline *time.Time `json:"resolution_deadline,omitempty"`
}
