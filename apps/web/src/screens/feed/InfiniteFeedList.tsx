// SRS §23.2 Category 4 — Feed System: InfiniteFeedList.tsx
import React, { useEffect, useRef } from 'react';
import { useFeedStore } from '../../stores/feedStore';
import { feedApi } from '../../api/feedApi';
import { FeedCard } from './FeedCard';
import { FeedSkeleton } from './FeedSkeleton';

export const InfiniteFeedList: React.FC = () => {
  const items = useFeedStore((s) => s.items);
  const cursor = useFeedStore((s) => s.cursor);
  const hasMore = useFeedStore((s) => s.hasMore);
  const isLoading = useFeedStore((s) => s.isLoading);
  const appendItems = useFeedStore((s) => s.appendItems);
  const setLoading = useFeedStore((s) => s.setLoading);

  const sentinelRef = useRef<HTMLDivElement>(null);

  useEffect(() => {
    const sentinel = sentinelRef.current;
    if (!sentinel) return;

    const observer = new IntersectionObserver(
      async ([entry]) => {
        if (entry.isIntersecting && hasMore && !isLoading) {
          setLoading(true);
          try {
            const res = await feedApi.getFeed(cursor?.nextToken);
            appendItems(res.items, res.cursor, res.hasMore);
          } finally {
            setLoading(false);
          }
        }
      },
      { threshold: 0.1 },
    );
    observer.observe(sentinel);
    return () => observer.disconnect();
  }, [cursor, hasMore, isLoading, appendItems, setLoading]);

  return (
    <div>
      {items.map((item) => (
        <FeedCard key={item.feedItemId} item={item} />
      ))}
      {isLoading && <FeedSkeleton count={2} />}
      <div ref={sentinelRef} style={{ height: 1 }} />
      {!hasMore && items.length > 0 && (
        <p style={{ textAlign: 'center', color: '#A3A3A3', fontSize: 13, padding: 24 }}>
          You're all caught up
        </p>
      )}
    </div>
  );
};
