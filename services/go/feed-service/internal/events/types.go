package events

import (
	"time"
)

// BehavioralEventKafka represents a behavioral event for Kafka streaming.
type BehavioralEventKafka struct {
	EventID       string                 `json:"event_id"`
	UserID        string                 `json:"user_id"`
	EventType     string                 `json:"event_type"`
	Properties    map[string]interface{} `json:"properties"`
	Timestamp     time.Time              `json:"timestamp"`
	Partition     int                    `json:"partition"`
	Offset        int64                  `json:"offset"`
}

// CRRecomputeEvent represents an event to recompute connectivity ranking.
type CRRecomputeEvent struct {
	EventID       string    `json:"event_id"`
	UserID        string    `json:"user_id"`
	Reason        string    `json:"reason"` // "NEW_MATCH", "USER_FEEDBACK", "PERIODIC"
	Priority      string    `json:"priority"` // "HIGH", "NORMAL", "LOW"
	CreatedAt     time.Time `json:"created_at"`
	ProcessedAt   *time.Time `json:"processed_at,omitempty"`
}

// BloomJobEvent represents an event for Bloom job progress.
type BloomJobEvent struct {
	EventID       string    `json:"event_id"`
	JobID         string    `json:"job_id"`
	UserID        string    `json:"user_id"`
	Status        string    `json:"status"` // "STARTED", "PROGRESS", "COMPLETED", "FAILED"
	ProgressPct   int       `json:"progress_pct"`
	CreatedAt     time.Time `json:"created_at"`
}

// VaultTriggerEvent represents an event for vault trigger activation.
type VaultTriggerEvent struct {
	EventID       string    `json:"event_id"`
	TriggerID     string    `json:"trigger_id"`
	UserID        string    `json:"user_id"`
	ActivationType string   `json:"activation_type"` // "MANUAL", "AUTOMATIC", "VERIFIED"
	CreatedAt     time.Time `json:"created_at"`
}

// DiscoveryMatchEvent represents an event for new discovery matches.
type DiscoveryMatchEvent struct {
	EventID       string    `json:"event_id"`
	MatchID       string    `json:"match_id"`
	UserID        string    `json:"user_id"`
	CandidateID   string    `json:"candidate_id"`
	MatchScore    float64   `json:"match_score"`
	CreatedAt     time.Time `json:"created_at"`
}

// RoomsSignalingEvent represents WebRTC signaling events.
type RoomsSignalingEvent struct {
	EventID       string    `json:"event_id"`
	RoomID        string    `json:"room_id"`
	UserID        string    `json:"user_id"`
	SignalType    string    `json:"signal_type"` // "OFFER", "ANSWER", "ICE_CANDIDATE"
	SignalData    string    `json:"signal_data"`
	CreatedAt     time.Time `json:"created_at"`
}

// MediaTranscodeEvent represents media transcoding progress events.
type MediaTranscodeEvent struct {
	EventID       string    `json:"event_id"`
	JobID         string    `json:"job_id"`
	MediaID       string    `json:"media_id"`
	UserID        string    `json:"user_id"`
	Status        string    `json:"status"` // "STARTED", "TRANSCODING", "COMPLETED", "FAILED"
	ProgressPct   int       `json:"progress_pct"`
	OutputFormat  string    `json:"output_format,omitempty"`
	CreatedAt     time.Time `json:"created_at"`
}

// NotificationDispatchEvent represents notification dispatch events.
type NotificationDispatchEvent struct {
	EventID       string    `json:"event_id"`
	DispatchID    string    `json:"dispatch_id"`
	UserID        string    `json:"user_id"`
	NotificationType string  `json:"notification_type"`
	Channels      []string  `json:"channels"`
	Status        string    `json:"status"` // "QUEUED", "SENT", "FAILED"
	CreatedAt     time.Time `json:"created_at"`
}

// UserEvent represents generic user lifecycle events.
type UserEvent struct {
	EventID       string    `json:"event_id"`
	UserID        string    `json:"user_id"`
	EventType     string    `json:"event_type"` // "SIGNUP", "LOGIN", "PROFILE_COMPLETE"
	Metadata      map[string]interface{} `json:"metadata,omitempty"`
	CreatedAt     time.Time `json:"created_at"`
}

// ModerationQueueEvent represents moderation queue events.
type ModerationQueueEvent struct {
	EventID       string    `json:"event_id"`
	QueueItemID   string    `json:"queue_item_id"`
	ContentID     string    `json:"content_id"`
	Action        string    `json:"action"` // "FLAGGED", "REVIEWED", "ACTIONED"
	Status        string    `json:"status"`
	CreatedAt     time.Time `json:"created_at"`
}

// ReplayAuditEvent represents event replay for audit purposes.
type ReplayAuditEvent struct {
	EventID       string    `json:"event_id"`
	OriginalEventID string  `json:"original_event_id"`
	ReplayReason  string    `json:"replay_reason"`
	ReplayedData  map[string]interface{} `json:"replayed_data"`
	CreatedAt     time.Time `json:"created_at"`
}

// ConsentRevocationEvent represents consent revocation events.
type ConsentRevocationEvent struct {
	EventID       string    `json:"event_id"`
	UserID        string    `json:"user_id"`
	ConsentType   string    `json:"consent_type"`
	RevokedAt     time.Time `json:"revoked_at"`
	Reason        string    `json:"reason,omitempty"`
}
