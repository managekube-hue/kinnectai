package infra

import (
	"time"
)

// ServiceStatus represents current status of a service.
type ServiceStatus struct {
	ServiceName    string    `json:"service_name"`
	Status         string    `json:"status"` // "UP", "DEGRADED", "DOWN"
	LastChecked    time.Time `json:"last_checked"`
	Uptime99Pct    float64   `json:"uptime_99pct"`
	AverageLatency int       `json:"average_latency_ms"`
	Dependencies   []DependencyHealth `json:"dependencies"`
}

// DependencyHealth represents health of a service dependency.
type DependencyHealth struct {
	DependencyName string    `json:"dependency_name"`
	Status         string    `json:"status"`
	LastChecked    time.Time `json:"last_checked"`
	LatencyMS      int       `json:"latency_ms"`
}

// DeploymentMetadata represents deployment information.
type DeploymentMetadata struct {
	DeploymentID   string    `json:"deployment_id"`
	Service        string    `json:"service"`
	Version        string    `json:"version"`
	GitCommit      string    `json:"git_commit"`
	DeployedAt     time.Time `json:"deployed_at"`
	DeployedBy     string    `json:"deployed_by"`
	Region         string    `json:"region"`
	InstanceCount  int       `json:"instance_count"`
	Status         string    `json:"status"` // "ACTIVE", "ROLLING_OUT", "ROLLED_BACK"
}

// RollbackResult represents result of a rollback operation.
type RollbackResult struct {
	RollbackID     string    `json:"rollback_id"`
	DeploymentID   string    `json:"deployment_id"`
	Service        string    `json:"service"`
	FromVersion    string    `json:"from_version"`
	ToVersion      string    `json:"to_version"`
	Reason         string    `json:"reason"`
	InitiatedBy    string    `json:"initiated_by"`
	InitiatedAt    time.Time `json:"initiated_at"`
	CompletedAt    *time.Time `json:"completed_at,omitempty"`
	Status         string    `json:"status"` // "IN_PROGRESS", "COMPLETED", "FAILED"
	RollbackTimeMS int       `json:"rollback_time_ms"`
}

// CanaryMetrics represents metrics from a canary deployment.
type CanaryMetrics struct {
	CanaryID       string    `json:"canary_id"`
	DeploymentID   string    `json:"deployment_id"`
	Service        string    `json:"service"`
	TrafficPercent int       `json:"traffic_percent"` // % of traffic to canary
	ErrorRate      float64   `json:"error_rate"`
	P99Latency     int       `json:"p99_latency_ms"`
	OkToPromote    bool      `json:"ok_to_promote"`
	StartedAt      time.Time `json:"started_at"`
	CollectedAt    time.Time `json:"collected_at"`
}

// ChaosExperiment represents a chaos engineering experiment.
type ChaosExperiment struct {
	ExperimentID   string    `json:"experiment_id"`
	Name           string    `json:"name"`
	Description    string    `json:"description"`
	Target         string    `json:"target"` // service name
	FaultType      string    `json:"fault_type"` // "LATENCY", "ERROR_RATE", "LOSS"
	Severity       string    `json:"severity"` // "LOW", "MEDIUM", "HIGH"
	StartedAt      time.Time `json:"started_at"`
	EndedAt        *time.Time `json:"ended_at,omitempty"`
	Status         string    `json:"status"` // "RUNNING", "COMPLETED", "FAILED"
	Results        map[string]interface{} `json:"results,omitempty"`
}

// ClusterState represents cluster-level infrastructure state.
type ClusterState struct {
	ClusterID      string    `json:"cluster_id"`
	Name           string    `json:"name"`
	Region         string    `json:"region"`
	NodeCount      int       `json:"node_count"`
	HealthyNodes   int       `json:"healthy_nodes"`
	Status         string    `json:"status"` // "HEALTHY", "DEGRADED", "CRITICAL"
	CPUUsageAvg    float64   `json:"cpu_usage_avg"`
	MemoryUsageAvg float64   `json:"memory_usage_avg"`
	DiskSpaceAvg   float64   `json:"disk_space_avg"`
	LastUpdatedAt  time.Time `json:"last_updated_at"`
}

// GPUWorkerState represents GPU worker node state.
type GPUWorkerState struct {
	NodeID         string    `json:"node_id"`
	GPUCount       int       `json:"gpu_count"`
	GPUUtilization []float64 `json:"gpu_utilization"` // per GPU
	Temperature    []float64 `json:"temperature"` // per GPU
	MemoryUsage    []int     `json:"memory_usage"` // per GPU in MB
	ActiveJobs     int       `json:"active_jobs"`
	Status         string    `json:"status"` // "READY", "BUSY", "ERROR"
	LastUpdatedAt  time.Time `json:"last_updated_at"`
}
