# KinnectAI Event Versioning Standards
*Schema Registry alignment, BACKWARD_TRANSITIVE, DLQ routing, SRS Appendix C.*

## 1. Schema Registry Strategy
- **Registry:** `schema-registry.internal:8081`
- **Compatibility:** `BACKWARD_TRANSITIVE` (default)
- **Subject Naming:** `TopicName-value` (e.g., `behavioral.events-value`)
- **Versioning:** Semantic major.minor. Breaking changes require new topic or v2 namespace.

## 2. Avro/Protobuf Evolution Rules
- Add optional fields with defaults.
- Add enum values (append-only).
- Remove required fields.
- Change field types without migration.
- Rename fields without `alias` mapping.

## 3. Consumer Resilience
- Ignore unknown fields. Rely on defaults for new optional fields.
- Validate against `writer_schema` at ingestion. Reject mismatch -> DLQ.
- Idempotent consumers: `event_id` keyed deduplication in PostgreSQL/Cassandra.

## 4. CI/CD Schema Gates
- `buf breaking --against '.git#branch=main'` must pass before merge.
- Schema changes deployed in canary: Consumers first -> Producers second.
- DLQ routing: `moderation.queue.dlq`, `behavioral.events.dlq`. Retention 30d.
- Replay compatibility tested monthly in staging with synthetic data (ML-007).
