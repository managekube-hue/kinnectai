-- Migration: 005_behavioral_events.sql
-- Behavioral Events Table (with Sampling Strategy)

CREATE TABLE behavioral_events (
    event_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL,
    event_type VARCHAR(50) NOT NULL,
    source VARCHAR(20) CHECK (source IN ('inapp','pixel','sdk','webhook')),
    timestamp TIMESTAMPTZ DEFAULT NOW(),
    metadata JSONB,
    sampled BOOLEAN DEFAULT TRUE,
    sampling_rate DECIMAL(3,2),
    consent_flags_snapshot INTEGER,
    CONSTRAINT fk_user FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE
) PARTITION BY RANGE (timestamp);

CREATE INDEX idx_behavioral_user_time_sampled ON behavioral_events (user_id, timestamp DESC) WHERE sampled = TRUE;
CREATE INDEX idx_behavioral_event_type ON behavioral_events (event_type, timestamp DESC);
