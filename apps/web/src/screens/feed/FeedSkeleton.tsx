// SRS §23.2 Category 4 — Feed System: FeedSkeleton.tsx
import React from 'react';

interface FeedSkeletonProps {
  count?: number;
}

const SkeletonBlock: React.FC<{ width: string; height: number; marginBottom?: number }> = ({
  width, height, marginBottom = 0,
}) => (
  <div style={{
    width, height, borderRadius: 6,
    background: 'linear-gradient(90deg,#F5F5F5 25%,#E5E5E5 50%,#F5F5F5 75%)',
    backgroundSize: '200% 100%',
    animation: 'shimmer 1.2s infinite',
    marginBottom,
  }} />
);

export const FeedSkeleton: React.FC<FeedSkeletonProps> = ({ count = 3 }) => (
  <>
    <style>{`
      @keyframes shimmer {
        from { background-position: 200% 0; }
        to   { background-position: -200% 0; }
      }
    `}</style>
    {Array.from({ length: count }).map((_, i) => (
      <div key={i} style={{ padding: 16, borderRadius: 12, border: '1px solid #E5E5E5', marginBottom: 12 }}>
        <div style={{ display: 'flex', gap: 12, marginBottom: 12 }}>
          <div style={{ width: 40, height: 40, borderRadius: '50%', background: '#E5E5E5' }} />
          <div style={{ flex: 1 }}>
            <SkeletonBlock width="40%" height={14} marginBottom={6} />
            <SkeletonBlock width="25%" height={11} />
          </div>
        </div>
        <SkeletonBlock width="100%" height={14} marginBottom={6} />
        <SkeletonBlock width="75%" height={14} />
      </div>
    ))}
  </>
);
