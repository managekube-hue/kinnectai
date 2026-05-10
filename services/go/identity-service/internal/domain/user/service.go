package user

import (
	"context"
	"fmt"
)

// Service encapsulates user domain logic that doesn't fit in the aggregate.
// Use sparingly; most logic should live on the User aggregate itself.
type Service struct {
	repo       Repository
	eventStore EventStore
}

// NewService creates a user domain service.
func NewService(repo Repository, eventStore EventStore) *Service {
	return &Service{
		repo:       repo,
		eventStore: eventStore,
	}
}

// RegisterUser creates and persists a new user account.
// This is a domain operation, not a handler operation.
func (s *Service) RegisterUser(ctx context.Context, email, phone, passwordHash string) (*User, error) {
	// Check invariant: user must not exist
	exists, err := s.repo.Exists(ctx, email)
	if err != nil {
		return nil, fmt.Errorf("failed to check user existence: %w", err)
	}
	if exists {
		return nil, ErrUserAlreadyExists
	}

	// Create user with business rules applied
	user, err := NewUser(email, phone, passwordHash)
	if err != nil {
		return nil, err
	}

	// Persist aggregate
	if err := s.repo.Save(ctx, user); err != nil {
		return nil, fmt.Errorf("failed to save user: %w", err)
	}

	// Record domain event for downstream consumption
	event := UserCreated{
		UserID:    user.ID,
		Email:     user.Email,
		CreatedAt: user.CreatedAt,
	}
	if err := s.eventStore.Append(ctx, user.ID, event); err != nil {
		// Log but don't fail; user is already persisted
		// In production, use compensating transaction or eventual consistency
		fmt.Printf("Warning: failed to store UserCreated event: %v\n", err)
	}

	return user, nil
}

// AuthenticateUser validates credentials and returns user if valid.
func (s *Service) AuthenticateUser(ctx context.Context, email, plainPassword string) (*User, error) {
	user, err := s.repo.FindByEmail(ctx, email)
	if err != nil {
		return nil, fmt.Errorf("failed to find user: %w", err)
	}

	// Check business rules
	if !user.CanAuthenticate() {
		return nil, ErrUserNotActive
	}

	// Validate password (using value object)
	hash, err := NewPasswordHash(user.PasswordHash)
	if err != nil {
		return nil, fmt.Errorf("invalid stored password hash: %w", err)
	}

	if !hash.Match(plainPassword) {
		return nil, ErrPasswordMismatch
	}

	// Record login in aggregate
	user.RecordLogin()

	// Persist state change
	if err := s.repo.Update(ctx, user); err != nil {
		return nil, fmt.Errorf("failed to update user: %w", err)
	}

	// Record domain event
	event := UserLoggedIn{
		UserID:   user.ID,
		LoggedAt: user.UpdatedAt,
	}
	if err := s.eventStore.Append(ctx, user.ID, event); err != nil {
		fmt.Printf("Warning: failed to store UserLoggedIn event: %v\n", err)
	}

	return user, nil
}
