// SRS §23.2 Category 2 — Auth Flow: MFAChallengeScreen.tsx
import React, { useMemo, useState } from 'react';
import { useRouter } from 'next/navigation';
import { authApi } from '../../api/authApi';
import { useAuthStore } from '../../stores/authStore';
import type { MFAChallenge } from '../../types/auth.types';

export const MFAChallengeScreen: React.FC = () => {
  const router = useRouter();
  const setAuth = useAuthStore((s) => s.setAuth);
  const challenge = useMemo(() => {
    try {
      const raw = sessionStorage.getItem('kinnect:mfaChallenge');
      if (!raw) return undefined;
      return JSON.parse(raw) as MFAChallenge;
    } catch {
      return undefined;
    }
  }, []);
  const [code, setCode] = useState('');
  const [error, setError] = useState<string | null>(null);
  const [loading, setLoading] = useState(false);

  const handleVerify = async (e: React.FormEvent) => {
    e.preventDefault();
    if (!challenge) return;
    setLoading(true);
    setError(null);
    try {
      const result = await authApi.verifyMFA({ challengeId: challenge.challengeId, code });
      setAuth(result);
      sessionStorage.removeItem('kinnect:mfaChallenge');
      router.push('/feed');
    } catch (err: unknown) {
      setError(err instanceof Error ? err.message : 'Verification failed');
    } finally {
      setLoading(false);
    }
  };

  return (
    <div style={{ maxWidth: 400, margin: '80px auto', padding: 24 }}>
      <h2>Two-factor verification</h2>
      <p style={{ color: '#737373' }}>
        Enter the {challenge?.method === 'totp' ? 'authenticator app' : 'SMS'} code.
      </p>
      <form onSubmit={handleVerify}>
        <input
          type="text"
          inputMode="numeric"
          pattern="[0-9]{6}"
          maxLength={6}
          value={code}
          onChange={(e) => setCode(e.target.value)}
          placeholder="000000"
          required
          style={{ display: 'block', width: '100%', fontSize: 24, textAlign: 'center', marginBottom: 16 }}
        />
        {error && <p role="alert" style={{ color: 'red' }}>{error}</p>}
        <button type="submit" disabled={loading || code.length !== 6} style={{ width: '100%' }}>
          {loading ? 'Verifying…' : 'Verify'}
        </button>
      </form>
    </div>
  );
};

export default MFAChallengeScreen;
