# Feed Service

This service contains the Go backend that serves The Line feed and core API endpoints.

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
