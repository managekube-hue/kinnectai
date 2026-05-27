// SRS §23.2 Category 4 — Feed System: FeedScreen.tsx
import React, { useMemo, useState } from 'react';
import { useRouter } from 'next/navigation';
import { InfiniteFeedList } from './InfiniteFeedList';
import { FeedSkeleton } from './FeedSkeleton';
import { useFeedStore } from '../../stores/feedStore';

export default function FeedScreen(): React.ReactElement {
  const router = useRouter();
  const isLoading = useFeedStore((s) => s.isLoading);
  const items = useFeedStore((s) => s.items);
  const [tab, setTab] = useState<'echoes' | 'kinnections' | 'discover'>('echoes');

  const title = useMemo(() => {
    if (tab === 'discover') return 'Discover';
    if (tab === 'kinnections') return 'Kinnections';
    return 'The Line';
  }, [tab]);

  return (
    <div style={{ maxWidth: 640, margin: '0 auto', padding: '24px 16px' }}>
      <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between', marginBottom: 12 }}>
        <h2 style={{ fontSize: 20, fontWeight: 700 }}>{title}</h2>
        <div style={{ display: 'flex', gap: 8 }}>
          <button onClick={() => router.push('/notifications')} style={{ border: '1px solid #E5E5E5', borderRadius: 6, padding: '4px 10px', background: '#fff', cursor: 'pointer' }}>Alerts</button>
          <button onClick={() => router.push('/bloom')} style={{ border: '1px solid #E5E5E5', borderRadius: 6, padding: '4px 10px', background: '#fff', cursor: 'pointer' }}>Store</button>
        </div>
      </div>
      <div style={{ display: 'flex', gap: 8, marginBottom: 16 }}>
        <button onClick={() => setTab('echoes')} style={{ border: '1px solid #E5E5E5', borderRadius: 999, padding: '6px 12px', background: tab === 'echoes' ? '#111' : '#fff', color: tab === 'echoes' ? '#fff' : '#111', cursor: 'pointer' }}>Echoes</button>
        <button onClick={() => setTab('kinnections')} style={{ border: '1px solid #E5E5E5', borderRadius: 999, padding: '6px 12px', background: tab === 'kinnections' ? '#111' : '#fff', color: tab === 'kinnections' ? '#fff' : '#111', cursor: 'pointer' }}>Kinnections</button>
        <button onClick={() => setTab('discover')} style={{ border: '1px solid #E5E5E5', borderRadius: 999, padding: '6px 12px', background: tab === 'discover' ? '#111' : '#fff', color: tab === 'discover' ? '#fff' : '#111', cursor: 'pointer' }}>Discover</button>
      </div>
      {isLoading && items.length === 0 ? (
        <FeedSkeleton count={4} />
      ) : (
        <InfiniteFeedList />
      )}
    </div>
  );
}
