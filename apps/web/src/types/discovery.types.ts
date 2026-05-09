// SRS §23.2 Category 17 — Frontend Types: Discovery
export interface DiscoveryCard {
  matchId: string;
  displayName: string;
  avatarUrl?: string;
  displayScore: number; // 0–100
  relation: string;
  pathSummary: string;
  surfacedAt: string;
}

export interface DiscoveryList {
  candidates: DiscoveryCard[];
  nextCursor?: string;
  hasMore: boolean;
  generatedAt: string;
}

export interface DiscoveryDismissPostRequest {
  targetUserId: string;
  reason?: 'not_related' | 'known' | 'other';
}

export interface DiscoveryInsight {
  sharedSurnames: string[];
  sharedLocations: string[];
  dnaOverlapPct?: number;
  confidence: 'low' | 'medium' | 'high';
}
