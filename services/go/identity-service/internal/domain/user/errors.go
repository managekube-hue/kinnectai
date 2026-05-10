package user

import "fmt"

// Domain errors for user aggregate.
var (
	ErrInvalidEmail                      = fmt.Errorf("invalid email address")
	ErrInvalidPhoneNumber                = fmt.Errorf("invalid phone number")
	ErrInvalidPasswordHash               = fmt.Errorf("invalid password hash")
	ErrInvalidUserID                     = fmt.Errorf("invalid user ID")
	ErrUserNotFound                      = fmt.Errorf("user not found")
	ErrUserAlreadyExists                 = fmt.Errorf("user already exists")
	ErrCannotActivateNonPendingUser      = fmt.Errorf("cannot activate non-pending user")
	ErrCannotSuspendDeactivatedUser      = fmt.Errorf("cannot suspend deactivated user")
	ErrCannotEnableMFAOnInactiveUser     = fmt.Errorf("cannot enable MFA on inactive user")
	ErrPasswordMismatch                  = fmt.Errorf("password does not match")
	ErrUserNotActive                     = fmt.Errorf("user account is not active")
	ErrMFARequired                       = fmt.Errorf("multi-factor authentication required")
	ErrInvalidMFAToken                   = fmt.Errorf("invalid MFA token")
	ErrAuthenticationFailed              = fmt.Errorf("authentication failed")
	ErrAccountLocked                     = fmt.Errorf("account temporarily locked")
	ErrAccountCompromised                = fmt.Errorf("account compromised")
	ErrConcurrentModificationConflict    = fmt.Errorf("concurrent modification conflict")
)
