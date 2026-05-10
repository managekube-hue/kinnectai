package redis

import (
	"context"
	"encoding/json"
	"fmt"
	"time"

	"github.com/redis/go-redis/v9"
	"github.com/managekube-hue/kinnectai/services/go/identity-service/internal/domain/user"
)

// Cache provides Redis caching for user data
type Cache struct {
	client *redis.Client
	ttl    time.Duration
}

// New creates redis cache
func New(client *redis.Client, ttl time.Duration) *Cache {
	return &Cache{client: client, ttl: ttl}
}

// Set caches a user
func (c *Cache) Set(ctx context.Context, u *user.User) error {
	data, err := json.Marshal(u)
	if err != nil {
		return fmt.Errorf("failed to marshal user: %w", err)
	}

	key := fmt.Sprintf("user:%s", u.ID)
	if err := c.client.Set(ctx, key, data, c.ttl).Err(); err != nil {
		return fmt.Errorf("failed to cache user: %w", err)
	}

	// Also cache by email
	emailKey := fmt.Sprintf("user:email:%s", u.Email)
	if err := c.client.Set(ctx, emailKey, u.ID, c.ttl).Err(); err != nil {
		return fmt.Errorf("failed to cache user email: %w", err)
	}

	return nil
}

// Get retrieves cached user
func (c *Cache) Get(ctx context.Context, id string) (*user.User, error) {
	key := fmt.Sprintf("user:%s", id)
	data, err := c.client.Get(ctx, key).Result()
	if err == redis.Nil {
		return nil, nil
	}
	if err != nil {
		return nil, fmt.Errorf("failed to get cached user: %w", err)
	}

	u := &user.User{}
	if err := json.Unmarshal([]byte(data), u); err != nil {
		return nil, fmt.Errorf("failed to unmarshal user: %w", err)
	}

	return u, nil
}

// GetByEmail retrieves user ID from email cache
func (c *Cache) GetByEmail(ctx context.Context, email string) (string, error) {
	key := fmt.Sprintf("user:email:%s", email)
	id, err := c.client.Get(ctx, key).Result()
	if err == redis.Nil {
		return "", nil
	}
	if err != nil {
		return "", fmt.Errorf("failed to get cached user email: %w", err)
	}

	return id, nil
}

// Delete removes cached user
func (c *Cache) Delete(ctx context.Context, id string, email string) error {
	key := fmt.Sprintf("user:%s", id)
	emailKey := fmt.Sprintf("user:email:%s", email)
	
	if err := c.client.Del(ctx, key, emailKey).Err(); err != nil {
		return fmt.Errorf("failed to delete cached user: %w", err)
	}

	return nil
}
