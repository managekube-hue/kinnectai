// SRS §23.1 Category 18 — Kafka / Events types
package events

import (
	"time"

	"github.com/google/uuid"
)

// BehavioralEventKafka is the Kafka-serialised form of a behavioral event.
type BehavioralEventKafka struct {
	EventID    uuid.UUID         `json:"event_id"`
	UserID     uuid.UUID         `json:"user_id"`
	EventType  string            `json:"event_type"`
	TargetID   string            `json:"target_id"`
	TargetType string            `json:"target_type"`
	SessionID  string            `json:"session_id"`
	Properties map[string]string `json:"properties,omitempty"`
	EmittedAt  time.Time         `json:"emitted_at"`
}

// CRRecomputeEvent triggers a KinScore recompute for a user pair.
type CRRecomputeEvent struct {
	EventID   uuid.UUID `json:"event_id"`
	UserAID   uuid.UUID `json:"user_a_id"`
	UserBID   uuid.UUID `json:"user_b_id"`
	Reason    string    `json:"reason"` // dna_updated | graph_changed | profile_updated
	Priority  string    `json:"priority"` // normal | high
	EmittedAt time.Time `json:"emitted_at"`
}

// BloomJobEvent notifies workers of a new Bloom generation job.
type BloomJobEvent struct {
	EventID   uuid.UUID `json:"event_id"`
	JobID     uuid.UUID `json:"job_id"`
	UserID    uuid.UUID `json:"user_id"`
	MediaType string    `json:"media_type"`
	EmittedAt time.Time `json:"emitted_at"`
}

// VaultTriggerEvent notifies the vault service that a trigger condition was met.
type VaultTriggerEvent struct {
	EventID   uuid.UUID `json:"event_id"`
	TriggerID uuid.UUID `json:"trigger_id"`
	MemoryID  uuid.UUID `json:"memory_id"`
	Reason    string    `json:"reason"`
	EmittedAt time.Time `json:"emitted_at"`
}

// DiscoveryMatchEvent notifies discovery workers of a new high-confidence match.
type DiscoveryMatchEvent struct {
	EventID      uuid.UUID `json:"event_id"`
	UserAID      uuid.UUID `json:"user_a_id"`
	UserBID      uuid.UUID `json:"user_b_id"`
	KinScore     float64   `json:"kin_score"`
	EmittedAt    time.Time `json:"emitted_at"`
}

// RoomsSignalingEvent carries WebRTC signaling messages via Kafka.
type RoomsSignalingEvent struct {
	EventID   uuid.UUID `json:"event_id"`
	RoomID    string    `json:"room_id"`
	FromID    uuid.UUID `json:"from_id"`
	Signal    string    `json:"signal"` // offer | answer | candidate | bye
	Payload   string    `json:"payload"`
	EmittedAt time.Time `json:"emitted_at"`
}

// MediaTranscodeEvent triggers transcoding of a Bloom-generated asset.
type MediaTranscodeEvent struct {
	EventID    uuid.UUID `json:"event_id"`
	AssetURL   string    `json:"asset_url"`
	TargetFormat string  `json:"target_format"` // mp4 | webm | hls
	JobID      uuid.UUID `json:"job_id"`
	EmittedAt  time.Time `json:"emitted_at"`
}

// NotificationDispatchEvent queues a notification for delivery.
type NotificationDispatchEvent struct {
	EventID    uuid.UUID         `json:"event_id"`
	UserID     uuid.UUID         `json:"user_id"`
	Channel    string            `json:"channel"`
	TemplateID string            `json:"template_id"`
	Data       map[string]string `json:"data"`
	EmittedAt  time.Time         `json:"emitted_at"`
}

// UserEvent is a user lifecycle event (created, updated, deleted).
type UserEvent struct {
	EventID   uuid.UUID `json:"event_id"`
	UserID    uuid.UUID `json:"user_id"`
	EventType string    `json:"event_type"` // user.created | user.updated | user.deleted
	Changes   map[string]interface{} `json:"changes,omitempty"`
	EmittedAt time.Time `json:"emitted_at"`
}

// ModerationQueueEvent routes new content to the moderation queue.
type ModerationQueueEvent struct {
	EventID     uuid.UUID `json:"event_id"`
	ContentID   string    `json:"content_id"`
	ContentType string    `json:"content_type"`
	Priority    string    `json:"priority"`
	EmittedAt   time.Time `json:"emitted_at"`
}

// ReplayAuditEvent triggers a historical inference replay for auditability.
type ReplayAuditEvent struct {
	EventID      uuid.UUID `json:"event_id"`
	UserAID      uuid.UUID `json:"user_a_id"`
	UserBID      uuid.UUID `json:"user_b_id"`
	ModelVersion string    `json:"model_version"`
	Reason       string    `json:"reason"`
	EmittedAt    time.Time `json:"emitted_at"`
}

// ConsentRevocationEvent notifies all services when a user revokes consent.
type ConsentRevocationEvent struct {
	EventID    uuid.UUID `json:"event_id"`
	UserID     uuid.UUID `json:"user_id"`
	ConsentKey string    `json:"consent_key"` // dna | biometric | marketing | all
	EmittedAt  time.Time `json:"emitted_at"`
}
