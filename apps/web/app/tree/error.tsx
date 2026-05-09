'use client';

import RouteError from '../_shared/RouteError';

export default function TreeError({
  error,
  reset,
}: {
  error: Error;
  reset: () => void;
}) {
  return <RouteError title="Tree route error" error={error} reset={reset} />;
}
