// SRS §23.2 Category 3 — Design System: Input.tsx
import React from 'react';

interface InputProps extends React.InputHTMLAttributes<HTMLInputElement> {
  label?: string;
  error?: string;
}

export const Input: React.FC<InputProps> = ({ label, error, id, style, ...rest }) => (
  <div style={{ display: 'flex', flexDirection: 'column', gap: 4 }}>
    {label && <label htmlFor={id} style={{ fontSize: 13, fontWeight: 500 }}>{label}</label>}
    <input
      id={id}
      style={{
        border: `1px solid ${error ? '#000' : '#D4D4D4'}`,
        borderRadius: 8,
        padding: '10px 14px',
        fontSize: 15,
        outline: 'none',
        width: '100%',
        boxSizing: 'border-box',
        ...style,
      }}
      {...rest}
    />
    {error && <span style={{ fontSize: 12, color: '#000' }}>{error}</span>}
  </div>
);
