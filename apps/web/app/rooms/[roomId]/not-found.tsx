export default function RoomNotFound() {
  return (
    <main style={{ padding: '2rem', color: '#111', background: '#fff', minHeight: '100dvh' }}>
      <h1 style={{ margin: 0, fontSize: '1.1rem' }}>Room not found</h1>
      <p style={{ marginTop: '0.75rem', fontSize: '0.9rem' }}>
        The requested room does not exist or is no longer accessible.
      </p>
    </main>
  );
}
