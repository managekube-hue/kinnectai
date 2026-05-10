package user

import (
	"fmt"
	"net/mail"
	"regexp"
)

// Email is a value object for email addresses.
// Immutable once created; enforces invariants.
type Email struct {
	value string
}

// NewEmail creates a validated email value object.
func NewEmail(e string) (Email, error) {
	if err := ValidateEmail(e); err != nil {
		return Email{}, err
	}
	return Email{value: e}, nil
}

// String returns the email as string.
func (e Email) String() string {
	return e.value
}

// PhoneNumber is a value object for phone numbers.
type PhoneNumber struct {
	value string
}

// NewPhoneNumber creates a validated phone number value object.
func NewPhoneNumber(p string) (PhoneNumber, error) {
	if err := ValidatePhoneNumber(p); err != nil {
		return PhoneNumber{}, err
	}
	return PhoneNumber{value: p}, nil
}

// String returns the phone number as string.
func (p PhoneNumber) String() string {
	return p.value
}

// PasswordHash is a value object for hashed passwords.
// Never exposes the hash directly; immutable.
type PasswordHash struct {
	value string
}

// NewPasswordHash creates a password hash value object.
func NewPasswordHash(hash string) (PasswordHash, error) {
	if err := ValidatePasswordHash(hash); err != nil {
		return PasswordHash{}, err
	}
	return PasswordHash{value: hash}, nil
}

// Match checks if a plaintext password matches this hash.
// Implementation depends on your hashing strategy (bcrypt, argon2, etc).
func (ph PasswordHash) Match(plaintext string) bool {
	// TODO: Implement actual hash comparison
	return false
}

// UserID is a value object for user identifiers.
type UserID struct {
	value string
}

// NewUserID creates a validated user ID value object.
func NewUserID(id string) (UserID, error) {
	if err := ValidateUserID(id); err != nil {
		return UserID{}, err
	}
	return UserID{value: id}, nil
}

// String returns the user ID as string.
func (uid UserID) String() string {
	return uid.value
}

// Equals checks if two UserIDs are identical.
func (uid UserID) Equals(other UserID) bool {
	return uid.value == other.value
}
