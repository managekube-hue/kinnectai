'use client';

import RouteError from '../_shared/RouteError';

export default function NotificationsError({
  error,
  reset,
}: {
  error: Error;
  reset: () => void;
}) {
  return <RouteError title="Notifications route error" error={error} reset={reset} />;
}
