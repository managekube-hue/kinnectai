// SRS §23.2 Category 12 — React Query / Cache Layer: queryKeys.ts
export const queryKeys = {
  feed: {
    all: ['feed'] as const,
    list: (cursor?: string) => ['feed', 'list', cursor ?? ''] as const,
  },
  discovery: {
    all: ['discovery'] as const,
    candidates: (cursor?: string) => ['discovery', 'candidates', cursor ?? ''] as const,
  },
  graph: {
    all: ['graph'] as const,
    kinnections: (userId: string) => ['graph', 'kinnections', userId] as const,
    path: (from: string, to: string) => ['graph', 'path', from, to] as const,
  },
  room: {
    all: ['room'] as const,
    detail: (roomId: string) => ['room', roomId] as const,
  },
  vault: {
    all: ['vault'] as const,
    memories: (userId: string) => ['vault', 'memories', userId] as const,
  },
  notifications: {
    all: ['notifications'] as const,
    list: () => ['notifications', 'list'] as const,
  },
  bloom: {
    all: ['bloom'] as const,
    job: (jobId: string) => ['bloom', 'job', jobId] as const,
  },
  billing: {
    all: ['billing'] as const,
    state: (userId: string) => ['billing', 'state', userId] as const,
  },
} as const;
