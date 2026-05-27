package v1

import (
	"encoding/json"
	"net/http"

	"github.com/managekube-hue/kinnectai/services/go/identity-service/internal/domain/user"
)

// RegisterRequest represents a user registration request.
type RegisterRequest struct {
	Email       string `json:"email" binding:"required,email"`
	Password    string `json:"password" binding:"required,min=12"`
	PhoneNumber string `json:"phone_number"`
}

// RegisterResponse represents the registration response.
type RegisterResponse struct {
	UserID    string `json:"user_id"`
	Email     string `json:"email"`
	Status    string `json:"status"`
	CreatedAt string `json:"created_at"`
}

// LoginRequest represents a login request.
type LoginRequest struct {
	Email    string `json:"email" binding:"required,email"`
	Password string `json:"password" binding:"required"`
}

// LoginResponse represents a successful login response.
type LoginResponse struct {
	UserID         string `json:"user_id"`
	SessionToken   string `json:"session_token"`
	MFARequired    bool   `json:"mfa_required"`
	MFAChallenge   string `json:"mfa_challenge,omitempty"`
	ExpiresIn      int    `json:"expires_in"`
}

// MFAVerifyRequest represents an MFA verification request.
type MFAVerifyRequest struct {
	Token string `json:"token" binding:"required"`
}

// MFAVerifyResponse represents the MFA verification response.
type MFAVerifyResponse struct {
	SessionToken string `json:"session_token"`
	ExpiresIn    int    `json:"expires_in"`
}

// ErrorResponse represents an API error response.
type ErrorResponse struct {
	Code    string `json:"code"`
	Message string `json:"message"`
	Details string `json:"details,omitempty"`
}

// ToErrorResponse converts a domain error to HTTP response.
func ToErrorResponse(err error) (int, ErrorResponse) {
	switch err {
	case user.ErrInvalidEmail:
		return http.StatusBadRequest, ErrorResponse{
			Code:    "INVALID_EMAIL",
			Message: "The provided email address is invalid",
		}
	case user.ErrUserNotFound:
		return http.StatusNotFound, ErrorResponse{
			Code:    "USER_NOT_FOUND",
			Message: "User not found",
		}
	case user.ErrUserAlreadyExists:
		return http.StatusConflict, ErrorResponse{
			Code:    "USER_EXISTS",
			Message: "A user with this email already exists",
		}
	case user.ErrPasswordMismatch:
		return http.StatusUnauthorized, ErrorResponse{
			Code:    "INVALID_CREDENTIALS",
			Message: "Email or password is incorrect",
		}
	case user.ErrMFARequired:
		return http.StatusForbidden, ErrorResponse{
			Code:    "MFA_REQUIRED",
			Message: "Multi-factor authentication is required",
		}
	case user.ErrUserNotActive:
		return http.StatusForbidden, ErrorResponse{
			Code:    "ACCOUNT_INACTIVE",
			Message: "This account is not active",
		}
	case user.ErrAccountLocked:
		return http.StatusForbidden, ErrorResponse{
			Code:    "ACCOUNT_LOCKED",
			Message: "Account is temporarily locked due to too many failed login attempts",
		}
	default:
		return http.StatusInternalServerError, ErrorResponse{
			Code:    "INTERNAL_ERROR",
			Message: "An internal error occurred",
		}
	}
}

// WriteJSON writes a JSON response.
func WriteJSON(w http.ResponseWriter, status int, data interface{}) {
	w.Header().Set("Content-Type", "application/json")
	w.WriteHeader(status)
	json.NewEncoder(w).Encode(data)
}

// ReadJSON reads and validates a JSON request body.
func ReadJSON(r *http.Request, data interface{}) error {
	defer r.Body.Close()
	return json.NewDecoder(r.Body).Decode(data)
}
