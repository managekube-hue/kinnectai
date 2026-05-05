# KinnectAI

Biological kinship social platform — Go backend + Flutter mobile/desktop frontend.

## Architecture

| Layer | Technology | Purpose |
|-------|-----------|---------|
| API | Go 1.22 + Gin | HTTP REST, JWT auth |
| Relational DB | PostgreSQL 16 + pgvector | Users, memories, kin scores, DNA embeddings |
| Graph DB | Neo4j 5.x + APOC | Biological relationship graph, shortest-path CR |
| Cache | Redis 7 | Kin Score cache (10-min TTL) |
| Event Store | DataStax Astra (Cassandra) | Behavioral events (Layers 4–5) |
| Feeds + CDN | GetStream | The Line feed + Bloom/video CDN |

## Project Structure

- `backend/` - Go backend services
- `apps/kinnectai_app/` - Flutter mobile/desktop app
- `docs/` - Documentation
- `scripts/` - Development scripts
- `.github/` - CI/CD workflows

## Quick Start

### Backend

1. `cd backend`
2. `cp .env.example .env` and fill secrets
3. `docker compose up postgres neo4j redis -d`
4. Apply Neo4j constraints: Open http://localhost:7474, login, run `scripts/neo4j_constraints.cypher`
5. `go mod download && go run ./cmd/api`

### Frontend

1. `cd apps/kinnectai_app`
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
docker compose up postgres neo4j redis -d
```

Wait for all health checks to pass (~30s).

### 3. Apply Neo4j constraints

```bash
# Open Neo4j Browser at http://localhost:7474
# Login: neo4j / kinnect_neo4j_password
# Paste contents of scripts/neo4j_constraints.cypher and run
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
powershell -ExecutionPolicy Bypass -File .\scripts\dev-api.ps1
powershell -ExecutionPolicy Bypass -File .\scripts\dev-stack.ps1
```

## Environment Variables

See `.env.example` for all required variables.

## Security

- JWT HS256, short-lived (configurable expiry)
- bcrypt cost 12 for passwords
- Generic auth errors prevent user enumeration
- GetStream secret is **never** exposed to clients — tokens generated server-side only
- Immutable audit log on all sensitive operations
- Security headers on every response (X-Frame-Options, Referrer-Policy, etc.)
