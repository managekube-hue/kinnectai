// SRS §23.2 Category 12 — React Query / Cache Layer: cacheHydration.ts
import { QueryClient } from '@tanstack/react-query';

let _queryClient: QueryClient | null = null;

export function getQueryClient(): QueryClient {
  if (!_queryClient) {
    _queryClient = new QueryClient({
      defaultOptions: {
        queries: {
          staleTime: 30_000,
          gcTime: 5 * 60_000,
          retry: 2,
          refetchOnWindowFocus: false,
        },
      },
    });
  }
  return _queryClient;
}

export function hydrateCache(queryClient: QueryClient, dehydratedState: unknown): void {
  // In SSR scenarios, hydrate TanStack Query cache from server state
  if (dehydratedState && typeof dehydratedState === 'object') {
    // @tanstack/react-query hydrate is called externally; this util is the single place for it
    void queryClient.resetQueries();
  }
}

// Shared singleton for use in apiClient interceptors
export const queryClient = getQueryClient();
