// SRS §23.2 Category 4 — Feed System: FeedCard.tsx
import React from 'react';
import { Card } from '../../components/design-system/Card';
import { Avatar } from '../../components/design-system/Avatar';
import { FeedRankingBadge } from './FeedRankingBadge';
import type { FeedItem } from '../../types/feed.types';

interface FeedCardProps {
  item: FeedItem;
  onPulse?: (itemId: string) => void;
}

export const FeedCard: React.FC<FeedCardProps> = ({ item, onPulse }) => (
  <Card style={{ marginBottom: 12 }}>
    <div style={{ display: 'flex', alignItems: 'flex-start', gap: 12 }}>
      <Avatar name={item.authorDisplayName} size={40} />
      <div style={{ flex: 1 }}>
        <div style={{ fontWeight: 600, fontSize: 14 }}>{item.authorDisplayName}</div>
        <div style={{ fontSize: 12, color: '#737373', marginBottom: 8 }}>
          {new Date(item.publishedAt).toLocaleDateString()}
        </div>
        <FeedRankingBadge reason={item.injectionReason} />
        {item.contentSnippet && (
          <p style={{ margin: '8px 0 0', fontSize: 15, lineHeight: 1.5 }}>{item.contentSnippet}</p>
        )}
      </div>
    </div>
    {onPulse && (
      <button
        onClick={() => onPulse(item.feedItemId)}
        style={{
          marginTop: 12, background: 'none', border: '1px solid #E5E5E5',
          borderRadius: 6, padding: '4px 12px', cursor: 'pointer', fontSize: 13,
        }}
      >
        Pulse
      </button>
    )}
  </Card>
);
