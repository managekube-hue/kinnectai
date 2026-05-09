// SRS §23.2 Category 4 — Feed System: MemoryCard.tsx
import React from 'react';
import { Card } from '../../components/design-system/Card';
import type { MemoryCard as MemoryCardType } from '../../types/feed.types';

interface MemoryCardProps {
  memory: MemoryCardType;
}

export const MemoryCard: React.FC<MemoryCardProps> = ({ memory }) => (
  <Card style={{ background: '#FAFAFA', marginBottom: 12 }}>
    <div style={{ fontSize: 11, fontWeight: 600, letterSpacing: 1, color: '#737373', marginBottom: 4 }}>
      MEMORY · {memory.year}
    </div>
    <p style={{ margin: 0, fontSize: 15, lineHeight: 1.5 }}>{memory.snippet}</p>
    {memory.mediaType && (
      <div style={{ marginTop: 8, fontSize: 12, color: '#A3A3A3' }}>
        {memory.mediaType.toUpperCase()}
      </div>
    )}
  </Card>
);
