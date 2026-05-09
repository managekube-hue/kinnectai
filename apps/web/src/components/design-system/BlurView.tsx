// SRS §23.2 Category 3 — Design System: BlurView.tsx
import React from 'react';

interface BlurViewProps {
  intensity?: number;
  children: React.ReactNode;
  style?: React.CSSProperties;
}

export const BlurView: React.FC<BlurViewProps> = ({ intensity = 8, children, style }) => (
  <div
    style={{
      backdropFilter: `blur(${intensity}px)`,
      WebkitBackdropFilter: `blur(${intensity}px)`,
      ...style,
    }}
  >
    {children}
  </div>
);
