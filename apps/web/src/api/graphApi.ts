// SRS §23.2 Category 11 — API Client Layer: graphApi.ts
import { apiClient } from './apiClient';
import type { KinnectionPath } from '../types/graph.types';

interface KinnectionListResponse {
  kinnections: Array<{ kinnectionId: string; relatedUserId: string; displayName: string; kinScore: number }>;
  total: number;
  nextCursor?: string;
}

export const graphApi = {
  getKinnections: async (userId: string, cursor?: string): Promise<KinnectionListResponse> => {
    const { data } = await apiClient.get<KinnectionListResponse>(`/kin-graph/${userId}/kinnections`, {
      params: cursor ? { cursor } : undefined,
    });
    return data;
  },
  getPath: async (fromUserId: string, toUserId: string): Promise<KinnectionPath> => {
    const { data } = await apiClient.get<KinnectionPath>('/kin-graph/path', {
      params: { from: fromUserId, to: toUserId },
    });
    return data;
  },
};
