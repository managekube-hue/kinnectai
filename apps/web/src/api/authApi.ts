// SRS §23.2 Category 11 — API Client Layer: authApi.ts
import { apiClient } from './apiClient';
import type { AuthResponse, MFAChallenge, ConsentFlags } from '../types/auth.types';

interface LoginRequest { email: string; password: string; }
interface RegisterRequest { username: string; email: string; password: string; displayName: string; }
interface MFAVerifyRequest { challengeId: string; code: string; }

export const authApi = {
  login: async (req: LoginRequest): Promise<AuthResponse | MFAChallenge> => {
    const { data } = await apiClient.post<AuthResponse | MFAChallenge>('/auth/login', req);
    return data;
  },
  register: async (req: RegisterRequest): Promise<AuthResponse> => {
    const { data } = await apiClient.post<AuthResponse>('/auth/signup', req);
    return data;
  },
  refresh: async (): Promise<AuthResponse> => {
    const { data } = await apiClient.post<AuthResponse>('/auth/refresh');
    return data;
  },
  verifyMFA: async (req: MFAVerifyRequest): Promise<AuthResponse> => {
    const { data } = await apiClient.post<AuthResponse>('/auth/mfa/verify', req);
    return data;
  },
  submitConsent: async (flags: ConsentFlags): Promise<void> => {
    await apiClient.post('/auth/consent', flags);
  },
  logout: async (): Promise<void> => {
    await apiClient.post('/auth/logout');
  },
};
