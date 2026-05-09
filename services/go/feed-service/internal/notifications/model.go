// SRS §23.1 Category 15 — Notifications types
package notifications

import (
	"time"

	"github.com/google/uuid"
)

// NotificationDispatch is the canonical outbound notification payload.
type NotificationDispatch struct {
	DispatchID  uuid.UUID         `json:"dispatch_id"`
	UserID      uuid.UUID         `json:"user_id"`
	Channel     string            `json:"channel"` // push | email | sms | in_app
	TemplateID  string            `json:"template_id"`
	Data        map[string]string `json:"data"`
	Priority    string            `json:"priority"` // low | normal | high | urgent
	ScheduledAt *time.Time        `json:"scheduled_at,omitempty"`
	SentAt      *time.Time        `json:"sent_at,omitempty"`
	Status      string            `json:"status"` // pending | sent | delivered | failed
}

// PulseNotification is a push notification triggered by a pulse/reaction event.
type PulseNotification struct {
	DispatchID  uuid.UUID `json:"dispatch_id"`
	SenderID    uuid.UUID `json:"sender_id"`
	ReceiverID  uuid.UUID `json:"receiver_id"`
	PulseType   string    `json:"pulse_type"`
	TargetID    string    `json:"target_id"`
	TargetType  string    `json:"target_type"`
	Body        string    `json:"body"`
	DeepLinkURL string    `json:"deep_link_url,omitempty"`
}

// APNSNotification is the Apple Push Notification Service payload.
type APNSNotification struct {
	DeviceToken string            `json:"device_token"`
	Alert       APNSAlert         `json:"alert"`
	Badge       int               `json:"badge,omitempty"`
	Sound       string            `json:"sound,omitempty"`
	Data        map[string]string `json:"data,omitempty"`
	Expiry      int64             `json:"expiry,omitempty"`
}

// APNSAlert is the visible notification content for APNS.
type APNSAlert struct {
	Title    string `json:"title"`
	Body     string `json:"body"`
	Subtitle string `json:"subtitle,omitempty"`
}

// FCMNotification is the Firebase Cloud Messaging payload.
type FCMNotification struct {
	Token string           `json:"token"`
	Title string           `json:"title"`
	Body  string           `json:"body"`
	Data  map[string]string `json:"data,omitempty"`
	ImageURL string        `json:"image_url,omitempty"`
}

// EmailNotification is a transactional email payload.
type EmailNotification struct {
	ToAddress    string            `json:"to_address"`
	FromAddress  string            `json:"from_address"`
	Subject      string            `json:"subject"`
	TemplateID   string            `json:"template_id"`
	TemplateData map[string]string `json:"template_data"`
	SentAt       *time.Time        `json:"sent_at,omitempty"`
}

// NotificationPreference stores a user's channel and type preferences.
type NotificationPreference struct {
	UserID          uuid.UUID         `json:"user_id"`
	Channels        map[string]bool   `json:"channels"`         // push | email | sms -> enabled
	TypePreferences map[string]string `json:"type_preferences"` // notification_type -> frequency
	UpdatedAt       time.Time         `json:"updated_at"`
}

// NotificationSuppressionRule defines a condition under which notifications are suppressed.
type NotificationSuppressionRule struct {
	RuleID       uuid.UUID `json:"rule_id"`
	UserID       uuid.UUID `json:"user_id"`
	Channel      string    `json:"channel"`
	Reason       string    `json:"reason"` // dnd | unsubscribed | bounced | rate_limit
	ActiveUntil  *time.Time `json:"active_until,omitempty"`
	CreatedAt    time.Time `json:"created_at"`
}
