package main

import (
	"context"
	"fmt"
	"log"
	"net/http"
	"os"
	"os/signal"
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
	tracer, meter, logger := telemetry.InitializeOTel()
	defer tracer.Shutdown(context.Background())
	defer meter.Shutdown(context.Background())

	log := log.New(os.Stdout, "[gateway] ", log.LstdFlags)
	log.Println("KinnectAI API Gateway starting...")

	// Load configuration
	cfg := loadConfig()
	log.Printf("Environment: %s, Port: %d", cfg.Environment, cfg.Port)

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

	// API v1 routes
	apiV1 := v1.NewRouter(authService)
	mux.Handle("/v1/", http.StripPrefix("/v1", apiV1))

	// Apply middleware chain
	chain := middleware.Chain(
		middleware.RequestLogging(logger),
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

		log.Println("Shutdown signal received, gracefully stopping...")
		ctx, cancel := context.WithTimeout(context.Background(), 30*time.Second)
		defer cancel()

		if err := srv.Shutdown(ctx); err != nil {
			log.Printf("Server shutdown error: %v", err)
		}
		close(done)
	}()

	// Start server
	log.Printf("Gateway listening on %s", srv.Addr)
	if err := srv.ListenAndServe(); err != nil && err != http.ErrServerClosed {
		log.Fatalf("Server error: %v", err)
	}

	<-done
	log.Println("Gateway stopped")
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
	return &Config{
		Environment:           os.Getenv("ENV"),
		Port:                  8000,
		JWTSecret:             os.Getenv("JWT_SECRET"),
		JWTIssuer:             "kinnectai",
		CORSAllowedOrigins:    []string{"*"}, // TODO: restrict to known origins
		RateLimitPerSecond:    1000,
		ServiceDiscoveryURL:   os.Getenv("SERVICE_DISCOVERY_URL"),
	}
}
