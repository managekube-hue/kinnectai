package handlers

import (
	"net/http"

	"github.com/gin-gonic/gin"
	"github.com/managekube-hue/kinnectai/services/go/identity-service/internal/application/commands"
	"github.com/managekube-hue/kinnectai/services/go/identity-service/internal/application/dto"
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

		// Create command and handler
		cmd := commands.RegisterUserCommand{
			Email:    req.Email,
			Password: req.Password,
		}

		handler := commands.NewRegisterUserHandler(db)
		usr, err := handler.Handle(c.Request.Context(), cmd)
		if err != nil {
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
			Token:   "TODO_JWT_TOKEN",
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

		// TODO: implement full login logic with password verification

		c.JSON(http.StatusOK, gin.H{"message": "Login successful"})
	}
}

// GetProfileHandler retrieves user profile
func GetProfileHandler(db *postgres.Repository) gin.HandlerFunc {
	return func(c *gin.Context) {
		userID := c.Param("user_id")

		// TODO: extract user ID from JWT instead

		repo := postgres.New(db) // This is wrong, refactor needed
		usr, err := repo.GetByID(c.Request.Context(), userID)
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
