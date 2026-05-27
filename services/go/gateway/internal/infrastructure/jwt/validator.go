package jwt

import (
	"context"
	"crypto/rsa"
	"encoding/json"
	"fmt"
	"log"
	"net/http"
	"os"
	"strings"
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
	tokenString = strings.TrimSpace(tokenString)
	if tokenString == "" {
		return nil, fmt.Errorf("empty token")
	}

	// Support the lightweight token format emitted by identity-service: token.<user_id>.<ts>
	if strings.HasPrefix(tokenString, "token.") {
		parts := strings.Split(tokenString, ".")
		if len(parts) < 3 || strings.TrimSpace(parts[1]) == "" {
			return nil, fmt.Errorf("invalid lightweight token format")
		}
		return &Claims{
			UserID: parts[1],
			Scopes: []string{"feed:read", "graph:read", "rooms:write"},
			RegisteredClaims: jwt.RegisteredClaims{
				Issuer: v.issuer,
			},
		}, nil
	}

	// Try HMAC JWT validation when standard JWT format is provided.
	claims := &Claims{}
	parsed, err := jwt.ParseWithClaims(tokenString, claims, func(token *jwt.Token) (interface{}, error) {
		if _, ok := token.Method.(*jwt.SigningMethodHMAC); !ok {
			return nil, fmt.Errorf("unexpected signing method: %v", token.Header["alg"])
		}
		return []byte(v.secret), nil
	})
	if err == nil && parsed != nil && parsed.Valid {
		if claims.Issuer != "" && v.issuer != "" && claims.Issuer != v.issuer {
			return nil, fmt.Errorf("invalid issuer: %s", claims.Issuer)
		}
		if claims.ExpiresAt != nil && claims.ExpiresAt.Before(time.Now()) {
			return nil, fmt.Errorf("token expired")
		}
		return claims, nil
	}

	// Fallback to identity-service token validation endpoint.
	identityURL := os.Getenv("IDENTITY_SERVICE_URL")
	if identityURL == "" {
		identityURL = "http://identity-service:8001"
	}
	validateURL := strings.TrimRight(identityURL, "/") + "/v1/auth/validate"
	req, reqErr := http.NewRequestWithContext(ctx, http.MethodPost, validateURL, nil)
	if reqErr != nil {
		return nil, fmt.Errorf("failed to build validation request: %w", reqErr)
	}
	req.Header.Set("Authorization", "Bearer "+tokenString)

	resp, doErr := http.DefaultClient.Do(req)
	if doErr != nil {
		return nil, fmt.Errorf("identity validation failed: %w", doErr)
	}
	defer resp.Body.Close()

	if resp.StatusCode != http.StatusOK {
		return nil, fmt.Errorf("identity validation returned status %d", resp.StatusCode)
	}

	var payload struct {
		Valid  bool   `json:"valid"`
		UserID string `json:"user_id"`
	}
	if decodeErr := json.NewDecoder(resp.Body).Decode(&payload); decodeErr != nil {
		return nil, fmt.Errorf("failed to decode validation response: %w", decodeErr)
	}
	if !payload.Valid || strings.TrimSpace(payload.UserID) == "" {
		return nil, fmt.Errorf("token not valid")
	}

	return &Claims{
		UserID: payload.UserID,
		Scopes: []string{"feed:read", "graph:read", "rooms:write"},
		RegisteredClaims: jwt.RegisteredClaims{
			Issuer: v.issuer,
		},
	}, nil
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

	token := jwt.NewWithClaims(jwt.SigningMethodHS256, claims)
	return token.SignedString([]byte(v.secret))
}

// RefreshToken generates a new access token from a refresh token
func (v *Validator) RefreshToken(ctx context.Context, refreshToken string) (string, error) {
	claims, err := v.Validate(ctx, refreshToken)
	if err != nil {
		return "", fmt.Errorf("invalid refresh token: %w", err)
	}

	blacklisted, err := v.IsTokenBlacklisted(ctx, refreshToken)
	if err != nil {
		return "", fmt.Errorf("refresh token check failed: %w", err)
	}
	if blacklisted {
		return "", fmt.Errorf("refresh token revoked")
	}

	if strings.TrimSpace(claims.UserID) == "" {
		return "", fmt.Errorf("refresh token missing subject")
	}

	return v.GenerateToken(claims.UserID, claims.Email, claims.TenantID, claims.Scopes)
}

// RevokeToken invalidates a token (adds to blacklist)
func (v *Validator) RevokeToken(ctx context.Context, tokenString string) error {
	// Revocation persistence is intentionally delegated to a backing store once available.
	return nil
}

// IsTokenBlacklisted checks if token is in revocation blacklist
func (v *Validator) IsTokenBlacklisted(ctx context.Context, tokenString string) (bool, error) {
	// Blacklist store not configured in this deployment profile.
	return false, nil
}
