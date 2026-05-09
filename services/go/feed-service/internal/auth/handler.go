package auth

import (
	"errors"
	"net/http"

	"github.com/gin-gonic/gin"
)

type Handler struct {
	service *Service
}

func NewHandler(service *Service) *Handler {
	return &Handler{service: service}
}

// RegisterRoutes mounts auth endpoints on the given router group.
func (h *Handler) RegisterRoutes(rg *gin.RouterGroup) {
	rg.POST("/register", h.register)
	rg.POST("/login", h.login)
	rg.POST("/oauth/google", h.oauthGoogle)
	rg.POST("/oauth/facebook", h.oauthFacebook)
	rg.POST("/oauth/tiktok", h.oauthTikTok)
	rg.POST("/phone/send-otp", h.sendPhoneOTP)
	rg.POST("/phone/verify-otp", h.verifyPhoneOTP)
}

// register godoc
// POST /api/v1/auth/register
func (h *Handler) register(c *gin.Context) {
	var req RegisterRequest
	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	resp, err := h.service.Register(c.Request.Context(), req)
	if err != nil {
		if errors.Is(err, ErrUserExists) {
			c.JSON(http.StatusConflict, gin.H{"error": "username or email already in use"})
			return
		}
		c.JSON(http.StatusInternalServerError, gin.H{"error": "registration failed"})
		return
	}

	c.JSON(http.StatusCreated, resp)
}

// login godoc
// POST /api/v1/auth/login
func (h *Handler) login(c *gin.Context) {
	var req LoginRequest
	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	resp, err := h.service.Login(c.Request.Context(), req)
	if err != nil {
		if errors.Is(err, ErrInvalidPassword) || errors.Is(err, ErrUserNotFound) {
			// Generic message prevents user enumeration (OWASP)
			c.JSON(http.StatusUnauthorized, gin.H{"error": "invalid email or password"})
			return
		}
		c.JSON(http.StatusInternalServerError, gin.H{"error": "login failed"})
		return
	}

	c.JSON(http.StatusOK, resp)
}

// POST /api/v1/auth/oauth/google
// Accepts Firebase Auth ID token from Google Sign-In on the client.
func (h *Handler) oauthGoogle(c *gin.Context) {
	var req struct {
		IDToken string `json:"id_token" binding:"required"`
	}
	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	resp, err := h.service.OAuthLogin(c.Request.Context(), "google", req.IDToken)
	if err != nil {
		c.JSON(http.StatusUnauthorized, gin.H{"error": "google auth failed"})
		return
	}
	c.JSON(http.StatusOK, resp)
}

// POST /api/v1/auth/oauth/facebook
func (h *Handler) oauthFacebook(c *gin.Context) {
	var req struct {
		AccessToken string `json:"access_token" binding:"required"`
	}
	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	resp, err := h.service.OAuthLogin(c.Request.Context(), "facebook", req.AccessToken)
	if err != nil {
		c.JSON(http.StatusUnauthorized, gin.H{"error": "facebook auth failed"})
		return
	}
	c.JSON(http.StatusOK, resp)
}

// POST /api/v1/auth/oauth/tiktok
func (h *Handler) oauthTikTok(c *gin.Context) {
	var req struct {
		AuthCode string `json:"auth_code" binding:"required"`
	}
	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	resp, err := h.service.OAuthLogin(c.Request.Context(), "tiktok", req.AuthCode)
	if err != nil {
		c.JSON(http.StatusUnauthorized, gin.H{"error": "tiktok auth failed"})
		return
	}
	c.JSON(http.StatusOK, resp)
}

// POST /api/v1/auth/phone/send-otp
func (h *Handler) sendPhoneOTP(c *gin.Context) {
	var req struct {
		Phone string `json:"phone" binding:"required"`
	}
	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	// TODO: Send OTP via Firebase Auth or Twilio
	c.JSON(http.StatusOK, gin.H{"status": "otp_sent", "phone": req.Phone})
}

// POST /api/v1/auth/phone/verify-otp
func (h *Handler) verifyPhoneOTP(c *gin.Context) {
	var req struct {
		Phone string `json:"phone" binding:"required"`
		Code  string `json:"code" binding:"required"`
	}
	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	// TODO: Verify OTP, create or login user
	c.JSON(http.StatusOK, gin.H{"status": "verified", "phone": req.Phone})
}
