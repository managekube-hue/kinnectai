// SRS §23.2 Category 4 — Feed System: FeedRankingBadge.tsx
import React from 'react';
import type { FeedInjectionReason } from '../../types/feed.types';

interface FeedRankingBadgeProps {
  reason?: FeedInjectionReason;
}

const labelMap: Record<FeedInjectionReason, string> = {
  kc_score: 'High Kin Score',
  pulse_reaction: 'Pulsed',
  memory_resurfaced: 'Memory',
  steward_promoted: 'Steward Pick',
  new_kinnection: 'New Connection',
};

export const FeedRankingBadge: React.FC<FeedRankingBadgeProps> = ({ reason }) => {
  if (!reason) return null;
  return (
    <span style={{
      display: 'inline-block', padding: '2px 8px', borderRadius: 4,
      background: '#E5E5E5', fontSize: 11, fontWeight: 600, color: '#525252',
      letterSpacing: 0.5,
    }}>
      {labelMap[reason] ?? reason}
    </span>
  );
};
