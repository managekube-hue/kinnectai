// SRS §23.2 Category 11 — API Client Layer: retryPolicy.ts
const MAX_RETRIES = 3;
const RETRYABLE_STATUS_CODES = new Set([429, 502, 503, 504]);

function shouldRetry(error: unknown, retryCount: number): boolean {
  if (retryCount >= MAX_RETRIES) return false;
  if (!error || typeof error !== 'object') return false;
  const status = (error as { response?: { status?: number } }).response?.status;
  if (status && RETRYABLE_STATUS_CODES.has(status)) return true;
  const code = (error as { code?: string }).code;
  return code === 'ECONNABORTED' || code === 'ERR_NETWORK';
}

function delay(attempt: number): Promise<void> {
  const ms = Math.min(1000 * 2 ** (attempt - 1), 8000);
  return new Promise((resolve) => setTimeout(resolve, ms));
}

export const retryPolicy = { shouldRetry, delay, MAX_RETRIES };
