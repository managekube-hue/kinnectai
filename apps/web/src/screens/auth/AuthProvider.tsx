// SRS §23.2 Category 2 — Auth Flow: AuthProvider.tsx
import React, { createContext, useContext, useEffect } from 'react';
import { useAuthStore } from '../../stores/authStore';
import { authApi } from '../../api/authApi';

interface AuthContextValue {
  isAuthenticated: boolean;
  userId: string | null;
  logout: () => void;
}

const AuthContext = createContext<AuthContextValue>({
  isAuthenticated: false,
  userId: null,
  logout: () => undefined,
});

export const useAuth = () => useContext(AuthContext);

interface AuthProviderProps {
  children: React.ReactNode;
}

export const AuthProvider: React.FC<AuthProviderProps> = ({ children }) => {
  const { user, accessToken, clearAuth, setAuth } = useAuthStore();

  useEffect(() => {
    // Attempt silent token refresh on mount
    if (accessToken) {
      authApi.refresh().then(setAuth).catch(clearAuth);
    }
  }, []); // eslint-disable-line react-hooks/exhaustive-deps

  const value: AuthContextValue = {
    isAuthenticated: !!accessToken,
    userId: user?.id ?? null,
    logout: clearAuth,
  };

  return <AuthContext.Provider value={value}>{children}</AuthContext.Provider>;
};
