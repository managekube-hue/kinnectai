// SRS §23.2 Category 5 — Discovery System: DiscoveryInsights.tsx
import React from 'react';
import type { DiscoveryInsight } from '../../types/discovery.types';

interface DiscoveryInsightsProps {
  insights: DiscoveryInsight[];
}

export const DiscoveryInsights: React.FC<DiscoveryInsightsProps> = ({ insights }) => {
  if (!insights.length) return null;
  return (
    <div style={{ marginTop: 12 }}>
      <div style={{ fontSize: 12, fontWeight: 600, color: '#737373', marginBottom: 6 }}>INSIGHTS</div>
      {insights.map((insight) => (
        <div key={insight.type} style={{ display: 'flex', justifyContent: 'space-between', fontSize: 13, padding: '4px 0' }}>
          <span>{insight.label}</span>
          <span style={{ fontWeight: 600 }}>{(insight.weight * 100).toFixed(0)}%</span>
        </div>
      ))}
    </div>
  );
};
