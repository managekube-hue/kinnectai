// SRS §23.2 Category 5 — Discovery System: SharedAncestorsGraph.tsx
import React from 'react';

interface SharedAncestorsGraphProps {
  ancestors: string[];
  currentUserId: string;
  matchUserId: string;
}

export const SharedAncestorsGraph: React.FC<SharedAncestorsGraphProps> = ({
  ancestors,
  currentUserId,
  matchUserId,
}) => {
  if (!ancestors.length) return null;

  return (
    <div style={{ padding: 16, background: '#FAFAFA', borderRadius: 10, marginTop: 12 }}>
      <div style={{ fontSize: 12, fontWeight: 600, color: '#737373', marginBottom: 10 }}>
        SHARED ANCESTORS
      </div>
      <div style={{ display: 'flex', flexDirection: 'column', gap: 8 }}>
        {ancestors.map((ancestor) => (
          <div key={ancestor} style={{ display: 'flex', alignItems: 'center', gap: 8, fontSize: 13 }}>
            <div style={{ width: 8, height: 8, borderRadius: '50%', background: '#000' }} />
            <span>{ancestor}</span>
          </div>
        ))}
      </div>
      <div style={{ marginTop: 10, fontSize: 11, color: '#A3A3A3' }}>
        {currentUserId} ← {ancestors.length} shared → {matchUserId}
      </div>
    </div>
  );
};
