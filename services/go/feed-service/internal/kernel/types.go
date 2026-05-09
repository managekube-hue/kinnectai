package kernel

import (
	"time"
)

// KCScore represents the Kinnection Kernel score for a user pair.
type KCScore struct {
	ScoreID          string    `json:"score_id"`
	UserID           string    `json:"user_id"`
	TargetUserID     string    `json:"target_user_id"`
	Score            float64   `json:"score"` // 0-100
	Confidence       float64   `json:"confidence"`
	Components       map[string]float64 `json:"components"` // genetic, behavioral, geographic, etc
	ModelVersion     string    `json:"model_version"`
	ComputedAt       time.Time `json:"computed_at"`
	ExpiresAt        *time.Time `json:"expires_at,omitempty"`
}

// KCModelVersion represents a version of the KC kernel model.
type KCModelVersion struct {
	VersionID        string    `json:"version_id"`
	ModelName        string    `json:"model_name"`
	Version          string    `json:"version"` // semver
	ReleaseDate      time.Time `json:"release_date"`
	Status           string    `json:"status"` // "ACTIVE", "DEPRECATED", "EXPERIMENTAL"
	Accuracy         float64   `json:"accuracy"`
	Performance      map[string]interface{} `json:"performance"`
	Dependencies     []string  `json:"dependencies"`
}

// FeatureImportance represents the importance of a feature in KC scoring.
type FeatureImportance struct {
	FeatureName      string    `json:"feature_name"`
	Importance       float64   `json:"importance"` // 0-1
	Rank             int       `json:"rank"`
	Category         string    `json:"category"` // "GENETIC", "BEHAVIORAL", "CONTEXTUAL"
	Contribution     float64   `json:"contribution"` // impact on final score
}

// LayerWeight represents weights for a specific layer in the KC model.
type LayerWeight struct {
	LayerID          string    `json:"layer_id"`
	LayerName        string    `json:"layer_name"` // "genetic", "behavioral", etc
	Weight           float64   `json:"weight"` // 0-1
	UpdatedAt        time.Time `json:"updated_at"`
	ExperimentID     string    `json:"experiment_id,omitempty"`
}

// KernelAudit represents an audit trail for KC scoring decisions.
type KernelAudit struct {
	AuditID          string    `json:"audit_id"`
	ScoreID          string    `json:"score_id"`
	UserID           string    `json:"user_id"`
	Action           string    `json:"action"` // "COMPUTE", "ADJUST", "INVALIDATE"
	ReasoningLog     string    `json:"reasoning_log"`
	InputFeatures    map[string]interface{} `json:"input_features"`
	OutputScore      float64   `json:"output_score"`
	TimestampAt      time.Time `json:"timestamp_at"`
	AuditedBy        string    `json:"audited_by,omitempty"`
}

// ModelLineage represents the lineage and evolution of KC models.
type ModelLineage struct {
	LineageID        string    `json:"lineage_id"`
	ModelFamily      string    `json:"model_family"`
	BaseModelVersion string    `json:"base_model_version"`
	Iterations       int       `json:"iterations"`
	DriftDetection   bool      `json:"drift_detection"`
	RetrainingReason string    `json:"retraining_reason,omitempty"`
	CreatedAt        time.Time `json:"created_at"`
}

// DriftDetectionResult represents the result of model drift detection.
type DriftDetectionResult struct {
	ResultID         string    `json:"result_id"`
	ModelVersion     string    `json:"model_version"`
	DriftDetected    bool      `json:"drift_detected"`
	DriftScore       float64   `json:"drift_score"`
	AffectedFeatures []string  `json:"affected_features"`
	RecommendedAction string   `json:"recommended_action"` // "RETRAIN", "MONITOR", "NONE"
	DetectedAt       time.Time `json:"detected_at"`
}

// BiasAudit represents bias detection and audit results.
type BiasAudit struct {
	AuditID          string    `json:"audit_id"`
	ModelVersion     string    `json:"model_version"`
	BiasDetected     bool      `json:"bias_detected"`
	BiasScore        float64   `json:"bias_score"` // 0-1
	AffectedGroups   []string  `json:"affected_groups"`
	BiasType         string    `json:"bias_type"` // "DEMOGRAPHIC", "SELECTION", "MEASUREMENT"
	RecommendedAction string   `json:"recommended_action"`
	AuditedAt        time.Time `json:"audited_at"`
}

// ReplayInferenceRequest represents a request to replay past inferences for validation.
type ReplayInferenceRequest struct {
	RequestID        string    `json:"request_id"`
	ModelVersion     string    `json:"model_version"`
	HistoricalDataID string    `json:"historical_data_id"`
	UserID           string    `json:"user_id"`
	TargetUserID     string    `json:"target_user_id"`
	Status           string    `json:"status"` // "QUEUED", "RUNNING", "COMPLETED"
	CreatedAt        time.Time `json:"created_at"`
	CompletedAt      *time.Time `json:"completed_at,omitempty"`
	OriginalScore    float64   `json:"original_score,omitempty"`
	ReplayedScore    float64   `json:"replayed_score,omitempty"`
}
