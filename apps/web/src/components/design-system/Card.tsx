// SRS §23.2 Category 3 — Design System: Card.tsx
import React from 'react';

interface CardProps {
  children: React.ReactNode;
  padding?: number;
  style?: React.CSSProperties;
  onClick?: () => void;
}

export const Card: React.FC<CardProps> = ({ children, padding = 20, style, onClick }) => (
  <div
    onClick={onClick}
    style={{
      background: '#fff',
      borderRadius: 12,
      border: '1px solid #E5E5E5',
      padding,
      cursor: onClick ? 'pointer' : undefined,
      transition: 'box-shadow 150ms ease',
      ...style,
    }}
  >
    {children}
  </div>
);
