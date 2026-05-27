package pkg

import (
	"context"
	"time"

	"go.opentelemetry.io/otel/attribute"
	"go.opentelemetry.io/otel/trace"
)

// TracerProvider wraps OpenTelemetry tracing.
type TracerProvider struct {
	tracer trace.Tracer
}

// NewTracerProvider creates a new tracer provider.
func NewTracerProvider(tracer trace.Tracer) *TracerProvider {
	return &TracerProvider{tracer: tracer}
}

// StartSpan creates a new trace span.
func (tp *TracerProvider) StartSpan(ctx context.Context, name string) (context.Context, trace.Span) {
	return tp.tracer.Start(ctx, name)
}

// MetricsCollector wraps OpenTelemetry metrics for lightweight runtime collection.
type MetricsCollector struct {
	// Metrics fields would be initialized here
}

// RecordLatency records operation latency in milliseconds.
func (mc *MetricsCollector) RecordLatency(ctx context.Context, operation string, duration time.Duration) {
	// Implementation would record to histogram
}

// RecordError increments error counter.
func (mc *MetricsCollector) RecordError(ctx context.Context, operation string, errorType string) {
	// Implementation would increment counter
}

// Logger is a structured logging interface compatible with zerolog/slog.
type Logger interface {
	Info(ctx context.Context, msg string, fields ...attribute.KeyValue)
	Warn(ctx context.Context, msg string, fields ...attribute.KeyValue)
	Error(ctx context.Context, msg string, fields ...attribute.KeyValue)
	Debug(ctx context.Context, msg string, fields ...attribute.KeyValue)
}
