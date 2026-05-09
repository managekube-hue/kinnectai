// SRS §23.2 Category 5 — Discovery System: MatchCard.tsx
import React from 'react';
import { Card } from '../../components/design-system/Card';
import { Avatar } from '../../components/design-system/Avatar';
import { ConfidenceBreakdown } from './ConfidenceBreakdown';
import type { DiscoveryCard } from '../../types/discovery.types';

interface MatchCardProps {
  card: DiscoveryCard;
  onDismiss?: (matchId: string) => void;
}

export const MatchCard: React.FC<MatchCardProps> = ({ card, onDismiss }) => (
  <Card style={{ marginBottom: 12 }}>
    <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'flex-start' }}>
      <div style={{ display: 'flex', gap: 12 }}>
        <Avatar name={card.displayName} size={48} />
        <div>
          <div style={{ fontWeight: 600, fontSize: 16 }}>{card.displayName}</div>
          <div style={{ fontSize: 12, color: '#737373', marginBottom: 4 }}>
            @{card.username}
          </div>
          <ConfidenceBreakdown kinScore={card.kinScore} confidence={card.confidence} />
        </div>
      </div>
      {onDismiss && (
        <button
          onClick={() => onDismiss(card.matchId)}
          aria-label="Dismiss match"
          style={{ background: 'none', border: 'none', cursor: 'pointer', fontSize: 18, color: '#A3A3A3' }}
        >
          ✕
        </button>
      )}
    </div>
    {card.sharedAncestors && card.sharedAncestors.length > 0 && (
      <div style={{ marginTop: 10, fontSize: 13, color: '#525252' }}>
        Shared ancestors: {card.sharedAncestors.join(', ')}
      </div>
    )}
  </Card>
);
