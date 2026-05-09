// SRS §23.1 Category 10 — Rooms / WebRTC types
package room

import (
	"time"

	"github.com/google/uuid"
)

// RoomCreateRequest is the client payload to create a new room.
type RoomCreateRequest struct {
	HostUserID    uuid.UUID `json:"host_user_id" binding:"required"`
	RoomName      string    `json:"room_name,omitempty"`
	MaxParticipants int     `json:"max_participants,omitempty"`
	RecordingEnabled bool   `json:"recording_enabled"`
}

// RoomTokenResponse is returned when a participant requests a room access token.
type RoomTokenResponse struct {
	RoomID     string                          `json:"room_id"`
	Token      string                          `json:"token"`
	HLSUrl     string                          `json:"hls_url,omitempty"`
	ICEServers []RoomTokenResponseIceServersInner `json:"ice_servers"`
	ExpiresAt  int64                           `json:"expires_at"`
}

// RoomTokenResponseIceServersInner is a single ICE server configuration entry.
type RoomTokenResponseIceServersInner struct {
	URLs       []string `json:"urls"`
	Username   string   `json:"username,omitempty"`
	Credential string   `json:"credential,omitempty"`
}

// Room is the full room entity.
type Room struct {
	RoomID          string     `json:"room_id"`
	HostUserID      uuid.UUID  `json:"host_user_id"`
	RoomName        string     `json:"room_name"`
	Status          string     `json:"status"` // pending | active | ended
	MaxParticipants int        `json:"max_participants"`
	RecordingEnabled bool      `json:"recording_enabled"`
	CreatedAt       time.Time  `json:"created_at"`
	EndedAt         *time.Time `json:"ended_at,omitempty"`
}

// RoomParticipant is a user actively or historically in a room.
type RoomParticipant struct {
	ParticipantID uuid.UUID  `json:"participant_id"`
	RoomID        string     `json:"room_id"`
	UserID        uuid.UUID  `json:"user_id"`
	DisplayName   string     `json:"display_name"`
	Role          string     `json:"role"` // host | attendee | observer
	JoinedAt      time.Time  `json:"joined_at"`
	LeftAt        *time.Time `json:"left_at,omitempty"`
}

// ICEConfiguration is the full ICE / STUN / TURN server configuration.
type ICEConfiguration struct {
	ICEServers    []ICECandidate `json:"ice_servers"`
	ICETransportPolicy string   `json:"ice_transport_policy"` // all | relay
}

// ICECandidate is a single ICE candidate.
type ICECandidate struct {
	Candidate     string `json:"candidate"`
	SDPMLineIndex int    `json:"sdp_m_line_index"`
	SDPMid        string `json:"sdp_mid"`
}

// SDPAnswer is the WebRTC SDP answer payload.
type SDPAnswer struct {
	Type string `json:"type"` // answer
	SDP  string `json:"sdp"`
}

// SDPOffer is the WebRTC SDP offer payload.
type SDPOffer struct {
	Type string `json:"type"` // offer
	SDP  string `json:"sdp"`
}

// HLSRecoveryState tracks HLS playback recovery status for a recording.
type HLSRecoveryState struct {
	RoomID          string     `json:"room_id"`
	RecordingID     uuid.UUID  `json:"recording_id"`
	LastSegmentURL  string     `json:"last_segment_url"`
	PlayheadSeconds int        `json:"playhead_seconds"`
	IsRecoverable   bool       `json:"is_recoverable"`
	UpdatedAt       time.Time  `json:"updated_at"`
}

// SFUNode is a selective forwarding unit worker in the media cluster.
type SFUNode struct {
	NodeID      string  `json:"node_id"`
	Region      string  `json:"region"`
	Load        float64 `json:"load"`        // 0.0–1.0
	ActiveRooms int     `json:"active_rooms"`
	Healthy     bool    `json:"healthy"`
}

// TURNCredential is a time-limited TURN server credential.
type TURNCredential struct {
	Username   string    `json:"username"`
	Credential string    `json:"credential"`
	TTL        int       `json:"ttl_seconds"`
	IssuedAt   time.Time `json:"issued_at"`
}

// RoomRecording tracks a recording of a room session.
type RoomRecording struct {
	RecordingID uuid.UUID  `json:"recording_id"`
	RoomID      string     `json:"room_id"`
	StorageURL  string     `json:"storage_url,omitempty"`
	DurationSec int        `json:"duration_seconds"`
	Status      string     `json:"status"` // recording | processing | ready | failed
	StartedAt   time.Time  `json:"started_at"`
	ReadyAt     *time.Time `json:"ready_at,omitempty"`
}

// ParticipantBandwidthState holds real-time bandwidth metrics for a participant.
type ParticipantBandwidthState struct {
	ParticipantID   uuid.UUID `json:"participant_id"`
	RoomID          string    `json:"room_id"`
	UploadKbps      int       `json:"upload_kbps"`
	DownloadKbps    int       `json:"download_kbps"`
	PacketLossPct   float64   `json:"packet_loss_pct"`
	JitterMs        int       `json:"jitter_ms"`
	MeasuredAt      time.Time `json:"measured_at"`
}
