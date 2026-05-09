// SRS §23.2 Category 10 — State Management: discoveryStore.ts
import { create } from 'zustand';
import type { DiscoveryCard } from '../types/discovery.types';

interface DiscoveryState {
  candidates: DiscoveryCard[];
  nextCursor: string | null;
  hasMore: boolean;
  setCandidates: (candidates: DiscoveryCard[], nextCursor: string | null, hasMore: boolean) => void;
  dismissCandidate: (matchId: string) => void;
  reset: () => void;
}

export const useDiscoveryStore = create<DiscoveryState>()((set) => ({
  candidates: [],
  nextCursor: null,
  hasMore: true,
  setCandidates: (candidates, nextCursor, hasMore) => set({ candidates, nextCursor, hasMore }),
  dismissCandidate: (matchId) =>
    set((s) => ({ candidates: s.candidates.filter((c) => c.matchId !== matchId) })),
  reset: () => set({ candidates: [], nextCursor: null, hasMore: true }),
}));
