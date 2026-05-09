// SRS §23.2 Category 1 — App Foundation: realtimeProvider.tsx
import React, { createContext, useContext, useEffect, useRef } from 'react';
import { websocketClient } from './api/websocketClient';

const RealtimeContext = createContext(websocketClient);
export const useRealtime = () => useContext(RealtimeContext);

interface RealtimeProviderProps {
  children: React.ReactNode;
}

export const RealtimeProvider: React.FC<RealtimeProviderProps> = ({ children }) => {
  const initialized = useRef(false);

  useEffect(() => {
    if (!initialized.current) {
      initialized.current = true;
      websocketClient.connect();
    }
    return () => {
      websocketClient.disconnect();
    };
  }, []);

  return (
    <RealtimeContext.Provider value={websocketClient}>
      {children}
    </RealtimeContext.Provider>
  );
};
