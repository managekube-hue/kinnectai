// SRS §23.2 Category 10 — State Management: graphStore.ts
import { create } from 'zustand';
import type { TreePerson, KinnectionEdge } from '../types/graph.types';

interface GraphState {
  nodes: TreePerson[];
  edges: KinnectionEdge[];
  selectedPersonId: string | null;
  setGraph: (nodes: TreePerson[], edges: KinnectionEdge[]) => void;
  selectPerson: (personId: string | null) => void;
  upsertNode: (person: TreePerson) => void;
}

export const useGraphStore = create<GraphState>()((set) => ({
  nodes: [],
  edges: [],
  selectedPersonId: null,
  setGraph: (nodes, edges) => set({ nodes, edges }),
  selectPerson: (selectedPersonId) => set({ selectedPersonId }),
  upsertNode: (person) =>
    set((s) => {
      const idx = s.nodes.findIndex((n) => n.personId === person.personId);
      if (idx >= 0) {
        const nodes = [...s.nodes];
        nodes[idx] = person;
        return { nodes };
      }
      return { nodes: [...s.nodes, person] };
    }),
}));
