package auth

import (
	"context"
	"errors"
)

// Manager handles JWT operations for all services
type Manager struct {
	// TODO: Initialize with JWT secret, issuer, algorithm
}

// NewManager creates a new shared auth manager
func NewManager(secret, issuer string) *Manager {
	return &Manager{
		// TODO: Store secret and issuer
	}
}

// Claims represents shared JWT claims structure
type Claims struct {
	UserID   string   `json:"user_id"`
	Email    string   `json:"email"`
	TenantID string   `json:"tenant_id"`
	Scopes   []string `json:"scopes"`
}

// ValidateToken validates JWT token
func (m *Manager) ValidateToken(ctx context.Context, token string) (*Claims, error) {
	// TODO: Implement JWT validation with shared secret
	return nil, errors.New("not implemented")
}

// GenerateToken generates JWT token
func (m *Manager) GenerateToken(ctx context.Context, claims *Claims) (string, error) {
	// TODO: Implement JWT generation
	return "", errors.New("not implemented")
}
