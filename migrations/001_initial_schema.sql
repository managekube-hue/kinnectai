-- KinnectAI PostgreSQL Migrations
-- Run in order: 001 → 004

-- Enable UUID extension
CREATE EXTENSION IF NOT EXISTS "pgcrypto";
CREATE EXTENSION IF NOT EXISTS "vector"; -- pgvector for DNA embeddings

-- ─────────────────────────────────────────────
-- USERS (Layer 1 + auth anchor)
-- ─────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS users (
    id                  UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    username            TEXT UNIQUE NOT NULL,
    email               TEXT UNIQUE NOT NULL,
    password_hash       TEXT NOT NULL,
    display_name        TEXT,
    bio                 TEXT,
    profile_picture_url TEXT,
    mother_maiden_name  TEXT,                    -- Onboarding hook
    birth_year          INT,
    is_verified         BOOLEAN DEFAULT FALSE,
    is_active           BOOLEAN DEFAULT TRUE,
    getstream_token     TEXT,                    -- Cached GetStream user token
    created_at          TIMESTAMPTZ DEFAULT NOW(),
    updated_at          TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX idx_users_email    ON users(email);
CREATE INDEX idx_users_username ON users(username);

-- ─────────────────────────────────────────────
-- IDENTITY LAYER (Layer 1 — LexisNexis / Whitepages enrichment)
-- ─────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS identity_profiles (
    id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id         UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    legal_name      TEXT,
    name_variants   TEXT[],                      -- Maiden names, aliases, transliterations
    address_history JSONB,                       -- [{street, city, state, zip, from, to}]
    known_relatives JSONB,                       -- From LexisNexis relatives-of data
    lexisnexis_id   TEXT,                        -- External reference
    whitepages_id   TEXT,
    enriched_at     TIMESTAMPTZ,
    created_at      TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX idx_identity_user_id ON identity_profiles(user_id);

-- ─────────────────────────────────────────────
-- DNA PROFILES (Layer 2 — Bioidentity)
-- ─────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS dna_profiles (
    id                      UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id                 UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    haplogroup_maternal     TEXT,                -- Mitochondrial haplogroup
    haplogroup_paternal     TEXT,                -- Y-chromosome haplogroup (if applicable)
    admixture               JSONB,               -- {"region": percentage, ...}
    snp_embedding           vector(512),         -- pgvector SNP marker embedding
    kit_source              TEXT,                -- 'sequencing_com' | 'kinnect_kit' | '23andme' | 'ancestry'
    kit_id                  TEXT,                -- External kit reference
    processing_status       TEXT DEFAULT 'pending', -- pending | processing | complete | error
    raw_file_s3_key         TEXT,                -- S3 Glacier key for raw FASTQ/BAM
    sequencing_api_ref      TEXT,
    created_at              TIMESTAMPTZ DEFAULT NOW(),
    updated_at              TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX idx_dna_user_id ON dna_profiles(user_id);
CREATE INDEX idx_dna_snp_embedding ON dna_profiles USING ivfflat (snp_embedding vector_cosine_ops);

-- ─────────────────────────────────────────────
-- KIN SCORES CACHE (Layer 2+3 CR output)
-- ─────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS kin_scores (
    id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_a_id       UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    user_b_id       UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    kin_score       FLOAT NOT NULL,              -- 0.0 to 1.0 (CR coefficient)
    relationship    TEXT,                        -- 'sibling' | 'first_cousin' | etc.
    confidence      FLOAT,                       -- 0.0 to 1.0
    computed_at     TIMESTAMPTZ DEFAULT NOW(),
    UNIQUE (user_a_id, user_b_id)
);

CREATE INDEX idx_kin_scores_user_a ON kin_scores(user_a_id);
CREATE INDEX idx_kin_scores_user_b ON kin_scores(user_b_id);

-- ─────────────────────────────────────────────
-- KINNECTIONS (Layer 3 — confirmed links)
-- ─────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS kinnections (
    id                  UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_a_id           UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    user_b_id           UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    relationship_type   TEXT,                    -- 'parent', 'sibling', 'cousin', 'spouse', etc.
    confirmation_method TEXT,                    -- 'dna' | 'tree' | 'identity' | 'mutual'
    kin_score           FLOAT,
    status              TEXT DEFAULT 'pending',  -- pending | confirmed | rejected
    requested_at        TIMESTAMPTZ DEFAULT NOW(),
    confirmed_at        TIMESTAMPTZ,
    UNIQUE (user_a_id, user_b_id)
);

CREATE INDEX idx_kinnections_user_a ON kinnections(user_a_id);
CREATE INDEX idx_kinnections_user_b ON kinnections(user_b_id);

-- ─────────────────────────────────────────────
-- MEMORIES (content units — The Line posts)
-- ─────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS memories (
    id                  UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id             UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    content_type        TEXT NOT NULL,           -- 'video' | 'bloom' | 'audio' | 'photo' | 'text'
    caption             TEXT,
    media_url           TEXT,                    -- GetStream Video CDN URL
    thumbnail_url       TEXT,
    getstream_activity_id TEXT,                  -- GetStream activity reference
    is_echo             BOOLEAN DEFAULT FALSE,   -- On-this-day memory
    echo_date           DATE,                    -- The historical date this echoes
    memory_depth        INT DEFAULT 0,           -- How many generations back
    branch_id           UUID,                    -- Optional: posted to a Branch
    status              TEXT DEFAULT 'active',   -- active | archived | vault
    created_at          TIMESTAMPTZ DEFAULT NOW(),
    updated_at          TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX idx_memories_user_id    ON memories(user_id);
CREATE INDEX idx_memories_created_at ON memories(created_at DESC);
CREATE INDEX idx_memories_echo_date  ON memories(echo_date);

-- ─────────────────────────────────────────────
-- PULSES (Layer 4 — lightweight reactions)
-- ─────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS pulses (
    id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id     UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    memory_id   UUID NOT NULL REFERENCES memories(id) ON DELETE CASCADE,
    pulse_type  TEXT DEFAULT 'pulse',            -- 'pulse' | 'ripple' | 'heart'
    created_at  TIMESTAMPTZ DEFAULT NOW(),
    UNIQUE (user_id, memory_id)
);

CREATE INDEX idx_pulses_memory_id ON pulses(memory_id);

-- ─────────────────────────────────────────────
-- BRANCHES (family group nodes)
-- ─────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS branches (
    id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name            TEXT NOT NULL,
    description     TEXT,
    surname_anchor  TEXT,                        -- Primary surname this branch is built on
    creator_id      UUID NOT NULL REFERENCES users(id),
    member_count    INT DEFAULT 1,
    is_public       BOOLEAN DEFAULT TRUE,
    created_at      TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS branch_members (
    branch_id   UUID NOT NULL REFERENCES branches(id) ON DELETE CASCADE,
    user_id     UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    role        TEXT DEFAULT 'member',           -- 'originator' | 'admin' | 'member'
    joined_at   TIMESTAMPTZ DEFAULT NOW(),
    PRIMARY KEY (branch_id, user_id)
);

-- ─────────────────────────────────────────────
-- AUDIT LOG (security — immutable access trail)
-- ─────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS audit_log (
    id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id     UUID REFERENCES users(id),
    action      TEXT NOT NULL,
    resource    TEXT,
    ip_address  INET,
    user_agent  TEXT,
    created_at  TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX idx_audit_log_user_id    ON audit_log(user_id);
CREATE INDEX idx_audit_log_created_at ON audit_log(created_at DESC);
