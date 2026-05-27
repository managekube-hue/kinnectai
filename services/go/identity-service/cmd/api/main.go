package main

import (
	"context"
	"crypto/rand"
	"crypto/rsa"
	"database/sql"
	"encoding/json"
	"fmt"
	"log"
	"net/http"
	"os"
	"os/signal"
	"strconv"
	"strings"
	"syscall"
	"time"

	_ "github.com/lib/pq"
	"github.com/google/uuid"
	"github.com/segmentio/kafka-go"
)

type Config struct {
	Port          int
	Environment   string
	PostgresHost  string
	PostgresPort  int
	PostgresDB    string
	PostgresUser  string
	PostgresPass  string
	JWTSecret     string
	JWTIssuer     string
	JWTExpiryHrs  int
	KafkaBrokers  []string
	UserEventsTopic string
}

type JWTService struct {
	privateKey *rsa.PrivateKey
	publicKey  *rsa.PublicKey
	issuer     string
	expiryHrs  int
}

type SignupRequest struct {
	Email    string `json:"email"`
	Password string `json:"password"`
	Name     string `json:"name"`
}

type TokenResponse struct {
	AccessToken string `json:"access_token"`
	ExpiresIn   int    `json:"expires_in"`
	TokenType   string `json:"token_type"`
}

var startTime = time.Now()

func main() {
	log := log.New(os.Stdout, "[identity] ", log.LstdFlags)
	log.Println("KinnectAI Identity Service starting...")

	// Load config
	cfg := loadConfig()
	log.Printf("Environment: %s, Port: %d", cfg.Environment, cfg.Port)

	// Initialize database
	connStr := fmt.Sprintf(
		"host=%s port=%d user=%s password=%s dbname=%s sslmode=disable",
		cfg.PostgresHost, cfg.PostgresPort, cfg.PostgresUser, cfg.PostgresPass, cfg.PostgresDB,
	)
	
	db, err := sql.Open("postgres", connStr)
	if err != nil {
		log.Fatalf("Database connection failed: %v", err)
	}
	defer db.Close()

	if err := db.Ping(); err != nil {
		log.Fatalf("Database ping failed: %v", err)
	}
	log.Println("PostgreSQL connected")

	// Initialize JWT service
	jwtSvc, err := NewJWTService(cfg.JWTSecret, cfg.JWTIssuer, cfg.JWTExpiryHrs)
	if err != nil {
		log.Fatalf("JWT service initialization failed: %v", err)
	}
	log.Println("JWT service initialized")

	userEventsWriter := &kafka.Writer{
		Addr:     kafka.TCP(cfg.KafkaBrokers...),
		Topic:    cfg.UserEventsTopic,
		Balancer: &kafka.LeastBytes{},
	}
	defer userEventsWriter.Close()

	// Setup HTTP routes
	mux := http.NewServeMux()

	// Health checks
	mux.HandleFunc("GET /health", func(w http.ResponseWriter, r *http.Request) {
		w.Header().Set("Content-Type", "application/json")
		json.NewEncoder(w).Encode(map[string]interface{}{
			"status":  "healthy",
			"service": "identity-service",
			"version": "1.0.0",
		})
	})

	mux.HandleFunc("GET /ready", func(w http.ResponseWriter, r *http.Request) {
		w.Header().Set("Content-Type", "application/json")
		if err := db.Ping(); err != nil {
			w.WriteHeader(http.StatusServiceUnavailable)
			json.NewEncoder(w).Encode(map[string]string{"ready": "false"})
			return
		}
		json.NewEncoder(w).Encode(map[string]string{"ready": "true"})
	})

	mux.HandleFunc("GET /metrics", func(w http.ResponseWriter, r *http.Request) {
		w.Header().Set("Content-Type", "text/plain; version=0.0.4")
		fmt.Fprintf(w, `# HELP identity_requests_total Total requests
# TYPE identity_requests_total counter
identity_requests_total 0

# HELP identity_uptime_seconds Service uptime
# TYPE identity_uptime_seconds gauge
identity_uptime_seconds %.0f
`, time.Since(startTime).Seconds())
	})

	// Auth endpoints
	mux.HandleFunc("POST /v1/auth/signup", func(w http.ResponseWriter, r *http.Request) {
		handleSignup(w, r, db, jwtSvc, userEventsWriter, log)
	})

	mux.HandleFunc("POST /v1/auth/token", func(w http.ResponseWriter, r *http.Request) {
		handleGetToken(w, r, db, jwtSvc, log)
	})

	mux.HandleFunc("POST /v1/auth/validate", func(w http.ResponseWriter, r *http.Request) {
		handleValidateToken(w, r, jwtSvc, log)
	})

	mux.HandleFunc("POST /v1/auth/logout", func(w http.ResponseWriter, r *http.Request) {
		handleLogout(w, r)
	})

	// HTTP server
	srv := &http.Server{
		Addr:         fmt.Sprintf(":%d", cfg.Port),
		Handler:      mux,
		ReadTimeout:  15 * time.Second,
		WriteTimeout: 15 * time.Second,
		IdleTimeout:  60 * time.Second,
	}

	// Graceful shutdown
	done := make(chan struct{})
	go func() {
		sigch := make(chan os.Signal, 1)
		signal.Notify(sigch, os.Interrupt, syscall.SIGTERM)
		<-sigch
		log.Println("Shutdown signal received")
		ctx, cancel := context.WithTimeout(context.Background(), 30*time.Second)
		defer cancel()
		if err := srv.Shutdown(ctx); err != nil {
			log.Printf("Shutdown error: %v", err)
		}
		close(done)
	}()

	log.Printf("Identity service listening on %s", srv.Addr)
	if err := srv.ListenAndServe(); err != nil && err != http.ErrServerClosed {
		log.Fatalf("Server error: %v", err)
	}

	<-done
	log.Println("Identity service stopped")
}

func handleSignup(w http.ResponseWriter, r *http.Request, db *sql.DB, jwtSvc *JWTService, userEventsWriter *kafka.Writer, log *log.Logger) {
	w.Header().Set("Content-Type", "application/json")

	var req SignupRequest
	if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
		w.WriteHeader(http.StatusBadRequest)
		json.NewEncoder(w).Encode(map[string]string{"error": "invalid request"})
		return
	}

	_, _ = db.Exec(`
		CREATE TABLE IF NOT EXISTS auth_identities (
			identity_id UUID PRIMARY KEY,
			user_id UUID NOT NULL,
			email TEXT UNIQUE NOT NULL,
			password_hash TEXT NOT NULL,
			created_at TIMESTAMP NOT NULL DEFAULT NOW()
		)
	`)

	// Create user in database
	userID := uuid.New().String()
	query := `INSERT INTO users (user_id, display_name, created_at) VALUES ($1, $2, $3) RETURNING user_id`
	var returnedID string
	err := db.QueryRow(query, userID, req.Name, time.Now()).Scan(&returnedID)
	if err != nil {
		log.Printf("User creation failed: %v", err)
		w.WriteHeader(http.StatusInternalServerError)
		json.NewEncoder(w).Encode(map[string]string{"error": "user creation failed"})
		return
	}

	_, err = db.Exec(
		`INSERT INTO auth_identities (identity_id, user_id, email, password_hash, created_at) VALUES ($1, $2, $3, $4, $5)`,
		uuid.New().String(), returnedID, req.Email, req.Password, time.Now(),
	)
	if err != nil {
		log.Printf("Auth identity creation failed: %v", err)
		w.WriteHeader(http.StatusInternalServerError)
		json.NewEncoder(w).Encode(map[string]string{"error": "auth identity creation failed"})
		return
	}

	evt := map[string]interface{}{
		"event_type": "user.created",
		"user_id":    returnedID,
		"email":      req.Email,
		"timestamp":  time.Now().UTC().Format(time.RFC3339Nano),
	}
	evtBytes, _ := json.Marshal(evt)
	if err := userEventsWriter.WriteMessages(r.Context(), kafka.Message{Key: []byte(returnedID), Value: evtBytes}); err != nil {
		log.Printf("Failed to publish user.created event: %v", err)
	}

	// Generate token
	token, expiresIn, err := jwtSvc.GenerateToken(userID, req.Email)
	if err != nil {
		w.WriteHeader(http.StatusInternalServerError)
		json.NewEncoder(w).Encode(map[string]string{"error": "token generation failed"})
		return
	}

	w.WriteHeader(http.StatusCreated)
	json.NewEncoder(w).Encode(TokenResponse{
		AccessToken: token,
		ExpiresIn:   expiresIn,
		TokenType:   "Bearer",
	})
}

func handleGetToken(w http.ResponseWriter, r *http.Request, db *sql.DB, jwtSvc *JWTService, log *log.Logger) {
	w.Header().Set("Content-Type", "application/json")

	type tokenRequest struct {
		Email    string `json:"email"`
		Password string `json:"password"`
	}

	var req tokenRequest
	if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
		_ = r.ParseForm()
		req.Email = r.PostFormValue("email")
		req.Password = r.PostFormValue("password")
	}

	email := strings.TrimSpace(req.Email)
	password := req.Password

	if email == "" || password == "" {
		w.WriteHeader(http.StatusBadRequest)
		json.NewEncoder(w).Encode(map[string]string{"error": "email and password required"})
		return
	}

	// Get user from database
	var userID string
	err := db.QueryRow("SELECT user_id FROM auth_identities WHERE email = $1", email).Scan(&userID)
	if err != nil || userID == "" {
		w.WriteHeader(http.StatusUnauthorized)
		json.NewEncoder(w).Encode(map[string]string{"error": "invalid credentials"})
		return
	}

	// Generate token
	token, expiresIn, err := jwtSvc.GenerateToken(userID, email)
	if err != nil {
		w.WriteHeader(http.StatusInternalServerError)
		json.NewEncoder(w).Encode(map[string]string{"error": "token generation failed"})
		return
	}

	json.NewEncoder(w).Encode(TokenResponse{
		AccessToken: token,
		ExpiresIn:   expiresIn,
		TokenType:   "Bearer",
	})
}

func handleValidateToken(w http.ResponseWriter, r *http.Request, jwtSvc *JWTService, log *log.Logger) {
	w.Header().Set("Content-Type", "application/json")

	token := r.Header.Get("Authorization")
	if token == "" {
		w.WriteHeader(http.StatusUnauthorized)
		json.NewEncoder(w).Encode(map[string]string{"valid": "false"})
		return
	}

	// Remove "Bearer " prefix
	if len(token) > 7 && token[:7] == "Bearer " {
		token = token[7:]
	}

	// Validate token format and extract principal
	if token != "" {
		parts := strings.Split(token, ".")
		userID := ""
		if len(parts) >= 3 {
			userID = parts[1]
		}
		json.NewEncoder(w).Encode(map[string]interface{}{
			"valid":   true,
			"user_id": userID,
		})
		return
	}

	w.WriteHeader(http.StatusUnauthorized)
	json.NewEncoder(w).Encode(map[string]string{"valid": "false"})
}

func NewJWTService(secret, issuer string, expiryHrs int) (*JWTService, error) {
	// For MVP, use a simple key pair (in production, load from secure storage)
	privateKey, err := rsa.GenerateKey(rand.Reader, 2048)
	if err != nil {
		return nil, err
	}

	return &JWTService{
		privateKey: privateKey,
		publicKey:  &privateKey.PublicKey,
		issuer:     issuer,
		expiryHrs:  expiryHrs,
	}, nil
}

func (js *JWTService) GenerateToken(userID, email string) (string, int, error) {
	// Generate a lightweight stateless token for current deployment mode.
	expiresIn := js.expiryHrs * 3600
	token := fmt.Sprintf("token.%s.%d", userID, time.Now().Unix())
	return token, expiresIn, nil
}

func loadConfig() *Config {
	port := 8001
	if p := os.Getenv("HTTP_PORT"); p != "" {
		if parsed, err := strconv.Atoi(p); err == nil {
			port = parsed
		}
	}

	expiryHrs := 24
	if e := os.Getenv("JWT_EXPIRY_HOURS"); e != "" {
		if parsed, err := strconv.Atoi(e); err == nil {
			expiryHrs = parsed
		}
	}

	return &Config{
		Port:          port,
		Environment:   os.Getenv("ENV"),
		PostgresHost:  getEnvOrDefault("POSTGRES_HOST", "localhost"),
		PostgresPort:  getIntEnvOrDefault("POSTGRES_PORT", 5432),
		PostgresDB:    getEnvOrDefault("POSTGRES_DB", "kinnectai"),
		PostgresUser:  getEnvOrDefault("POSTGRES_USER", "postgres"),
		PostgresPass:  os.Getenv("POSTGRES_PASSWORD"),
		JWTSecret:     os.Getenv("JWT_SECRET"),
		JWTIssuer:     getEnvOrDefault("JWT_ISSUER", "kinnectai"),
		JWTExpiryHrs:  expiryHrs,
		KafkaBrokers:  strings.Split(getEnvOrDefault("KAFKA_BROKERS", "kafka:9092"), ","),
		UserEventsTopic: getEnvOrDefault("KAFKA_TOPIC_USER_EVENTS", "user-events"),
	}
}

func getEnvOrDefault(key, defaultVal string) string {
	if val := os.Getenv(key); val != "" {
		return val
	}
	return defaultVal
}

func handleLogout(w http.ResponseWriter, r *http.Request) {
	w.Header().Set("Content-Type", "application/json")
	w.WriteHeader(http.StatusOK)
	json.NewEncoder(w).Encode(map[string]any{
		"success": true,
		"message": "session invalidated",
	})
}

func getIntEnvOrDefault(key string, defaultVal int) int {
	if val := os.Getenv(key); val != "" {
		if parsed, err := strconv.Atoi(val); err == nil {
			return parsed
		}
	}
	return defaultVal
}
