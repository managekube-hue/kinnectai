package middleware

import (
	"net/http"
	"strings"

	"github.com/gin-gonic/gin"
	"github.com/golang-jwt/jwt/v5"
)

// ValidateScope checks that the JWT carried in the gin context (populated by
// the JWT middleware) contains the required OAuth2 scope. Returns 403 if the
// scope is absent (PRD §API-Gateway, Item 98).
//
// Usage:
//
//	protected := router.Group("/v1/admin")
//	protected.Use(middleware.JWT(authSvc), middleware.ValidateScope("admin:write"))
func ValidateScope(requiredScope string) gin.HandlerFunc {
	return func(c *gin.Context) {
		raw, exists := c.Get("jwt_claims")
		if !exists {
			c.AbortWithStatusJSON(http.StatusUnauthorized, gin.H{"error": "missing_claims"})
			return
		}

		claims, ok := raw.(jwt.MapClaims)
		if !ok {
			c.AbortWithStatusJSON(http.StatusUnauthorized, gin.H{"error": "invalid_claims"})
			return
		}

		scopeVal, _ := claims["scope"].(string)
		scopes := strings.Fields(scopeVal) // space-delimited per RFC 6749 §3.3

		for _, s := range scopes {
			if s == requiredScope {
				c.Next()
				return
			}
		}

		c.AbortWithStatusJSON(http.StatusForbidden, gin.H{
			"error":          "insufficient_scope",
			"required_scope": requiredScope,
		})
	}
}
