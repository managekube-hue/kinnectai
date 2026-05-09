// SRS §23.2 Category 2 — Auth Flow: ConsentFlowScreen.tsx
import React, { useState } from 'react';
import { useRouter } from 'next/navigation';
import { authApi } from '../../api/authApi';

export const ConsentFlowScreen: React.FC = () => {
  const router = useRouter();
  const [consent, setConsent] = useState({
    termsAccepted: false,
    privacyAccepted: false,
    marketingConsent: false,
    dnaConsent: false,
    biometricConsent: false,
  });
  const [loading, setLoading] = useState(false);

  const toggle = (key: keyof typeof consent) =>
    setConsent((c) => ({ ...c, [key]: !c[key] }));

  const canProceed = consent.termsAccepted && consent.privacyAccepted;

  const handleSubmit = async () => {
    setLoading(true);
    await authApi.submitConsent(consent);
    router.push('/onboarding');
    setLoading(false);
  };

  return (
    <div style={{ maxWidth: 480, margin: '80px auto', padding: 24 }}>
      <h2>Your privacy choices</h2>
      {Object.entries(consent).map(([key, val]) => (
        <label key={key} style={{ display: 'flex', gap: 12, marginBottom: 16, cursor: 'pointer' }}>
          <input type="checkbox" checked={val} onChange={() => toggle(key as keyof typeof consent)} />
          <span>{key.replace(/([A-Z])/g, ' $1').toLowerCase()}</span>
        </label>
      ))}
      <button onClick={handleSubmit} disabled={!canProceed || loading} style={{ width: '100%', marginTop: 16 }}>
        {loading ? 'Saving…' : 'Continue'}
      </button>
    </div>
  );
};

export default ConsentFlowScreen;
