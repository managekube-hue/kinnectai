// SRS §23.2 Category 3 — Design System: GlassPanel.tsx
import React from 'react';

interface GlassPanelProps {
  children: React.ReactNode;
  style?: React.CSSProperties;
}

export const GlassPanel: React.FC<GlassPanelProps> = ({ children, style }) => (
  <div
    style={{
      background: 'rgba(255,255,255,0.85)',
      backdropFilter: 'blur(12px)',
      WebkitBackdropFilter: 'blur(12px)',
      borderRadius: 16,
      border: '1px solid rgba(255,255,255,0.6)',
      padding: 20,
      ...style,
    }}
  >
    {children}
  </div>
);
