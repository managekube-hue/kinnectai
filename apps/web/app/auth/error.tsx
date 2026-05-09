'use client';

import RouteError from '../_shared/RouteError';

export default function AuthError({
  error,
  reset,
}: {
  error: Error;
  reset: () => void;
}) {
  return <RouteError title="Authentication route error" error={error} reset={reset} />;
}
