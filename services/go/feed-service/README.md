# Feed Service

Feed serving, ranking, and timeline assembly.

Responsibilities:
- Build and return The Line feed payloads.
- Apply feed ranking and retrieval policies.

Out of scope:
- Candidate generation (owned by discovery-service).
- Kernel intelligence orchestration (owned by kernel-service).
- Behavioral telemetry/scoring pipelines (owned by behavioral-service).

## Local development

```bash
cd services/go/feed-service
cp ../../.env.example .env
go mod download
go run ./cmd/api
```

## Docker

```bash
docker build -t kinnectai/feed-service ./services/go/feed-service
```
