package middleware

import (
	"net/http"
	"strings"

	"github.com/gin-gonic/gin"
)

// EnforceAPIVersion rejects any request whose path does not start with /v1/.
// Mount this as a global middleware before route groups to ensure all
// clients send versioned requests (PRD §API-Gateway, Item 97).
func EnforceAPIVersion() gin.HandlerFunc {
	return func(c *gin.Context) {
		if !strings.HasPrefix(c.Request.URL.Path, "/v1/") {
			c.AbortWithStatusJSON(http.StatusBadRequest, gin.H{
				"error":    "missing_api_version",
				"required": "/v1/...",
			})
			return
		}
		c.Next()
	}
}
