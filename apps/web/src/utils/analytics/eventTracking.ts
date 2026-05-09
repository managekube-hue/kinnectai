// SRS §23.2 Category 15 — Analytics: eventTracking.ts
import { analytics } from './analytics';

export const Events = {
  // Auth
  AUTH_LOGIN_SUCCESS: 'auth_login_success',
  AUTH_SIGNUP_SUCCESS: 'auth_signup_success',
  AUTH_MFA_VERIFIED: 'auth_mfa_verified',
  AUTH_LOGOUT: 'auth_logout',
  // Feed
  FEED_ITEM_VIEWED: 'feed_item_viewed',
  FEED_PULSE_SENT: 'feed_pulse_sent',
  FEED_LOAD_MORE: 'feed_load_more',
  // Discovery
  DISCOVERY_CARD_VIEWED: 'discovery_card_viewed',
  DISCOVERY_CARD_DISMISSED: 'discovery_card_dismissed',
  DISCOVERY_KINNECT_INITIATED: 'discovery_kinnect_initiated',
  // Graph
  GRAPH_NODE_SELECTED: 'graph_node_selected',
  GRAPH_PATH_VIEWED: 'graph_path_viewed',
  // Rooms
  ROOM_CREATED: 'room_created',
  ROOM_JOINED: 'room_joined',
  ROOM_LEFT: 'room_left',
  // Vault
  VAULT_MEMORY_VIEWED: 'vault_memory_viewed',
  VAULT_SEALED: 'vault_sealed',
  // Bloom
  BLOOM_GENERATION_QUEUED: 'bloom_generation_queued',
  BLOOM_MEDIA_VIEWED: 'bloom_media_viewed',
} as const;

export type TrackEvent = (typeof Events)[keyof typeof Events];

export function trackEvent(event: TrackEvent, properties?: Record<string, unknown>): void {
  analytics.track(event, properties);
}
