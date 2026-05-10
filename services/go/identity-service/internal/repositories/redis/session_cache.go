package redis

import (
	"context"
	"encoding/json"
	"fmt"
	"identityservice/internal/domain/user"
	"time"

	"github.com/redis/go-redis/v9"
)

// SessionCache caches user sessions in Redis with TTL.
// Used for fast login/MFA token lookups without hitting the database every time.
type SessionCache struct {
	client *redis.Client
	ttl    time.Duration
}

// New creates a new Redis session cache.
func New(client *redis.Client, ttl time.Duration) *SessionCache {
	return &SessionCache{
		client: client,
		ttl:    ttl,
	}
}

// StoreSession caches a user session.
func (c *SessionCache) StoreSession(ctx context.Context, sessionID string, u *user.User) error {
	data, err := json.Marshal(u)
	if err != nil {
		return fmt.Errorf("failed to marshal user: %w", err)
	}

	key := fmt.Sprintf("session:%s", sessionID)
	err = c.client.Set(ctx, key, data, c.ttl).Err()
	if err != nil {
		return fmt.Errorf("failed to store session in Redis: %w", err)
	}

	return nil
}

// GetSession retrieves a cached session.
func (c *SessionCache) GetSession(ctx context.Context, sessionID string) (*user.User, error) {
	key := fmt.Sprintf("session:%s", sessionID)
	val, err := c.client.Get(ctx, key).Result()
	if err == redis.Nil {
		return nil, user.ErrUserNotFound
	}
	if err != nil {
		return nil, fmt.Errorf("failed to get session from Redis: %w", err)
	}

	u := &user.User{}
	if err := json.Unmarshal([]byte(val), u); err != nil {
		return nil, fmt.Errorf("failed to unmarshal user: %w", err)
	}

	return u, nil
}

// InvalidateSession removes a cached session.
func (c *SessionCache) InvalidateSession(ctx context.Context, sessionID string) error {
	key := fmt.Sprintf("session:%s", sessionID)
	err := c.client.Del(ctx, key).Err()
	if err != nil {
		return fmt.Errorf("failed to invalidate session: %w", err)
	}
	return nil
}

// StoreMFAToken caches an MFA token with a short TTL.
func (c *SessionCache) StoreMFAToken(ctx context.Context, userID string, token string) error {
	key := fmt.Sprintf("mfa_token:%s:%s", userID, token)
	// MFA tokens typically have a shorter TTL (5-10 minutes)
	err := c.client.Set(ctx, key, "1", 10*time.Minute).Err()
	if err != nil {
		return fmt.Errorf("failed to store MFA token: %w", err)
	}
	return nil
}

// ValidateMFAToken checks if an MFA token exists and is valid.
func (c *SessionCache) ValidateMFAToken(ctx context.Context, userID string, token string) (bool, error) {
	key := fmt.Sprintf("mfa_token:%s:%s", userID, token)
	val, err := c.client.Get(ctx, key).Result()
	if err == redis.Nil {
		return false, nil // Token not found or expired
	}
	if err != nil {
		return false, fmt.Errorf("failed to check MFA token: %w", err)
	}
	return val == "1", nil
}
