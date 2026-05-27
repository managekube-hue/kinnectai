# KinnectAI

KinnectAI is a production-oriented distributed systems foundation for identity, event ingestion, and social graph workflows. The current local milestone proves one real distributed path end to end: signup through the gateway, persistence in PostgreSQL, publication to Kafka, consumption by the behavioral service, and persistence in Cassandra.

## Service Map

- `gateway` on `:8000`: public HTTP entrypoint, auth boundary, request lifecycle, proxy to internal services
- `identity-service` on `:8001`: signup, token issuance, PostgreSQL persistence, Kafka publishing of `user.created`
- `behavioral-service` on `:8002`: consumes `user-events`, persists `user.created` into Cassandra, exposes processing metrics
- `postgres` on `:5432`: transactional user storage
- `redis` on `:6379`: cache and future rate-limit state
- `kafka` on `:9092`: local event bus via Redpanda
- `cassandra` on `:9042`: behavioral event store
- `neo4j` on `:7687`: reserved for later graph execution paths

## Local Startup

```bash
docker-compose -f docker-compose.local.yml up --build
```

Expected local result:

- healthy containers for `postgres`, `redis`, `kafka`, `cassandra`, `gateway`, `identity-service`, and `behavioral-service`
- service logs showing gateway startup, identity PostgreSQL connection, and behavioral Kafka consumer startup
- reachable health and metrics endpoints

## Ports

- `8000` gateway
- `8001` identity-service
- `8002` behavioral-service
- `5432` postgres
- `6379` redis
- `9092` kafka
- `9042` cassandra
- `7474` and `7687` neo4j

## Health Endpoints

- `http://localhost:8000/health`
- `http://localhost:8000/ready`
- `http://localhost:8000/metrics`
- `http://localhost:8001/health`
- `http://localhost:8001/ready`
- `http://localhost:8001/metrics`
- `http://localhost:8002/health`
- `http://localhost:8002/ready`
- `http://localhost:8002/metrics`

## Event Flow

1. Client sends `POST /v1/auth/signup` to the gateway.
2. Gateway forwards the request to `identity-service`.
3. `identity-service` inserts the user into PostgreSQL and publishes `user.created` to Kafka topic `user-events`.
4. `behavioral-service` consumes `user.created` from Kafka.
5. `behavioral-service` writes the event into Cassandra table `behavioral_events`.
6. `behavioral-service` metrics expose processed event counts.

Example request:

```bash
curl -X POST http://localhost:8000/v1/auth/signup \
	-H "Content-Type: application/json" \
	-d '{"email":"test@kinnect.ai","password":"devpass123","name":"Test User"}'
```

## Architecture Overview

- Go services own HTTP entrypoints and request orchestration.
- Kafka carries domain events between services.
- PostgreSQL stores transactional identity data.
- Cassandra stores append-oriented behavioral events.
- Each service exposes health, readiness, and metrics for local operability.
