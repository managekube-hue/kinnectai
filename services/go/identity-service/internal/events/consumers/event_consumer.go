package consumers

import (
	"context"
	"encoding/json"
	"fmt"
	"log"

	"github.com/segmentio/kafka-go"
)

// EventConsumer subscribes to user events for downstream processing.
// Example: notification service listens to user.created to send welcome email.
type EventConsumer struct {
	reader *kafka.Reader
}

// New creates a new event consumer.
func New(reader *kafka.Reader) *EventConsumer {
	return &EventConsumer{reader: reader}
}

// StartConsuming begins reading events from Kafka.
// This is typically run as a background goroutine.
func (c *EventConsumer) StartConsuming(ctx context.Context, handlers map[string]EventHandler) error {
	for {
		select {
		case <-ctx.Done():
			return ctx.Err()
		default:
		}

		message, err := c.reader.ReadMessage(ctx)
		if err != nil {
			log.Printf("Error reading message: %v", err)
			continue
		}

		eventType := string(message.Headers[0].Value)
		handler, exists := handlers[eventType]
		if !exists {
			log.Printf("No handler for event type: %s", eventType)
			continue
		}

		if err := handler(ctx, message.Value); err != nil {
			log.Printf("Error handling event %s: %v", eventType, err)
			// Implement dead-letter queue logic here
		}
	}
}

// EventHandler is a function that processes an event payload.
type EventHandler func(context.Context, []byte) error

// ExampleNotificationHandler demonstrates how to handle a UserCreated event.
func ExampleNotificationHandler(ctx context.Context, payload []byte) error {
	var event struct {
		UserID string `json:"user_id"`
		Email  string `json:"email"`
	}

	if err := json.Unmarshal(payload, &event); err != nil {
		return fmt.Errorf("failed to unmarshal event: %w", err)
	}

	log.Printf("Sending welcome email to user %s (%s)", event.UserID, event.Email)
	// Implement actual email sending logic

	return nil
}

// Close gracefully closes the Kafka reader.
func (c *EventConsumer) Close() error {
	return c.reader.Close()
}
