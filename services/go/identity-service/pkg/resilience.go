package resilience

import (
	"context"
	"time"
)

// CircuitBreaker prevents cascading failures by failing fast.
// Opens when error rate exceeds threshold, half-opens after timeout.
type CircuitBreaker interface {
	Execute(ctx context.Context, fn func() error) error
}

// ExponentialBackoff implements exponential backoff with jitter for retries.
type ExponentialBackoff struct {
	initialDelay time.Duration
	maxDelay     time.Duration
	multiplier   float64
	maxRetries   int
}

// NewExponentialBackoff creates a backoff strategy.
func NewExponentialBackoff(initialDelay time.Duration, maxDelay time.Duration) *ExponentialBackoff {
	return &ExponentialBackoff{
		initialDelay: initialDelay,
		maxDelay:     maxDelay,
		multiplier:   2.0,
		maxRetries:   5,
	}
}

// Retry executes a function with exponential backoff.
func (b *ExponentialBackoff) Retry(ctx context.Context, fn func() error) error {
	delay := b.initialDelay

	for attempt := 0; attempt < b.maxRetries; attempt++ {
		if err := fn(); err == nil {
			return nil
		}

		select {
		case <-ctx.Done():
			return ctx.Err()
		case <-time.After(delay):
			delay = time.Duration(float64(delay) * b.multiplier)
			if delay > b.maxDelay {
				delay = b.maxDelay
			}
		}
	}

	return fn() // Final attempt without waiting
}

// Idempotency ensures requests are executed exactly once even if retried.
// Critical for distributed systems.
type IdempotencyKey struct {
	RequestID string
}

// IdempotencyStore persists idempotency keys to prevent duplicate execution.
type IdempotencyStore interface {
	// HasBeenProcessed checks if a request was already processed.
	HasBeenProcessed(ctx context.Context, requestID string) (bool, error)

	// MarkProcessed records that a request was processed.
	MarkProcessed(ctx context.Context, requestID string, result interface{}) error
}
