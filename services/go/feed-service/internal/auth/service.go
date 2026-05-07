package auth

import (
	"context"
	"errors"
	"fmt"
	"time"

	"github.com/GetStream/stream-go2/v8"
	"github.com/golang-jwt/jwt/v5"
	"github.com/google/uuid"
	"github.com/jackc/pgx/v5/pgxpool"
	"golang.org/x/crypto/bcrypt"
)

var (
	ErrUserNotFound    = errors.New("user not found")
	ErrInvalidPassword = errors.New("invalid credentials")
	ErrUserExists      = errors.New("user already exists")
)

type Service struct {
	db              *pgxpool.Pool
	streamClient    *stream.Client
	jwtSecret       []byte
	jwtExpiryHours  int
}

func NewService(db *pgxpool.Pool, streamClient *stream.Client, jwtSecret string, jwtExpiryHours int) *Service {
	return &Service{
		db:             db,
		streamClient:   streamClient,
		jwtSecret:      []byte(jwtSecret),
		jwtExpiryHours: jwtExpiryHours,
	}
}

// Register creates a new user, provisions GetStream user, returns tokens.
func (s *Service) Register(ctx context.Context, req RegisterRequest) (*AuthResponse, error) {
	// Check existing user
	var exists bool
	err := s.db.QueryRow(ctx,
		`SELECT EXISTS(SELECT 1 FROM users WHERE email=$1 OR username=$2)`,
		req.Email, req.Username,
	).Scan(&exists)
	if err != nil {
		return nil, fmt.Errorf("register: db check failed: %w", err)
	}
	if exists {
		return nil, ErrUserExists
	}

	// Hash password (bcrypt cost 12)
	hash, err := bcrypt.GenerateFromPassword([]byte(req.Password), 12)
	if err != nil {
		return nil, fmt.Errorf("register: bcrypt failed: %w", err)
	}

	userID := uuid.New()
	now := time.Now().UTC()

	// Insert user
	_, err = s.db.Exec(ctx,
		`INSERT INTO users (id, username, email, password_hash, display_name, mother_maiden_name, birth_year, created_at, updated_at)
		 VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $8)`,
		userID, req.Username, req.Email, string(hash), req.DisplayName,
		req.MotherMaidenName, req.BirthYear, now,
	)
	if err != nil {
		return nil, fmt.Errorf("register: insert user failed: %w", err)
	}

	// Generate tokens
	return s.buildAuthResponse(ctx, userID.String(), req.Username, req.Email, now)
}

// Login validates credentials and returns tokens.
func (s *Service) Login(ctx context.Context, req LoginRequest) (*AuthResponse, error) {
	var (
		id           uuid.UUID
		username     string
		passwordHash string
		createdAt    time.Time
	)
	err := s.db.QueryRow(ctx,
		`SELECT id, username, password_hash, created_at FROM users WHERE email=$1 AND is_active=TRUE`,
		req.Email,
	).Scan(&id, &username, &passwordHash, &createdAt)
	if err != nil {
		// Return generic error to prevent user enumeration
		return nil, ErrInvalidPassword
	}

	if err := bcrypt.CompareHashAndPassword([]byte(passwordHash), []byte(req.Password)); err != nil {
		return nil, ErrInvalidPassword
	}

	return s.buildAuthResponse(ctx, id.String(), username, req.Email, createdAt)
}

// GenerateGetStreamToken creates a signed GetStream user token server-side.
// The GetStream secret MUST never leave the backend.
func (s *Service) GenerateGetStreamToken(userID string) (string, error) {
	token, err := s.streamClient.CreateUserToken(userID)
	if err != nil {
		return "", fmt.Errorf("getstream token: %w", err)
	}
	return token, nil
}

func (s *Service) buildAuthResponse(ctx context.Context, userID, username, email string, createdAt time.Time) (*AuthResponse, error) {
	expiresAt := time.Now().Add(time.Duration(s.jwtExpiryHours) * time.Hour)

	// JWT
	jwtToken, err := s.generateJWT(userID, username, email, expiresAt)
	if err != nil {
		return nil, err
	}

	// GetStream user token
	gsToken, err := s.GenerateGetStreamToken(userID)
	if err != nil {
		return nil, err
	}

	user := User{
		ID:        uuid.MustParse(userID),
		Username:  username,
		Email:     email,
		CreatedAt: createdAt,
	}

	return &AuthResponse{
		User:           user,
		AccessToken:    jwtToken,
		GetStreamToken: gsToken,
		ExpiresAt:      expiresAt.Unix(),
	}, nil
}

func (s *Service) generateJWT(userID, username, email string, expiresAt time.Time) (string, error) {
	claims := jwt.MapClaims{
		"sub":      userID,
		"username": username,
		"email":    email,
		"exp":      expiresAt.Unix(),
		"iat":      time.Now().Unix(),
	}
	token := jwt.NewWithClaims(jwt.SigningMethodHS256, claims)
	signed, err := token.SignedString(s.jwtSecret)
	if err != nil {
		return "", fmt.Errorf("jwt sign: %w", err)
	}
	return signed, nil
}

// ValidateJWT parses and validates a JWT string, returning the user ID.
func (s *Service) ValidateJWT(tokenStr string) (string, error) {
	token, err := jwt.Parse(tokenStr, func(t *jwt.Token) (interface{}, error) {
		if _, ok := t.Method.(*jwt.SigningMethodHMAC); !ok {
			return nil, fmt.Errorf("unexpected signing method: %v", t.Header["alg"])
		}
		return s.jwtSecret, nil
	})
	if err != nil || !token.Valid {
		return "", errors.New("invalid token")
	}

	claims, ok := token.Claims.(jwt.MapClaims)
	if !ok {
		return "", errors.New("invalid token claims")
	}

	userID, ok := claims["sub"].(string)
	if !ok || userID == "" {
		return "", errors.New("invalid token subject")
	}

	return userID, nil
}
