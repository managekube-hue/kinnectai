// Observability - OpenTelemetry Tracing
// Shows how a login request is traced through all layers

package observability

import (
	"context"
	"go.opentelemetry.io/otel"
	"go.opentelemetry.io/otel/attribute"
	"go.opentelemetry.io/trace"
)

// LoginTracer instruments the login flow
type LoginTracer struct {
	tracer trace.Tracer
}

func NewLoginTracer() *LoginTracer {
	return &LoginTracer{
		tracer: otel.Tracer("identity-service"),
	}
}

// TraceLogin creates trace span for login operation
func (t *LoginTracer) TraceLogin(ctx context.Context, email string) (context.Context, trace.Span) {
	ctx, span := t.tracer.Start(ctx, "user.login")
	
	span.SetAttributes(
		attribute.String("user.email", email),
		attribute.String("service", "identity-service"),
	)
	
	return ctx, span
}

// TracePasswordValidation traces password validation step
func (t *LoginTracer) TracePasswordValidation(ctx context.Context) (context.Context, trace.Span) {
	ctx, span := t.tracer.Start(ctx, "password.validate")
	return ctx, span
}

// TraceDatabaseQuery traces database query
func (t *LoginTracer) TraceDatabaseQuery(ctx context.Context, query string) (context.Context, trace.Span) {
	ctx, span := t.tracer.Start(ctx, "db.query")
	span.SetAttributes(
		attribute.String("db.query_type", "select"),
		attribute.String("db.operation", "get_user"),
	)
	return ctx, span
}

// TraceEventPublish traces Kafka event publishing
func (t *LoginTracer) TraceEventPublish(ctx context.Context, eventType string) (context.Context, trace.Span) {
	ctx, span := t.tracer.Start(ctx, "kafka.publish")
	span.SetAttributes(
		attribute.String("kafka.topic", "user-events"),
		attribute.String("kafka.event_type", eventType),
	)
	return ctx, span
}

/* Full trace hierarchy for login:
user.login (root span)
├── password.validate
├── db.query (get_user)
├── crypto.compare
├── session.create
├── db.query (insert_session)
└── kafka.publish (user.login.success)
*/
