package telemetry

import (
	"context"
	"log"
	"os"
	"sync"
	"sync/atomic"

	"go.opentelemetry.io/otel"
	"go.opentelemetry.io/otel/metric"
	"go.opentelemetry.io/otel/trace"
)

var (
	metricCounter = struct {
		sync.RWMutex
		values map[string]float64
	}{values: make(map[string]float64)}

	requestTotal     atomic.Int64
	errorTotal       atomic.Int64
	serviceHealthMap = struct {
		sync.RWMutex
		values map[string]ServiceHealthStatus
	}{values: make(map[string]ServiceHealthStatus)}
)

// InitializeOTel initializes OpenTelemetry components for the gateway
func InitializeOTel() (trace.Tracer, metric.Meter, *log.Logger) {
	logger := log.New(os.Stdout, "[telemetry] ", log.LstdFlags)

	// Get global tracer and meter
	tracer := otel.Tracer("gateway")
	meter := otel.Meter("gateway")

	return tracer, meter, logger
}

// StartSpan starts a new distributed trace span
func StartSpan(ctx context.Context, tracer trace.Tracer, spanName string) (context.Context, trace.Span) {
	return tracer.Start(ctx, spanName)
}

// RecordMetric records a metric value
func RecordMetric(meter metric.Meter, name string, value float64) {
	metricCounter.Lock()
	metricCounter.values[name] += value
	metricCounter.Unlock()
}

// RequestMetrics tracks per-request metrics
type RequestMetrics struct {
	RequestID      string
	Service        string
	Endpoint       string
	Method         string
	StatusCode     int
	DurationMs     int64
	UserID         string
	TenantID       string
}

// RecordRequest logs a request with metrics
func RecordRequest(meter metric.Meter, metrics RequestMetrics) {
	requestTotal.Add(1)
	if metrics.StatusCode >= 400 {
		errorTotal.Add(1)
	}

	metricCounter.Lock()
	metricCounter.values["request.duration.ms.sum"] += float64(metrics.DurationMs)
	metricCounter.values["request.duration.ms.count"] += 1
	metricCounter.values["request."+metrics.Service+"."+metrics.Method] += 1
	metricCounter.Unlock()
}

// ServiceHealthStatus tracks service health
type ServiceHealthStatus struct {
	Service     string
	Healthy     bool
	LastCheck   int64
	ErrorRate   float64
	P99Latency  float64
}

// RecordServiceHealth records service health metrics
func RecordServiceHealth(meter metric.Meter, status ServiceHealthStatus) {
	serviceHealthMap.Lock()
	serviceHealthMap.values[status.Service] = status
	serviceHealthMap.Unlock()

	metricCounter.Lock()
	if status.Healthy {
		metricCounter.values["service."+status.Service+".healthy"] = 1
	} else {
		metricCounter.values["service."+status.Service+".healthy"] = 0
	}
	metricCounter.values["service."+status.Service+".error_rate"] = status.ErrorRate
	metricCounter.values["service."+status.Service+".p99_latency"] = status.P99Latency
	metricCounter.Unlock()
}
