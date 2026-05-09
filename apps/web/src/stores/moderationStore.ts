// SRS §23.2 Category 10 — State Management: moderationStore.ts
import { create } from 'zustand';
import type { ModerationQueueItem } from '../types/moderation.types';

interface ModerationState {
  queue: ModerationQueueItem[];
  setQueue: (items: ModerationQueueItem[]) => void;
  removeItem: (itemId: string) => void;
}

export const useModerationStore = create<ModerationState>()((set) => ({
  queue: [],
  setQueue: (queue) => set({ queue }),
  removeItem: (itemId) =>
    set((s) => ({ queue: s.queue.filter((i) => i.itemId !== itemId) })),
}));
