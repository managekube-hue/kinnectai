// SRS §23.2 Category 12 — React Query / Cache Layer: optimisticUpdates.ts
import type { QueryClient } from '@tanstack/react-query';
import { queryKeys } from './queryKeys';
import type { DiscoveryCard } from '../types/discovery.types';
import type { FeedGet200Response } from '../types/feed.types';

export function optimisticallyDismissCandidate(
  queryClient: QueryClient,
  matchId: string,
): void {
  queryClient.setQueriesData<{ candidates: DiscoveryCard[] }>(
    { queryKey: queryKeys.discovery.all },
    (old) => {
      if (!old) return old;
      return { ...old, candidates: old.candidates.filter((c) => c.matchId !== matchId) };
    },
  );
}

export function optimisticallyAddPulse(
  queryClient: QueryClient,
  _targetId: string,
): void {
  // Invalidate feed so the pulse reaction renders on next refetch
  void queryClient.invalidateQueries({ queryKey: queryKeys.feed.all });
}

export function prefetchFeed(queryClient: QueryClient): Promise<void> {
  return queryClient.prefetchQuery({
    queryKey: queryKeys.feed.list(),
    staleTime: 30_000,
  });
}

export function hydrateFromSSR(
  queryClient: QueryClient,
  feedData: FeedGet200Response,
): void {
  queryClient.setQueryData(queryKeys.feed.list(), feedData);
}
