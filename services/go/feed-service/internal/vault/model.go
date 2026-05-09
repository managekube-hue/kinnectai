// SRS §23.1 Category 9 — Memory Box / Vault types
package vault

import (
	"time"

	"github.com/google/uuid"
)

// MemoryboxPostRequest is the client request to seal a memory into the vault.
type MemoryboxPostRequest struct {
	Title        string    `json:"title" binding:"required"`
	MediaType    string    `json:"media_type" binding:"required"` // text | image | video | audio
	ContentRef   string    `json:"content_ref" binding:"required"`
	TriggerAt    *time.Time `json:"trigger_at,omitempty"`
	StewardID    *uuid.UUID `json:"steward_id,omitempty"`
}

// VaultSealedResponse confirms a memory was sealed successfully.
type VaultSealedResponse struct {
	MemoryID    uuid.UUID `json:"memory_id"`
	SealedAt    time.Time `json:"sealed_at"`
	KMSKeyID    string    `json:"kms_key_id"`
	TriggerID   *uuid.UUID `json:"trigger_id,omitempty"`
}

// VaultMemory is the full record of a sealed vault memory.
type VaultMemory struct {
	MemoryID     uuid.UUID  `json:"memory_id"`
	UserID       uuid.UUID  `json:"user_id"`
	Title        string     `json:"title"`
	MediaType    string     `json:"media_type"`
	ContentRef   string     `json:"content_ref_encrypted"`
	KMSKeyID     string     `json:"kms_key_id"`
	StewardID    *uuid.UUID `json:"steward_id,omitempty"`
	Status       string     `json:"status"` // sealed | triggered | unlocked | revoked
	SealedAt     time.Time  `json:"sealed_at"`
	UnlockedAt   *time.Time `json:"unlocked_at,omitempty"`
}

// VaultTrigger defines the condition that unlocks a vault memory.
type VaultTrigger struct {
	TriggerID    uuid.UUID       `json:"trigger_id"`
	MemoryID     uuid.UUID       `json:"memory_id"`
	TriggerType  string          `json:"trigger_type"` // date | event | steward_confirm | inactivity
	Condition    TriggerCondition `json:"condition"`
	Metadata     TriggerMetadata  `json:"metadata"`
	State        string          `json:"state"` // pending | fired | cancelled
	CreatedAt    time.Time       `json:"created_at"`
}

// TriggerCondition holds the evaluation logic for a vault trigger.
type TriggerCondition struct {
	TriggerDate       *time.Time `json:"trigger_date,omitempty"`
	InactivityDays    *int       `json:"inactivity_days,omitempty"`
	EventCode         string     `json:"event_code,omitempty"`
	StewardApproval   bool       `json:"steward_approval_required"`
}

// TriggerMetadata holds descriptive metadata for a trigger.
type TriggerMetadata struct {
	Label       string `json:"label"`
	Description string `json:"description,omitempty"`
	CreatedBy   string `json:"created_by"`
}

// VerificationState tracks multi-party verification for vault unlock.
type VerificationState struct {
	TriggerID       uuid.UUID  `json:"trigger_id"`
	RequiredParties int        `json:"required_parties"`
	VerifiedParties int        `json:"verified_parties"`
	IsComplete      bool       `json:"is_complete"`
	CompletedAt     *time.Time `json:"completed_at,omitempty"`
}

// ShamirReconstructionRequest asks the vault to reconstruct a Shamir secret.
type ShamirReconstructionRequest struct {
	MemoryID uuid.UUID `json:"memory_id" binding:"required"`
	Shares   []string  `json:"shares" binding:"required"`
}

// ShamirReconstructionResponse returns the reconstructed decryption key.
type ShamirReconstructionResponse struct {
	MemoryID    uuid.UUID `json:"memory_id"`
	ReconstructedKey string `json:"reconstructed_key"`
	Success     bool      `json:"success"`
}

// KMSEncryptRequest is a request to encrypt data via the KMS.
type KMSEncryptRequest struct {
	KeyID     string `json:"key_id" binding:"required"`
	Plaintext string `json:"plaintext" binding:"required"`
	Context   map[string]string `json:"context,omitempty"`
}

// KMSEncryptResponse returns the ciphertext from KMS.
type KMSEncryptResponse struct {
	KeyID      string `json:"key_id"`
	Ciphertext string `json:"ciphertext"`
}

// KMSDecryptRequest is a request to decrypt data via the KMS.
type KMSDecryptRequest struct {
	KeyID      string `json:"key_id" binding:"required"`
	Ciphertext string `json:"ciphertext" binding:"required"`
	Context    map[string]string `json:"context,omitempty"`
}

// KMSDecryptResponse returns the plaintext from KMS.
type KMSDecryptResponse struct {
	KeyID     string `json:"key_id"`
	Plaintext string `json:"plaintext"`
}

// EstateRecoveryAudit tracks access to a vault during estate recovery.
type EstateRecoveryAudit struct {
	AuditID      uuid.UUID `json:"audit_id"`
	MemoryID     uuid.UUID `json:"memory_id"`
	StewardID    uuid.UUID `json:"steward_id"`
	Action       string    `json:"action"` // unlocked | accessed | exported
	IPAddress    string    `json:"ip_address"`
	OccurredAt   time.Time `json:"occurred_at"`
}
