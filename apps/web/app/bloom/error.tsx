'use client';

import RouteError from '../_shared/RouteError';

export default function BloomError({
  error,
  reset,
}: {
  error: Error;
  reset: () => void;
}) {
  return <RouteError title="Bloom route error" error={error} reset={reset} />;
}
