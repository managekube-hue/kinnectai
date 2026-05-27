package kafka

import (
	"context"
	"encoding/json"
	"fmt"
	"time"

	"github.com/managekube-hue/kinnectai/services/go/identity-service/internal/domain/user"
	"github.com/segmentio/kafka-go"
)

// Producer publishes user events to Kafka
type Producer struct {
	writer *kafka.Writer
}

// New creates kafka producer
func New(brokers []string) *Producer {
	writer := &kafka.Writer{
		Addr:     kafka.TCP(brokers...),
		Topic:    "user-events",
		Balancer: &kafka.LeastBytes{},
	}

	return &Producer{writer: writer}
}

// PublishUserCreated publishes user.created event
func (p *Producer) PublishUserCreated(ctx context.Context, u *user.User) error {
	event := user.UserCreated{
		UserID:    u.ID,
		Email:     u.Email,
		CreatedAt: u.CreatedAt,
	}

	return p.publishEvent(ctx, event)
}

// PublishUserLoggedIn publishes user.logged_in event
func (p *Producer) PublishUserLoggedIn(ctx context.Context, u *user.User) error {
	event := user.UserLoggedIn{
		UserID:  u.ID,
		LoggedAt: time.Now(),
	}

	return p.publishEvent(ctx, event)
}

// PublishMFAEnabled publishes user.mfa_enabled event
func (p *Producer) PublishMFAEnabled(ctx context.Context, userID string) error {
	event := user.UserMFAEnabled{
		UserID:    userID,
		MFAType:   string(user.MFATypeTOTP),
		EnabledAt: time.Now(),
	}

	return p.publishEvent(ctx, event)
}

// PublishUserSuspended publishes user.suspended event
func (p *Producer) PublishUserSuspended(ctx context.Context, userID string, reason string) error {
	event := user.UserSuspended{
		UserID:      userID,
		Reason:      reason,
		SuspendedAt: time.Now(),
	}

	return p.publishEvent(ctx, event)
}

// publishEvent writes event to Kafka
func (p *Producer) publishEvent(ctx context.Context, evt user.DomainEvent) error {
	payload := map[string]any{
		"event_type":   evt.EventType(),
		"aggregate_id": evt.AggregateID(),
		"occurred_at":  evt.OccurredAt().UTC().Format(time.RFC3339Nano),
		"event":        evt,
	}

	data, err := json.Marshal(payload)
	if err != nil {
		return fmt.Errorf("failed to marshal event: %w", err)
	}

	msg := kafka.Message{
		Key:   []byte(evt.AggregateID()),
		Value: data,
		Headers: []kafka.Header{
			{Key: "event_type", Value: []byte(evt.EventType())},
			{Key: "timestamp", Value: []byte(evt.OccurredAt().UTC().Format(time.RFC3339Nano))},
		},
	}

	if err := p.writer.WriteMessages(ctx, msg); err != nil {
		return fmt.Errorf("failed to write event: %w", err)
	}

	return nil
}

// Close closes the producer
func (p *Producer) Close() error {
	return p.writer.Close()
}
