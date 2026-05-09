// SRS §23.2 Category 5 — Discovery System: ConfidenceBreakdown.tsx
import React from 'react';

interface ConfidenceBreakdownProps {
  kinScore: number;
  confidence?: number;
}

export const ConfidenceBreakdown: React.FC<ConfidenceBreakdownProps> = ({ kinScore, confidence }) => {
  const pct = Math.min(100, Math.round(kinScore * 100));
  const conf = confidence !== undefined ? Math.round(confidence * 100) : null;

  return (
    <div>
      <div style={{ display: 'flex', alignItems: 'center', gap: 8 }}>
        <div style={{ flex: 1, height: 4, background: '#E5E5E5', borderRadius: 2, overflow: 'hidden' }}>
          <div style={{ width: `${pct}%`, height: '100%', background: '#000', borderRadius: 2 }} />
        </div>
        <span style={{ fontSize: 12, fontWeight: 600, minWidth: 36 }}>{pct}%</span>
      </div>
      {conf !== null && (
        <div style={{ fontSize: 11, color: '#A3A3A3', marginTop: 2 }}>
          {conf}% confidence
        </div>
      )}
    </div>
  );
};
