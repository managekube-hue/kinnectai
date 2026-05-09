'use client';

import WebAppShell from '@/WebAppShell';
import MFAChallengeScreen from '@/screens/auth/MFAChallengeScreen';

export default function MFAPage() {
  return (
    <WebAppShell>
      <MFAChallengeScreen />
    </WebAppShell>
  );
}
