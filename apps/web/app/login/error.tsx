'use client';

import RouteError from '../_shared/RouteError';

export default function LoginError({
  error,
  reset,
}: {
  error: Error;
  reset: () => void;
}) {
  return <RouteError title="Login route error" error={error} reset={reset} />;
}
