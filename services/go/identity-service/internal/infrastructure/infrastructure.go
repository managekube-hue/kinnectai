package infrastructure

import (
	"context"
	"database/sql"
	"fmt"
	"strings"

	"github.com/redis/go-redis/v9"
	"go.opentelemetry.io/trace"

	"github.com/managekube-hue/kinnectai/services/go/identity-service/internal/config"
	"github.com/managekube-hue/kinnectai/services/go/identity-service/internal/infrastructure/kafka"
	"github.com/managekube-hue/kinnectai/services/go/identity-service/internal/infrastructure/postgres"
	"github.com/managekube-hue/kinnectai/services/go/identity-service/internal/infrastructure/redis"
	"github.com/managekube-hue/kinnectai/pkg/telemetry"
)

// Infrastructure holds all infrastructure dependencies
type Infrastructure struct {
	DB        *sql.DB
	UserRepo  *postgres.Repository
	Cache     *redis.Cache
	Producer  *kafka.Producer
	Logger    telemetry.Logger
	Tracer    trace.Tracer
}

// New initializes infrastructure
func New(ctx context.Context, cfg *config.Config, logger telemetry.Logger, tracer trace.Tracer, meter any) (*Infrastructure, error) {
	// Connect to PostgreSQL
	db, err := sql.Open("postgres", cfg.DatabaseURL)
	if err != nil {
		return nil, fmt.Errorf("failed to connect to postgres: %w", err)
	}

	if err := db.PingContext(ctx); err != nil {
		return nil, fmt.Errorf("failed to ping postgres: %w", err)
	}

	// Initialize repository
	userRepo := postgres.New(db)

	// Connect to Redis
	redisOpts, err := redis.ParseURL(cfg.RedisURL)
	if err != nil {
		return nil, fmt.Errorf("failed to parse redis url: %w", err)
	}

	redisClient := redis.NewClient(redisOpts)
	if err := redisClient.Ping(ctx).Err(); err != nil {
		return nil, fmt.Errorf("failed to ping redis: %w", err)
	}

	cache := redis.New(redisClient, 0) // TODO: make TTL configurable

	// Initialize Kafka producer
	brokers := strings.Split(cfg.KafkaBrokers, ",")
	producer := kafka.New(brokers)

	return &Infrastructure{
		DB:       db,
		UserRepo: userRepo,
		Cache:    cache,
		Producer: producer,
		Logger:   logger,
		Tracer:   tracer,
	}, nil
}

// Close closes all connections
func (i *Infrastructure) Close() error {
	if i.DB != nil {
		if err := i.DB.Close(); err != nil {
			return err
		}
	}

	if i.Producer != nil {
		if err := i.Producer.Close(); err != nil {
			return err
		}
	}

	return nil
}
