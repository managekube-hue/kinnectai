// SRS §23.2 Category 3 — Design System: Tabs.tsx
import React, { useState } from 'react';

interface Tab {
  id: string;
  label: string;
}

interface TabsProps {
  tabs: Tab[];
  defaultTab?: string;
  onChange?: (id: string) => void;
  children?: React.ReactNode;
}

export const Tabs: React.FC<TabsProps> = ({ tabs, defaultTab, onChange }) => {
  const [active, setActive] = useState(defaultTab ?? tabs[0]?.id);

  const select = (id: string) => {
    setActive(id);
    onChange?.(id);
  };

  return (
    <div role="tablist" style={{ display: 'flex', borderBottom: '1px solid #E5E5E5' }}>
      {tabs.map((tab) => (
        <button
          key={tab.id}
          role="tab"
          aria-selected={active === tab.id}
          onClick={() => select(tab.id)}
          style={{
            padding: '10px 16px',
            background: 'none',
            border: 'none',
            borderBottom: active === tab.id ? '2px solid #000' : '2px solid transparent',
            fontWeight: active === tab.id ? 600 : 400,
            cursor: 'pointer',
            fontSize: 14,
          }}
        >
          {tab.label}
        </button>
      ))}
    </div>
  );
};
