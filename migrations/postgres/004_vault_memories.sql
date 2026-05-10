-- Migration: 004_vault_memories.sql
-- Vault Memories Table (Zero-Knowledge Architecture)

CREATE TABLE vault_memories (
    memory_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    creator_id UUID NOT NULL REFERENCES users(user_id) ON DELETE CASCADE,
    recipient_id UUID REFERENCES users(user_id),
    content_s3_key VARCHAR(256) NOT NULL,
    encrypted_dek BYTEA NOT NULL,
    dek_key_id VARCHAR(64) NOT NULL,
    trigger_type VARCHAR(30) NOT NULL CHECK (trigger_type IN ('time_capsule','milestone','unspoken','geofence')),
    trigger_value JSONB NOT NULL,
    steward_id UUID REFERENCES users(user_id),
    created_at TIMESTAMPTZ DEFAULT NOW(),
    delivered_at TIMESTAMPTZ,
    status VARCHAR(20) DEFAULT 'sealed' CHECK (status IN ('sealed','triggered','delivered','revoked','hold')),
    verification_state JSONB,
    c2pa_manifest_hash VARCHAR(64),
    audit_id UUID DEFAULT gen_random_uuid(),
    CONSTRAINT zk_architecture CHECK (encrypted_dek IS NOT NULL AND LENGTH(encrypted_dek) > 0)
);

CREATE INDEX idx_vault_memories_creator ON vault_memories(creator_id, created_at DESC);
CREATE INDEX idx_vault_memories_recipient ON vault_memories(recipient_id) WHERE status IN ('sealed','triggered');
CREATE INDEX idx_vault_memories_trigger_type ON vault_memories(trigger_type, status) WHERE delivered_at IS NULL;
CREATE INDEX idx_vault_memories_steward ON vault_memories(steward_id) WHERE status IN ('pending','hold');
