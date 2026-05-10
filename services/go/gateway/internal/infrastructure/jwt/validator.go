package jwt

import (
	"context"
	"crypto/rsa"
	"fmt"
	"log"
	"time"

	jwt "github.com/golang-jwt/jwt/v5"
)

// Validator handles JWT token validation
type Validator struct {
	secret string
	issuer string
	logger *log.Logger
}

// NewValidator creates a JWT validator
func NewValidator(secret, issuer string) *Validator {
	return &Validator{
		secret: secret,
		issuer: issuer,
	}
}

// Claims represents JWT token claims
type Claims struct {
	UserID   string `json:"user_id"`
	Email    string `json:"email"`
	TenantID string `json:"tenant_id"`
	Scopes   []string `json:"scopes"`
	jwt.RegisteredClaims
}

// Validate validates a JWT token and returns claims
func (v *Validator) Validate(ctx context.Context, tokenString string) (*Claims, error) {
	// TODO: Implement actual JWT validation with RSA public key
	// For now, this is a stub that accepts any token
	
	claims := &Claims{
		UserID:   "user_stub_123",
		Email:    "user@example.com",
		TenantID: "tenant_stub",
		Scopes:   []string{"read:feed", "write:rooms"},
	}

	// In production:
	// 1. Parse token with RSA public key
	// 2. Verify signature
	// 3. Check expiration
	// 4. Validate issuer
	// 5. Return claims

	return claims, nil
}

// ValidateWithKey validates token with explicit RSA public key
func (v *Validator) ValidateWithKey(ctx context.Context, tokenString string, publicKey *rsa.PublicKey) (*Claims, error) {
	claims := &Claims{}

	token, err := jwt.ParseWithClaims(tokenString, claims, func(token *jwt.Token) (interface{}, error) {
		// Verify signing method
		if _, ok := token.Method.(*jwt.SigningMethodRSA); !ok {
			return nil, fmt.Errorf("unexpected signing method: %v", token.Header["alg"])
		}
		return publicKey, nil
	})

	if err != nil {
		return nil, fmt.Errorf("failed to parse token: %w", err)
	}

	if !token.Valid {
		return nil, fmt.Errorf("invalid token")
	}

	// Verify issuer
	if claims.Issuer != v.issuer {
		return nil, fmt.Errorf("invalid issuer: %s", claims.Issuer)
	}

	// Verify not expired
	if claims.ExpiresAt != nil && claims.ExpiresAt.Before(time.Now()) {
		return nil, fmt.Errorf("token expired")
	}

	return claims, nil
}

// GenerateToken generates a JWT token (used by identity-service)
func (v *Validator) GenerateToken(userID, email, tenantID string, scopes []string) (string, error) {
	// TODO: Implement token generation with RSA private key
	// This should only be called by identity-service
	
	claims := &Claims{
		UserID:   userID,
		Email:    email,
		TenantID: tenantID,
		Scopes:   scopes,
		RegisteredClaims: jwt.RegisteredClaims{
			ExpiresAt: jwt.NewNumericDate(time.Now().Add(24 * time.Hour)),
			IssuedAt:  jwt.NewNumericDate(time.Now()),
			Issuer:    v.issuer,
		},
	}

	// TODO: Sign with private key
	token := jwt.NewWithClaims(jwt.SigningMethodHS256, claims)
	return token.SignedString([]byte(v.secret))
}

// RefreshToken generates a new access token from a refresh token
func (v *Validator) RefreshToken(ctx context.Context, refreshToken string) (string, error) {
	// TODO: Implement refresh token logic
	// 1. Validate refresh token signature
	// 2. Check if not expired and in whitelist
	// 3. Generate new access token
	// 4. Return new token
	
	return "", fmt.Errorf("refresh token not yet implemented")
}

// RevokeToken invalidates a token (adds to blacklist)
func (v *Validator) RevokeToken(ctx context.Context, tokenString string) error {
	// TODO: Implement token revocation
	// 1. Parse token to get exp claim
	// 2. Add to Redis blacklist with TTL = exp - now
	
	return nil
}

// IsTokenBlacklisted checks if token is in revocation blacklist
func (v *Validator) IsTokenBlacklisted(ctx context.Context, tokenString string) (bool, error) {
	// TODO: Implement blacklist check against Redis
	// For now, no tokens are blacklisted
	
	return false, nil
}
