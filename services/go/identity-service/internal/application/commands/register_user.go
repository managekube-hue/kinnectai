package commands

import (
	"context"

	"github.com/managekube-hue/kinnectai/services/go/identity-service/internal/domain/user"
	"golang.org/x/crypto/bcrypt"
)

// RegisterUserCommand represents the intent to register
type RegisterUserCommand struct {
	Email    string
	Password string
}

// RegisterUserHandler handles registration command
type RegisterUserHandler struct {
	repo user.Repository
}

type noopEventStore struct{}

func (noopEventStore) Append(ctx context.Context, aggregateID string, events ...user.DomainEvent) error {
	return nil
}

func (noopEventStore) Events(ctx context.Context, aggregateID string) ([]user.DomainEvent, error) {
	return nil, nil
}

func (noopEventStore) EventsSince(ctx context.Context, aggregateID string, version int64) ([]user.DomainEvent, error) {
	return nil, nil
}

// NewRegisterUserHandler creates handler
func NewRegisterUserHandler(repo user.Repository) *RegisterUserHandler {
	return &RegisterUserHandler{repo: repo}
}

// Handle executes the command
func (h *RegisterUserHandler) Handle(ctx context.Context, cmd RegisterUserCommand) (*user.User, error) {
	service := user.NewService(h.repo, noopEventStore{})

	hashBytes, err := bcrypt.GenerateFromPassword([]byte(cmd.Password), bcrypt.DefaultCost)
	if err != nil {
		return nil, err
	}
	passwordHash := string(hashBytes)

	return service.RegisterUser(ctx, cmd.Email, "", passwordHash)
}
