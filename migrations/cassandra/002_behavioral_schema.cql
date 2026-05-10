-- Cassandra: Behavioral Events Schema

CREATE KEYSPACE IF NOT EXISTS behavioral WITH replication = {'class': 'NetworkTopologyStrategy', 'us-east-1': 3, 'eu-west-1': 3};

CREATE TABLE behavioral.pulses (
    user_id UUID,
    hour_bucket TIMESTAMP,
    memory_id UUID,
    actor_id UUID,
    pulse_type TEXT,
    timestamp TIMESTAMP,
    sampled BOOLEAN,
    PRIMARY KEY ((user_id, hour_bucket), timestamp, memory_id)
) WITH CLUSTERING ORDER BY (timestamp DESC, memory_id ASC)
  AND default_time_to_live = 63072000
  AND compaction = {'class': 'TimeWindowCompactionStrategy', 'compaction_window_size': 1, 'compaction_window_unit': 'DAYS'};

CREATE TABLE behavioral.events (
    user_id UUID,
    hour_bucket TIMESTAMP,
    event_id UUID,
    event_type TEXT,
    source TEXT,
    timestamp TIMESTAMP,
    metadata JSON,
    sampled BOOLEAN,
    sampling_rate DECIMAL,
    PRIMARY KEY ((user_id, hour_bucket, event_type), timestamp, event_id)
) WITH default_time_to_live = 63072000
  AND compaction = {'class': 'TimeWindowCompactionStrategy'};

-- GDPR Art. 15 access view
CREATE MATERIALIZED VIEW behavioral.user_events_export AS
SELECT user_id, event_id, event_type, source, timestamp, metadata, sampled
FROM behavioral.events
WHERE user_id IS NOT NULL AND hour_bucket IS NOT NULL
PRIMARY KEY (user_id, timestamp, event_id, hour_bucket)
WITH default_time_to_live = 63072000;
