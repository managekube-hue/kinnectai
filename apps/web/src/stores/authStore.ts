// SRS §23.2 Category 10 — State Management: authStore.ts
import { create } from 'zustand';
import { persist } from 'zustand/middleware';
import type { AuthUser, AuthResponse } from '../types/auth.types';

interface AuthState {
  user: AuthUser | null;
  accessToken: string | null;
  expiresAt: number | null;
  setAuth: (response: AuthResponse) => void;
  clearAuth: () => void;
}

export const useAuthStore = create<AuthState>()(
  persist(
    (set) => ({
      user: null,
      accessToken: null,
      expiresAt: null,
      setAuth: (response) =>
        set({
          user: response.user,
          accessToken: response.accessToken,
          expiresAt: response.expiresAt,
        }),
      clearAuth: () => set({ user: null, accessToken: null, expiresAt: null }),
    }),
    { name: 'kinnectai-auth' },
  ),
);
