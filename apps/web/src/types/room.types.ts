// SRS §23.2 Category 17 — Frontend Types: Room
export interface Room {
  roomId: string;
  hostUserId: string;
  roomName: string;
  status: 'pending' | 'active' | 'ended';
  maxParticipants: number;
  recordingEnabled: boolean;
  createdAt: string;
  endedAt?: string;
}

export interface RoomTokenResponse {
  roomId: string;
  token: string;
  hlsUrl?: string;
  iceServers: IceServer[];
  expiresAt: number;
}

export interface IceServer {
  urls: string[];
  username?: string;
  credential?: string;
}

export interface RoomParticipant {
  participantId: string;
  roomId: string;
  userId: string;
  displayName: string;
  role: 'host' | 'attendee' | 'observer';
  joinedAt: string;
  leftAt?: string;
}

export interface ParticipantBandwidthState {
  participantId: string;
  uploadKbps: number;
  downloadKbps: number;
  packetLossPct: number;
  jitterMs: number;
}

export interface HLSRecoveryState {
  roomId: string;
  recordingId: string;
  lastSegmentUrl: string;
  playheadSeconds: number;
  isRecoverable: boolean;
}
