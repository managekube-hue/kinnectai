package user

import (
	"time"

	"github.com/google/uuid"
)

type Profile struct {
	ID                uuid.UUID `json:"id"`
	Username          string    `json:"username"`
	DisplayName       string    `json:"display_name"`
	Bio               string    `json:"bio"`
	ProfilePictureURL string    `json:"profile_picture_url"`
	IsVerified        bool      `json:"is_verified"`
	KinnectionCount   int       `json:"kinnection_count"`
	CreatedAt         time.Time `json:"created_at"`
}

type UpdateProfileRequest struct {
	DisplayName       string `json:"display_name"        binding:"omitempty,min=1,max=60"`
	Bio               string `json:"bio"                 binding:"omitempty,max=300"`
	ProfilePictureURL string `json:"profile_picture_url" binding:"omitempty,url"`
}

type SurnameMapResult struct {
	Surname       string    `json:"surname"`
	MatchingUsers []Profile `json:"matching_users"`
	UserCount     int       `json:"user_count"`
}
