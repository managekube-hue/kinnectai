// SRS §23.2 Category 11 — API Client Layer: feedApi.ts
import { apiClient } from './apiClient';
import type { FeedGet200Response } from '../types/feed.types';

export const feedApi = {
  getFeed: async (cursor?: string): Promise<FeedGet200Response> => {
    const { data } = await apiClient.get<FeedGet200Response>('/feed', {
      params: cursor ? { cursor } : undefined,
    });
    return data;
  },
  sendPulse: async (targetId: string, pulseType: string): Promise<void> => {
    await apiClient.post('/pulses', { target_id: targetId, pulse_type: pulseType });
  },
};
