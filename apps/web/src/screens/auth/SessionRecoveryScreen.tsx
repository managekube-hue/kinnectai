// SRS §23.2 Category 2 — Auth Flow: SessionRecoveryScreen.tsx
import React, { useEffect, useState } from 'react';
import { useRouter } from 'next/navigation';
import { authApi } from '../../api/authApi';
import { useAuthStore } from '../../stores/authStore';

export const SessionRecoveryScreen: React.FC = () => {
  const router = useRouter();
  const setAuth = useAuthStore((s) => s.setAuth);
  const clearAuth = useAuthStore((s) => s.clearAuth);
  const [status, setStatus] = useState<'recovering' | 'failed'>('recovering');

  useEffect(() => {
    authApi.refresh()
      .then((res) => {
        setAuth(res);
        router.push('/feed');
      })
      .catch(() => {
        clearAuth();
        setStatus('failed');
      });
  }, []); // eslint-disable-line react-hooks/exhaustive-deps

  if (status === 'recovering') {
    return <div style={{ padding: 40, textAlign: 'center' }}>Recovering session…</div>;
  }

  return (
    <div style={{ padding: 40, textAlign: 'center' }}>
      <p>Your session has expired.</p>
      <a href="/login">Sign in again</a>
    </div>
  );
};

export default SessionRecoveryScreen;
