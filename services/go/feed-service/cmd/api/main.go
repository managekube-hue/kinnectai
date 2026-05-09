package main

import (
	"context"
	"fmt"
	"log/slog"
	"net/http"
	"os"
	"os/signal"
	"strings"
	"syscall"
	"time"

	stream "github.com/GetStream/stream-go2/v8"
	"github.com/gin-gonic/gin"
	"github.com/kinnectai/backend/internal/auth"
	"github.com/kinnectai/backend/internal/discovery"
	"github.com/kinnectai/backend/internal/dna"
	"github.com/kinnectai/backend/internal/feed"
	"github.com/kinnectai/backend/internal/graph"
	"github.com/kinnectai/backend/internal/interaction"
	"github.com/kinnectai/backend/internal/marketplace"
	"github.com/kinnectai/backend/internal/media"
	"github.com/kinnectai/backend/internal/messaging"
	"github.com/kinnectai/backend/internal/moderation"
	"github.com/kinnectai/backend/internal/payment"
	"github.com/kinnectai/backend/internal/room"
	"github.com/kinnectai/backend/internal/settings"
	"github.com/kinnectai/backend/internal/user"
	"github.com/kinnectai/backend/internal/vault"
	"github.com/kinnectai/backend/internal/voiceprint"
	"github.com/kinnectai/backend/pkg/config"
	"github.com/kinnectai/backend/pkg/database"
	"github.com/kinnectai/backend/pkg/middleware"
	"github.com/segmentio/kafka-go"
)

func main() {
	// ── Config ───────────────────────────────────────────────────────────────
	cfg, err := config.Load()
	if err != nil {
		slog.Error("config load failed", "err", err)
		os.Exit(1)
	}

	if cfg.Env == "production" {
		gin.SetMode(gin.ReleaseMode)
	}

	ctx, cancel := context.WithTimeout(context.Background(), 30*time.Second)
	defer cancel()

	// ── Databases ────────────────────────────────────────────────────────────
	pg, err := database.NewPostgresPool(ctx, cfg.PostgresDSN())
	if err != nil {
		slog.Error("postgres connection failed", "err", err)
		os.Exit(1)
	}
	defer pg.Close()

	neo4jDriver, err := database.NewNeo4jDriver(cfg.Neo4jURI, cfg.Neo4jUser, cfg.Neo4jPassword)
	if err != nil {
		slog.Error("neo4j connection failed", "err", err)
		os.Exit(1)
	}
	defer neo4jDriver.Close(context.Background())

	redisClient, err := database.NewRedisClient(cfg.RedisAddr, cfg.RedisPassword, cfg.RedisDB)
	if err != nil {
		slog.Error("redis connection failed", "err", err)
		os.Exit(1)
	}
	defer redisClient.Close()

	slog.Info("all databases connected")

	// ── GetStream Client ──────────────────────────────────────────────────────
	streamClient, err := stream.New(cfg.GetStreamAPIKey, cfg.GetStreamSecret)
	if err != nil {
		slog.Error("getstream client init failed", "err", err)
		os.Exit(1)
	}

	slog.Info("getstream client initialized")

	kafkaBrokers := strings.Split(strings.TrimSpace(cfg.KafkaBrokers), ",")
	if len(kafkaBrokers) == 0 || kafkaBrokers[0] == "" {
		slog.Error("kafka brokers are required")
		os.Exit(1)
	}

	kafkaWriter := kafka.NewWriter(kafka.WriterConfig{
		Brokers:  kafkaBrokers,
		Topic:    cfg.KafkaTopicDNAKits,
		Balancer: &kafka.LeastBytes{},
		Async:    true,
	})
	defer func() {
		if err := kafkaWriter.Close(); err != nil {
			slog.Warn("failed to close kafka writer", "err", err)
		}
	}()

	// ── Services ─────────────────────────────────────────────────────────────
	authSvc := auth.NewService(pg, streamClient, cfg.JWTSecret, cfg.JWTExpiryHours)
	userSvc := user.NewService(pg)
	graphSvc := graph.NewService(pg, neo4jDriver, redisClient)
	feedSvc := feed.NewService(pg, streamClient)
	dnaSvc := dna.NewService(pg, kafkaWriter)
	mediaSvc := media.NewService(streamClient, cfg.GetStreamAPIKey, cfg.GetStreamAppID)

	// ── Handlers ─────────────────────────────────────────────────────────────
	authHandler := auth.NewHandler(authSvc)
	userHandler := user.NewHandler(userSvc)
	graphHandler := graph.NewHandler(graphSvc)
	feedHandler := feed.NewHandler(feedSvc)
	dnaHandler := dna.NewHandler(dnaSvc)
	mediaHandler := media.NewHandler(mediaSvc)
	discoveryHandler := discovery.NewHandler()
	vaultHandler := vault.NewHandler()
	interactionHandler := interaction.NewHandler()
	voiceprintHandler := voiceprint.NewHandler()
	paymentHandler := payment.NewHandler()
	roomHandler := room.NewHandler()
	messagingHandler := messaging.NewHandler()
	moderationHandler := moderation.NewHandler()
	settingsHandler := settings.NewHandler()
	marketplaceHandler := marketplace.NewHandler()

	// ── Router ───────────────────────────────────────────────────────────────
	r := gin.New()
	r.Use(gin.Recovery())
	r.Use(middleware.Logger())
	r.Use(middleware.SecurityHeaders())

	// Health check
	r.GET("/health", func(c *gin.Context) {
		c.JSON(http.StatusOK, gin.H{
			"status":  "ok",
			"version": "1.0.0",
			"service": "kinnectai-backend",
		})
	})

	// ── API v1 ───────────────────────────────────────────────────────────────
	v1 := r.Group("/api/v1")

	// Public routes (no auth required)
	authHandler.RegisterRoutes(v1.Group("/auth"))

	// Protected routes (JWT required)
	protected := v1.Group("")
	protected.Use(middleware.JWT(authSvc))

	userHandler.RegisterRoutes(protected.Group("/users"))
	graphHandler.RegisterRoutes(protected.Group("/graph"))
	feedHandler.RegisterRoutes(protected.Group("/feed"))
	dnaHandler.RegisterRoutes(protected.Group("/dna"))
	mediaHandler.RegisterRoutes(protected.Group("/media"))
	discoveryHandler.RegisterRoutes(protected.Group("/discovery"))
	vaultHandler.RegisterRoutes(protected.Group("/memories"))
	interactionHandler.RegisterRoutes(protected.Group("/interactions"))
	voiceprintHandler.RegisterRoutes(protected.Group("/voiceprints"))
	paymentHandler.RegisterRoutes(protected.Group("/payments"))
	roomHandler.RegisterRoutes(protected.Group("/rooms"))
	messagingHandler.RegisterRoutes(protected.Group("/messages"))
	moderationHandler.RegisterRoutes(protected.Group("/moderation"))
	settingsHandler.RegisterRoutes(protected.Group("/settings"))
	marketplaceHandler.RegisterRoutes(protected.Group("/marketplace"))

	// ── Server ───────────────────────────────────────────────────────────────
	srv := &http.Server{
		Addr:         fmt.Sprintf(":%s", cfg.Port),
		Handler:      r,
		ReadTimeout:  15 * time.Second,
		WriteTimeout: 30 * time.Second,
		IdleTimeout:  60 * time.Second,
	}

	// Graceful shutdown
	go func() {
		slog.Info("server starting", "port", cfg.Port)
		if err := srv.ListenAndServe(); err != nil && err != http.ErrServerClosed {
			slog.Error("server error", "err", err)
			os.Exit(1)
		}
	}()

	quit := make(chan os.Signal, 1)
	signal.Notify(quit, syscall.SIGINT, syscall.SIGTERM)
	<-quit

	slog.Info("shutting down gracefully...")
	shutdownCtx, shutdownCancel := context.WithTimeout(context.Background(), 30*time.Second)
	defer shutdownCancel()
	if err := srv.Shutdown(shutdownCtx); err != nil {
		slog.Error("server forced shutdown", "err", err)
	}
	slog.Info("server stopped")
}
