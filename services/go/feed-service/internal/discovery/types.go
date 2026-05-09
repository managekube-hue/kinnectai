package discovery

import (
	"time"
)

// DiscoveryMatch represents a single potential match for discovery.
type DiscoveryMatch struct {
	ID               string    `json:"id"`
	UserID           string    `json:"user_id"`
	CandidateID      string    `json:"candidate_id"`
	MatchScore       float64   `json:"match_score"` // 0-100
	ReasoningScore   float64   `json:"reasoning_score"`
	GeneticDistance  float64   `json:"genetic_distance,omitempty"` // cM
	SharedAncestors  int       `json:"shared_ancestors,omitempty"`
	CreatedAt        time.Time `json:"created_at"`
	ExpiresAt        *time.Time `json:"expires_at,omitempty"`
	IsViewed         bool      `json:"is_viewed"`
	IsLiked          bool      `json:"is_liked"`
	IsDismissed      bool      `json:"is_dismissed"`
	MatchRanking     DiscoveryRanking `json:"match_ranking"`
}

// DiscoveryRanking represents ranking metadata for a discovery match.
type DiscoveryRanking struct {
	Rank         int     `json:"rank"`
	Position     int     `json:"position"`
	Percentile   float64 `json:"percentile"`
	Confidence   float64 `json:"confidence"`
	LastUpdated  time.Time `json:"last_updated"`
}

// DiscoveryModifier represents boosters/suppressors for match generation.
type DiscoveryModifier struct {
	ID              string    `json:"id"`
	DiscoveryMatchID string   `json:"discovery_match_id"`
	ModifierType    string    `json:"modifier_type"` // "BOOST", "SUPPRESS", "FILTER"
	Signal          string    `json:"signal"` // what triggered the modifier
	Strength        float64   `json:"strength"` // 0-1
	ExpiresAt       *time.Time `json:"expires_at,omitempty"`
}

// DiscoveryReason represents the reasoning behind a match.
type DiscoveryReason struct {
	ID              string    `json:"id"`
	DiscoveryMatchID string   `json:"discovery_match_id"`
	ReasonType      string    `json:"reason_type"` // "GENETIC", "GEOGRAPHIC", "BEHAVIORAL"
	Signal          string    `json:"signal"`
	Weight          float64   `json:"weight"`
	Description     string    `json:"description"`
}

// DiscoveryExposureBudget represents exposure limits for privacy.
type DiscoveryExposureBudget struct {
	UserID           string    `json:"user_id"`
	WeeklyBudget     int       `json:"weekly_budget"` // max matches shown per week
	MonthlyBudget    int       `json:"monthly_budget"`
	MatchesShownThisWeek int   `json:"matches_shown_this_week"`
	MatchesShownThisMonth int  `json:"matches_shown_this_month"`
	ResetAtTime      time.Time `json:"reset_at_time"`
}

// DiscoveryFeedbackLoopMetrics tracks user feedback on discovery matches.
type DiscoveryFeedbackLoopMetrics struct {
	UserID              string    `json:"user_id"`
	ViewRate            float64   `json:"view_rate"` // views / matches
	LikeRate            float64   `json:"like_rate"`
	DismissRate         float64   `json:"dismiss_rate"`
	ConversionRate      float64   `json:"conversion_rate"` // likes to messages
	AverageTimeSpent    int       `json:"average_time_spent_sec"`
	ModelRetrainingFlag bool      `json:"model_retraining_flag"`
	LastComputedAt      time.Time `json:"last_computed_at"`
}
