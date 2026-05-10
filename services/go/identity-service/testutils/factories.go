package testutils

import (
	"identityservice/internal/domain/user"
	"time"
)

// UserFactory builds user objects for testing with sensible defaults.
type UserFactory struct {
	id           string
	email        string
	phoneNumber  string
	passwordHash string
	status       user.Status
	mfaEnabled   bool
}

// NewUserFactory creates a factory with defaults.
func NewUserFactory() *UserFactory {
	return &UserFactory{
		id:           "test_user_123",
		email:        "test@example.com",
		phoneNumber:  "+1234567890",
		passwordHash: "$2a$12$N9qo8uLOickgx2ZMRZoMyeIjZAgcg7b3XeKeQaJ7P18nJ6o.Gvaq2", // bcrypt
		status:       user.StatusActive,
		mfAEnabled:   false,
	}
}

// WithEmail sets the email.
func (f *UserFactory) WithEmail(email string) *UserFactory {
	f.email = email
	return f
}

// WithStatus sets the status.
func (f *UserFactory) WithStatus(status user.Status) *UserFactory {
	f.status = status
	return f
}

// WithMFAEnabled enables MFA.
func (f *UserFactory) WithMFAEnabled(enabled bool) *UserFactory {
	f.mfaEnabled = enabled
	return f
}

// Build creates the user.
func (f *UserFactory) Build() *user.User {
	return &user.User{
		ID:           f.id,
		Email:        f.email,
		PhoneNumber:  f.phoneNumber,
		PasswordHash: f.passwordHash,
		Status:       f.status,
		MFAEnabled:   f.mfaEnabled,
		MFAType:      user.MFATypeNone,
		CreatedAt:    time.Now(),
		UpdatedAt:    time.Now(),
	}
}

// MockRepository is a test double for user.Repository.
type MockRepository struct {
	SaveFunc     func(user *user.User) error
	FindByIDFunc func(id string) (*user.User, error)
	FindByEmailFunc func(email string) (*user.User, error)
	ExistsFunc   func(email string) (bool, error)
}

func (m *MockRepository) Save(user *user.User) error {
	if m.SaveFunc != nil {
		return m.SaveFunc(user)
	}
	return nil
}

func (m *MockRepository) FindByID(id string) (*user.User, error) {
	if m.FindByIDFunc != nil {
		return m.FindByIDFunc(id)
	}
	return nil, user.ErrUserNotFound
}

func (m *MockRepository) FindByEmail(email string) (*user.User, error) {
	if m.FindByEmailFunc != nil {
		return m.FindByEmailFunc(email)
	}
	return nil, user.ErrUserNotFound
}

func (m *MockRepository) Exists(email string) (bool, error) {
	if m.ExistsFunc != nil {
		return m.ExistsFunc(email)
	}
	return false, nil
}

// Contract tests ensure all implementations follow the same behavior.
// Located in testutils/contracts/
