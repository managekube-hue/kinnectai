// SRS §23.2 Category 11 — API Client Layer: requestQueue.ts
// Serializes API calls to prevent race conditions on slow connections.
type QueuedRequest<T> = () => Promise<T>;

class RequestQueue {
  private queue: Array<() => void> = [];
  private running = 0;
  private readonly concurrency: number;

  constructor(concurrency = 3) {
    this.concurrency = concurrency;
  }

  enqueue<T>(request: QueuedRequest<T>): Promise<T> {
    return new Promise<T>((resolve, reject) => {
      this.queue.push(async () => {
        try { resolve(await request()); }
        catch (e) { reject(e); }
        finally { this.running--; this.next(); }
      });
      this.next();
    });
  }

  private next(): void {
    while (this.running < this.concurrency && this.queue.length > 0) {
      const task = this.queue.shift();
      if (task) { this.running++; task(); }
    }
  }
}

export const requestQueue = new RequestQueue();
