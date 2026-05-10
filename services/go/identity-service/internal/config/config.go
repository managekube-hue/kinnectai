package config

import (
	"fmt"
	"os"
	"time"

	"gopkg.in/yaml.v3"
)

// Config holds application configuration
type Config struct {
	Environment    string        `yaml:"environment"`
	Port           int           `yaml:"port"`
	DatabaseURL    string        `yaml:"database_url"`
	RedisURL       string        `yaml:"redis_url"`
	KafkaBrokers   string        `yaml:"kafka_brokers"`
	LogLevel       string        `yaml:"log_level"`
	SecretKey      string        `yaml:"secret_key"`
	TokenExpiry    time.Duration `yaml:"token_expiry"`
	MFAEnabled     bool          `yaml:"mfa_enabled"`
	ServiceName    string
}

// Load loads configuration from environment
func Load() (*Config, error) {
	env := os.Getenv("ENVIRONMENT")
	if env == "" {
		env = "dev"
	}

	configFile := fmt.Sprintf("configs/%s.yaml", env)
	data, err := os.ReadFile(configFile)
	if err != nil {
		return nil, fmt.Errorf("failed to read config: %w", err)
	}

	cfg := &Config{ServiceName: "identity-service"}
	if err := yaml.Unmarshal(data, cfg); err != nil {
		return nil, fmt.Errorf("failed to parse config: %w", err)
	}

	// Override from environment variables
	if url := os.Getenv("DATABASE_URL"); url != "" {
		cfg.DatabaseURL = url
	}
	if url := os.Getenv("REDIS_URL"); url != "" {
		cfg.RedisURL = url
	}
	if brokers := os.Getenv("KAFKA_BROKERS"); brokers != "" {
		cfg.KafkaBrokers = brokers
	}

	return cfg, nil
}
