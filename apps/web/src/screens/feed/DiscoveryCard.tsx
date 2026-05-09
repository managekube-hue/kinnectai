// SRS §23.2 Category 4 — Feed System: DiscoveryCard.tsx (Feed context)
import React from 'react';
import { Card } from '../../components/design-system/Card';
import { Avatar } from '../../components/design-system/Avatar';
import type { DiscoveryCard as DiscoveryCardType } from '../../types/discovery.types';

interface DiscoveryCardProps {
  card: DiscoveryCardType;
  onDismiss?: (matchId: string) => void;
}

export const DiscoveryCard: React.FC<DiscoveryCardProps> = ({ card, onDismiss }) => (
  <Card style={{ background: '#F5F5F5', marginBottom: 12 }}>
    <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center' }}>
      <div style={{ display: 'flex', gap: 10, alignItems: 'center' }}>
        <Avatar name={card.displayName} size={44} />
        <div>
          <div style={{ fontWeight: 600 }}>{card.displayName}</div>
          <div style={{ fontSize: 12, color: '#737373' }}>Kin Score: {card.kinScore.toFixed(1)}</div>
        </div>
      </div>
      {onDismiss && (
        <button
          onClick={() => onDismiss(card.matchId)}
          aria-label="Dismiss"
          style={{ background: 'none', border: 'none', cursor: 'pointer', fontSize: 18, color: '#A3A3A3' }}
        >
          ✕
        </button>
      )}
    </div>
  </Card>
);
