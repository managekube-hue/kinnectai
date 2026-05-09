'use client';

import RouteError from '../_shared/RouteError';

export default function SignupError({
  error,
  reset,
}: {
  error: Error;
  reset: () => void;
}) {
  return <RouteError title="Signup route error" error={error} reset={reset} />;
}
