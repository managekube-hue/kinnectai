package auth

import (
	"bytes"
	"context"
	"encoding/json"
	"errors"
	"fmt"
	"io"
	"net/http"
	"net/url"
	"os"
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

// OAuthLogin handles Google, Facebook, and TikTok OAuth authentication.
// The client sends the provider token; this method verifies it, creates or
// finds the user, and returns JWT + GetStream tokens.
func (s *Service) OAuthLogin(ctx context.Context, provider, token string) (*AuthResponse, error) {
	// Step 1: Verify the OAuth token with the provider
	providerUID, email, displayName, err := s.verifyOAuthToken(ctx, provider, token)
	if err != nil {
		return nil, fmt.Errorf("oauth verify (%s): %w", provider, err)
	}

	// Step 2: Check if user exists with this provider link
	var userID uuid.UUID
	var username string
	var createdAt time.Time
	err = s.db.QueryRow(ctx,
		`SELECT u.id, u.username, u.created_at FROM users u
		 JOIN user_oauth uo ON u.id = uo.user_id
		 WHERE uo.provider = $1 AND uo.provider_uid = $2`,
		provider, providerUID,
	).Scan(&userID, &username, &createdAt)

	if err != nil {
		// User doesn't exist -- create new account
		userID = uuid.New()
		username = fmt.Sprintf("%s_%s", provider, providerUID[:8])
		createdAt = time.Now().UTC()

		_, err = s.db.Exec(ctx,
			`INSERT INTO users (id, username, email, display_name, created_at, updated_at)
			 VALUES ($1, $2, $3, $4, $5, $5)`,
			userID, username, email, displayName, createdAt,
		)
		if err != nil {
			return nil, fmt.Errorf("oauth create user: %w", err)
		}

		// Link OAuth provider
		_, err = s.db.Exec(ctx,
			`INSERT INTO user_oauth (user_id, provider, provider_uid, access_token, created_at)
			 VALUES ($1, $2, $3, $4, $5)`,
			userID, provider, providerUID, token, createdAt,
		)
		if err != nil {
			return nil, fmt.Errorf("oauth link provider: %w", err)
		}
	}

	return s.buildAuthResponse(ctx, userID.String(), username, email, createdAt)
}

// verifyOAuthToken validates a token with the respective provider and
// returns (providerUID, email, displayName, error).
func (s *Service) verifyOAuthToken(ctx context.Context, provider, token string) (string, string, string, error) {
	httpClient := &http.Client{Timeout: 10 * time.Second}

	switch provider {
	case "google":
		endpoint := "https://oauth2.googleapis.com/tokeninfo?id_token=" + url.QueryEscape(token)
		req, _ := http.NewRequestWithContext(ctx, http.MethodGet, endpoint, nil)
		resp, err := httpClient.Do(req)
		if err != nil {
			return "", "", "", fmt.Errorf("google verify request: %w", err)
		}
		defer resp.Body.Close()
		if resp.StatusCode != http.StatusOK {
			body, _ := io.ReadAll(resp.Body)
			return "", "", "", fmt.Errorf("google verify failed: %s", string(body))
		}
		var payload struct {
			Sub   string `json:"sub"`
			Email string `json:"email"`
			Name  string `json:"name"`
		}
		if err := json.NewDecoder(resp.Body).Decode(&payload); err != nil {
			return "", "", "", fmt.Errorf("google verify decode: %w", err)
		}
		if payload.Sub == "" {
			return "", "", "", errors.New("google token missing subject")
		}
		if payload.Email == "" {
			payload.Email = payload.Sub + "@google.local"
		}
		if payload.Name == "" {
			payload.Name = "Google User"
		}
		return payload.Sub, payload.Email, payload.Name, nil

	case "facebook":
		endpoint := "https://graph.facebook.com/me?fields=id,email,name&access_token=" + url.QueryEscape(token)
		req, _ := http.NewRequestWithContext(ctx, http.MethodGet, endpoint, nil)
		resp, err := httpClient.Do(req)
		if err != nil {
			return "", "", "", fmt.Errorf("facebook verify request: %w", err)
		}
		defer resp.Body.Close()
		if resp.StatusCode != http.StatusOK {
			body, _ := io.ReadAll(resp.Body)
			return "", "", "", fmt.Errorf("facebook verify failed: %s", string(body))
		}
		var payload struct {
			ID    string `json:"id"`
			Email string `json:"email"`
			Name  string `json:"name"`
		}
		if err := json.NewDecoder(resp.Body).Decode(&payload); err != nil {
			return "", "", "", fmt.Errorf("facebook verify decode: %w", err)
		}
		if payload.ID == "" {
			return "", "", "", errors.New("facebook token missing id")
		}
		if payload.Email == "" {
			payload.Email = payload.ID + "@facebook.local"
		}
		if payload.Name == "" {
			payload.Name = "Facebook User"
		}
		return payload.ID, payload.Email, payload.Name, nil

	case "tiktok":
		clientKey := os.Getenv("TIKTOK_CLIENT_KEY")
		clientSecret := os.Getenv("TIKTOK_CLIENT_SECRET")
		redirectURI := os.Getenv("TIKTOK_REDIRECT_URI")
		if clientKey == "" || clientSecret == "" || redirectURI == "" {
			return "", "", "", errors.New("tiktok oauth env vars are not configured")
		}

		form := url.Values{}
		form.Set("client_key", clientKey)
		form.Set("client_secret", clientSecret)
		form.Set("code", token)
		form.Set("grant_type", "authorization_code")
		form.Set("redirect_uri", redirectURI)

		req, _ := http.NewRequestWithContext(ctx, http.MethodPost, "https://open.tiktokapis.com/v2/oauth/token/", bytes.NewBufferString(form.Encode()))
		req.Header.Set("Content-Type", "application/x-www-form-urlencoded")
		resp, err := httpClient.Do(req)
		if err != nil {
			return "", "", "", fmt.Errorf("tiktok token exchange request: %w", err)
		}
		defer resp.Body.Close()
		if resp.StatusCode < 200 || resp.StatusCode >= 300 {
			body, _ := io.ReadAll(resp.Body)
			return "", "", "", fmt.Errorf("tiktok token exchange failed: %s", string(body))
		}
		var tokenPayload struct {
			OpenID      string `json:"open_id"`
			AccessToken string `json:"access_token"`
		}
		if err := json.NewDecoder(resp.Body).Decode(&tokenPayload); err != nil {
			return "", "", "", fmt.Errorf("tiktok token decode: %w", err)
		}
		if tokenPayload.OpenID == "" {
			return "", "", "", errors.New("tiktok open_id missing")
		}

		profileReqBody := bytes.NewBufferString(`{"fields":["open_id","display_name","avatar_url"]}`)
		profileReq, _ := http.NewRequestWithContext(ctx, http.MethodPost, "https://open.tiktokapis.com/v2/user/info/", profileReqBody)
		profileReq.Header.Set("Content-Type", "application/json")
		profileReq.Header.Set("Authorization", "Bearer "+tokenPayload.AccessToken)
		profileResp, err := httpClient.Do(profileReq)
		if err != nil {
			return "", "", "", fmt.Errorf("tiktok profile request: %w", err)
		}
		defer profileResp.Body.Close()
		var displayName string
		if profileResp.StatusCode >= 200 && profileResp.StatusCode < 300 {
			var profile struct {
				Data struct {
					User struct {
						DisplayName string `json:"display_name"`
					} `json:"user"`
				} `json:"data"`
			}
			_ = json.NewDecoder(profileResp.Body).Decode(&profile)
			displayName = profile.Data.User.DisplayName
		}
		if displayName == "" {
			displayName = "TikTok User"
		}
		return tokenPayload.OpenID, tokenPayload.OpenID + "@tiktok.local", displayName, nil

	default:
		return "", "", "", fmt.Errorf("unsupported provider: %s", provider)
	}
}

func (s *Service) SendPhoneOTP(ctx context.Context, phone string) error {
	accountSID := os.Getenv("TWILIO_ACCOUNT_SID")
	authToken := os.Getenv("TWILIO_AUTH_TOKEN")
	verifySID := os.Getenv("TWILIO_VERIFY_SERVICE_SID")
	if accountSID == "" || authToken == "" || verifySID == "" {
		return errors.New("twilio verify env vars are not configured")
	}

	endpoint := fmt.Sprintf("https://verify.twilio.com/v2/Services/%s/Verifications", verifySID)
	form := url.Values{}
	form.Set("To", phone)
	form.Set("Channel", "sms")

	req, _ := http.NewRequestWithContext(ctx, http.MethodPost, endpoint, bytes.NewBufferString(form.Encode()))
	req.SetBasicAuth(accountSID, authToken)
	req.Header.Set("Content-Type", "application/x-www-form-urlencoded")

	resp, err := (&http.Client{Timeout: 10 * time.Second}).Do(req)
	if err != nil {
		return fmt.Errorf("twilio send otp request: %w", err)
	}
	defer resp.Body.Close()
	if resp.StatusCode < 200 || resp.StatusCode >= 300 {
		body, _ := io.ReadAll(resp.Body)
		return fmt.Errorf("twilio send otp failed: %s", string(body))
	}
	return nil
}

func (s *Service) VerifyPhoneOTP(ctx context.Context, phone, code string) (bool, error) {
	accountSID := os.Getenv("TWILIO_ACCOUNT_SID")
	authToken := os.Getenv("TWILIO_AUTH_TOKEN")
	verifySID := os.Getenv("TWILIO_VERIFY_SERVICE_SID")
	if accountSID == "" || authToken == "" || verifySID == "" {
		return false, errors.New("twilio verify env vars are not configured")
	}

	endpoint := fmt.Sprintf("https://verify.twilio.com/v2/Services/%s/VerificationCheck", verifySID)
	form := url.Values{}
	form.Set("To", phone)
	form.Set("Code", code)

	req, _ := http.NewRequestWithContext(ctx, http.MethodPost, endpoint, bytes.NewBufferString(form.Encode()))
	req.SetBasicAuth(accountSID, authToken)
	req.Header.Set("Content-Type", "application/x-www-form-urlencoded")

	resp, err := (&http.Client{Timeout: 10 * time.Second}).Do(req)
	if err != nil {
		return false, fmt.Errorf("twilio verify otp request: %w", err)
	}
	defer resp.Body.Close()
	if resp.StatusCode < 200 || resp.StatusCode >= 300 {
		body, _ := io.ReadAll(resp.Body)
		return false, fmt.Errorf("twilio verify otp failed: %s", string(body))
	}
	var payload struct {
		Status string `json:"status"`
	}
	if err := json.NewDecoder(resp.Body).Decode(&payload); err != nil {
		return false, fmt.Errorf("twilio verify otp decode: %w", err)
	}
	return payload.Status == "approved", nil
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
