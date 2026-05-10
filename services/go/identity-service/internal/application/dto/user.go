package dto

// UserDTO is the data transfer object for API responses
type UserDTO struct {
	ID          string `json:"id"`
	Email       string `json:"email"`
	Status      string `json:"status"`
	MFAEnabled  bool   `json:"mfa_enabled"`
	CreatedAt   string `json:"created_at"`
	LastLoginAt *string `json:"last_login_at,omitempty"`
}

// RegisterRequestDTO is the API request for registration
type RegisterRequestDTO struct {
	Email    string `json:"email" binding:"required,email"`
	Password string `json:"password" binding:"required,min=8"`
}

// RegisterResponseDTO is the API response after registration
type RegisterResponseDTO struct {
	User    UserDTO `json:"user"`
	Token   string  `json:"token"`
	Message string  `json:"message"`
}

// LoginRequestDTO is the API request for login
type LoginRequestDTO struct {
	Email    string `json:"email" binding:"required"`
	Password string `json:"password" binding:"required"`
}

// LoginResponseDTO is the API response after login
type LoginResponseDTO struct {
	User    UserDTO `json:"user"`
	Token   string  `json:"token"`
	Message string  `json:"message"`
}
