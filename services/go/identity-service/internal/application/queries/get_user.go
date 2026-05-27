package queries

import (
	"context"

	"github.com/managekube-hue/kinnectai/services/go/identity-service/internal/domain/user"
)

// GetUserQuery retrieves user by ID
type GetUserQuery struct {
	UserID string
}

// GetUserHandler handles the query
type GetUserHandler struct {
	repo user.Repository
}

// NewGetUserHandler creates handler
func NewGetUserHandler(repo user.Repository) *GetUserHandler {
	return &GetUserHandler{repo: repo}
}

// Handle executes the query
func (h *GetUserHandler) Handle(ctx context.Context, q GetUserQuery) (*user.User, error) {
	return h.repo.FindByID(ctx, q.UserID)
}
