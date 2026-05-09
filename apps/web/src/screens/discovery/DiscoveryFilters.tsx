// SRS §23.2 Category 5 — Discovery System: DiscoveryFilters.tsx
import React, { useState } from 'react';

interface FilterState {
  minKinScore: number;
  relationshipType: 'all' | 'dna' | 'surname' | 'behavioral';
}

interface DiscoveryFiltersProps {
  onChange?: (filters: FilterState) => void;
}

export const DiscoveryFilters: React.FC<DiscoveryFiltersProps> = ({ onChange }) => {
  const [filters, setFilters] = useState<FilterState>({ minKinScore: 0, relationshipType: 'all' });

  const update = (partial: Partial<FilterState>) => {
    const next = { ...filters, ...partial };
    setFilters(next);
    onChange?.(next);
  };

  return (
    <div style={{ display: 'flex', gap: 8, marginBottom: 16, flexWrap: 'wrap' }}>
      {(['all', 'dna', 'surname', 'behavioral'] as const).map((type) => (
        <button
          key={type}
          onClick={() => update({ relationshipType: type })}
          style={{
            padding: '6px 14px', borderRadius: 20, border: '1px solid',
            borderColor: filters.relationshipType === type ? '#000' : '#E5E5E5',
            background: filters.relationshipType === type ? '#000' : '#fff',
            color: filters.relationshipType === type ? '#fff' : '#000',
            fontWeight: 500, cursor: 'pointer', fontSize: 13,
          }}
        >
          {type.charAt(0).toUpperCase() + type.slice(1)}
        </button>
      ))}
    </div>
  );
};
