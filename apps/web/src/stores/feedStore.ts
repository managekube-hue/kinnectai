// SRS §23.2 Category 10 — State Management: feedStore.ts
import { create } from 'zustand';
import type { FeedItem, FeedCursor } from '../types/feed.types';

interface FeedState {
  items: FeedItem[];
  cursor: FeedCursor | null;
  hasMore: boolean;
  isLoading: boolean;
  setItems: (items: FeedItem[], cursor: FeedCursor, hasMore: boolean) => void;
  appendItems: (items: FeedItem[], cursor: FeedCursor, hasMore: boolean) => void;
  setLoading: (loading: boolean) => void;
  reset: () => void;
}

export const useFeedStore = create<FeedState>()((set) => ({
  items: [],
  cursor: null,
  hasMore: true,
  isLoading: false,
  setItems: (items, cursor, hasMore) => set({ items, cursor, hasMore }),
  appendItems: (items, cursor, hasMore) =>
    set((s) => ({ items: [...s.items, ...items], cursor, hasMore })),
  setLoading: (isLoading) => set({ isLoading }),
  reset: () => set({ items: [], cursor: null, hasMore: true }),
}));
