// Package foundation defines shared types used across all KinnectAI backend services.
// SRS §23.1 Category 1 — Foundation / Core Types
package foundation

import (
	"time"

	"github.com/google/uuid"
)

// ErrorResponse is the canonical API error envelope.
type ErrorResponse struct {
	Code      string            `json:"code"`
	Message   string            `json:"message"`
	RequestID string            `json:"request_id,omitempty"`
	Details   map[string]string `json:"details,omitempty"`
}

// Pagination holds offset-based page metadata.
type Pagination struct {
	Page       int `json:"page"`
	PageSize   int `json:"page_size"`
	TotalItems int `json:"total_items"`
	TotalPages int `json:"total_pages"`
}

// CursorPagination holds cursor-based page metadata for infinite feeds.
type CursorPagination struct {
	NextCursor string `json:"next_cursor,omitempty"`
	PrevCursor string `json:"prev_cursor,omitempty"`
	HasMore    bool   `json:"has_more"`
	PageSize   int    `json:"page_size"`
}

// HealthCheckResponse is the standard /healthz response.
type HealthCheckResponse struct {
	Status      string                       `json:"status"` // ok | degraded | down
	Version     string                       `json:"version"`
	Timestamp   time.Time                    `json:"timestamp"`
	Services    map[string]ServiceDependency `json:"services,omitempty"`
}

// Metadata holds generic key-value metadata attached to resources.
type Metadata struct {
	CreatedAt time.Time         `json:"created_at"`
	UpdatedAt time.Time         `json:"updated_at"`
	Tags      map[string]string `json:"tags,omitempty"`
}

// AuditLog records a single auditable event.
type AuditLog struct {
	ID         uuid.UUID         `json:"id"`
	ActorID    uuid.UUID         `json:"actor_id"`
	Action     string            `json:"action"`
	ResourceID string            `json:"resource_id"`
	Resource   string            `json:"resource_type"`
	IPAddress  string            `json:"ip_address,omitempty"`
	UserAgent  string            `json:"user_agent,omitempty"`
	Metadata   map[string]string `json:"metadata,omitempty"`
	OccurredAt time.Time         `json:"occurred_at"`
}

// ConfidenceInterval represents a statistical confidence range.
type ConfidenceInterval struct {
	Lower      float64 `json:"lower"`
	Upper      float64 `json:"upper"`
	Confidence float64 `json:"confidence"` // e.g. 0.95 for 95%
}

// FeatureFlag controls runtime feature enablement.
type FeatureFlag struct {
	Name        string            `json:"name"`
	Enabled     bool              `json:"enabled"`
	Percentage  float64           `json:"rollout_percentage,omitempty"`
	Constraints map[string]string `json:"constraints,omitempty"`
}

// Region identifies a geographic or data-residency region.
type Region struct {
	Code        string `json:"code"`        // e.g. "us-east-1"
	DisplayName string `json:"display_name"`
	DataCenter  string `json:"data_center"`
}

// DeviceFingerprint captures client device attributes for fraud/session binding.
type DeviceFingerprint struct {
	FingerprintID string    `json:"fingerprint_id"`
	UserAgent     string    `json:"user_agent"`
	Platform      string    `json:"platform"`
	OSVersion     string    `json:"os_version"`
	AppVersion    string    `json:"app_version"`
	IPAddress     string    `json:"ip_address"`
	CapturedAt    time.Time `json:"captured_at"`
}

// CorrelationID is a trace propagation identifier.
type CorrelationID struct {
	TraceID  string `json:"trace_id"`
	SpanID   string `json:"span_id"`
	ParentID string `json:"parent_id,omitempty"`
}

// ServiceDependency reports health of a downstream service.
type ServiceDependency struct {
	Name      string        `json:"name"`
	Status    string        `json:"status"` // ok | degraded | down
	Latency   time.Duration `json:"latency_ms"`
	CheckedAt time.Time     `json:"checked_at"`
}

// DistributedTrace aggregates spans for a single request.
type DistributedTrace struct {
	TraceID   string        `json:"trace_id"`
	Spans     []TraceSpan   `json:"spans"`
	TotalMS   int64         `json:"total_ms"`
	ServiceID string        `json:"service_id"`
}

// TraceSpan is a single operation within a distributed trace.
type TraceSpan struct {
	SpanID    string    `json:"span_id"`
	ParentID  string    `json:"parent_id,omitempty"`
	Operation string    `json:"operation"`
	StartedAt time.Time `json:"started_at"`
	EndedAt   time.Time `json:"ended_at"`
	Tags      map[string]string `json:"tags,omitempty"`
}

// ErrorBudget tracks SLO burn rate.
type ErrorBudget struct {
	ServiceID       string    `json:"service_id"`
	SLOTarget       float64   `json:"slo_target"`       // e.g. 0.999
	ConsumedPercent float64   `json:"consumed_percent"`
	WindowStart     time.Time `json:"window_start"`
	WindowEnd       time.Time `json:"window_end"`
}

// SLAMetric captures a single SLA measurement.
type SLAMetric struct {
	MetricName string    `json:"metric_name"`
	Value      float64   `json:"value"`
	Unit       string    `json:"unit"`
	ServiceID  string    `json:"service_id"`
	RecordedAt time.Time `json:"recorded_at"`
}

// ObservabilityEvent is a structured log/event for telemetry pipelines.
type ObservabilityEvent struct {
	EventID    uuid.UUID         `json:"event_id"`
	Level      string            `json:"level"`      // info | warn | error | critical
	Message    string            `json:"message"`
	Service    string            `json:"service"`
	TraceID    string            `json:"trace_id,omitempty"`
	Attributes map[string]string `json:"attributes,omitempty"`
	EmittedAt  time.Time         `json:"emitted_at"`
}
