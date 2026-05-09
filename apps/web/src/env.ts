// SRS §23.2 Category 1 — App Foundation: env.ts
// All env vars must be explicitly listed here — no dynamic key access.
export const env = {
  apiBaseUrl: process.env.NEXT_PUBLIC_API_BASE_URL as string,
  wsBaseUrl: process.env.NEXT_PUBLIC_WS_BASE_URL as string,
  getstreamApiKey: process.env.NEXT_PUBLIC_GETSTREAM_API_KEY as string,
  revenueCatApiKey: process.env.NEXT_PUBLIC_REVENUECAT_API_KEY as string,
  sentryDsn: process.env.NEXT_PUBLIC_SENTRY_DSN as string,
  analyticsWriteKey: process.env.NEXT_PUBLIC_ANALYTICS_WRITE_KEY as string,
  isProd: process.env.NODE_ENV === 'production',
  isDev: process.env.NODE_ENV !== 'production',
} as const;
