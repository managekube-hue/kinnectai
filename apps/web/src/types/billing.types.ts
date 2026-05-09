// SRS §23.2 Category 17 — Frontend Types: Billing
export interface Subscription {
  subscriptionId: string;
  userId: string;
  planId: string;
  status: 'active' | 'paused' | 'cancelled' | 'expired';
  currentPeriodEnd: string;
  cancelAtPeriodEnd: boolean;
  provider: 'stripe' | 'revenuecat' | 'apple' | 'google';
  externalId: string;
}

export interface Entitlement {
  entitlementId: string;
  userId: string;
  lookupKey: string;
  isActive: boolean;
  grantedAt: string;
  expiresAt?: string;
}

export interface BillingState {
  userId: string;
  activeSubscription?: Subscription;
  entitlements: Entitlement[];
  balanceCents: number;
  currency: string;
  paymentMethodOnFile: boolean;
}
