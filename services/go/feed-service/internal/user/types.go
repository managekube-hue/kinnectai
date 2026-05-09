package user

import (
	"time"
)

// User represents a KinnectAI platform user.
type User struct {
	ID               string    `json:"id"`
	Email            string    `json:"email"`
	FirstName        string    `json:"first_name"`
	LastName         string    `json:"last_name"`
	PhoneNumber      string    `json:"phone_number,omitempty"`
	ProfileImageURL  string    `json:"profile_image_url,omitempty"`
	DateOfBirth      *time.Time `json:"date_of_birth,omitempty"`
	Gender           string    `json:"gender,omitempty"` // "M", "F", "OTHER", "PREFER_NOT"
	CreatedAt        time.Time `json:"created_at"`
	UpdatedAt        time.Time `json:"updated_at"`
	LastLoginAt      *time.Time `json:"last_login_at,omitempty"`
	Status           string    `json:"status"` // "ACTIVE", "SUSPENDED", "DELETED"
	VerificationSentAt *time.Time `json:"verification_sent_at,omitempty"`
	VerifiedAt       *time.Time `json:"verified_at,omitempty"`
}

// UserProfile represents extended user profile information.
type UserProfile struct {
	UserID           string    `json:"user_id"`
	Bio              string    `json:"bio,omitempty"`
	Interests        []string  `json:"interests,omitempty"`
	Location         string    `json:"location,omitempty"`
	Latitude         float64   `json:"latitude,omitempty"`
	Longitude        float64   `json:"longitude,omitempty"`
	FollowerCount    int       `json:"follower_count"`
	FollowingCount   int       `json:"following_count"`
	KinScore         float64   `json:"kin_score"`
	IsPublic         bool      `json:"is_public"`
	AllowMessaging   bool      `json:"allow_messaging"`
	AllowDiscovery   bool      `json:"allow_discovery"`
	ThumbnailURL     string    `json:"thumbnail_url,omitempty"`
	SocialProof      map[string]interface{} `json:"social_proof,omitempty"`
	UpdatedAt        time.Time `json:"updated_at"`
}

// UserSettings represents user-specific application settings.
type UserSettings struct {
	UserID                  string    `json:"user_id"`
	NotificationsEnabled    bool      `json:"notifications_enabled"`
	EmailNotifications      bool      `json:"email_notifications"`
	PushNotifications       bool      `json:"push_notifications"`
	SMSNotifications        bool      `json:"sms_notifications"`
	Theme                   string    `json:"theme"` // "LIGHT", "DARK", "AUTO"
	Language                string    `json:"language"`
	TimeZone                string    `json:"time_zone"`
	DataSharingEnabled      bool      `json:"data_sharing_enabled"`
	AnalyticsEnabled        bool      `json:"analytics_enabled"`
	PrivacyLevel            string    `json:"privacy_level"` // "PUBLIC", "FRIENDS", "PRIVATE"
	BlockedUsers            []string  `json:"blocked_users"`
	MutedUsers              []string  `json:"muted_users"`
	UpdatedAt               time.Time `json:"updated_at"`
}

// Steward represents a family steward or trusted person.
type Steward struct {
	ID               string    `json:"id"`
	UserID           string    `json:"user_id"` // the user this steward manages
	StewardUserID    string    `json:"steward_user_id"` // the steward
	Status           string    `json:"status"` // "PENDING", "ACCEPTED", "REVOKED"
	Permissions      []string  `json:"permissions"` // "VIEW_VAULT", "MANAGE_MEDIA", "TRANSFER_LEGACY"
	CreatedAt        time.Time `json:"created_at"`
	AcceptedAt       *time.Time `json:"accepted_at,omitempty"`
	RevokedAt        *time.Time `json:"revoked_at,omitempty"`
	RevokeReason     string    `json:"revoke_reason,omitempty"`
}

// UserTrustScore represents a user's trust and reputation score.
type UserTrustScore struct {
	UserID               string    `json:"user_id"`
	OverallScore         float64   `json:"overall_score"` // 0-100
	IdentityConfidence   float64   `json:"identity_confidence"`
	BehaviorScore        float64   `json:"behavior_score"`
	ContentQualityScore  float64   `json:"content_quality_score"`
	EngagementScore      float64   `json:"engagement_score"`
	ComplianceScore      float64   `json:"compliance_score"`
	LastUpdateAt         time.Time `json:"last_update_at"`
	Flags                []string  `json:"flags,omitempty"` // "SUSPICIOUS", "VERIFIED_ID", "HIGH_ENGAGEMENT"
}

// UserPresence represents real-time user presence status.
type UserPresence struct {
	UserID     string    `json:"user_id"`
	Status     string    `json:"status"` // "ONLINE", "IDLE", "OFFLINE", "DND"
	LastSeenAt time.Time `json:"last_seen_at"`
	CurrentScreen string `json:"current_screen,omitempty"`
	DeviceID   string    `json:"device_id,omitempty"`
	OnlineAt   *time.Time `json:"online_at,omitempty"`
}

// UserRegion represents a user's geographic region preferences.
type UserRegion struct {
	UserID           string    `json:"user_id"`
	PrimaryRegion    string    `json:"primary_region"`
	SecondaryRegions []string  `json:"secondary_regions,omitempty"`
	IPAddress        string    `json:"ip_address,omitempty"`
	DataResidency    string    `json:"data_residency"` // "US", "EU", "CA"
	PreferredLanguage string   `json:"preferred_language"`
	Currency         string    `json:"currency"`
}

// UserRelationshipPreference represents user's preferences for discovery and matching.
type UserRelationshipPreference struct {
	UserID                    string    `json:"user_id"`
	RelationshipType          string    `json:"relationship_type"` // "FAMILY", "FRIEND", "GENETIC"
	GeneticMatchingOptIn      bool      `json:"genetic_matching_opt_in"`
	MaxGeneticDistance        float64   `json:"max_genetic_distance"` // cM
	AgeRangeMin               int       `json:"age_range_min,omitempty"`
	AgeRangeMax               int       `json:"age_range_max,omitempty"`
	LocationRadius            int       `json:"location_radius,omitempty"` // km
	AllowCrossCountry         bool      `json:"allow_cross_country"`
	PreferredDiscoveryMethod  string    `json:"preferred_discovery_method"` // "AI", "MANUAL", "BOTH"
	UpdatedAt                 time.Time `json:"updated_at"`
}

// UserBehaviorProfile represents aggregated user behavior patterns.
type UserBehaviorProfile struct {
	UserID              string    `json:"user_id"`
	LastActiveTime      time.Time `json:"last_active_time"`
	AverageDailySession int       `json:"average_daily_session_min"`
	PeakUsageHour       int       `json:"peak_usage_hour"`
	MessageFrequency    string    `json:"message_frequency"` // "HIGH", "MEDIUM", "LOW"
	ContentConsumption  string    `json:"content_consumption"` // "HIGH", "MEDIUM", "LOW"
	DiscoveryEngagement float64   `json:"discovery_engagement"` // 0-1
	DeviceTypes         []string  `json:"device_types"`
	Churn               float64   `json:"churn_risk"` // 0-1
}

// UserRiskProfile represents security and compliance risk assessment.
type UserRiskProfile struct {
	UserID                  string    `json:"user_id"`
	RiskScore               float64   `json:"risk_score"` // 0-100
	SuspiciousLoginAttempts int       `json:"suspicious_login_attempts"`
	FailedMFAAttempts       int       `json:"failed_mfa_attempts"`
	UnusualLocationLogins   int       `json:"unusual_location_logins"`
	DataAccessAnomalies     int       `json:"data_access_anomalies"`
	PolicyViolations        int       `json:"policy_violations"`
	LastAssessmentAt        time.Time `json:"last_assessment_at"`
	RecommendedActions      []string  `json:"recommended_actions"`
}

// UserLifecycleState represents user journey stage.
type UserLifecycleState struct {
	UserID           string    `json:"user_id"`
	Stage            string    `json:"stage"` // "ONBOARDING", "ACTIVE", "DORMANT", "CHURNED"
	DaysSinceSignup  int       `json:"days_since_signup"`
	OnboardingStep   int       `json:"onboarding_step"`
	OnboardingAt     *time.Time `json:"onboarding_at,omitempty"`
	FirstMatchAt     *time.Time `json:"first_match_at,omitempty"`
	FirstMessageAt   *time.Time `json:"first_message_at,omitempty"`
	ChurnRiskAt      *time.Time `json:"churn_risk_at,omitempty"`
	ReactivatedAt    *time.Time `json:"reactivated_at,omitempty"`
}
