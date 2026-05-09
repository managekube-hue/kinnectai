// SRS §23.2 Category 17 — Frontend Types: Feed
export interface FeedItem {
  itemId: string;
  itemType: 'memory_card' | 'discovery' | 'pulse' | 'bloom';
  payload: unknown;
  rankScore: number;
  injectionReason?: FeedInjectionReason;
  experimentVariant?: FeedExperimentVariant;
  insertedAt: string; // ISO 8601
}

export interface FeedInjectionReason {
  code: string;
  label: string;
  policyId?: string;
}

export interface FeedExperimentVariant {
  experimentId: string;
  variantId: string;
  variantName: string;
}

export interface FeedMetadata {
  nextCursor?: string;
  hasMore: boolean;
  generatedAt: string;
  fallbackReason?: string;
}

export interface MemoryCard {
  memoryId: string;
  userId: string;
  title: string;
  mediaType: 'text' | 'image' | 'video' | 'audio';
  previewUrl?: string;
  sealedAt: string;
}

export interface FeedCursor {
  cursor: string;
  generatedAt: string;
}

export interface FeedGet200Response {
  items: FeedItem[];
  cursor: FeedCursor;
  metadata: FeedMetadata;
}
