// SRS §23.2 Category 10 — State Management: roomStore.ts
import { create } from 'zustand';
import type { Room, RoomParticipant, RoomTokenResponse } from '../types/room.types';

interface RoomState {
  currentRoom: Room | null;
  token: RoomTokenResponse | null;
  participants: RoomParticipant[];
  isConnected: boolean;
  isMuted: boolean;
  isCameraOff: boolean;
  setRoom: (room: Room, token: RoomTokenResponse) => void;
  setParticipants: (participants: RoomParticipant[]) => void;
  upsertParticipant: (participant: RoomParticipant) => void;
  removeParticipant: (participantId: string) => void;
  toggleMute: () => void;
  toggleCamera: () => void;
  setConnected: (connected: boolean) => void;
  clearRoom: () => void;
}

export const useRoomStore = create<RoomState>()((set) => ({
  currentRoom: null,
  token: null,
  participants: [],
  isConnected: false,
  isMuted: false,
  isCameraOff: false,
  setRoom: (room, token) => set({ currentRoom: room, token }),
  setParticipants: (participants) => set({ participants }),
  upsertParticipant: (p) =>
    set((s) => {
      const existing = s.participants.findIndex((x) => x.participantId === p.participantId);
      if (existing >= 0) {
        const updated = [...s.participants];
        updated[existing] = p;
        return { participants: updated };
      }
      return { participants: [...s.participants, p] };
    }),
  removeParticipant: (id) =>
    set((s) => ({ participants: s.participants.filter((p) => p.participantId !== id) })),
  toggleMute: () => set((s) => ({ isMuted: !s.isMuted })),
  toggleCamera: () => set((s) => ({ isCameraOff: !s.isCameraOff })),
  setConnected: (isConnected) => set({ isConnected }),
  clearRoom: () => set({ currentRoom: null, token: null, participants: [], isConnected: false }),
}));
