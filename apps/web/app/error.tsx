'use client';

import RouteError from './_shared/RouteError';

export default function GlobalError({
  error,
  reset,
}: {
  error: Error;
  reset: () => void;
}) {
  return <RouteError title="Application error" error={error} reset={reset} />;
}