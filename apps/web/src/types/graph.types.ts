// SRS §23.2 Category 17 — Frontend Types: Graph
export interface TreePerson {
  personId: string;
  displayName: string;
  birthYear?: number;
  deathYear?: number;
  isLiving: boolean;
  avatarUrl?: string;
  verified: boolean;
}

export interface KinnectionEdge {
  edgeId: string;
  fromId: string;
  toId: string;
  edgeType: 'parent' | 'child' | 'sibling' | 'cousin' | 'spouse';
  weight: number;
}

export interface KinnectionPath {
  fromUserId: string;
  toUserId: string;
  path: KinnectionPathStep[];
  hops: number;
}

export interface KinnectionPathStep {
  userId: string;
  displayName: string;
  relationshipFromPrev: string;
}

export interface GraphTraversalMetrics {
  queryId: string;
  nodesVisited: number;
  edgesTraversed: number;
  latencyMs: number;
  algorithm: string;
}

export interface BranchMergeCandidate {
  candidateId: string;
  branchAId: string;
  branchBId: string;
  confidence: number;
  commonPersonId?: string;
}
