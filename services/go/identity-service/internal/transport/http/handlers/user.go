package handlers

import (
	"fmt"
	"net/http"
	"time"

	"github.com/gin-gonic/gin"
	"github.com/managekube-hue/kinnectai/services/go/identity-service/internal/application/dto"
	"github.com/managekube-hue/kinnectai/services/go/identity-service/internal/domain/user"
	"github.com/managekube-hue/kinnectai/services/go/identity-service/internal/infrastructure/postgres"
)

// RegisterHandler handles user registration
func RegisterHandler(db *postgres.Repository) gin.HandlerFunc {
	return func(c *gin.Context) {
		var req dto.RegisterRequestDTO

		if err := c.ShouldBindJSON(&req); err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
			return
		}

		usr, err := user.NewUser(req.Email, "", req.Password)
		if err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
			return
		}

		usr.ID = fmt.Sprintf("user_%d", time.Now().UnixNano())
		if err := usr.Activate(); err != nil {
			c.JSON(http.StatusConflict, gin.H{"error": err.Error()})
			return
		}

		if err := db.Create(c.Request.Context(), usr); err != nil {
			c.JSON(http.StatusConflict, gin.H{"error": err.Error()})
			return
		}

		// Convert to DTO
		userDTO := dto.UserDTO{
			ID:         usr.ID,
			Email:      usr.Email,
			Status:     string(usr.Status),
			MFAEnabled: usr.MFAEnabled,
			CreatedAt:  usr.CreatedAt.Format("2006-01-02T15:04:05Z"),
		}

		c.JSON(http.StatusCreated, dto.RegisterResponseDTO{
			User:    userDTO,
			Token:   fmt.Sprintf("token.%s.%d", usr.ID, time.Now().Unix()),
			Message: "User registered successfully",
		})
	}
}

// LoginHandler handles user login
func LoginHandler(db *postgres.Repository) gin.HandlerFunc {
	return func(c *gin.Context) {
		var req dto.LoginRequestDTO

		if err := c.ShouldBindJSON(&req); err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
			return
		}

		usr, err := db.GetByEmail(c.Request.Context(), req.Email)
		if err != nil {
			c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
			return
		}
		if usr == nil {
			c.JSON(http.StatusUnauthorized, gin.H{"error": "invalid credentials"})
			return
		}
		if usr.PasswordHash != req.Password {
			c.JSON(http.StatusUnauthorized, gin.H{"error": "invalid credentials"})
			return
		}

		usr.RecordLogin()
		_ = db.Update(c.Request.Context(), usr)

		lastLoginAt := ""
		if usr.LastLoginAt != nil {
			lastLoginAt = usr.LastLoginAt.Format("2006-01-02T15:04:05Z")
		}
		var lastLoginPtr *string
		if lastLoginAt != "" {
			lastLoginPtr = &lastLoginAt
		}

		c.JSON(http.StatusOK, dto.LoginResponseDTO{
			User: dto.UserDTO{
				ID:          usr.ID,
				Email:       usr.Email,
				Status:      string(usr.Status),
				MFAEnabled:  usr.MFAEnabled,
				CreatedAt:   usr.CreatedAt.Format("2006-01-02T15:04:05Z"),
				LastLoginAt: lastLoginPtr,
			},
			Token:   fmt.Sprintf("token.%s.%d", usr.ID, time.Now().Unix()),
			Message: "Login successful",
		})
	}
}

// GetProfileHandler retrieves user profile
func GetProfileHandler(db *postgres.Repository) gin.HandlerFunc {
	return func(c *gin.Context) {
		userID := c.Param("user_id")
		if userID == "" {
			userID = c.GetHeader("X-User-ID")
		}
		if userID == "" {
			c.JSON(http.StatusBadRequest, gin.H{"error": "user_id is required"})
			return
		}

		usr, err := db.GetByID(c.Request.Context(), userID)
		if err != nil {
			c.JSON(http.StatusNotFound, gin.H{"error": "User not found"})
			return
		}

		userDTO := dto.UserDTO{
			ID:         usr.ID,
			Email:      usr.Email,
			Status:     string(usr.Status),
			MFAEnabled: usr.MFAEnabled,
			CreatedAt:  usr.CreatedAt.Format("2006-01-02T15:04:05Z"),
		}

		c.JSON(http.StatusOK, userDTO)
	}
}
