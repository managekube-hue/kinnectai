package config

import (
	"fmt"
	"os"
	"strconv"

	"github.com/joho/godotenv"
)

type Config struct {
	Port string
	Env  string

	JWTSecret      string
	JWTExpiryHours int

	PostgresHost     string
	PostgresPort     string
	PostgresUser     string
	PostgresPassword string
	PostgresDB       string
	PostgresSSLMode  string

	Neo4jURI      string
	Neo4jUser     string
	Neo4jPassword string

	RedisAddr     string
	RedisPassword string
	RedisDB       int

	AstraDBID     string
	AstraRegion   string
	AstraKeyspace string
	AstraToken    string

	GetStreamAPIKey string
	GetStreamSecret string
	GetStreamAppID  string

	KafkaBrokers      string
	KafkaTopicDNAKits string

	SequencingAPIKey  string
	SequencingBaseURL string

	LexisNexisAPIKey  string
	LexisNexisSecret  string
	LexisNexisBaseURL string

	WhitepagesAPIKey string

	AWSS3BucketMedia   string
	AWSS3BucketDNACold string

	RateLimitRPM int
}

func Load() (*Config, error) {
	// Load .env if present (non-fatal if missing in production)
	_ = godotenv.Load()

	cfg := &Config{
		Port: getEnv("PORT", "8080"),
		Env:  getEnv("ENV", "development"),

		JWTSecret:      requireEnv("JWT_SECRET"),
		JWTExpiryHours: getEnvInt("JWT_EXPIRY_HOURS", 72),

		PostgresHost:     getEnv("POSTGRES_HOST", "localhost"),
		PostgresPort:     getEnv("POSTGRES_PORT", "5432"),
		PostgresUser:     requireEnv("POSTGRES_USER"),
		PostgresPassword: requireEnv("POSTGRES_PASSWORD"),
		PostgresDB:       getEnv("POSTGRES_DB", "kinnectai"),
		PostgresSSLMode:  getEnv("POSTGRES_SSL_MODE", "disable"),

		Neo4jURI:      getEnv("NEO4J_URI", "bolt://localhost:7687"),
		Neo4jUser:     getEnv("NEO4J_USER", "neo4j"),
		Neo4jPassword: requireEnv("NEO4J_PASSWORD"),

		RedisAddr:     getEnv("REDIS_ADDR", "localhost:6379"),
		RedisPassword: getEnv("REDIS_PASSWORD", ""),
		RedisDB:       getEnvInt("REDIS_DB", 0),

		AstraDBID:     getEnv("ASTRA_DB_ID", ""),
		AstraRegion:   getEnv("ASTRA_REGION", "us-east-2"),
		AstraKeyspace: getEnv("ASTRA_KEYSPACE", "Kinnect_AI"),
		AstraToken:    getEnv("ASTRA_TOKEN", ""),

		GetStreamAPIKey: requireEnv("GETSTREAM_API_KEY"),
		GetStreamSecret: requireEnv("GETSTREAM_SECRET"),
		GetStreamAppID:  getEnv("GETSTREAM_APP_ID", ""),

		KafkaBrokers:      getEnv("KAFKA_BROKERS", "localhost:9092"),
		KafkaTopicDNAKits: getEnv("KAFKA_TOPIC_DNA_KITS", "dna-kit-submissions"),

		SequencingAPIKey:  getEnv("SEQUENCING_API_KEY", ""),
		SequencingBaseURL: getEnv("SEQUENCING_BASE_URL", "https://api.sequencing.com"),

		LexisNexisAPIKey:  getEnv("LEXISNEXIS_API_KEY", ""),
		LexisNexisSecret:  getEnv("LEXISNEXIS_SECRET", ""),
		LexisNexisBaseURL: getEnv("LEXISNEXIS_BASE_URL", "https://risk.api.lexisnexis.com"),

		WhitepagesAPIKey: getEnv("WHITEPAGES_API_KEY", ""),

		AWSS3BucketMedia:   getEnv("S3_BUCKET_MEDIA", "kinnectai-media"),
		AWSS3BucketDNACold: getEnv("S3_BUCKET_DNA_COLD", "kinnectai-dna-glacier"),

		RateLimitRPM: getEnvInt("RATE_LIMIT_REQUESTS_PER_MINUTE", 60),
	}

	return cfg, nil
}

func (c *Config) PostgresDSN() string {
	return fmt.Sprintf(
		"host=%s port=%s user=%s password=%s dbname=%s sslmode=%s",
		c.PostgresHost, c.PostgresPort, c.PostgresUser, c.PostgresPassword, c.PostgresDB, c.PostgresSSLMode,
	)
}

func getEnv(key, fallback string) string {
	if v := os.Getenv(key); v != "" {
		return v
	}
	return fallback
}

func requireEnv(key string) string {
	v := os.Getenv(key)
	if v == "" {
		panic(fmt.Sprintf("required environment variable %q is not set", key))
	}
	return v
}

func getEnvInt(key string, fallback int) int {
	if v := os.Getenv(key); v != "" {
		if i, err := strconv.Atoi(v); err == nil {
			return i
		}
	}
	return fallback
}
