package payment

import (
	"time"
)

// Subscription represents a user subscription.
type Subscription struct {
	ID               string    `json:"id"`
	UserID           string    `json:"user_id"`
	PlanID           string    `json:"plan_id"`
	Status           string    `json:"status"` // "ACTIVE", "PAUSED", "CANCELLED", "EXPIRED"
	Provider         string    `json:"provider"` // "STRIPE", "REVENUECAT"
	ProviderID       string    `json:"provider_id"`
	StartDate        time.Time `json:"start_date"`
	EndDate          *time.Time `json:"end_date,omitempty"`
	RenewalDate      *time.Time `json:"renewal_date,omitempty"`
	CycleCount       int       `json:"cycle_count"`
	PriceInCents     int       `json:"price_in_cents"`
	Currency         string    `json:"currency"`
	Entitlements     []Entitlement `json:"entitlements,omitempty"`
	CreatedAt        time.Time `json:"created_at"`
	UpdatedAt        time.Time `json:"updated_at"`
}

// Entitlement represents a feature entitlement from a subscription.
type Entitlement struct {
	ID               string    `json:"id"`
	SubscriptionID   string    `json:"subscription_id"`
	Feature          string    `json:"feature"` // "VAULT", "ROOM", "AI_MEDIA"
	Limit            int       `json:"limit,omitempty"` // -1 = unlimited
	IsActive         bool      `json:"is_active"`
	ExpiresAt        *time.Time `json:"expires_at,omitempty"`
	CreatedAt        time.Time `json:"created_at"`
}

// BillingState represents the current billing state for a user.
type BillingState struct {
	UserID           string    `json:"user_id"`
	FailedPaymentCount int     `json:"failed_payment_count"`
	LastPaymentAttempt *time.Time `json:"last_payment_attempt,omitempty"`
	HasValidPaymentMethod bool  `json:"has_valid_payment_method"`
	IsInGracePeriod  bool      `json:"is_in_grace_period"`
	GracePeriodEndsAt *time.Time `json:"grace_period_ends_at,omitempty"`
	DaysOverdue      int       `json:"days_overdue"`
	NextBillingDate  *time.Time `json:"next_billing_date,omitempty"`
	Status           string    `json:"status"` // "CURRENT", "PAST_DUE", "SUSPENDED"
}

// StripeWebhook represents a Stripe webhook event.
type StripeWebhook struct {
	ID               string    `json:"id"`
	StripeEventID    string    `json:"stripe_event_id"`
	EventType        string    `json:"event_type"` // "payment_intent.succeeded", etc
	ResourceType     string    `json:"resource_type"` // "PaymentIntent", "Subscription"
	ResourceID       string    `json:"resource_id"`
	Data             map[string]interface{} `json:"data"`
	ProcessedAt      time.Time `json:"processed_at"`
	Status           string    `json:"status"` // "RECEIVED", "PROCESSED", "FAILED"
}

// RefundAudit represents a refund audit trail.
type RefundAudit struct {
	AuditID          string    `json:"audit_id"`
	SubscriptionID   string    `json:"subscription_id"`
	UserID           string    `json:"user_id"`
	RefundAmount     int       `json:"refund_amount"` // in cents
	Currency         string    `json:"currency"`
	Reason           string    `json:"reason"` // "CUSTOMER_REQUEST", "CHARGEBACK", "ERROR"
	Status           string    `json:"status"` // "PENDING", "COMPLETED", "FAILED"
	ProcessedAt      time.Time `json:"processed_at"`
	ApprovedBy       string    `json:"approved_by"`
}

// SubscriptionMigration represents migration between subscription plans.
type SubscriptionMigration struct {
	MigrationID      string    `json:"migration_id"`
	SubscriptionID   string    `json:"subscription_id"`
	UserID           string    `json:"user_id"`
	FromPlanID       string    `json:"from_plan_id"`
	ToPlanID         string    `json:"to_plan_id"`
	MigrationType    string    `json:"migration_type"` // "UPGRADE", "DOWNGRADE", "SWITCH"
	EffectiveDate    time.Time `json:"effective_date"`
	Proration        int       `json:"proration"` // credit/charge in cents
	Status           string    `json:"status"` // "PENDING", "COMPLETED", "FAILED"
	CreatedAt        time.Time `json:"created_at"`
}

// RevenueSyncState represents state of revenue data sync with RevenueCat.
type RevenueSyncState struct {
	SyncID           string    `json:"sync_id"`
	LastSyncAt       time.Time `json:"last_sync_at"`
	NextSyncAt       time.Time `json:"next_sync_at"`
	Status           string    `json:"status"` // "IDLE", "SYNCING", "FAILED"
	ItemsSynced      int       `json:"items_synced"`
	ItemsFailed      int       `json:"items_failed"`
	ErrorLog         []string  `json:"error_log,omitempty"`
}
