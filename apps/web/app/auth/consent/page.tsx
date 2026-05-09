'use client';

import WebAppShell from '@/WebAppShell';
import ConsentFlowScreen from '@/screens/auth/ConsentFlowScreen';

export default function ConsentPage() {
  return (
    <WebAppShell>
      <ConsentFlowScreen />
    </WebAppShell>
  );
}
