// SRS §23.1 Category 7 — KC Kernel / AI types
package kernel

import (
	"time"

	"github.com/google/uuid"
)

// KCExplainRequest asks the kernel to explain a KinScore between two users.
type KCExplainRequest struct {
	UserAID      uuid.UUID `json:"user_a_id" binding:"required"`
	UserBID      uuid.UUID `json:"user_b_id" binding:"required"`
	ModelVersion string    `json:"model_version,omitempty"`
}

// KCExplainResponse is the explainability payload from the KC kernel.
type KCExplainResponse struct {
	UserAID            uuid.UUID                          `json:"user_a_id"`
	UserBID            uuid.UUID                          `json:"user_b_id"`
	KinScore           float64                            `json:"kin_score"`
	TopFeatures        []KCExplainResponseTopFeaturesInner `json:"top_features"`
	ConfidenceInterval KCExplainResponseConfidenceInterval `json:"confidence_interval"`
	ModelVersion       string                             `json:"model_version"`
	ComputedAt         time.Time                          `json:"computed_at"`
}

// KCExplainResponseTopFeaturesInner is a single feature contribution.
type KCExplainResponseTopFeaturesInner struct {
	FeatureName string  `json:"feature_name"`
	Importance  float64 `json:"importance"`
	Direction   string  `json:"direction"` // positive | negative
}

// KCExplainResponseConfidenceInterval is the statistical confidence range for a KinScore.
type KCExplainResponseConfidenceInterval struct {
	Lower      float64 `json:"lower"`
	Upper      float64 `json:"upper"`
	Confidence float64 `json:"confidence"`
}

// KCScore is a stored KinScore record.
type KCScore struct {
	ScoreID      uuid.UUID `json:"score_id"`
	UserAID      uuid.UUID `json:"user_a_id"`
	UserBID      uuid.UUID `json:"user_b_id"`
	Score        float64   `json:"score"`
	DisplayScore int       `json:"display_score"`
	ModelVersion string    `json:"model_version"`
	ComputedAt   time.Time `json:"computed_at"`
	TTLSeconds   int       `json:"ttl_seconds"`
}

// KCModelVersion describes a versioned kernel model deployment.
type KCModelVersion struct {
	Version     string    `json:"version"`
	Description string    `json:"description"`
	DeployedAt  time.Time `json:"deployed_at"`
	IsActive    bool      `json:"is_active"`
	Checksum    string    `json:"checksum"`
}

// FeatureImportance aggregates feature weights from a model version.
type FeatureImportance struct {
	ModelVersion string             `json:"model_version"`
	Features     []FeatureWeight    `json:"features"`
	ComputedAt   time.Time          `json:"computed_at"`
}

// FeatureWeight is the global importance weight for a single model feature.
type FeatureWeight struct {
	FeatureName string  `json:"feature_name"`
	Weight      float64 `json:"weight"`
}

// LayerWeight holds neural layer weight metadata for interpretability.
type LayerWeight struct {
	LayerName  string    `json:"layer_name"`
	LayerIndex int       `json:"layer_index"`
	WeightNorm float64   `json:"weight_norm"`
	SnapshotAt time.Time `json:"snapshot_at"`
}

// KernelAudit tracks an inference request for auditability.
type KernelAudit struct {
	AuditID      uuid.UUID `json:"audit_id"`
	UserAID      uuid.UUID `json:"user_a_id"`
	UserBID      uuid.UUID `json:"user_b_id"`
	ModelVersion string    `json:"model_version"`
	InputHash    string    `json:"input_hash"`
	OutputScore  float64   `json:"output_score"`
	LatencyMs    int64     `json:"latency_ms"`
	RequestedBy  string    `json:"requested_by"`
	InvokedAt    time.Time `json:"invoked_at"`
}

// ModelLineage tracks the training ancestry of a model version.
type ModelLineage struct {
	ModelVersion  string    `json:"model_version"`
	ParentVersion string    `json:"parent_version,omitempty"`
	TrainingJobID string    `json:"training_job_id"`
	DatasetRef    string    `json:"dataset_ref"`
	FineTuned     bool      `json:"fine_tuned"`
	CreatedAt     time.Time `json:"created_at"`
}

// DriftDetectionResult captures statistical drift between model training and live distributions.
type DriftDetectionResult struct {
	ModelVersion   string    `json:"model_version"`
	DriftScore     float64   `json:"drift_score"`
	DriftDetected  bool      `json:"drift_detected"`
	AffectedFeatures []string `json:"affected_features,omitempty"`
	DetectedAt     time.Time `json:"detected_at"`
}

// BiasAudit assesses demographic bias in model outputs.
type BiasAudit struct {
	AuditID      uuid.UUID         `json:"audit_id"`
	ModelVersion string            `json:"model_version"`
	Segments     map[string]float64 `json:"segments"` // segment_name -> disparity_score
	PassedThreshold bool           `json:"passed_threshold"`
	AuditedAt    time.Time         `json:"audited_at"`
}

// ReplayInferenceRequest asks the kernel to re-score a historical pair with the current model.
type ReplayInferenceRequest struct {
	UserAID      uuid.UUID `json:"user_a_id" binding:"required"`
	UserBID      uuid.UUID `json:"user_b_id" binding:"required"`
	OriginalScore float64  `json:"original_score"`
	Reason       string    `json:"reason"`
}
