// SRS §23.1 Category 19 — Infra / Ops types
package infra

import "time"

// ServiceStatus is the operational status of a single microservice.
type ServiceStatus struct {
	ServiceID   string    `json:"service_id"`
	ServiceName string    `json:"service_name"`
	Status      string    `json:"status"`   // healthy | degraded | down
	Version     string    `json:"version"`
	Uptime      float64   `json:"uptime_pct"`
	CheckedAt   time.Time `json:"checked_at"`
}

// DependencyHealth tracks the health of a downstream dependency.
type DependencyHealth struct {
	Name        string        `json:"name"`
	Type        string        `json:"type"` // database | cache | queue | external_api
	Status      string        `json:"status"`
	LatencyMs   int64         `json:"latency_ms"`
	LastError   string        `json:"last_error,omitempty"`
	CheckedAt   time.Time     `json:"checked_at"`
}

// DeploymentMetadata describes a service deployment.
type DeploymentMetadata struct {
	DeploymentID string    `json:"deployment_id"`
	ServiceID    string    `json:"service_id"`
	Version      string    `json:"version"`
	CommitSHA    string    `json:"commit_sha"`
	Environment  string    `json:"environment"` // dev | staging | production
	DeployedBy   string    `json:"deployed_by"`
	DeployedAt   time.Time `json:"deployed_at"`
}

// RollbackResult captures the outcome of a deployment rollback.
type RollbackResult struct {
	DeploymentID    string    `json:"deployment_id"`
	RolledBackTo    string    `json:"rolled_back_to_version"`
	Triggered       time.Time `json:"triggered_at"`
	Completed       time.Time `json:"completed_at"`
	Success         bool      `json:"success"`
	FailureReason   string    `json:"failure_reason,omitempty"`
}

// CanaryMetrics tracks traffic and error rates during a canary deployment.
type CanaryMetrics struct {
	DeploymentID   string    `json:"deployment_id"`
	CanaryPercent  float64   `json:"canary_traffic_pct"`
	ErrorRateCanary float64  `json:"error_rate_canary"`
	ErrorRateStable float64  `json:"error_rate_stable"`
	P99LatencyMs   int64     `json:"p99_latency_ms"`
	MeasuredAt     time.Time `json:"measured_at"`
}

// ChaosExperiment defines a chaos engineering experiment.
type ChaosExperiment struct {
	ExperimentID  string    `json:"experiment_id"`
	TargetService string    `json:"target_service"`
	FaultType     string    `json:"fault_type"` // latency | error | partition | resource
	Magnitude     float64   `json:"magnitude"`
	DurationSecs  int       `json:"duration_seconds"`
	ScheduledAt   time.Time `json:"scheduled_at"`
	IsActive      bool      `json:"is_active"`
}

// ClusterState captures the current state of the Kubernetes cluster.
type ClusterState struct {
	ClusterName   string    `json:"cluster_name"`
	Region        string    `json:"region"`
	NodeCount     int       `json:"node_count"`
	ReadyNodes    int       `json:"ready_nodes"`
	PodCount      int       `json:"pod_count"`
	CPUUtilPct    float64   `json:"cpu_utilization_pct"`
	MemUtilPct    float64   `json:"memory_utilization_pct"`
	RecordedAt    time.Time `json:"recorded_at"`
}

// GPUWorkerState captures the state of a GPU compute worker (for Bloom jobs).
type GPUWorkerState struct {
	WorkerID    string    `json:"worker_id"`
	Region      string    `json:"region"`
	GPUModel    string    `json:"gpu_model"`
	VRAM_GB     float64   `json:"vram_gb"`
	Utilization float64   `json:"utilization_pct"`
	ActiveJobs  int       `json:"active_jobs"`
	Healthy     bool      `json:"healthy"`
	ReportedAt  time.Time `json:"reported_at"`
}
