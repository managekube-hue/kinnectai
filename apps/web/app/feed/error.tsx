'use client';

import RouteError from '../_shared/RouteError';

export default function FeedError({
  error,
  reset,
}: {
  error: Error;
  reset: () => void;
}) {
  return <RouteError title="Feed route error" error={error} reset={reset} />;
}
