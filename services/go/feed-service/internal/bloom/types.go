package bloom

import (
	"time"
)

// BloomJob represents an AI media generation job.
type BloomJob struct {
	ID               string    `json:"id"`
	UserID           string    `json:"user_id"`
	JobType          string    `json:"job_type"` // "VOICEPRINT", "VIDEO_GEN", "IMAGE_GEN"
	Status           string    `json:"status"` // "QUEUED", "PROCESSING", "COMPLETED", "FAILED"
	ProgressPercent  int       `json:"progress_percent"`
	CreatedAt        time.Time `json:"created_at"`
	StartedAt        *time.Time `json:"started_at,omitempty"`
	CompletedAt      *time.Time `json:"completed_at,omitempty"`
	ResultURL        string    `json:"result_url,omitempty"`
	ErrorMessage     string    `json:"error_message,omitempty"`
	Metadata         map[string]interface{} `json:"metadata,omitempty"`
}

// Voiceprint represents a user's voice biometric profile.
type Voiceprint struct {
	ID               string    `json:"id"`
	UserID           string    `json:"user_id"`
	VoiceprintVector []float64 `json:"voiceprint_vector"` // embedding
	SampleDurationSec int      `json:"sample_duration_sec"`
	Quality          string    `json:"quality"` // "HIGH", "MEDIUM", "LOW"
	CreatedAt        time.Time `json:"created_at"`
	LastUpdatedAt    time.Time `json:"last_updated_at"`
	IsRevoked        bool      `json:"is_revoked"`
	RevokedAt        *time.Time `json:"revoked_at,omitempty"`
	RevokeReason     string    `json:"revoke_reason,omitempty"`
}

// MediaGenerationRequest represents a request to generate synthetic media.
type MediaGenerationRequest struct {
	RequestID        string    `json:"request_id"`
	UserID           string    `json:"user_id"`
	MediaType        string    `json:"media_type"` // "VIDEO", "IMAGE", "AUDIO"
	Style            string    `json:"style"`
	Duration         int       `json:"duration,omitempty"` // seconds
	Parameters       map[string]interface{} `json:"parameters"`
	CreatedAt        time.Time `json:"created_at"`
	Status           string    `json:"status"` // "PENDING", "PROCESSING", "COMPLETE"
}

// MediaGenerationResult represents the result of media generation.
type MediaGenerationResult struct {
	ResultID         string    `json:"result_id"`
	RequestID        string    `json:"request_id"`
	MediaURL         string    `json:"media_url"`
	ThumbnailURL     string    `json:"thumbnail_url,omitempty"`
	C2PAManifestURL  string    `json:"c2pa_manifest_url,omitempty"`
	GeneratedAt      time.Time `json:"generated_at"`
	ExpiresAt        *time.Time `json:"expires_at,omitempty"`
	Quality          string    `json:"quality"`
}

// C2PAManifest represents a Coalition for Content Provenance & Authenticity manifest.
type C2PAManifest struct {
	ManifestID       string    `json:"manifest_id"`
	MediaID          string    `json:"media_id"`
	CreatorID        string    `json:"creator_id"`
	CreationTime     time.Time `json:"creation_time"`
	GenerationModel  string    `json:"generation_model"` // model version used
	Hash             string    `json:"hash"` // content hash
	Signature        string    `json:"signature"` // cryptographic signature
	ChainOfCustody   []C2PAEntry `json:"chain_of_custody"`
	IsAuthentic      bool      `json:"is_authentic"`
}

// C2PAEntry represents a single entry in the C2PA chain of custody.
type C2PAEntry struct {
	Action       string    `json:"action"` // "CREATED", "EDITED", "SIGNED"
	ActorID      string    `json:"actor_id"`
	Timestamp    time.Time `json:"timestamp"`
	Software     string    `json:"software,omitempty"`
	Hash         string    `json:"hash"`
}

// SyntheticMediaMetadata represents metadata about synthetic/generated media.
type SyntheticMediaMetadata struct {
	ID               string    `json:"id"`
	MediaID          string    `json:"media_id"`
	GenerationModel  string    `json:"generation_model"`
	ConfidenceScore  float64   `json:"confidence_score"`
	DisclosureFlag   bool      `json:"disclosure_flag"` // should be disclosed as synthetic
	SynthTypeDetectable bool   `json:"synth_type_detectable"` // detection likelihood
	CreatedAt        time.Time `json:"created_at"`
}

// DeepfakeVerification represents verification results for deepfake detection.
type DeepfakeVerification struct {
	VerificationID   string    `json:"verification_id"`
	MediaID          string    `json:"media_id"`
	IsDeepfake       bool      `json:"is_deepfake"`
	Confidence       float64   `json:"confidence"`
	DetectionMethod  string    `json:"detection_method"` // "FACIAL", "AUDIO", "BEHAVIORAL"
	VerifiedAt       time.Time `json:"verified_at"`
}

// VoiceCloneAudit represents audit trail for voice cloning usage.
type VoiceCloneAudit struct {
	AuditID          string    `json:"audit_id"`
	UserID           string    `json:"user_id"`
	VoiceprintID     string    `json:"voiceprint_id"`
	CloneCount       int       `json:"clone_count"`
	LastCloneAt      *time.Time `json:"last_clone_at,omitempty"`
	TotalDurationSec int       `json:"total_duration_sec"`
	IsRevoked        bool      `json:"is_revoked"`
}
