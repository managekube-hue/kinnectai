// SRS §23.2 Category 15 — Analytics: sessionReplay.ts
import { env } from '../../env';

let replayActive = false;

export const sessionReplay = {
  start(userId: string): void {
    if (replayActive || !env.isProd) return;
    replayActive = true;
    // In production wire up FullStory/LogRocket/PostHog session recording
    if (env.isDev) console.debug('[sessionReplay] start for', userId);
  },
  stop(): void {
    if (!replayActive) return;
    replayActive = false;
    if (env.isDev) console.debug('[sessionReplay] stopped');
  },
  maskElement(selector: string): void {
    // Mark sensitive DOM elements as masked in replay
    document.querySelectorAll(selector).forEach((el) => {
      (el as HTMLElement).setAttribute('data-replay-mask', 'true');
    });
  },
};
