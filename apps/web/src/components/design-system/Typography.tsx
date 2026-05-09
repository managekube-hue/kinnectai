// SRS §23.2 Category 3 — Design System: Typography.tsx
import React from 'react';

interface TypographyProps {
  variant?: 'h1' | 'h2' | 'h3' | 'body' | 'caption' | 'label';
  children: React.ReactNode;
  style?: React.CSSProperties;
}

const variantStyles: Record<NonNullable<TypographyProps['variant']>, React.CSSProperties> = {
  h1: { fontSize: 36, fontWeight: 700, lineHeight: 1.1 },
  h2: { fontSize: 24, fontWeight: 600, lineHeight: 1.2 },
  h3: { fontSize: 18, fontWeight: 600, lineHeight: 1.3 },
  body: { fontSize: 16, fontWeight: 400, lineHeight: 1.5 },
  caption: { fontSize: 12, fontWeight: 400, color: '#737373' },
  label: { fontSize: 13, fontWeight: 500 },
};

const tagMap: Record<NonNullable<TypographyProps['variant']>, keyof React.JSX.IntrinsicElements> = {
  h1: 'h1', h2: 'h2', h3: 'h3', body: 'p', caption: 'span', label: 'span',
};

export const Typography: React.FC<TypographyProps> = ({ variant = 'body', children, style }) => {
  const Tag = tagMap[variant];
  return <Tag style={{ ...variantStyles[variant], ...style }}>{children}</Tag>;
};
