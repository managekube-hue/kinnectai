package http

import (
	"github.com/gin-gonic/gin"
	"go.opentelemetry.io/contrib/instrumentation/github.com/gin-gonic/gin/otelgin"
	"go.opentelemetry.io/trace"

	"github.com/managekube-hue/kinnectai/services/go/identity-service/internal/infrastructure"
	"github.com/managekube-hue/kinnectai/services/go/identity-service/internal/transport/http/handlers"
	"github.com/managekube-hue/kinnectai/pkg/telemetry"
)

// NewRouter creates HTTP router with all routes
func NewRouter(infra *infrastructure.Infrastructure, logger telemetry.Logger, tracer trace.Tracer) *gin.Engine {
	router := gin.New()

	// Add OpenTelemetry middleware
	router.Use(otelgin.Middleware("identity-service"))

	// Health check
	router.GET("/health", func(c *gin.Context) {
		c.JSON(200, gin.H{"status": "healthy"})
	})

	// API v1 routes
	v1 := router.Group("/api/v1")
	{
		// Auth endpoints
		v1.POST("/register", handlers.RegisterHandler(infra.UserRepo))
		v1.POST("/login", handlers.LoginHandler(infra.UserRepo))

		// Protected endpoints
		v1.GET("/profile/:user_id", handlers.GetProfileHandler(infra.UserRepo))
	}

	return router
}
