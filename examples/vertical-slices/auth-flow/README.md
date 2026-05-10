# Auth Flow Vertical Slice

This is the **canonical implementation** showing how KinnectAI works end-to-end.

Use this as the SOURCE OF TRUTH when:
- Building new services
- Reviewing code
- Debugging issues
- Onboarding to the codebase
- Generating implementations with AI

## Flow Overview

```
Mobile (Flutter)
    ↓ HTTP POST /api/v1/login
Gateway (Port 8080)
    ↓ Forward to identity-service
Identity Service (Port 8081)
    ↓ Query PostgreSQL
PostgreSQL
    ↓ Insert session
Identity Service (domain logic)
    ↓ Publish event
Kafka Topic: user-events
    ↓ Event consumed by
Behavioral Service (records login)
    ↓ Telemetry span
OpenTelemetry Collector
    ↓ Export
Jaeger (trace visualization)
```

## Components

1. **Mobile** (`mobile/LoginScreen.dart`)
   - Makes HTTP POST to gateway
   - Receives JWT token
   - Stores token securely
   - Makes authenticated requests

2. **Gateway** (`gateway/routes.go`)
   - Routes requests to identity-service
   - Adds tracing headers
   - Handles CORS
   - Simple HTTP forwarding (no transformation)

3. **Identity Service** 
   - Validates credentials
   - Creates user session
   - Publishes domain event
   - Returns JWT token

4. **PostgreSQL** (`postgres/schema.sql`)
   - Persists users
   - Stores sessions
   - Audit log (auth_events)

5. **Kafka** (`kafka/events.schema`)
   - Publishes user.login.success
   - Topic: user-events
   - Partitioned by user_id

6. **Observability** (`observability/tracing.go`)
   - Traces each layer
   - Records spans
   - Metrics for latency

7. **Deployment** (`deployment/docker-compose.yml`)
   - Orchestrates all services
   - Single `docker-compose up` starts everything

8. **Tests** (`tests/integration_test.go`)
   - Tests complete flow
   - Verifies all layers
   - Example for other vertical slices

## Running Locally

```bash
cd examples/vertical-slices/auth-flow/deployment
docker-compose up -d

# Wait for services to be healthy
sleep 10

# Test login
curl -X POST http://localhost:8080/api/v1/login \
  -H "Content-Type: application/json" \
  -d '{"email":"user@example.com","password":"password123"}'
```

## Key Principles

1. **Mobile → Gateway → Service** (never direct)
2. **Domain layer** (business logic isolated)
3. **Events** (publish after state change)
4. **Persistence** (explicit schema)
5. **Tracing** (every operation traced)
6. **Tests** (integration tests proof)
