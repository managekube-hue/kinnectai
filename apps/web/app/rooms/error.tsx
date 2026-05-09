'use client';

import RouteError from '../_shared/RouteError';

export default function RoomsError({
  error,
  reset,
}: {
  error: Error;
  reset: () => void;
}) {
  return <RouteError title="Rooms route error" error={error} reset={reset} />;
}
