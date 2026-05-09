'use client';

interface RouteErrorProps {
  title: string;
  error?: Error;
  reset?: () => void;
}

export default function RouteError({ title, error, reset }: RouteErrorProps) {
  return (
    <main style={{ padding: '2rem', color: '#111', background: '#fff', minHeight: '100dvh' }}>
      <h1 style={{ margin: 0, fontSize: '1.1rem' }}>{title}</h1>
      <p style={{ marginTop: '0.75rem', fontSize: '0.9rem' }}>
        {error?.message ?? 'Unexpected route error occurred.'}
      </p>
      {reset ? (
        <button
          type="button"
          onClick={reset}
          style={{ marginTop: '1rem', padding: '0.5rem 0.9rem', border: '1px solid #222', background: '#fff' }}
        >
          Retry
        </button>
      ) : null}
    </main>
  );
}