'use client';

import RouteError from '../_shared/RouteError';

export default function VaultError({
  error,
  reset,
}: {
  error: Error;
  reset: () => void;
}) {
  return <RouteError title="Vault route error" error={error} reset={reset} />;
}
