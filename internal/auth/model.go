package auth

import (
	"time"

	"github.com/google/uuid"
)

type User struct {
	ID                 uuid.UUID  `json:"id"`
	Username           string     `json:"username"`
	Email              string     `json:"email"`
	DisplayName        string     `json:"display_name"`
	ProfilePictureURL  string     `json:"profile_picture_url"`
	IsVerified         bool       `json:"is_verified"`
	CreatedAt          time.Time  `json:"created_at"`
}

type RegisterRequest struct {
	Username          string `json:"username"         binding:"required,min=3,max=30,alphanum"`
	Email             string `json:"email"            binding:"required,email"`
	Password          string `json:"password"         binding:"required,min=8,max=72"`
	DisplayName       string `json:"display_name"     binding:"required,min=1,max=60"`
	MotherMaidenName  string `json:"mother_maiden_name"`
	BirthYear         int    `json:"birth_year"`
}

type LoginRequest struct {
	Email    string `json:"email"    binding:"required,email"`
	Password string `json:"password" binding:"required"`
}

type AuthResponse struct {
	User            User   `json:"user"`
	AccessToken     string `json:"access_token"`
	GetStreamToken  string `json:"getstream_token"`
	ExpiresAt       int64  `json:"expires_at"`
}

type JWTClaims struct {
	UserID   string `json:"user_id"`
	Username string `json:"username"`
	Email    string `json:"email"`
}
