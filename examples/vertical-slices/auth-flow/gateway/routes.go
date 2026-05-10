// Gateway - Routes auth requests to identity-service
// In services/gateway/main.go

package main

import (
	"github.com/gin-gonic/gin"
	"log"
)

func main() {
	router := gin.Default()

	// CORS for mobile
	router.Use(corsMiddleware())

	// Health check
	router.GET("/health", func(c *gin.Context) {
		c.JSON(200, gin.H{"status": "healthy"})
	})

	// Auth routes - forward to identity-service
	authRoutes := router.Group("/api/v1")
	{
		// Forward POST /api/v1/login to identity-service:8081/api/v1/login
		authRoutes.POST("/login", forwardToIdentityService("POST", "login"))
		authRoutes.POST("/register", forwardToIdentityService("POST", "register"))
		authRoutes.POST("/refresh", forwardToIdentityService("POST", "refresh"))
		authRoutes.GET("/profile/:user_id", forwardToIdentityService("GET", "profile/:user_id"))
	}

	log.Fatal(router.Run(":8080"))
}

func forwardToIdentityService(method string, path string) gin.HandlerFunc {
	return func(c *gin.Context) {
		// In production, use proper HTTP client with retries and circuit breaker
		// For now, simplified forwarding

		// Extract original request body and parameters
		var body []byte
		if c.Request.Body != nil {
			body, _ = ioutil.ReadAll(c.Request.Body)
		}

		// Build identity-service URL
		identityURL := fmt.Sprintf("http://identity-service:8081/api/v1/%s", path)

		// Forward request with tracing context
		req, err := http.NewRequestWithContext(c.Request.Context(), method, identityURL, bytes.NewReader(body))
		if err != nil {
			c.JSON(500, gin.H{"error": "Failed to forward request"})
			return
		}

		// Copy headers (excluding hop-by-hop)
		for key, values := range c.Request.Header {
			for _, value := range values {
				req.Header.Add(key, value)
			}
		}

		// Add tracing headers
		req.Header.Set("X-Trace-ID", c.GetString("trace_id"))
		req.Header.Set("X-Span-ID", c.GetString("span_id"))

		// Execute request
		client := &http.Client{Timeout: 30 * time.Second}
		resp, err := client.Do(req)
		if err != nil {
			c.JSON(500, gin.H{"error": "Service unavailable"})
			return
		}
		defer resp.Body.Close()

		// Copy response
		respBody, _ := ioutil.ReadAll(resp.Body)
		c.Data(resp.StatusCode, resp.Header.Get("Content-Type"), respBody)
	}
}

func corsMiddleware() gin.HandlerFunc {
	return func(c *gin.Context) {
		c.Writer.Header().Set("Access-Control-Allow-Origin", "*")
		c.Writer.Header().Set("Access-Control-Allow-Methods", "GET, POST, PUT, DELETE")
		c.Writer.Header().Set("Access-Control-Allow-Headers", "Content-Type, Authorization")
		c.Next()
	}
}
