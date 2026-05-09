package notifications

import (
	"time"
)

// NotificationDispatch represents a notification to be sent.
type NotificationDispatch struct {
	DispatchID       string    `json:"dispatch_id"`
	UserID           string    `json:"user_id"`
	NotificationType string    `json:"notification_type"` // "MATCH", "MESSAGE", "PULSE"
	Title            string    `json:"title"`
	Body             string    `json:"body"`
	DeepLink         string    `json:"deep_link,omitempty"`
	Channels         []string  `json:"channels"` // "PUSH", "EMAIL", "SMS"
	CreatedAt        time.Time `json:"created_at"`
	ScheduledFor     *time.Time `json:"scheduled_for,omitempty"`
	SentAt           *time.Time `json:"sent_at,omitempty"`
	Status           string    `json:"status"` // "PENDING", "SENT", "FAILED"
}

// PulseNotification represents a notification about user pulses.
type PulseNotification struct {
	NotificationID   string    `json:"notification_id"`
	DispatchID       string    `json:"dispatch_id"`
	PulseID          string    `json:"pulse_id"`
	TriggerThreshold float64   `json:"trigger_threshold"` // engagement score threshold
	IsTriggered      bool      `json:"is_triggered"`
}

// APNSNotification represents Apple Push Notification Service details.
type APNSNotification struct {
	NotificationID   string    `json:"notification_id"`
	DeviceToken      string    `json:"device_token"`
	Alert            string    `json:"alert"`
	Badge            int       `json:"badge"`
	Sound            string    `json:"sound"`
	Category         string    `json:"category"`
	MutableContent   bool      `json:"mutable_content"`
	CustomPayload    map[string]interface{} `json:"custom_payload,omitempty"`
	SentAt           *time.Time `json:"sent_at,omitempty"`
	Status           string    `json:"status"`
}

// FCMNotification represents Firebase Cloud Messaging details.
type FCMNotification struct {
	NotificationID   string    `json:"notification_id"`
	DeviceToken      string    `json:"device_token"`
	Title            string    `json:"title"`
	Body             string    `json:"body"`
	Data             map[string]string `json:"data,omitempty"`
	Priority         string    `json:"priority"` // "high", "normal"
	TimeToLiveSeconds int      `json:"time_to_live_seconds"`
	SentAt           *time.Time `json:"sent_at,omitempty"`
	Status           string    `json:"status"`
}

// EmailNotification represents email notification details.
type EmailNotification struct {
	NotificationID   string    `json:"notification_id"`
	RecipientEmail   string    `json:"recipient_email"`
	Subject          string    `json:"subject"`
	BodyHTML         string    `json:"body_html"`
	BodyText         string    `json:"body_text,omitempty"`
	TemplateID       string    `json:"template_id,omitempty"`
	SentAt           *time.Time `json:"sent_at,omitempty"`
	Status           string    `json:"status"`
	OpenedAt         *time.Time `json:"opened_at,omitempty"`
}

// NotificationPreference represents user notification preferences.
type NotificationPreference struct {
	PreferenceID     string    `json:"preference_id"`
	UserID           string    `json:"user_id"`
	NotificationType string    `json:"notification_type"`
	Enabled          bool      `json:"enabled"`
	Channels         []string  `json:"channels"` // push, email, sms
	QuietHours       *QuietHours `json:"quiet_hours,omitempty"`
	FrequencyLimit   string    `json:"frequency_limit"` // "INSTANT", "DAILY_DIGEST", "WEEKLY"
	UpdatedAt        time.Time `json:"updated_at"`
}

// QuietHours represents quiet hours for notifications.
type QuietHours struct {
	StartHour        int    `json:"start_hour"` // 0-23
	EndHour          int    `json:"end_hour"`
	DaysOfWeek       []int  `json:"days_of_week"` // 0=Sunday, 6=Saturday
	TimeZone         string `json:"time_zone"`
	IsEnabled        bool   `json:"is_enabled"`
}

// NotificationSuppressionRule represents a rule to suppress notifications.
type NotificationSuppressionRule struct {
	RuleID           string    `json:"rule_id"`
	UserID           string    `json:"user_id"`
	NotificationType string    `json:"notification_type,omitempty"` // null = all types
	Condition        string    `json:"condition"` // "AT_LOCATION", "ON_CALL", "LOW_BATTERY"
	ConditionValue   string    `json:"condition_value,omitempty"`
	IsActive         bool      `json:"is_active"`
	ExpiresAt        *time.Time `json:"expires_at,omitempty"`
	CreatedAt        time.Time `json:"created_at"`
}
