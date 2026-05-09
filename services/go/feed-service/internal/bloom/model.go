// SRS §23.1 Category 8 — Bloom / AI Media types
package bloom

import (
	"time"

	"github.com/google/uuid"
)

// BloomRequest is the client request to queue an AI media generation job.
type BloomRequest struct {
	UserID      uuid.UUID `json:"user_id" binding:"required"`
	MediaType   string    `json:"media_type" binding:"required"` // image | video | audio
	Prompt      string    `json:"prompt" binding:"required"`
	StyleTag    string    `json:"style_tag,omitempty"`
	VoiceprintID *uuid.UUID `json:"voiceprint_id,omitempty"`
}

// BloomJobResponse is the immediate response after enqueuing a Bloom job.
type BloomJobResponse struct {
	JobID     uuid.UUID `json:"job_id"`
	Status    string    `json:"status"` // queued | processing | completed | failed
	EstimatedSecs int   `json:"estimated_seconds,omitempty"`
	QueuedAt  time.Time `json:"queued_at"`
}

// BloomJob is the full record of an AI media generation job.
type BloomJob struct {
	JobID       uuid.UUID  `json:"job_id"`
	UserID      uuid.UUID  `json:"user_id"`
	MediaType   string     `json:"media_type"`
	Prompt      string     `json:"prompt"`
	Status      string     `json:"status"`
	ResultURL   string     `json:"result_url,omitempty"`
	ManifestID  string     `json:"manifest_id,omitempty"`
	ErrorMsg    string     `json:"error,omitempty"`
	StartedAt   *time.Time `json:"started_at,omitempty"`
	CompletedAt *time.Time `json:"completed_at,omitempty"`
	CreatedAt   time.Time  `json:"created_at"`
}

// Voiceprint stores a user's consented voice model reference.
type Voiceprint struct {
	VoiceprintID  uuid.UUID  `json:"voiceprint_id"`
	UserID        uuid.UUID  `json:"user_id"`
	ModelRef      string     `json:"model_ref"`
	ConsentGiven  bool       `json:"consent_given"`
	ConsentAt     *time.Time `json:"consent_at,omitempty"`
	RevokedAt     *time.Time `json:"revoked_at,omitempty"`
	CreatedAt     time.Time  `json:"created_at"`
}

// MediaGenerationRequest is the internal payload sent to the GPU media worker.
type MediaGenerationRequest struct {
	JobID       uuid.UUID          `json:"job_id"`
	MediaType   string             `json:"media_type"`
	Prompt      string             `json:"prompt"`
	Parameters  map[string]string  `json:"parameters,omitempty"`
	VoiceRef    string             `json:"voice_ref,omitempty"`
	CallbackURL string             `json:"callback_url"`
}

// MediaGenerationResult is the result payload returned by the GPU worker.
type MediaGenerationResult struct {
	JobID      uuid.UUID `json:"job_id"`
	OutputURL  string    `json:"output_url"`
	Checksum   string    `json:"checksum"`
	DurationMS int64     `json:"duration_ms"`
	GPUNode    string    `json:"gpu_node"`
}

// C2PAManifest holds the Coalition for Content Provenance and Authenticity manifest.
type C2PAManifest struct {
	ManifestID   string    `json:"manifest_id"`
	AssetURL     string    `json:"asset_url"`
	Issuer       string    `json:"issuer"`
	GeneratedBy  string    `json:"generated_by"` // model name
	Signature    string    `json:"signature"`
	IssuedAt     time.Time `json:"issued_at"`
}

// SyntheticMediaMetadata augments an asset with AI-generation attribution.
type SyntheticMediaMetadata struct {
	AssetID      uuid.UUID `json:"asset_id"`
	IsSynthetic  bool      `json:"is_synthetic"`
	ModelVersion string    `json:"model_version"`
	ManifestID   string    `json:"manifest_id"`
	Watermarked  bool      `json:"watermarked"`
	CreatedAt    time.Time `json:"created_at"`
}

// DeepfakeVerification records the result of a deepfake detection check.
type DeepfakeVerification struct {
	VerificationID uuid.UUID `json:"verification_id"`
	AssetURL       string    `json:"asset_url"`
	IsFake         bool      `json:"is_fake"`
	Confidence     float64   `json:"confidence"`
	DetectorModel  string    `json:"detector_model"`
	CheckedAt      time.Time `json:"checked_at"`
}

// VoiceCloneAudit tracks consent and usage for a cloned voice.
type VoiceCloneAudit struct {
	AuditID        uuid.UUID  `json:"audit_id"`
	UserID         uuid.UUID  `json:"user_id"`
	VoiceprintID   uuid.UUID  `json:"voiceprint_id"`
	UsedInJobID    uuid.UUID  `json:"used_in_job_id"`
	ConsentVerified bool      `json:"consent_verified"`
	UsedAt         time.Time  `json:"used_at"`
}
