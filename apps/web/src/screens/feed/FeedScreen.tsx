// SRS §23.2 Category 4 — Feed System: FeedScreen.tsx
import React, { useCallback } from 'react';
import { InfiniteFeedList } from './InfiniteFeedList';
import { FeedSkeleton } from './FeedSkeleton';
import { useFeedStore } from '../../stores/feedStore';

export default function FeedScreen(): React.ReactElement {
  const isLoading = useFeedStore((s) => s.isLoading);
  const items = useFeedStore((s) => s.items);

  return (
    <div style={{ maxWidth: 640, margin: '0 auto', padding: '24px 16px' }}>
      <h2 style={{ fontSize: 20, fontWeight: 700, marginBottom: 16 }}>Your Feed</h2>
      {isLoading && items.length === 0 ? (
        <FeedSkeleton count={4} />
      ) : (
        <InfiniteFeedList />
      )}
    </div>
  );
}
