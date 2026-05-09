'use client';

import RouteError from '../../_shared/RouteError';

export default function RoomDetailError({
  error,
  reset,
}: {
  error: Error;
  reset: () => void;
}) {
  return <RouteError title="Room detail route error" error={error} reset={reset} />;
}
