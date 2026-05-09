'use client';

import RouteError from '../_shared/RouteError';

export default function DiscoverError({
  error,
  reset,
}: {
  error: Error;
  reset: () => void;
}) {
  return <RouteError title="Discovery route error" error={error} reset={reset} />;
}
