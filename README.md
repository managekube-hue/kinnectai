# KinnectAI

Biological kinship social platform — Go backend + Flutter mobile/desktop frontend.

## Architecture

| Layer | Technology | Purpose |
|-------|-----------|---------|
| API | Go 1.22 + Gin | HTTP REST, JWT auth |
| Relational DB | PostgreSQL 16 + pgvector | Users, memories, kin scores, DNA embeddings |
| Graph DB | Neo4j 5.x + APOC | Biological relationship graph, shortest-path CR |
| Cache | Redis 7 | Kin Score cache (10-min TTL) |
| Event Store | DataStax Astra (Cassandra) | Behavioral events (Layers 4–5) |- **Object Storage** | AWS S3 / MinIO | Media originals, vault files, raw genomic assets || Feeds + CDN | GetStream | The Line feed + Bloom/video CDN |

## Project Structure

- `apps/mobile/` - Flutter mobile app
- `apps/web/` - Web frontend
- `services/gateway/` - API/security boundary service
- `services/go/` - Go service group (feed, graph, media, rooms, memorybox, payment, notification, identity)
- `services/python/` - Python service group (kernel, discovery, behavioral, dna-ingest, photoplay, moderation, voiceprint)
- `packages/shared-contracts/` - OpenAPI/event/schema contracts
- `infra/` - Unified infrastructure root (terraform, k8s, monitoring, data infra)
- `migrations/postgres|neo4j|cassandra/` - Database migrations by datastore
- `scripts/bootstrap|dev|ci|release|data/` - Operational scripts by lifecycle stage
- `tests/integration|e2e|load|contracts/` - Cross-cutting test suites

## Service Ownership

- `services/go/feed-service/` = feed serving, ranking, and timeline assembly.
- `services/python/kernel-service/` = orchestration and intelligence core.
- `services/python/behavioral-service/` = telemetry ingestion and scoring pipelines.
- `services/python/discovery-service/` = kin candidate generation and candidate ranking.

## Quick Start

### Backend

1. `cd services/go/feed-service`
2. `cp ../../.env.example .env` and fill secrets
3. `docker compose up postgres neo4j redis -d`
4. Apply Neo4j constraints: Open http://localhost:7474, login, run `migrations/neo4j/002_constraints.cypher`
5. `go mod download && go run ./cmd/api`

### Frontend

1. `cd apps/mobile`
2. `flutter pub get`
3. `flutter run` (for mobile) or `flutter run -d linux` (for desktop)

## API Endpoints

[See backend README for details]

## Contributing

1. Fork the repo
2. Create a feature branch
3. Make changes
4. Run tests: `flutter test` (frontend), `go test ./...` (backend)
5. Submit PR

## Domain Terminology

| Term | Meaning |
|------|---------|
| The Line | CR-ranked activity feed |
| Kin | User node in the biological graph |
| Kinnection | Confirmed biological link between two Kins |
| Memory | Content unit (video/bloom/audio/photo/text) |
| Pulse | Lightweight reaction (like) |
| Bloom | Animated talking photo |
| Branch | Family group |
| Root | User profile |
| Kin Score | User-facing Coefficient of Relationship (0–100 scale) |
| Echo | On-this-day memory resurfaced |
| Ripple | Viral memory within a tree |
| Heartbeat | Daily digest notification |

## Quick Start (local dev)

### 1. Prerequisites

- Docker Desktop
- Go 1.22+
- Copy `.env.example` to `.env` and fill in secrets

```bash
cp .env.example .env
```

### 2. Start databases

```bash
docker compose up postgres neo4j redis cassandra minio -d
```

Wait for all health checks to pass (~30s).

### 3. Apply Neo4j constraints

```bash
# Open Neo4j Browser at http://localhost:7474
# Login: neo4j / kinnect_neo4j_password
# Paste contents of migrations/neo4j/002_constraints.cypher and run
```

### 4. Run the backend

```bash
go mod download
go run ./cmd/api
```

Or with Docker Compose (full stack):

```bash
docker compose up --build
```

Server starts on `http://localhost:8080`.

## API Endpoints

### Public

| Method | Path | Description |
|--------|------|-------------|
| GET | `/health` | Health check |
| POST | `/api/v1/auth/register` | Register new Kin |
| POST | `/api/v1/auth/login` | Login, receive JWT + GetStream token |

### Protected (Bearer JWT required)

| Method | Path | Description |
|--------|------|-------------|
| GET | `/api/v1/users/me` | Get own Root (profile) |
| PATCH | `/api/v1/users/me` | Update own Root |
| GET | `/api/v1/users/:id` | Get another Kin's public Root |
| GET | `/api/v1/users/surname-map?surname=` | Find Kins sharing a surname |
| GET | `/api/v1/graph/kin-score/:targetID` | Compute Kin Score (CR) to another Kin |
| POST | `/api/v1/graph/kinnections` | Request a Kinnection |
| PATCH | `/api/v1/graph/kinnections/:id/confirm` | Confirm a Kinnection |
| GET | `/api/v1/feed/line` | Get The Line (CR-ranked feed) |
| POST | `/api/v1/feed/memories` | Post a Memory |
| POST | `/api/v1/feed/memories/:id/pulse` | Pulse (react to) a Memory |
| POST | `/api/v1/dna/kit` | Submit DNA kit |
| GET | `/api/v1/dna/status` | Get DNA processing status |
| POST | `/api/v1/media/upload-token` | Get GetStream CDN upload token |

## Build

```bash
go build ./cmd/api
```

## Docker

```bash
docker build -t kinnectai-backend .
docker compose up --build
```

## Run Scripts

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\dev\dev-api.ps1
powershell -ExecutionPolicy Bypass -File .\scripts\dev\dev-stack.ps1
```

`dev-stack.ps1` now orchestrates database schema safely on each boot:
- PostgreSQL: applies each `migrations/postgres/*.sql` file once via `schema_migrations` ledger.
- Cassandra: reapplies `migrations/cassandra/001_initial_schema.cql` idempotently (uses `IF NOT EXISTS`).

## Environment Variables

See `.env.example` for all required variables.

## Security

- JWT HS256, short-lived (configurable expiry)
- bcrypt cost 12 for passwords
- Generic auth errors prevent user enumeration
- GetStream secret is **never** exposed to clients — tokens generated server-side only
- Immutable audit log on all sensitive operations
- Security headers on every response (X-Frame-Options, Referrer-Policy, etc.)
