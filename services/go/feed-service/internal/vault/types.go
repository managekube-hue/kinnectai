package vault

import (
	"time"
)

// VaultMemory represents a memory stored in the vault.
type VaultMemory struct {
	ID               string    `json:"id"`
	UserID           string    `json:"user_id"`
	Title            string    `json:"title"`
	Description      string    `json:"description"`
	EncryptedContent string    `json:"encrypted_content"`
	ContentHash      string    `json:"content_hash"`
	MediaURLs        []string  `json:"media_urls,omitempty"`
	Participants     []string  `json:"participants,omitempty"`
	Tags             []string  `json:"tags,omitempty"`
	CreatedAt        time.Time `json:"created_at"`
	UpdatedAt        time.Time `json:"updated_at"`
	AccessLog        []VaultAccessEvent `json:"access_log,omitempty"`
}

// VaultAccessEvent represents access to a vault memory.
type VaultAccessEvent struct {
	UserID     string    `json:"user_id"`
	Action     string    `json:"action"` // "VIEW", "EDIT", "SHARE"
	Timestamp  time.Time `json:"timestamp"`
	IPAddress  string    `json:"ip_address,omitempty"`
}

// VaultTrigger represents a trigger condition for vault memory release.
type VaultTrigger struct {
	ID               string    `json:"id"`
	VaultMemoryID    string    `json:"vault_memory_id"`
	UserID           string    `json:"user_id"`
	TriggerType      string    `json:"trigger_type"` // "DEATH", "INACTIVITY", "CUSTOM_DATE"
	TriggerCondition TriggerCondition `json:"trigger_condition"`
	ReleaseToUsers   []string  `json:"release_to_users"`
	Notification     string    `json:"notification,omitempty"`
	CreatedAt        time.Time `json:"created_at"`
	ActivatedAt      *time.Time `json:"activated_at,omitempty"`
	ExecutedAt       *time.Time `json:"executed_at,omitempty"`
	IsActive         bool      `json:"is_active"`
}

// TriggerCondition represents the condition for trigger activation.
type TriggerCondition struct {
	ConditionType    string    `json:"condition_type"`
	Value            string    `json:"value"`
	VerificationMethod string  `json:"verification_method,omitempty"` // for death: "CERTIFICATE", "OBITUARY"
	Timestamp        *time.Time `json:"timestamp,omitempty"`
}

// TriggerMetadata represents metadata about a trigger.
type TriggerMetadata struct {
	TriggerID        string    `json:"trigger_id"`
	LastCheckAt      time.Time `json:"last_check_at"`
	CheckInterval    int       `json:"check_interval_hours"`
	ExecutionCount   int       `json:"execution_count"`
	Status           string    `json:"status"` // "ARMED", "TRIGGERED", "EXECUTED"
}

// VerificationState represents the state of verification for a trigger.
type VerificationState struct {
	TriggerID        string    `json:"trigger_id"`
	VerificationMethod string  `json:"verification_method"`
	VerifiedAt       *time.Time `json:"verified_at,omitempty"`
	VerificationToken string   `json:"verification_token,omitempty"`
	IsVerified       bool      `json:"is_verified"`
	ExpiresAt        *time.Time `json:"expires_at,omitempty"`
}

// ShamirReconstructionRequest represents a request to reconstruct encrypted data using Shamir's Secret Sharing.
type ShamirReconstructionRequest struct {
	RequestID        string    `json:"request_id"`
	MemoryID         string    `json:"memory_id"`
	UserID           string    `json:"user_id"`
	ShareIndices     []int     `json:"share_indices"` // which shares are provided
	Shares           []string  `json:"shares"` // encrypted shares
	Threshold        int       `json:"threshold"` // k needed for reconstruction
	CreatedAt        time.Time `json:"created_at"`
	Status           string    `json:"status"` // "PENDING", "RECONSTRUCTED", "FAILED"
}

// ShamirReconstructionResponse represents the result of reconstruction.
type ShamirReconstructionResponse struct {
	RequestID        string    `json:"request_id"`
	ReconstructedContent string `json:"reconstructed_content"`
	ReconstructedAt  time.Time `json:"reconstructed_at"`
	ExpiresAt        time.Time `json:"expires_at"` // short TTL
}

// KMSEncryptRequest represents a request to encrypt data using KMS.
type KMSEncryptRequest struct {
	RequestID        string    `json:"request_id"`
	KeyID            string    `json:"key_id"`
	Plaintext        string    `json:"plaintext"`
	Context          map[string]string `json:"context,omitempty"`
	CreatedAt        time.Time `json:"created_at"`
}

// KMSEncryptResponse represents the result of KMS encryption.
type KMSEncryptResponse struct {
	RequestID        string    `json:"request_id"`
	Ciphertext       string    `json:"ciphertext"`
	KeyID            string    `json:"key_id"`
	EncryptedAt      time.Time `json:"encrypted_at"`
}

// KMSDecryptRequest represents a request to decrypt data using KMS.
type KMSDecryptRequest struct {
	RequestID        string    `json:"request_id"`
	Ciphertext       string    `json:"ciphertext"`
	Context          map[string]string `json:"context,omitempty"`
	CreatedAt        time.Time `json:"created_at"`
}

// KMSDecryptResponse represents the result of KMS decryption.
type KMSDecryptResponse struct {
	RequestID        string    `json:"request_id"`
	Plaintext        string    `json:"plaintext"`
	KeyID            string    `json:"key_id"`
	DecryptedAt      time.Time `json:"decrypted_at"`
}

// EstateRecoveryAudit represents audit trail for legacy contact recovery.
type EstateRecoveryAudit struct {
	AuditID          string    `json:"audit_id"`
	UserID           string    `json:"user_id"`
	DeceasedUserID   string    `json:"deceased_user_id"`
	RecoveryType     string    `json:"recovery_type"` // "FULL", "PARTIAL", "CUSTOM"
	ItemsRecovered   int       `json:"items_recovered"`
	RecoveredAt      time.Time `json:"recovered_at"`
	RecoveredBy      string    `json:"recovered_by"`
	Status           string    `json:"status"` // "PENDING", "COMPLETED"
}
