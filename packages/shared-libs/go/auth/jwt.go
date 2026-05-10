// shared-libs/go/auth
// JWT validation, consent enforcement, step-up auth middleware

package auth

import (
	"context"
	"fmt"
)

type Claims struct {
	Sub              string   `json:"sub"`
	Iss              string   `json:"iss"`
	Aud              []string `json:"aud"`
	ConsentTiers     []string `json:"consent_tiers"`
	Scopes           map[string][]string `json:"scopes"`
	StepupVerified   bool     `json:"stepup_verified"`
	AttStatus        string   `json:"att_status"`
	ConsentFlags     int      `json:"consent_flags"`
	DeviceFingerprint string  `json:"device_fingerprint"`
}

// ValidateConsent checks if user has required consent tier
func ValidateConsent(ctx context.Context, claims *Claims, tier string) error {
	for _, t := range claims.ConsentTiers {
		if t == tier {
			return nil
		}
	}
	return fmt.Errorf("missing consent tier: %s", tier)
}

// ValidateScope checks if JWT has required scope
func ValidateScope(ctx context.Context, claims *Claims, service string, action string) error {
	if scopes, ok := claims.Scopes[service]; ok {
		for _, s := range scopes {
			if s == action {
				return nil
			}
		}
	}
	return fmt.Errorf("missing scope: %s:%s", service, action)
}
