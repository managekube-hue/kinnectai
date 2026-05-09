// SRS §23.2 Category 11 — API Client Layer: roomApi.ts
import { apiClient } from './apiClient';
import type { RoomTokenResponse } from '../types/room.types';

interface CreateRoomRequest {
  hostUserId: string;
  roomName?: string;
  maxParticipants?: number;
  recordingEnabled?: boolean;
}

export const roomApi = {
  createRoom: async (req: CreateRoomRequest): Promise<RoomTokenResponse> => {
    const { data } = await apiClient.post<RoomTokenResponse>('/rooms', {
      host_user_id: req.hostUserId,
      room_name: req.roomName,
      max_participants: req.maxParticipants,
      recording_enabled: req.recordingEnabled,
    });
    return data;
  },
  joinRoom: async (roomId: string): Promise<RoomTokenResponse> => {
    const { data } = await apiClient.post<RoomTokenResponse>(`/rooms/${roomId}/token`);
    return data;
  },
};
