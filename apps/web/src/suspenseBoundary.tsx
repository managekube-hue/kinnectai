// SRS §23.2 Category 1 — App Foundation: suspenseBoundary.tsx
import React from 'react';

interface SuspenseBoundaryProps {
  children: React.ReactNode;
  fallback?: React.ReactNode;
}

export const SuspenseBoundary: React.FC<SuspenseBoundaryProps> = ({
  children,
  fallback = <div style={{ padding: 32, textAlign: 'center' }}>Loading…</div>,
}) => (
  <React.Suspense fallback={fallback}>
    {children}
  </React.Suspense>
);
