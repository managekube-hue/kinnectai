// SRS §23.2 Category 15 — Analytics: performanceMetrics.ts
export interface WebVital {
  name: 'FCP' | 'LCP' | 'FID' | 'CLS' | 'TTFB';
  value: number;
  rating: 'good' | 'needs-improvement' | 'poor';
}

function getRating(name: WebVital['name'], value: number): WebVital['rating'] {
  const thresholds: Record<WebVital['name'], [number, number]> = {
    FCP: [1800, 3000],
    LCP: [2500, 4000],
    FID: [100, 300],
    CLS: [0.1, 0.25],
    TTFB: [800, 1800],
  };
  const [good, poor] = thresholds[name];
  return value <= good ? 'good' : value <= poor ? 'needs-improvement' : 'poor';
}

export function reportWebVital(vital: Omit<WebVital, 'rating'>): WebVital {
  const rated: WebVital = { ...vital, rating: getRating(vital.name, vital.value) };
  // In production, forward to analytics backend
  console.debug('[perf]', rated);
  return rated;
}

export function measureNavigationTiming(): PerformanceNavigationTiming | null {
  const entries = performance.getEntriesByType('navigation') as PerformanceNavigationTiming[];
  return entries[0] ?? null;
}
