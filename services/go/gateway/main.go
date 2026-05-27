package main

import (
	"context"
	"fmt"
	"log"
	"net/http"
	"os"
	"os/signal"
	"strconv"
	"strings"
	"syscall"
	"time"

	"gateway/internal/domain/auth"
	"gateway/internal/infrastructure/jwt"
	"gateway/internal/transport/http/middleware"
	"gateway/internal/transport/http/v1"
	"gateway/pkg/telemetry"
)

func main() {
	// Initialize telemetry (tracing, metrics, logging)
	startTime := time.Now()
	tracer, meter, telemetryLogger := telemetry.InitializeOTel()
	_ = tracer
	_ = meter
	_ = telemetryLogger

	stdLogger := log.New(os.Stdout, "[gateway] ", log.LstdFlags)
	stdLogger.Println("KinnectAI API Gateway starting...")

	// Load configuration
	cfg := loadConfig()
	stdLogger.Printf("Environment: %s, Port: %d", cfg.Environment, cfg.Port)

	// Initialize JWT validator
	validator := jwt.NewValidator(cfg.JWTSecret, cfg.JWTIssuer)

	// Initialize auth domain service
	authService := auth.NewAuthService(validator)

	// Set up routes
	mux := http.NewServeMux()

	// Health check endpoint (no auth required)
	mux.HandleFunc("GET /health", func(w http.ResponseWriter, r *http.Request) {
		w.Header().Set("Content-Type", "application/json")
		fmt.Fprintf(w, `{"status":"healthy","service":"gateway","version":"1.0.0"}`)
	})

	// Ready check (auth system initialized)
	mux.HandleFunc("GET /ready", func(w http.ResponseWriter, r *http.Request) {
		w.Header().Set("Content-Type", "application/json")
		fmt.Fprintf(w, `{"ready":true}`)
	})

	// Metrics endpoint (Prometheus format)
	mux.HandleFunc("GET /metrics", func(w http.ResponseWriter, r *http.Request) {
		w.Header().Set("Content-Type", "text/plain; version=0.0.4")
		fmt.Fprintf(w, `# HELP gateway_requests_total Total requests received
# TYPE gateway_requests_total counter
gateway_requests_total 0

# HELP gateway_uptime_seconds Service uptime in seconds
# TYPE gateway_uptime_seconds gauge
gateway_uptime_seconds %.0f
`, time.Since(startTime).Seconds())
	})

	// API v1 routes
	apiV1 := v1.NewRouter(authService)
	mux.Handle("/v1/", http.StripPrefix("/v1", apiV1))

	// Apply middleware chain
	chain := middleware.Chain(
		middleware.RequestLogging(stdLogger),
		middleware.CORS(cfg.CORSAllowedOrigins),
		middleware.Authentication(authService),
		middleware.RateLimit(cfg.RateLimitPerSecond),
		middleware.ErrorHandling(),
	)

	handler := chain(mux)

	// HTTP server configuration
	srv := &http.Server{
		Addr:         fmt.Sprintf(":%d", cfg.Port),
		Handler:      handler,
		ReadTimeout:  15 * time.Second,
		WriteTimeout: 15 * time.Second,
		IdleTimeout:  60 * time.Second,
	}

	// Graceful shutdown channel
	done := make(chan struct{})
	go func() {
		sigch := make(chan os.Signal, 1)
		signal.Notify(sigch, os.Interrupt, syscall.SIGTERM)
		<-sigch

		stdLogger.Println("Shutdown signal received, gracefully stopping...")
		ctx, cancel := context.WithTimeout(context.Background(), 30*time.Second)
		defer cancel()

		if err := srv.Shutdown(ctx); err != nil {
			stdLogger.Printf("Server shutdown error: %v", err)
		}
		close(done)
	}()

	// Start server
	stdLogger.Printf("Gateway listening on %s", srv.Addr)
	if err := srv.ListenAndServe(); err != nil && err != http.ErrServerClosed {
		stdLogger.Fatalf("Server error: %v", err)
	}

	<-done
	stdLogger.Println("Gateway stopped")
}

type Config struct {
	Environment           string
	Port                  int
	JWTSecret             string
	JWTIssuer             string
	CORSAllowedOrigins    []string
	RateLimitPerSecond    int
	ServiceDiscoveryURL   string
}

func loadConfig() *Config {
	port := 8000
	if raw := os.Getenv("HTTP_PORT"); raw != "" {
		if parsed, err := strconv.Atoi(raw); err == nil {
			port = parsed
		}
	}

	allowedOrigins := []string{"*"}
	if raw := os.Getenv("CORS_ALLOWED_ORIGINS"); raw != "" {
		allowedOrigins = strings.Split(raw, ",")
	}

	return &Config{
		Environment:           os.Getenv("ENV"),
		Port:                  port,
		JWTSecret:             os.Getenv("JWT_SECRET"),
		JWTIssuer:             getEnvOrDefault("JWT_ISSUER", "kinnectai"),
		CORSAllowedOrigins:    allowedOrigins,
		RateLimitPerSecond:    1000,
		ServiceDiscoveryURL:   os.Getenv("SERVICE_DISCOVERY_URL"),
	}
}

func getEnvOrDefault(key, defaultValue string) string {
	if value := os.Getenv(key); value != "" {
		return value
	}
	return defaultValue
}
