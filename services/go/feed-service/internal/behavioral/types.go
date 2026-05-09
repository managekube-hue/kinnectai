package behavioral

import (
	"time"
)

// BehavioralEvent represents a user behavioral event.
type BehavioralEvent struct {
	EventID          string    `json:"event_id"`
	UserID           string    `json:"user_id"`
	EventType        string    `json:"event_type"` // "CLICK", "VIEW", "SHARE", "MESSAGE"
	Screen           string    `json:"screen"`
	Timestamp        time.Time `json:"timestamp"`
	DurationMS       int       `json:"duration_ms,omitempty"`
	Metadata         map[string]interface{} `json:"metadata,omitempty"`
	SessionID        string    `json:"session_id"`
}

// Pulse represents a user pulse/heartbeat signal.
type Pulse struct {
	PulseID          string    `json:"pulse_id"`
	UserID           string    `json:"user_id"`
	EventCount       int       `json:"event_count"` // events in this pulse window
	InteractionCount int       `json:"interaction_count"`
	EngagementScore  float64   `json:"engagement_score"` // 0-1
	MoodEstimate     string    `json:"mood_estimate,omitempty"` // "POSITIVE", "NEUTRAL", "NEGATIVE"
	SessionDurationMin int     `json:"session_duration_min"`
	IsActive         bool      `json:"is_active"`
	Timestamp        time.Time `json:"timestamp"`
	Window           string    `json:"window"` // "5m", "1h", "1d"
}

// BehavioralAggregate represents aggregated behavioral metrics.
type BehavioralAggregate struct {
	AggregateID      string    `json:"aggregate_id"`
	UserID           string    `json:"user_id"`
	Period           string    `json:"period"` // "DAILY", "WEEKLY", "MONTHLY"
	TotalEvents      int       `json:"total_events"`
	UniqueScreens    int       `json:"unique_screens"`
	AverageDwellTime int       `json:"average_dwell_time_sec"`
	ReturnVisits     int       `json:"return_visits"`
	AggregatedAt     time.Time `json:"aggregated_at"`
}

// InteractionEvent represents user-to-user interaction.
type InteractionEvent struct {
	EventID          string    `json:"event_id"`
	InitiatorID      string    `json:"initiator_id"`
	TargetID         string    `json:"target_id"`
	InteractionType  string    `json:"interaction_type"` // "LIKE", "MESSAGE", "SHARE", "PROFILE_VIEW"
	Timestamp        time.Time `json:"timestamp"`
	IsReciprocal     bool      `json:"is_reciprocal"`
}

// SentimentResult represents sentiment analysis of user content.
type SentimentResult struct {
	ResultID         string    `json:"result_id"`
	UserID           string    `json:"user_id"`
	ContentID        string    `json:"content_id"`
	Sentiment        string    `json:"sentiment"` // "POSITIVE", "NEUTRAL", "NEGATIVE"
	Score            float64   `json:"score"` // -1 to +1
	Confidence       float64   `json:"confidence"` // 0-1
	Entities         []string  `json:"entities,omitempty"` // mentioned topics
	AnalyzedAt       time.Time `json:"analyzed_at"`
}

// BehavioralDrift represents significant behavioral pattern changes.
type BehavioralDrift struct {
	DriftID          string    `json:"drift_id"`
	UserID           string    `json:"user_id"`
	MetricName       string    `json:"metric_name"`
	PreviousValue    float64   `json:"previous_value"`
	CurrentValue     float64   `json:"current_value"`
	PercentChange    float64   `json:"percent_change"`
	Significance     string    `json:"significance"` // "LOW", "MEDIUM", "HIGH"
	DetectedAt       time.Time `json:"detected_at"`
	Reason           string    `json:"reason,omitempty"`
}

// DiscoveryInfluenceMetric represents how discovery matches influence user behavior.
type DiscoveryInfluenceMetric struct {
	MetricID         string    `json:"metric_id"`
	UserID           string    `json:"user_id"`
	DiscoveryMatchID string    `json:"discovery_match_id"`
	InfluenceType    string    `json:"influence_type"` // "POSITIVE", "NEGATIVE", "NEUTRAL"
	InfluenceScore   float64   `json:"influence_score"` // 0-1
	BehaviorChanges  []string  `json:"behavior_changes,omitempty"`
	MeasuredAt       time.Time `json:"measured_at"`
}
