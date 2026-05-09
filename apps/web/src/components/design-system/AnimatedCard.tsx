// SRS §23.2 Category 3 — Design System: AnimatedCard.tsx
import React from 'react';

interface AnimatedCardProps {
  children: React.ReactNode;
  delay?: number;
  style?: React.CSSProperties;
}

export const AnimatedCard: React.FC<AnimatedCardProps> = ({ children, delay = 0, style }) => (
  <div
    style={{
      background: '#fff',
      borderRadius: 12,
      border: '1px solid #E5E5E5',
      padding: 20,
      animation: `fadeSlideIn 250ms ease ${delay}ms both`,
      ...style,
    }}
  >
    <style>{`
      @keyframes fadeSlideIn {
        from { opacity: 0; transform: translateY(8px); }
        to   { opacity: 1; transform: translateY(0); }
      }
    `}</style>
    {children}
  </div>
);
