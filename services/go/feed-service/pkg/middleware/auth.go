package middleware

import (
	"net/http"
	"strings"

	"github.com/gin-gonic/gin"
	"github.com/kinnectai/backend/internal/auth"
)

const userIDKey = "user_id"

// JWT validates the Authorization: Bearer <token> header.
// Injects user_id into the gin context for downstream handlers.
func JWT(authSvc *auth.Service) gin.HandlerFunc {
	return func(c *gin.Context) {
		header := c.GetHeader("Authorization")
		if header == "" || !strings.HasPrefix(header, "Bearer ") {
			c.AbortWithStatusJSON(http.StatusUnauthorized, gin.H{"error": "authorization required"})
			return
		}

		tokenStr := strings.TrimPrefix(header, "Bearer ")
		userID, err := authSvc.ValidateJWT(tokenStr)
		if err != nil {
			c.AbortWithStatusJSON(http.StatusUnauthorized, gin.H{"error": "invalid or expired token"})
			return
		}

		c.Set(userIDKey, userID)
		c.Next()
	}
}

// GetUserID extracts the authenticated user's ID from the gin context.
func GetUserID(c *gin.Context) (string, bool) {
	v, exists := c.Get(userIDKey)
	if !exists {
		return "", false
	}
	id, ok := v.(string)
	return id, ok
}
