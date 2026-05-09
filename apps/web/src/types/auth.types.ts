// SRS §23.2 Category 17 — Frontend Types: Auth
export interface JwtClaims {
  userId: string;
  username: string;
  email: string;
  scopes: string[];
  sessionId: string;
  iat: number;
  exp: number;
}

export interface AuthUser {
  id: string;
  username: string;
  email: string;
  displayName: string;
  profilePictureUrl?: string;
  isVerified: boolean;
}

export interface AuthResponse {
  user: AuthUser;
  accessToken: string;
  expiresAt: number;
}

export interface ConsentFlags {
  termsAccepted: boolean;
  privacyAccepted: boolean;
  dnaConsent: boolean;
  biometricConsent: boolean;
  marketingConsent: boolean;
}

export interface MFAChallenge {
  challengeId: string;
  method: 'totp' | 'sms_otp' | 'email_otp';
  expiresAt: string;
}

export interface SessionMetadata {
  sessionId: string;
  userId: string;
  deviceId: string;
  createdAt: string;
  expiresAt: string;
}
