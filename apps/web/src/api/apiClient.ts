// SRS §23.2 Category 11 — API Client Layer: apiClient.ts
import axios, { type AxiosInstance, type AxiosRequestConfig } from 'axios';
import { env } from '../env';
import { useAuthStore } from '../stores/authStore';
import { retryPolicy } from './retryPolicy';

const createApiClient = (): AxiosInstance => {
  const client = axios.create({
    baseURL: env.apiBaseUrl,
    timeout: 15_000,
    headers: { 'Content-Type': 'application/json' },
  });

  client.interceptors.request.use((config) => {
    const token = useAuthStore.getState().accessToken;
    if (token) {
      config.headers.Authorization = `Bearer ${token}`;
    }
    return config;
  });

  client.interceptors.response.use(
    (res) => res,
    async (error) => {
      const config = error.config as AxiosRequestConfig & { _retryCount?: number };
      if (retryPolicy.shouldRetry(error, config._retryCount ?? 0)) {
        config._retryCount = (config._retryCount ?? 0) + 1;
        await retryPolicy.delay(config._retryCount);
        return client(config);
      }
      if (error.response?.status === 401) {
        useAuthStore.getState().clearAuth();
      }
      return Promise.reject(error);
    },
  );

  return client;
};

export const apiClient = createApiClient();
