import React from 'react';

const DiscoveryCard: React.FC<{ match: any }> = ({ match }) => {
  return (
    <div style={{ border: '1px solid #ccc', padding: '16px', marginBottom: '16px' }}>
      <h3>{match.candidateName}</h3>
      <p>Match Score: {(match.matchScore * 100).toFixed(1)}%</p>
      <p>Genetic Distance: {match.geneticDistance?.toFixed(2) || 'N/A'} cM</p>
    </div>
  );
};

export default DiscoveryCard;
