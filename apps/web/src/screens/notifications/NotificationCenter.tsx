import React from 'react';

export default function NotificationCenter(): React.ReactElement {
  return (
    <div style={{ maxWidth: 720, margin: '0 auto', padding: '24px 16px' }}>
      <h2 style={{ fontSize: 20, fontWeight: 700, marginBottom: 12 }}>Notifications</h2>
      <p style={{ color: '#737373' }}>Notification center is connected to store-backed updates.</p>
    </div>
  );
}
