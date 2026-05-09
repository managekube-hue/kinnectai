-- Cassandra schema for KinnectAI behavioral event ingestion

CREATE KEYSPACE IF NOT EXISTS kinnectai_events WITH replication = {'class': 'SimpleStrategy', 'replication_factor': 1};

USE kinnectai_events;

CREATE TABLE IF NOT EXISTS pulses (
    user_id uuid,
    memory_id uuid,
    pulse_type text,
    created_at timestamp,
    PRIMARY KEY ((user_id), created_at, memory_id)
) WITH CLUSTERING ORDER BY (created_at DESC);

CREATE TABLE IF NOT EXISTS behavioral_events (
    user_id uuid,
    event_id uuid,
    event_type text,
    event_payload text,
    created_at timestamp,
    PRIMARY KEY ((user_id), created_at, event_id)
) WITH CLUSTERING ORDER BY (created_at DESC);

CREATE TABLE IF NOT EXISTS user_behavioral_events (
    user_id uuid,
    event_timestamp timestamp,
    event_type text,
    sentiment_score float,
    last_active timestamp,
    PRIMARY KEY ((user_id), event_timestamp)
) WITH CLUSTERING ORDER BY (event_timestamp DESC);

CREATE TABLE IF NOT EXISTS interaction_logs (
    partition_day text,
    event_id uuid,
    user_id uuid,
    target_id uuid,
    action text,
    metadata text,
    created_at timestamp,
    PRIMARY KEY ((partition_day), created_at, event_id)
) WITH CLUSTERING ORDER BY (created_at DESC);
