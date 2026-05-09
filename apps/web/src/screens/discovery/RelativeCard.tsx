// SRS §23.2 Category 5 — Discovery System: RelativeCard.tsx
import React from 'react';
import { Card } from '../../components/design-system/Card';
import { Avatar } from '../../components/design-system/Avatar';
import type { DiscoveryCard } from '../../types/discovery.types';

interface RelativeCardProps {
  card: DiscoveryCard;
}

export const RelativeCard: React.FC<RelativeCardProps> = ({ card }) => (
  <Card style={{ background: '#FAFAFA', marginBottom: 8 }}>
    <div style={{ display: 'flex', gap: 10, alignItems: 'center' }}>
      <Avatar name={card.displayName} size={36} />
      <div>
        <div style={{ fontWeight: 500, fontSize: 14 }}>{card.displayName}</div>
        {card.relationshipLabel && (
          <div style={{ fontSize: 12, color: '#737373' }}>{card.relationshipLabel}</div>
        )}
      </div>
      <div style={{ marginLeft: 'auto', fontSize: 12, fontWeight: 600 }}>
        {(card.kinScore * 100).toFixed(0)}% match
      </div>
    </div>
  </Card>
);
