// SRS §23.2 Category 3 — Design System: Avatar.tsx
import React from 'react';

interface AvatarProps {
  src?: string;
  name: string;
  size?: number;
}

export const Avatar: React.FC<AvatarProps> = ({ src, name, size = 40 }) => {
  const initials = name.split(' ').map((w) => w[0]).slice(0, 2).join('').toUpperCase();
  return src ? (
    <img
      src={src}
      alt={name}
      style={{ width: size, height: size, borderRadius: '50%', objectFit: 'cover' }}
    />
  ) : (
    <div style={{
      width: size, height: size, borderRadius: '50%',
      background: '#E5E5E5', display: 'flex', alignItems: 'center',
      justifyContent: 'center', fontWeight: 600, fontSize: size * 0.38, color: '#000',
    }}>
      {initials}
    </div>
  );
};
