'use client';

import WebAppShell from '@/WebAppShell';
import MemoryVaultScreen from '@/screens/vault/MemoryVaultScreen';

export default function VaultPage() {
  return (
    <WebAppShell>
      <MemoryVaultScreen />
    </WebAppShell>
  );
}
