'use client';

import RouteError from '../_shared/RouteError';

export default function OnboardingError({
  error,
  reset,
}: {
  error: Error;
  reset: () => void;
}) {
  return <RouteError title="Onboarding route error" error={error} reset={reset} />;
}
