'use client';

import WebAppShell from '@/WebAppShell';
import SessionRecoveryScreen from '@/screens/auth/SessionRecoveryScreen';

export default function RecoverPage() {
  return (
    <WebAppShell>
      <SessionRecoveryScreen />
    </WebAppShell>
  );
}
