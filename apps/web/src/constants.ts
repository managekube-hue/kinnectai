// SRS §23.2 Category 1 — App Foundation: constants.ts
export const APP_NAME = 'KinnectAI';
export const APP_VERSION = '0.1.0';

export const API_BASE_URL = process.env.NEXT_PUBLIC_API_BASE_URL ?? 'https://api.kinnectai.app/v1';

export const PAGINATION = {
  DEFAULT_PAGE_SIZE: 20,
  MAX_PAGE_SIZE: 100,
} as const;

export const KIN_SCORE = {
  DISPLAY_MAX: 100,
  HIGH_CONFIDENCE_THRESHOLD: 75,
  MEDIUM_CONFIDENCE_THRESHOLD: 50,
} as const;

export const RELATIONSHIP_TYPES = [
  'parent',
  'child',
  'sibling',
  'first_cousin',
  'second_cousin',
  'grandparent',
  'ancestor',
] as const;

export const MEDIA_TYPES = ['text', 'image', 'video', 'audio'] as const;

export const NOTIFICATION_CHANNELS = ['push', 'email', 'sms', 'in_app'] as const;
