// SRS §23.2 Category 12 — React Query / Cache Layer: mutationKeys.ts
export const mutationKeys = {
  auth: {
    login: ['auth', 'login'] as const,
    logout: ['auth', 'logout'] as const,
    register: ['auth', 'register'] as const,
    verifyMFA: ['auth', 'mfa', 'verify'] as const,
    submitConsent: ['auth', 'consent'] as const,
  },
  feed: {
    sendPulse: ['feed', 'sendPulse'] as const,
  },
  discovery: {
    dismiss: ['discovery', 'dismiss'] as const,
  },
  graph: {
    addKinnection: ['graph', 'addKinnection'] as const,
  },
  room: {
    create: ['room', 'create'] as const,
    join: ['room', 'join'] as const,
    leave: ['room', 'leave'] as const,
  },
  vault: {
    seal: ['vault', 'seal'] as const,
  },
  bloom: {
    queue: ['bloom', 'queue'] as const,
  },
  moderation: {
    report: ['moderation', 'report'] as const,
    block: ['moderation', 'block'] as const,
  },
} as const;
