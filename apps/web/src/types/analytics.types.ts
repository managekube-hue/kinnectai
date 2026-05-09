// SRS §23.2 Category 17 — Frontend Types: Analytics
export interface AnalyticsEvent {
  eventName: string;
  userId?: string;
  sessionId: string;
  properties: Record<string, string | number | boolean>;
  timestamp: number;
}

export interface SessionReplayConfig {
  enabled: boolean;
  sampleRate: number; // 0.0–1.0
  maskInputs: boolean;
}

export interface PerformanceMetric {
  metricName: string;
  value: number;
  unit: string;
  recordedAt: number;
}
