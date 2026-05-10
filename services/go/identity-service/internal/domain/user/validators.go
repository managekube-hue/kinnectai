package user

import (
	"net/mail"
	"regexp"
)

// ValidateEmail validates email format and domain.
func ValidateEmail(email string) error {
	_, err := mail.ParseAddress(email)
	if err != nil {
		return ErrInvalidEmail
	}
	// Additional domain checks can be added here
	return nil
}

// ValidatePhoneNumber validates phone format.
func ValidatePhoneNumber(phone string) error {
	if phone == "" {
		return nil // Optional field
	}
	// E.164 format or similar
	phoneRegex := regexp.MustCompile(`^\+?[1-9]\d{1,14}$`)
	if !phoneRegex.MatchString(phone) {
		return ErrInvalidPhoneNumber
	}
	return nil
}

// ValidatePasswordHash validates that hash is non-empty and reasonable.
func ValidatePasswordHash(hash string) error {
	if len(hash) < 20 { // Bcrypt, Argon2, etc produce long hashes
		return ErrInvalidPasswordHash
	}
	return nil
}

// ValidateUserID validates user ID format.
func ValidateUserID(id string) error {
	if len(id) == 0 || len(id) > 128 {
		return ErrInvalidUserID
	}
	// Add UUID or other format validation
	return nil
}
