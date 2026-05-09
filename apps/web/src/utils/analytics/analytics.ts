// SRS §23.2 Category 15 — Analytics: analytics.ts
import { env } from '../../env';

interface AnalyticsInitOptions {
  userId?: string;
  anonymousId?: string;
}

let initialised = false;
let currentUserId: string | undefined;

function init(options: AnalyticsInitOptions = {}): void {
  if (initialised) return;
  currentUserId = options.userId;
  initialised = true;
  if (env.isDev) console.debug('[analytics] init', options);
}

function identify(userId: string, traits?: Record<string, unknown>): void {
  currentUserId = userId;
  if (env.isDev) console.debug('[analytics] identify', userId, traits);
  // Production: forward to Segment/Amplitude/etc. write key from env.analyticsWriteKey
}

function track(event: string, properties?: Record<string, unknown>): void {
  if (!initialised) return;
  if (env.isDev) console.debug('[analytics] track', event, properties);
  // Production: send to analytics backend
}

function page(name: string, properties?: Record<string, unknown>): void {
  if (!initialised) return;
  if (env.isDev) console.debug('[analytics] page', name, properties);
}

function reset(): void {
  currentUserId = undefined;
}

export const analytics = { init, identify, track, page, reset };
export type { AnalyticsInitOptions };
