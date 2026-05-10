package user

import "context"

// Repository defines the persistence contract for user aggregates.
// Implementations should be in internal/repositories/{postgres,neo4j,etc}.
// This ensures service layer doesn't know about DB details.
type Repository interface {
	// Save persists a user aggregate.
	Save(ctx context.Context, user *User) error

	// FindByID retrieves a user by ID.
	FindByID(ctx context.Context, id string) (*User, error)

	// FindByEmail retrieves a user by email.
	FindByEmail(ctx context.Context, email string) (*User, error)

	// Exists checks if a user exists.
	Exists(ctx context.Context, email string) (bool, error)

	// Update persists changes to an existing user.
	Update(ctx context.Context, user *User) error

	// Delete marks a user as deleted (soft delete).
	Delete(ctx context.Context, id string) error

	// FindByStatus retrieves users with a specific status.
	FindByStatus(ctx context.Context, status Status) ([]*User, error)
}

// EventStore defines persistence contract for domain events.
// Enables event sourcing and audit trails.
type EventStore interface {
	// Append writes domain events to the event stream.
	Append(ctx context.Context, aggregateID string, events ...DomainEvent) error

	// Events retrieves all events for an aggregate.
	Events(ctx context.Context, aggregateID string) ([]DomainEvent, error)

	// EventsSince retrieves events since a given version.
	EventsSince(ctx context.Context, aggregateID string, version int64) ([]DomainEvent, error)
}
