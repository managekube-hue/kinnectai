// SRS §23.2 Category 2 — Auth Flow: OnboardingScreen.tsx
import React, { useState } from 'react';
import { useRouter } from 'next/navigation';

const STEPS = ['Welcome', 'Profile', 'DNA Consent', 'Notifications'] as const;

export const OnboardingScreen: React.FC = () => {
  const router = useRouter();
  const [step, setStep] = useState(0);

  const next = () => {
    if (step < STEPS.length - 1) {
      setStep((s) => s + 1);
    } else {
      router.push('/feed');
    }
  };

  return (
    <div style={{ maxWidth: 480, margin: '80px auto', padding: 24 }}>
      <div style={{ display: 'flex', gap: 8, marginBottom: 32 }}>
        {STEPS.map((s, i) => (
          <div
            key={s}
            style={{
              flex: 1,
              height: 4,
              background: i <= step ? '#000' : '#E5E5E5',
              borderRadius: 2,
            }}
          />
        ))}
      </div>
      <h2>{STEPS[step]}</h2>
      <p style={{ color: '#737373', marginBottom: 32 }}>
        Step {step + 1} of {STEPS.length}
      </p>
      <button onClick={next} style={{ width: '100%' }}>
        {step < STEPS.length - 1 ? 'Continue' : 'Get started'}
      </button>
    </div>
  );
};

export default OnboardingScreen;
