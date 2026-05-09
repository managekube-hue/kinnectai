// SRS §23.2 Category 11 — API Client Layer: discoveryApi.ts
import { apiClient } from './apiClient';
import type { DiscoveryList, DiscoveryDismissPostRequest } from '../types/discovery.types';

export const discoveryApi = {
  getCandidates: async (cursor?: string): Promise<DiscoveryList> => {
    const { data } = await apiClient.get<DiscoveryList>('/discovery', {
      params: cursor ? { cursor } : undefined,
    });
    return data;
  },
  dismiss: async (req: DiscoveryDismissPostRequest): Promise<void> => {
    await apiClient.post('/discovery/dismiss', req);
  },
};
