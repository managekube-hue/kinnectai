import { QueryClient } from '@tanstack/react-query';
import { queryKeys } from './queryKeys';

export function cacheHydration(queryClient: QueryClient, initialData: Record<string, any>) {
  Object.entries(initialData).forEach(([key, data]) => {
    if (key === 'auth') {
      queryClient.setQueryData(queryKeys.auth.user, data.user);
    } else if (key === 'feed') {
      queryClient.setQueryData(queryKeys.feed.list, data.items);
    }
    // ... other cache hydrations
  });
}
