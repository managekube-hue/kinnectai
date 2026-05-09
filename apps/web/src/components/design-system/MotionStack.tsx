// SRS §23.2 Category 3 — Design System: MotionStack.tsx
import React from 'react';

interface MotionStackProps {
  children: React.ReactNode;
  gap?: number;
  direction?: 'column' | 'row';
  style?: React.CSSProperties;
}

export const MotionStack: React.FC<MotionStackProps> = ({
  children, gap = 16, direction = 'column', style,
}) => (
  <div
    style={{
      display: 'flex',
      flexDirection: direction,
      gap,
      animation: 'stackEntrance 300ms ease both',
      ...style,
    }}
  >
    <style>{`
      @keyframes stackEntrance {
        from { opacity: 0; transform: translateY(12px); }
        to   { opacity: 1; transform: translateY(0); }
      }
    `}</style>
    {children}
  </div>
);
