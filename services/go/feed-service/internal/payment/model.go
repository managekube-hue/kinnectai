// SRS §23.1 Category 11 — Payment / RevenueCat types
package payment

import (
	"time"

	"github.com/google/uuid"
)

// RevenueCatWebhook is the top-level RevenueCat webhook envelope.
type RevenueCatWebhook struct {
	APIVersion string               `json:"api_version"`
	Event      RevenueCatWebhookEvent `json:"event"`
}

// RevenueCatWebhookEvent is the event body within a RevenueCat webhook.
type RevenueCatWebhookEvent struct {
	ID                string                                    `json:"id"`
	Type              string                                    `json:"type"`
	AppUserID         string                                    `json:"app_user_id"`
	ProductID         string                                    `json:"product_id"`
	PeriodType        string                                    `json:"period_type"`
	PurchasedAt       int64                                     `json:"purchased_at_ms"`
	ExpiresAt         int64                                     `json:"expires_date_ms,omitempty"`
	Environment       string                                    `json:"environment"`
	Entitlements      []RevenueCatWebhookEventEntitlementsInner `json:"entitlements"`
}

// RevenueCatWebhookEventEntitlementsInner is a single entitlement within a RC event.
type RevenueCatWebhookEventEntitlementsInner struct {
	LookupKey   string `json:"lookup_key"`
	DisplayName string `json:"display_name"`
	ProductID   string `json:"product_id"`
}

// Subscription tracks a user's active subscription state.
type Subscription struct {
	SubscriptionID  uuid.UUID  `json:"subscription_id"`
	UserID          uuid.UUID  `json:"user_id"`
	PlanID          string     `json:"plan_id"`
	Status          string     `json:"status"` // active | paused | cancelled | expired
	CurrentPeriodEnd time.Time `json:"current_period_end"`
	CancelAtPeriodEnd bool     `json:"cancel_at_period_end"`
	Provider        string     `json:"provider"` // stripe | revenuecat | apple | google
	ExternalID      string     `json:"external_id"`
	CreatedAt       time.Time  `json:"created_at"`
	UpdatedAt       time.Time  `json:"updated_at"`
}

// Entitlement is a specific capability granted by a subscription plan.
type Entitlement struct {
	EntitlementID uuid.UUID `json:"entitlement_id"`
	UserID        uuid.UUID `json:"user_id"`
	LookupKey     string    `json:"lookup_key"`
	IsActive      bool      `json:"is_active"`
	GrantedAt     time.Time `json:"granted_at"`
	ExpiresAt     *time.Time `json:"expires_at,omitempty"`
}

// BillingState is the aggregated billing status for a user.
type BillingState struct {
	UserID              uuid.UUID   `json:"user_id"`
	ActiveSubscription  *Subscription `json:"active_subscription,omitempty"`
	Entitlements        []Entitlement `json:"entitlements"`
	BalanceCents        int         `json:"balance_cents"`
	Currency            string      `json:"currency"`
	PaymentMethodOnFile bool        `json:"payment_method_on_file"`
}

// StripeWebhook is the top-level Stripe webhook envelope (used for Connect events).
type StripeWebhook struct {
	ID      string      `json:"id"`
	Type    string      `json:"type"`
	Created int64       `json:"created"`
	Data    interface{} `json:"data"`
}

// RefundAudit records a refund action for compliance.
type RefundAudit struct {
	AuditID         uuid.UUID `json:"audit_id"`
	OrderID         string    `json:"order_id"`
	UserID          uuid.UUID `json:"user_id"`
	RefundAmountCents int     `json:"refund_amount_cents"`
	Reason          string    `json:"reason"`
	InitiatedBy     string    `json:"initiated_by"` // user | admin | system
	StripeRefundID  string    `json:"stripe_refund_id,omitempty"`
	OccurredAt      time.Time `json:"occurred_at"`
}

// SubscriptionMigration records a plan upgrade or downgrade event.
type SubscriptionMigration struct {
	MigrationID   uuid.UUID `json:"migration_id"`
	UserID        uuid.UUID `json:"user_id"`
	FromPlanID    string    `json:"from_plan_id"`
	ToPlanID      string    `json:"to_plan_id"`
	Proration     int       `json:"proration_cents"`
	MigratedAt    time.Time `json:"migrated_at"`
}

// RevenueSyncState tracks reconciliation between RevenueCat and Stripe.
type RevenueSyncState struct {
	UserID          uuid.UUID  `json:"user_id"`
	LastSyncAt      time.Time  `json:"last_sync_at"`
	InSync          bool       `json:"in_sync"`
	DiscrepancyNote string     `json:"discrepancy_note,omitempty"`
}
