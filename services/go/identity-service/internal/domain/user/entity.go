package user

import (
	"time"
)

// User is the aggregate root for user identity.
// All business logic about user lifecycle, state transitions, and invariants lives here.
type User struct {
	ID           string
	Email        string
	PhoneNumber  string
	PasswordHash string
	Status       Status
	MFAEnabled   bool
	MFAType      MFAType
	CreatedAt    time.Time
	UpdatedAt    time.Time
	LastLoginAt  *time.Time
}

// Status represents the lifecycle state of a user account.
type Status string

const (
	StatusPending      Status = "pending"      // Awaiting email verification
	StatusActive       Status = "active"       // Fully onboarded
	StatusSuspended    Status = "suspended"    // Temporarily locked
	StatusDeactivated  Status = "deactivated"  // User requested deletion
	StatusCompromised  Status = "compromised"  // Security incident
)

// MFAType represents the multi-factor authentication method.
type MFAType string

const (
	MFATypeNone MFAType = "none"
	MFATypeTOTP MFAType = "totp"
	MFATypeSMS  MFAType = "sms"
)

// NewUser creates a new user with validation applied.
func NewUser(email string, phoneNumber string, passwordHash string) (*User, error) {
	if err := ValidateEmail(email); err != nil {
		return nil, err
	}

	if err := ValidatePasswordHash(passwordHash); err != nil {
		return nil, err
	}

	return &User{
		Email:        email,
		PhoneNumber:  phoneNumber,
		PasswordHash: passwordHash,
		Status:       StatusPending,
		MFAEnabled:   false,
		MFAType:      MFATypeNone,
		CreatedAt:    time.Now(),
		UpdatedAt:    time.Now(),
	}, nil
}

// Activate transitions user from pending to active.
func (u *User) Activate() error {
	if u.Status != StatusPending {
		return ErrCannotActivateNonPendingUser
	}
	u.Status = StatusActive
	u.UpdatedAt = time.Now()
	return nil
}

// Suspend temporarily locks a user account.
func (u *User) Suspend(reason string) error {
	if u.Status == StatusDeactivated {
		return ErrCannotSuspendDeactivatedUser
	}
	u.Status = StatusSuspended
	u.UpdatedAt = time.Now()
	return nil
}

// Deactivate permanently marks a user as deleted.
func (u *User) Deactivate() error {
	u.Status = StatusDeactivated
	u.UpdatedAt = time.Now()
	return nil
}

// EnableMFA enables multi-factor authentication.
func (u *User) EnableMFA(mfaType MFAType) error {
	if u.Status != StatusActive {
		return ErrCannotEnableMFAOnInactiveUser
	}
	u.MFAEnabled = true
	u.MFAType = mfaType
	u.UpdatedAt = time.Now()
	return nil
}

// DisableMFA disables multi-factor authentication.
func (u *User) DisableMFA() error {
	u.MFAEnabled = false
	u.MFAType = MFATypeNone
	u.UpdatedAt = time.Now()
	return nil
}

// RecordLogin updates last login timestamp.
func (u *User) RecordLogin() {
	now := time.Now()
	u.LastLoginAt = &now
	u.UpdatedAt = now
}

// IsActive checks if user can perform authenticated operations.
func (u *User) IsActive() bool {
	return u.Status == StatusActive
}

// CanAuthenticate checks if user can attempt authentication.
func (u *User) CanAuthenticate() bool {
	return u.Status == StatusActive || u.Status == StatusPending
}
