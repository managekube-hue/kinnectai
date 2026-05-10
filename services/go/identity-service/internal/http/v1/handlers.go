package v1

import (
	"context"
	"identityservice/internal/domain/user"
	"log"
	"net/http"
)

// Handler encapsulates HTTP v1 handlers for identity operations.
// Separates HTTP concerns from domain logic.
type Handler struct {
	userService *user.Service
}

// New creates a new v1 handler.
func New(userService *user.Service) *Handler {
	return &Handler{
		userService: userService,
	}
}

// Register handles POST /v1/auth/register
func (h *Handler) Register(w http.ResponseWriter, r *http.Request) {
	if r.Method != http.MethodPost {
		http.Error(w, "Method not allowed", http.StatusMethodNotAllowed)
		return
	}

	var req RegisterRequest
	if err := ReadJSON(r, &req); err != nil {
		WriteJSON(w, http.StatusBadRequest, ErrorResponse{
			Code:    "INVALID_REQUEST",
			Message: "Invalid request body",
		})
		return
	}

	// Call domain service (business logic is here)
	// u, err := h.userService.RegisterUser(r.Context(), req.Email, req.PhoneNumber, req.Password)
	// Simplified for template - would hash password using bcrypt/argon2
	
	log.Printf("Register handler: received request for %s", req.Email)

	// Respond with success (simplified for template)
	WriteJSON(w, http.StatusCreated, RegisterResponse{
		UserID:    "user_123",
		Email:     req.Email,
		Status:    "pending",
		CreatedAt: "2026-05-09T12:00:00Z",
	})
}

// Login handles POST /v1/auth/login
func (h *Handler) Login(w http.ResponseWriter, r *http.Request) {
	if r.Method != http.MethodPost {
		http.Error(w, "Method not allowed", http.StatusMethodNotAllowed)
		return
	}

	var req LoginRequest
	if err := ReadJSON(r, &req); err != nil {
		WriteJSON(w, http.StatusBadRequest, ErrorResponse{
			Code:    "INVALID_REQUEST",
			Message: "Invalid request body",
		})
		return
	}

	// Call domain service
	// u, err := h.userService.AuthenticateUser(r.Context(), req.Email, req.Password)
	
	log.Printf("Login handler: authentication attempt for %s", req.Email)

	// Would generate actual JWT token here
	WriteJSON(w, http.StatusOK, LoginResponse{
		UserID:       "user_123",
		SessionToken: "jwt_token_here",
		MFARequired:  false,
		ExpiresIn:    3600,
	})
}

// VerifyMFA handles POST /v1/auth/mfa/verify
func (h *Handler) VerifyMFA(w http.ResponseWriter, r *http.Request) {
	if r.Method != http.MethodPost {
		http.Error(w, "Method not allowed", http.StatusMethodNotAllowed)
		return
	}

	var req MFAVerifyRequest
	if err := ReadJSON(r, &req); err != nil {
		WriteJSON(w, http.StatusBadRequest, ErrorResponse{
			Code:    "INVALID_REQUEST",
			Message: "Invalid request body",
		})
		return
	}

	log.Printf("MFA verification attempt with token: %s", req.Token)

	WriteJSON(w, http.StatusOK, MFAVerifyResponse{
		SessionToken: "jwt_token_here",
		ExpiresIn:    3600,
	})
}

// GetProfile handles GET /v1/me (protected endpoint)
func (h *Handler) GetProfile(w http.ResponseWriter, r *http.Request) {
	if r.Method != http.MethodGet {
		http.Error(w, "Method not allowed", http.StatusMethodNotAllowed)
		return
	}

	// Extract user ID from JWT token (done by middleware)
	userID := r.Header.Get("X-User-ID")
	if userID == "" {
		WriteJSON(w, http.StatusUnauthorized, ErrorResponse{
			Code:    "UNAUTHORIZED",
			Message: "Authentication required",
		})
		return
	}

	// Fetch user from repository
	// u, err := repo.FindByID(r.Context(), userID)

	log.Printf("Profile fetch for user: %s", userID)

	WriteJSON(w, http.StatusOK, map[string]interface{}{
		"user_id": userID,
		"email":   "user@example.com",
		"status":  "active",
	})
}
