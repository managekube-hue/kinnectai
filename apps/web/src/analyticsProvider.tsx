// SRS §23.2 Category 1 — App Foundation: analyticsProvider.tsx
import React, { createContext, useContext, useEffect } from 'react';
import { analytics } from './utils/analytics/analytics';

const AnalyticsContext = createContext<typeof analytics>(analytics);

export const useAnalytics = () => useContext(AnalyticsContext);

interface AnalyticsProviderProps {
  children: React.ReactNode;
}

export const AnalyticsProvider: React.FC<AnalyticsProviderProps> = ({ children }) => {
  useEffect(() => {
    analytics.init();
  }, []);

  return (
    <AnalyticsContext.Provider value={analytics}>
      {children}
    </AnalyticsContext.Provider>
  );
};
