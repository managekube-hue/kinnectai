// SRS §23.2 Category 4 — Feed System: FeedCard.tsx
import React from 'react';
import { Card } from '../../components/design-system/Card';
import { Avatar } from '../../components/design-system/Avatar';
import { FeedRankingBadge } from './FeedRankingBadge';
import type { FeedItem } from '../../types/feed.types';

interface FeedCardProps {
  item: FeedItem;
  onPulse?: (itemId: string) => void;
  onOpenComments?: (memoryId: string) => void;
  onOpenShare?: (memoryId: string) => void;
  onOpenRewind?: (memoryId: string) => void;
  onOpenBranch?: (branchId: string) => void;
  onOpenProfile?: (userId: string) => void;
  onOpenGraph?: (candidateId: string) => void;
}

export const FeedCard: React.FC<FeedCardProps> = ({
  item,
  onPulse,
  onOpenComments,
  onOpenShare,
  onOpenRewind,
  onOpenBranch,
  onOpenProfile,
  onOpenGraph,
}) => {
  const payload = (item.payload as Record<string, unknown> | null) ?? {};
  const memoryId = item.memoryId ?? String(payload.memoryId ?? payload.id ?? item.itemId);
  const authorId = item.authorId ?? String(payload.authorId ?? payload.creatorId ?? 'unknown');
  const authorDisplayName =
    item.authorDisplayName ?? String(payload.authorDisplayName ?? payload.creatorDisplayName ?? 'Unknown');
  const contentSnippet = item.contentSnippet ?? String(payload.contentSnippet ?? payload.caption ?? '');
  const publishedAt = item.publishedAt ?? String(payload.publishedAt ?? item.insertedAt);
  const kinScore = Number(item.kinScore ?? payload.kinScore ?? 0);
  const branchId = item.branchId ?? (payload.branchId ? String(payload.branchId) : undefined);

  return (
    <Card style={{ marginBottom: 12 }}>
      <div style={{ display: 'flex', alignItems: 'flex-start', gap: 12 }}>
        <button
          onClick={() => onOpenProfile?.(authorId)}
          style={{ border: 'none', background: 'transparent', padding: 0, cursor: 'pointer' }}
        >
          <Avatar name={authorDisplayName} size={40} />
        </button>
        <div style={{ flex: 1 }}>
          <div style={{ display: 'flex', alignItems: 'center', gap: 8, flexWrap: 'wrap' }}>
            <button
              onClick={() => onOpenProfile?.(authorId)}
              style={{ border: 'none', background: 'transparent', padding: 0, cursor: 'pointer', fontWeight: 600, fontSize: 14 }}
            >
              {authorDisplayName}
            </button>
            <span style={{ fontSize: 11, color: '#0EA5E9', fontWeight: 600 }}>Kin {Math.round(kinScore * 100)}%</span>
            <button
              onClick={() => onOpenGraph?.(authorId)}
              style={{ border: 'none', background: 'transparent', padding: 0, cursor: 'pointer', fontSize: 11, color: '#2563EB' }}
            >
              Explore Connection
            </button>
          </div>
          <div style={{ fontSize: 12, color: '#737373', marginBottom: 8 }}>
            {new Date(publishedAt).toLocaleDateString()}
          </div>
          <FeedRankingBadge reason={item.injectionReason} />
          {contentSnippet && (
            <p style={{ margin: '8px 0 0', fontSize: 15, lineHeight: 1.5 }}>{contentSnippet}</p>
          )}
        </div>
        <div style={{ display: 'flex', flexDirection: 'column', gap: 6 }}>
          <button onClick={() => onPulse?.(memoryId)} style={{ border: '1px solid #E5E5E5', borderRadius: 6, padding: '2px 8px', cursor: 'pointer', fontSize: 12 }}>Pulse</button>
          <button onClick={() => onOpenComments?.(memoryId)} style={{ border: '1px solid #E5E5E5', borderRadius: 6, padding: '2px 8px', cursor: 'pointer', fontSize: 12 }}>Comment</button>
          <button onClick={() => onOpenRewind?.(memoryId)} style={{ border: '1px solid #E5E5E5', borderRadius: 6, padding: '2px 8px', cursor: 'pointer', fontSize: 12 }}>Rewind</button>
          <button onClick={() => onOpenShare?.(memoryId)} style={{ border: '1px solid #E5E5E5', borderRadius: 6, padding: '2px 8px', cursor: 'pointer', fontSize: 12 }}>Share</button>
          {branchId && (
            <button onClick={() => onOpenBranch?.(branchId)} style={{ border: '1px solid #E5E5E5', borderRadius: 6, padding: '2px 8px', cursor: 'pointer', fontSize: 12 }}>Branch</button>
          )}
        </div>
      </div>
    </Card>
  );
};
