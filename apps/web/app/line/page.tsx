'use client';

import WebAppShell from '@/WebAppShell';
import FeedScreen from '@/screens/feed/FeedScreen';

export default function LinePage() {
  return (
    <WebAppShell>
      <FeedScreen />
    </WebAppShell>
  );
}
