// SRS §23.2 Category 11 — API Client Layer: websocketClient.ts
import { env } from '../env';

type MessageHandler = (data: unknown) => void;

class WebSocketClient {
  private ws: WebSocket | null = null;
  private handlers = new Map<string, Set<MessageHandler>>();
  private reconnectAttempts = 0;
  private readonly maxReconnects = 5;

  connect(token?: string): void {
    const url = token ? `${env.wsBaseUrl}?token=${encodeURIComponent(token)}` : env.wsBaseUrl;
    this.ws = new WebSocket(url);

    this.ws.onmessage = (event: MessageEvent<string>) => {
      try {
        const msg = JSON.parse(event.data) as { type: string; payload: unknown };
        this.handlers.get(msg.type)?.forEach((h) => h(msg.payload));
      } catch {
        // malformed message — ignore
      }
    };

    this.ws.onclose = () => {
      if (this.reconnectAttempts < this.maxReconnects) {
        this.reconnectAttempts++;
        setTimeout(() => this.connect(token), 1000 * this.reconnectAttempts);
      }
    };

    this.ws.onopen = () => { this.reconnectAttempts = 0; };
  }

  disconnect(): void {
    this.ws?.close();
    this.ws = null;
  }

  on(eventType: string, handler: MessageHandler): () => void {
    if (!this.handlers.has(eventType)) this.handlers.set(eventType, new Set());
    this.handlers.get(eventType)!.add(handler);
    return () => this.handlers.get(eventType)?.delete(handler);
  }

  send(type: string, payload: unknown): void {
    if (this.ws?.readyState === WebSocket.OPEN) {
      this.ws.send(JSON.stringify({ type, payload }));
    }
  }
}

export const websocketClient = new WebSocketClient();
