interface RouteLoadingProps {
  label?: string;
}

export default function RouteLoading({ label = 'Loading view...' }: RouteLoadingProps) {
  return (
    <main style={{ padding: '2rem', color: '#111', background: '#fff', minHeight: '100dvh' }}>
      <p style={{ margin: 0, fontSize: '0.95rem' }}>{label}</p>
    </main>
  );
}