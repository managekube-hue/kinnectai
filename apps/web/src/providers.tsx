// SRS §23.2 Category 1 — App Foundation: providers.tsx
import React from 'react';
import { AuthProvider } from './screens/auth/AuthProvider';
import { AnalyticsProvider } from './analyticsProvider';
import { RealtimeProvider } from './realtimeProvider';

interface ProvidersProps {
  children: React.ReactNode;
}

export const Providers: React.FC<ProvidersProps> = ({ children }) => (
  <AuthProvider>
    <AnalyticsProvider>
      <RealtimeProvider>
        {children}
      </RealtimeProvider>
    </AnalyticsProvider>
  </AuthProvider>
);
