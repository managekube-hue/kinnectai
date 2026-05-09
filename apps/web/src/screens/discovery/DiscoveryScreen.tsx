// SRS §23.2 Category 5 — Discovery System: DiscoveryScreen.tsx
import React, { useEffect } from 'react';
import { discoveryApi } from '../../api/discoveryApi';
import { useDiscoveryStore } from '../../stores/discoveryStore';
import { MatchCard } from './MatchCard';
import { DiscoveryFilters } from './DiscoveryFilters';
import { FeedSkeleton } from '../feed/FeedSkeleton';

export default function DiscoveryScreen(): React.ReactElement {
  const candidates = useDiscoveryStore((s) => s.candidates);
  const setCandidates = useDiscoveryStore((s) => s.setCandidates);
  const dismissCandidate = useDiscoveryStore((s) => s.dismissCandidate);
  const [loading, setLoading] = React.useState(true);

  useEffect(() => {
    discoveryApi.getCandidates()
      .then((res) => setCandidates(res.candidates ?? [], res.nextCursor ?? null, (res.candidates?.length ?? 0) > 0))
      .catch(console.error)
      .finally(() => setLoading(false));
  }, [setCandidates]);

  const handleDismiss = async (matchId: string) => {
    dismissCandidate(matchId);
    await discoveryApi.dismiss({ matchId, reason: 'not_interested' }).catch(console.error);
  };

  return (
    <div style={{ maxWidth: 640, margin: '0 auto', padding: '24px 16px' }}>
      <h2 style={{ fontSize: 20, fontWeight: 700, marginBottom: 12 }}>Discover</h2>
      <DiscoveryFilters />
      {loading ? (
        <FeedSkeleton count={4} />
      ) : candidates.length === 0 ? (
        <p style={{ color: '#737373', textAlign: 'center', padding: 40 }}>No more suggestions right now.</p>
      ) : (
        candidates.map((c) => (
          <MatchCard key={c.matchId} card={c} onDismiss={handleDismiss} />
        ))
      )}
    </div>
  );
}
