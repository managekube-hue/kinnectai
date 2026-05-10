package user

import "time"

// DomainEvent is the interface all domain events must implement.
type DomainEvent interface {
	EventType() string
	AggregateID() string
	OccurredAt() time.Time
}

// UserCreated domain event.
type UserCreated struct {
	UserID    string
	Email     string
	CreatedAt time.Time
}

func (e UserCreated) EventType() string   { return "user.created" }
func (e UserCreated) AggregateID() string { return e.UserID }
func (e UserCreated) OccurredAt() time.Time { return e.CreatedAt }

// UserActivated domain event.
type UserActivated struct {
	UserID      string
	ActivatedAt time.Time
}

func (e UserActivated) EventType() string   { return "user.activated" }
func (e UserActivated) AggregateID() string { return e.UserID }
func (e UserActivated) OccurredAt() time.Time { return e.ActivatedAt }

// UserSuspended domain event.
type UserSuspended struct {
	UserID      string
	Reason      string
	SuspendedAt time.Time
}

func (e UserSuspended) EventType() string   { return "user.suspended" }
func (e UserSuspended) AggregateID() string { return e.UserID }
func (e UserSuspended) OccurredAt() time.Time { return e.SuspendedAt }

// UserDeactivated domain event.
type UserDeactivated struct {
	UserID        string
	DeactivatedAt time.Time
}

func (e UserDeactivated) EventType() string   { return "user.deactivated" }
func (e UserDeactivated) AggregateID() string { return e.UserID }
func (e UserDeactivated) OccurredAt() time.Time { return e.DeactivatedAt }

// UserLoggedIn domain event.
type UserLoggedIn struct {
	UserID   string
	LoggedAt time.Time
}

func (e UserLoggedIn) EventType() string   { return "user.logged_in" }
func (e UserLoggedIn) AggregateID() string { return e.UserID }
func (e UserLoggedIn) OccurredAt() time.Time { return e.LoggedAt }

// UserMFAEnabled domain event.
type UserMFAEnabled struct {
	UserID    string
	MFAType   string
	EnabledAt time.Time
}

func (e UserMFAEnabled) EventType() string   { return "user.mfa_enabled" }
func (e UserMFAEnabled) AggregateID() string { return e.UserID }
func (e UserMFAEnabled) OccurredAt() time.Time { return e.EnabledAt }

// UserCompromised domain event (security incident).
type UserCompromised struct {
	UserID        string
	Reason        string
	CompromisedAt time.Time
}

func (e UserCompromised) EventType() string   { return "user.compromised" }
func (e UserCompromised) AggregateID() string { return e.UserID }
func (e UserCompromised) OccurredAt() time.Time { return e.CompromisedAt }
