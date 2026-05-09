// SRS §23.2 Category 3 — Design System: Button.tsx
import React from 'react';

interface ButtonProps extends React.ButtonHTMLAttributes<HTMLButtonElement> {
  variant?: 'primary' | 'secondary' | 'ghost' | 'danger';
  size?: 'sm' | 'md' | 'lg';
  loading?: boolean;
}

const styles: Record<string, React.CSSProperties> = {
  base: {
    display: 'inline-flex',
    alignItems: 'center',
    justifyContent: 'center',
    fontWeight: 600,
    borderRadius: 8,
    cursor: 'pointer',
    border: 'none',
    transition: 'opacity 150ms ease',
  },
  primary: { background: '#000', color: '#fff' },
  secondary: { background: '#F5F5F5', color: '#000' },
  ghost: { background: 'transparent', color: '#000', border: '1px solid #E5E5E5' },
  danger: { background: '#000', color: '#fff', opacity: 0.9 },
  sm: { padding: '6px 12px', fontSize: 13 },
  md: { padding: '10px 20px', fontSize: 15 },
  lg: { padding: '14px 28px', fontSize: 17 },
};

export const Button: React.FC<ButtonProps> = ({
  variant = 'primary',
  size = 'md',
  loading = false,
  children,
  disabled,
  style,
  ...rest
}) => (
  <button
    {...rest}
    disabled={disabled || loading}
    style={{
      ...styles.base,
      ...styles[variant],
      ...styles[size],
      opacity: disabled || loading ? 0.5 : 1,
      ...style,
    }}
  >
    {loading ? 'Loading…' : children}
  </button>
);
