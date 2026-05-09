// SRS §23.2 Category 3 — Design System: Toast.tsx
import React, { useEffect } from 'react';

interface ToastProps {
  message: string;
  type?: 'info' | 'success' | 'error';
  onDismiss: () => void;
  duration?: number;
}

export const Toast: React.FC<ToastProps> = ({ message, type = 'info', onDismiss, duration = 3000 }) => {
  useEffect(() => {
    const t = setTimeout(onDismiss, duration);
    return () => clearTimeout(t);
  }, [onDismiss, duration]);

  return (
    <div
      role="status"
      aria-live="polite"
      style={{
        position: 'fixed', bottom: 24, left: '50%', transform: 'translateX(-50%)',
        background: type === 'error' ? '#000' : '#262626',
        color: '#fff', padding: '12px 20px', borderRadius: 8,
        fontSize: 14, fontWeight: 500, zIndex: 2000,
        boxShadow: '0 4px 12px rgba(0,0,0,0.3)',
        maxWidth: '90vw',
      }}
    >
      {message}
    </div>
  );
};
