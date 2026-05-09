package rooms

import (
	"time"
)

// Room represents a video/audio room for real-time communication.
type Room struct {
	ID               string    `json:"id"`
	HostUserID       string    `json:"host_user_id"`
	Name             string    `json:"name"`
	Description      string    `json:"description,omitempty"`
	Status           string    `json:"status"` // "CREATED", "LIVE", "ENDED"
	RoomType         string    `json:"room_type"` // "PUBLIC", "PRIVATE", "FAMILY"
	MaxParticipants  int       `json:"max_participants"`
	CreatedAt        time.Time `json:"created_at"`
	StartsAt         time.Time `json:"starts_at,omitempty"`
	EndsAt           *time.Time `json:"ends_at,omitempty"`
	IsRecording      bool      `json:"is_recording"`
	RecordingURL     string    `json:"recording_url,omitempty"`
	HLSStreamURL     string    `json:"hls_stream_url,omitempty"`
}

// RoomParticipant represents a participant in a room.
type RoomParticipant struct {
	ParticipantID    string    `json:"participant_id"`
	RoomID           string    `json:"room_id"`
	UserID           string    `json:"user_id"`
	JoinedAt         time.Time `json:"joined_at"`
	LeftAt           *time.Time `json:"left_at,omitempty"`
	IsAudioEnabled   bool      `json:"is_audio_enabled"`
	IsVideoEnabled   bool      `json:"is_video_enabled"`
	IsPresenting     bool      `json:"is_presenting"`
	BandwidthState   ParticipantBandwidthState `json:"bandwidth_state"`
}

// ParticipantBandwidthState represents current bandwidth state for a participant.
type ParticipantBandwidthState struct {
	ParticipantID    string    `json:"participant_id"`
	UpstreamBps      int       `json:"upstream_bps"`
	DownstreamBps    int       `json:"downstream_bps"`
	PacketLoss       float64   `json:"packet_loss"` // 0-1
	RTTMs            int       `json:"rtt_ms"`
	VideoQuality     string    `json:"video_quality"` // "HIGH", "MEDIUM", "LOW"
	LastUpdatedAt    time.Time `json:"last_updated_at"`
}

// ICEConfiguration represents STUN/TURN servers for WebRTC.
type ICEConfiguration struct {
	ConfigID         string    `json:"config_id"`
	STUNServers      []string  `json:"stun_servers"`
	TURNServers      []TURNCredential `json:"turn_servers"`
	ICECandidates    []ICECandidate `json:"ice_candidates,omitempty"`
	CreatedAt        time.Time `json:"created_at"`
}

// ICECandidate represents a single ICE candidate.
type ICECandidate struct {
	CandidateID      string    `json:"candidate_id"`
	Candidate        string    `json:"candidate"` // raw SDP candidate
	SdpMID           string    `json:"sdp_mid"`
	SdpMLineIndex    int       `json:"sdp_m_line_index"`
	UsernameFragment string    `json:"username_fragment,omitempty"`
}

// TURNCredential represents TURN server credentials.
type TURNCredential struct {
	Urls             []string  `json:"urls"`
	Username         string    `json:"username"`
	Credential       string    `json:"credential"`
	CredentialType   string    `json:"credential_type"` // "password", "oauth"
	ExpiresAt        *time.Time `json:"expires_at,omitempty"`
}

// SDPOffer represents a WebRTC SDP offer.
type SDPOffer struct {
	OfferID          string    `json:"offer_id"`
	SDP              string    `json:"sdp"`
	CreatedAt        time.Time `json:"created_at"`
}

// SDPAnswer represents a WebRTC SDP answer.
type SDPAnswer struct {
	AnswerID         string    `json:"answer_id"`
	OfferID          string    `json:"offer_id"`
	SDP              string    `json:"sdp"`
	CreatedAt        time.Time `json:"created_at"`
}

// HLSRecoveryState represents the state of HLS stream recovery.
type HLSRecoveryState struct {
	RoomID           string    `json:"room_id"`
	StreamURL        string    `json:"stream_url"`
	LastSegmentID    int       `json:"last_segment_id"`
	LastSegmentTime  time.Time `json:"last_segment_time"`
	IsRecovering     bool      `json:"is_recovering"`
	RecoveryStartedAt *time.Time `json:"recovery_started_at,omitempty"`
}

// SFUNode represents a Selective Forwarding Unit (SFU) media server node.
type SFUNode struct {
	NodeID           string    `json:"node_id"`
	Region           string    `json:"region"`
	Capacity         int       `json:"capacity"` // max concurrent participants
	CurrentLoad      int       `json:"current_load"`
	HealthStatus     string    `json:"health_status"` // "UP", "DEGRADED", "DOWN"
	CPUUsage         float64   `json:"cpu_usage"`
	MemoryUsage      float64   `json:"memory_usage"`
	LastHealthCheckAt time.Time `json:"last_health_check_at"`
}

// RoomRecording represents a recorded room session.
type RoomRecording struct {
	RecordingID      string    `json:"recording_id"`
	RoomID           string    `json:"room_id"`
	HostUserID       string    `json:"host_user_id"`
	StartedAt        time.Time `json:"started_at"`
	EndedAt          *time.Time `json:"ended_at,omitempty"`
	Status           string    `json:"status"` // "RECORDING", "PROCESSING", "READY", "FAILED"
	VideoURL         string    `json:"video_url,omitempty"`
	AudioURL         string    `json:"audio_url,omitempty"`
	TranscriptURL    string    `json:"transcript_url,omitempty"`
	StorageLocation  string    `json:"storage_location"`
	IsPublic         bool      `json:"is_public"`
	ExpiresAt        *time.Time `json:"expires_at,omitempty"`
}
