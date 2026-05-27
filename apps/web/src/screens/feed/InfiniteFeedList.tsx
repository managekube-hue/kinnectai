// SRS §23.2 Category 4 — Feed System: InfiniteFeedList.tsx
import React, { useEffect, useRef } from 'react';
import { useRouter } from 'next/navigation';
import { useFeedStore } from '../../stores/feedStore';
import { feedApi } from '../../api/feedApi';
import { FeedCard } from './FeedCard';
import { FeedSkeleton } from './FeedSkeleton';

export const InfiniteFeedList: React.FC = () => {
  const router = useRouter();
  const items = useFeedStore((s) => s.items);
  const cursor = useFeedStore((s) => s.cursor);
  const hasMore = useFeedStore((s) => s.hasMore);
  const isLoading = useFeedStore((s) => s.isLoading);
  const appendItems = useFeedStore((s) => s.appendItems);
  const setLoading = useFeedStore((s) => s.setLoading);

  const sentinelRef = useRef<HTMLDivElement>(null);

  useEffect(() => {
    if (items.length > 0 || isLoading) {
      return;
    }

    let active = true;
    setLoading(true);
    feedApi
      .getFeed()
      .then((res) => {
        if (!active) return;
        appendItems(res.items, res.cursor, res.metadata?.hasMore ?? res.hasMore);
      })
      .finally(() => {
        if (!active) return;
        setLoading(false);
      });

    return () => {
      active = false;
    };
  }, [items.length, isLoading, appendItems, setLoading]);

  useEffect(() => {
    const sentinel = sentinelRef.current;
    if (!sentinel) return;

    const observer = new IntersectionObserver(
      async ([entry]) => {
        if (entry.isIntersecting && hasMore && !isLoading) {
          setLoading(true);
          try {
            const res = await feedApi.getFeed(cursor?.cursor);
            appendItems(res.items, res.cursor, res.metadata?.hasMore ?? res.hasMore);
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
        <FeedCard
          key={item.feedItemId ?? item.itemId}
          item={item}
          onPulse={async (itemId) => {
            await feedApi.sendPulse(itemId, 'memory').catch(() => undefined);
          }}
          onOpenComments={(memoryId) => router.push(`/vault?memoryId=${encodeURIComponent(memoryId)}&sheet=comments`)}
          onOpenShare={(memoryId) => router.push(`/vault?memoryId=${encodeURIComponent(memoryId)}&sheet=share`)}
          onOpenRewind={(memoryId) => router.push(`/rooms/${encodeURIComponent(memoryId)}`)}
          onOpenBranch={(branchId) => router.push(`/tree?branchId=${encodeURIComponent(branchId)}`)}
          onOpenProfile={(userId) => router.push(`/tree?userId=${encodeURIComponent(userId)}`)}
          onOpenGraph={(candidateId) => router.push(`/discover?candidateId=${encodeURIComponent(candidateId)}`)}
        />
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
