'use client';

import WebAppShell from '@/WebAppShell';
import FeedScreen from '@/screens/feed/FeedScreen';

export default function HomePage() {
  return (
    <WebAppShell>
      <FeedScreen />
    </WebAppShell>
  );
}
