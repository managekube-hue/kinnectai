package commands

import (
	"context"

	"github.com/managekube-hue/kinnectai/services/go/identity-service/internal/domain/user"
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

// NewRegisterUserHandler creates handler
func NewRegisterUserHandler(repo user.Repository) *RegisterUserHandler {
	return &RegisterUserHandler{repo: repo}
}

// Handle executes the command
func (h *RegisterUserHandler) Handle(ctx context.Context, cmd RegisterUserCommand) (*user.User, error) {
	service := user.NewService(h.repo)

	// Hash password (TODO: use bcrypt)
	passwordHash := cmd.Password // TODO: hash

	return service.Register(ctx, cmd.Email, passwordHash)
}
