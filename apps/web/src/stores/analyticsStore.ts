// SRS §23.2 Category 10 — State Management: analyticsStore.ts
import { create } from 'zustand';
import type { AnalyticsEvent } from '../types/analytics.types';

interface AnalyticsState {
  sessionId: string;
  eventQueue: AnalyticsEvent[];
  enqueueEvent: (event: Omit<AnalyticsEvent, 'sessionId' | 'timestamp'>) => void;
  flushQueue: () => AnalyticsEvent[];
}

export const useAnalyticsStore = create<AnalyticsState>()((set, get) => ({
  sessionId: crypto.randomUUID(),
  eventQueue: [],
  enqueueEvent: (event) =>
    set((s) => ({
      eventQueue: [
        ...s.eventQueue,
        { ...event, sessionId: s.sessionId, timestamp: Date.now() },
      ],
    })),
  flushQueue: () => {
    const { eventQueue } = get();
    set({ eventQueue: [] });
    return eventQueue;
  },
}));
