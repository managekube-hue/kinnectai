package middleware

import (
	"context"
	"fmt"
	"net/http"
	"strconv"
	"time"

	"github.com/gin-gonic/gin"
	"github.com/redis/go-redis/v9"
)

// RateLimit implements a sliding-window rate limiter backed by Redis
// (PRD §API-Gateway, Item 99).
//
// Each (userID, path) pair is tracked with an incremented counter that
// expires after [window]. If the counter exceeds [max] the request is
// rejected with 429 and a Retry-After header.
//
// The JWT middleware must run before this middleware so that "user_id" is
// already present in the gin context.
//
// Usage:
//
//	router.Use(middleware.JWT(authSvc), middleware.RateLimit(rdb, 60, time.Minute))
func RateLimit(rdb *redis.Client, max int, window time.Duration) gin.HandlerFunc {
	return func(c *gin.Context) {
		userID, ok := GetUserID(c)
		if !ok {
			// Unauthenticated request — allow through; JWT middleware will
			// reject it if the route requires auth.
			c.Next()
			return
		}

		key := fmt.Sprintf("rate:%s:%s", userID, c.Request.URL.Path)
		ctx := context.Background()

		// Atomic increment + TTL reset in a pipeline.
		pipe := rdb.Pipeline()
		incrCmd := pipe.Incr(ctx, key)
		pipe.Expire(ctx, key, window)
		if _, err := pipe.Exec(ctx); err != nil {
			// Redis failure — fail open to avoid blocking legitimate traffic.
			c.Next()
			return
		}

		count := incrCmd.Val()
		if count > int64(max) {
			c.Header("Retry-After", strconv.Itoa(int(window.Seconds())))
			c.AbortWithStatusJSON(http.StatusTooManyRequests, gin.H{
				"error":       "rate_limit_exceeded",
				"limit":       max,
				"window_secs": int(window.Seconds()),
			})
			return
		}

		c.Next()
	}
}
