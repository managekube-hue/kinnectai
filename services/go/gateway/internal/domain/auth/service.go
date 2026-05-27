package auth

import (
	"context"
	"fmt"

	"gateway/internal/infrastructure/jwt"
)

// AuthService manages authentication and authorization
type AuthService struct {
	jwtValidator *jwt.Validator
}

// NewAuthService creates a new auth service
func NewAuthService(jwtValidator *jwt.Validator) *AuthService {
	return &AuthService{
		jwtValidator: jwtValidator,
	}
}

// TokenClaims represents user claims extracted from token
type TokenClaims struct {
	UserID   string
	Email    string
	TenantID string
	Scopes   []string
}

// ValidateToken validates a JWT token and returns claims
func (s *AuthService) ValidateToken(ctx context.Context, token string) (*TokenClaims, error) {
	claims, err := s.jwtValidator.Validate(ctx, token)
	if err != nil {
		return nil, fmt.Errorf("token validation failed: %w", err)
	}

	// Check if token is revoked (blacklisted)
	if blacklisted, err := s.jwtValidator.IsTokenBlacklisted(ctx, token); err == nil && blacklisted {
		return nil, fmt.Errorf("token has been revoked")
	}

	return &TokenClaims{
		UserID:   claims.UserID,
		Email:    claims.Email,
		TenantID: claims.TenantID,
		Scopes:   claims.Scopes,
	}, nil
}

// HasScope checks if user has required scope
func (s *AuthService) HasScope(claims *TokenClaims, requiredScope string) bool {
	for _, scope := range claims.Scopes {
		if scope == requiredScope {
			return true
		}
	}
	return false
}

// HasAllScopes checks if user has all required scopes
func (s *AuthService) HasAllScopes(claims *TokenClaims, requiredScopes []string) bool {
	for _, required := range requiredScopes {
		if !s.HasScope(claims, required) {
			return false
		}
	}
	return true
}

// RefreshToken generates new access token
func (s *AuthService) RefreshToken(ctx context.Context, refreshToken string) (string, error) {
	return s.jwtValidator.RefreshToken(ctx, refreshToken)
}

// RevokeToken invalidates a token
func (s *AuthService) RevokeToken(ctx context.Context, token string) error {
	return s.jwtValidator.RevokeToken(ctx, token)
}

// User represents an authenticated user
type User struct {
	ID       string
	Email    string
	TenantID string
	Scopes   []string
}

// FromClaims converts TokenClaims to User
func (s *AuthService) FromClaims(claims *TokenClaims) *User {
	return &User{
		ID:       claims.UserID,
		Email:    claims.Email,
		TenantID: claims.TenantID,
		Scopes:   claims.Scopes,
	}
}

// CanAccessTenant checks if user has access to tenant
func (u *User) CanAccessTenant(tenantID string) bool {
	return u.TenantID == tenantID
}

// HasPermission checks if user has specific permission
func (u *User) HasPermission(permission string) bool {
	// Scope-based permission check for current deployment profile.
	for _, scope := range u.Scopes {
		if scope == permission {
			return true
		}
	}
	return false
}
