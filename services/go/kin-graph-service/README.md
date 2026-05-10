# kin-graph-service

Neo4j graph operations, KC computation, Branch traversal, shortest path resolution.

## Port
8081

## Dependencies
- Neo4j (Aura Enterprise)
- Redis (ElastiCache)
- Kafka (MSK)
- PostgreSQL 16 (Aurora)

## Health Checks
- `/healthz` - Liveness probe
- `/readyz` - Readiness probe (checks dependencies)

## Kafka Topics
- cr.recompute (subscribe)
- discovery.matches (publish)

## Environment Variables
- NEO4J_URI
- NEO4J_USERNAME
- NEO4J_PASSWORD
- REDIS_URL
- KAFKA_BROKERS
- POSTGRES_DSN
