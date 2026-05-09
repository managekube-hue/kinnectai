// SRS §23.2 Category 1 — App Foundation: featureFlags.ts
// Feature flags are resolved server-side and cached client-side.
const flags: Record<string, boolean> = {};

export function initFeatureFlags(serverFlags: Record<string, boolean>): void {
  Object.assign(flags, serverFlags);
}

export function isEnabled(flagName: string): boolean {
  return flags[flagName] ?? false;
}

export const FLAG = {
  BLOOM_ENABLED: 'bloom_enabled',
  DNA_UPLOAD_ENABLED: 'dna_upload_enabled',
  FAMILY_TREE_V2: 'family_tree_v2',
  ROOMS_RECORDING: 'rooms_recording',
  MARKETPLACE_ENABLED: 'marketplace_enabled',
  STEWARD_VAULT: 'steward_vault',
} as const;
