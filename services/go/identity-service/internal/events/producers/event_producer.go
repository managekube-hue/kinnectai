package producers

import (
	"context"
	"encoding/json"
	"fmt"
	"identityservice/internal/domain/user"
	"log"

	"github.com/segmentio/kafka-go"
)

// EventProducer publishes user domain events to Kafka.
type EventProducer struct {
	writer *kafka.Writer
}

// New creates a new event producer.
func New(writer *kafka.Writer) *EventProducer {
	return &EventProducer{writer: writer}
}

// PublishUserCreated publishes a UserCreated event.
func (p *EventProducer) PublishUserCreated(ctx context.Context, event user.UserCreated) error {
	return p.publishEvent(ctx, "user.created", event.UserID, event)
}

// PublishUserActivated publishes a UserActivated event.
func (p *EventProducer) PublishUserActivated(ctx context.Context, event user.UserActivated) error {
	return p.publishEvent(ctx, "user.activated", event.UserID, event)
}

// PublishUserLoggedIn publishes a UserLoggedIn event.
func (p *EventProducer) PublishUserLoggedIn(ctx context.Context, event user.UserLoggedIn) error {
	return p.publishEvent(ctx, "user.logged_in", event.UserID, event)
}

// PublishUserSuspended publishes a UserSuspended event.
func (p *EventProducer) PublishUserSuspended(ctx context.Context, event user.UserSuspended) error {
	return p.publishEvent(ctx, "user.suspended", event.UserID, event)
}

// PublishUserCompromised publishes a security incident event.
func (p *EventProducer) PublishUserCompromised(ctx context.Context, event user.UserCompromised) error {
	return p.publishEvent(ctx, "user.compromised", event.UserID, event)
}

// publishEvent is the internal method that writes to Kafka.
func (p *EventProducer) publishEvent(ctx context.Context, eventType, aggregateID string, payload interface{}) error {
	data, err := json.Marshal(payload)
	if err != nil {
		return fmt.Errorf("failed to marshal event: %w", err)
	}

	message := kafka.Message{
		Key:   []byte(aggregateID), // Partition by user ID to maintain order
		Value: data,
		Headers: []kafka.Header{
			{Key: "event_type", Value: []byte(eventType)},
			{Key: "aggregate_id", Value: []byte(aggregateID)},
		},
	}

	err = p.writer.WriteMessages(ctx, message)
	if err != nil {
		log.Printf("Failed to publish %s event for user %s: %v", eventType, aggregateID, err)
		return fmt.Errorf("failed to write to Kafka: %w", err)
	}

	return nil
}

// Close gracefully closes the Kafka writer.
func (p *EventProducer) Close() error {
	return p.writer.Close()
}
