// SRS §23.2 Category 3 — Design System: TextArea.tsx
import React from 'react';

interface TextAreaProps extends React.TextareaHTMLAttributes<HTMLTextAreaElement> {
  label?: string;
  error?: string;
}

export const TextArea: React.FC<TextAreaProps> = ({ label, error, id, style, ...rest }) => (
  <div style={{ display: 'flex', flexDirection: 'column', gap: 4 }}>
    {label && <label htmlFor={id} style={{ fontSize: 13, fontWeight: 500 }}>{label}</label>}
    <textarea
      id={id}
      rows={4}
      style={{
        border: `1px solid ${error ? '#000' : '#D4D4D4'}`,
        borderRadius: 8,
        padding: '10px 14px',
        fontSize: 15,
        resize: 'vertical',
        fontFamily: 'inherit',
        ...style,
      }}
      {...rest}
    />
    {error && <span style={{ fontSize: 12, color: '#000' }}>{error}</span>}
  </div>
);
