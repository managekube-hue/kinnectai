-- pgvector must be enabled: CREATE EXTENSION vector;

CREATE TABLE users (
    user_id UUID PRIMARY KEY,
    display_name VARCHAR(100),
    surname VARCHAR(50),
    created_at TIMESTAMP DEFAULT NOW(),
    last_active TIMESTAMP,
    steward_user_id UUID REFERENCES users(user_id)
);

CREATE TABLE bioidentity_embeddings (
    user_id UUID PRIMARY KEY REFERENCES users(user_id),
    dna_cr FLOAT DEFAULT 0.0,
    haplogroup_match INT DEFAULT 0,
    facial_embedding vector(128),
    voice_embedding vector(256),
    haplogroup_embedding vector(512),
    updated_at TIMESTAMP DEFAULT NOW()
);

CREATE TABLE memories (
    memory_id UUID PRIMARY KEY,
    creator_id UUID REFERENCES users(user_id),
    type VARCHAR(20) CHECK (type IN ('video', 'bloom', 'audio')),
    vault_trigger_type VARCHAR(20),
    vault_trigger_value TEXT,
    recipient_id UUID REFERENCES users(user_id),
    s3_key TEXT,
    created_at TIMESTAMP DEFAULT NOW()
);

CREATE INDEX ON bioidentity_embeddings USING hnsw (facial_embedding vector_cosine_ops);
CREATE INDEX ON bioidentity_embeddings USING hnsw (voice_embedding vector_cosine_ops);
CREATE INDEX ON bioidentity_embeddings USING hnsw (haplogroup_embedding vector_cosine_ops);
