package policy

import (
	"context"
	"fmt"
	"identityservice/internal/domain/user"
)

// AuthorizationEngine enforces access control policies.
// Prevents anemic models and scattered authorization logic.
type AuthorizationEngine struct {
	policies map[string]Policy
}

// Policy defines a permission rule.
type Policy interface {
	Evaluate(ctx context.Context, subject string, action string, resource string) (bool, error)
}

// New creates a new authorization engine.
func New() *AuthorizationEngine {
	return &AuthorizationEngine{
		policies: make(map[string]Policy),
	}
}

// RegisterPolicy registers a policy by name.
func (ae *AuthorizationEngine) RegisterPolicy(name string, p Policy) {
	ae.policies[name] = p
}

// CanUserAccess checks if a user can perform an action on a resource.
func (ae *AuthorizationEngine) CanUserAccess(ctx context.Context, userID string, action string, resource string) (bool, error) {
	// This is where you'd check role-based, attribute-based, or other access control
	// For KinnectAI: consent-based access to ancestry data, family roles, etc.

	policy, exists := ae.policies["default"]
	if !exists {
		return false, fmt.Errorf("default policy not found")
	}

	return policy.Evaluate(ctx, userID, action, resource)
}

// ConsentPolicy enforces consent-based access control.
// Example: User can only view their own ancestry data unless they granted consent.
type ConsentPolicy struct {
	consentRepo ConsentRepository
}

// ConsentRepository defines how to check user consent.
type ConsentRepository interface {
	HasConsent(ctx context.Context, userID string, action string, resource string) (bool, error)
}

// NewConsentPolicy creates a consent-based policy.
func NewConsentPolicy(consentRepo ConsentRepository) *ConsentPolicy {
	return &ConsentPolicy{consentRepo: consentRepo}
}

// Evaluate checks if user has granted consent for the action.
func (cp *ConsentPolicy) Evaluate(ctx context.Context, userID string, action string, resource string) (bool, error) {
	// Example: user_viewing_ancestry_data action on ancestry resource requires consent
	if action == "view_ancestry_data" && resource == "ancestry" {
		return cp.consentRepo.HasConsent(ctx, userID, action, resource)
	}

	// Default allow for non-sensitive actions
	return true, nil
}

// DataRetentionPolicy enforces data lifecycle rules.
type DataRetentionPolicy struct {
	maxRetentionDays int
}

// NewDataRetentionPolicy creates a data retention policy.
func NewDataRetentionPolicy(maxRetentionDays int) *DataRetentionPolicy {
	return &DataRetentionPolicy{
		maxRetentionDays: maxRetentionDays,
	}
}

// CanDeleteUserData checks if a user's data can be deleted based on retention policies.
func (drp *DataRetentionPolicy) CanDeleteUserData(u *user.User) bool {
	// Check if enough time has passed since user requested deletion
	// This is domain logic that should NOT drift into handlers
	return true // Simplified
}

// RegionalPolicy enforces data residency and regional access rules.
type RegionalPolicy struct {
	allowedRegions []string
}

// NewRegionalPolicy creates a regional access policy.
func NewRegionalPolicy(allowedRegions []string) *RegionalPolicy {
	return &RegionalPolicy{
		allowedRegions: allowedRegions,
	}
}

// Evaluate checks if access is allowed from the given region.
func (rp *RegionalPolicy) Evaluate(ctx context.Context, userID string, action string, resource string) (bool, error) {
	// Extract region from context (set by middleware)
	region := ctx.Value("region").(string)

	for _, allowed := range rp.allowedRegions {
		if region == allowed {
			return true, nil
		}
	}

	return false, fmt.Errorf("access not allowed from region: %s", region)
}
