# KinnectAI Service Catalog

## Service Registry
**Last Updated:** 2025-01-09

### Go Services (High-Performance Core)

| Service | Owner | Language | Domain | Status |
|---------|-------|----------|--------|--------|
| feed-service | @behavioral-team | Go 1.22 | Feed ranking/personalization | 🟡 Partial |
| kin-graph-service | @graph-team | Go 1.22 | Graph data/relationships | 🟡 Partial |
| identity-service | @platform-team | Go 1.22 | User identity/auth | 🟡 Partial |
| media-service | @content-team | Go 1.22 | Media storage/processing | 🟡 Partial |
| rooms-service | @social-team | Go 1.22 | Real-time rooms | 🟡 Partial |
| memorybox-service | @vault-team | Go 1.22 | Zero-knowledge vault | 🟡 Partial |
| notification-service | @engagement-team | Go 1.22 | FCM/notification delivery | 🟡 Partial |
| payment-service | @platform-team | Go 1.22 | Payment processing | 🟡 Partial |
| gateway | @platform-team | Go 1.22 | API gateway/routing | 🔴 Stub |

### Python Services (Data/ML Pipeline)

| Service | Owner | Language | Domain | Status |
|---------|-------|----------|--------|--------|
| behavioral-service | @behavioral-team | Python 3.11 | Event ingestion/analytics | 🟡 Partial |
| photoplay-service | @content-team | Python 3.11 | Photo ranking/jobs | 🟡 Partial |
| kernel-service | @ml-team | Python 3.11 | ML inference/knowledge | 🟡 Partial |
| dna-ingest-service | @data-team | Python 3.11 | Data ingestion | 🟡 Partial |
| discovery-service | @discovery-team | Python 3.11 | Candidate discovery | 🟡 Partial |

### Status Legend
- 🟢 Production (v1 stable)
- 🟡 Partial (domain + application + infrastructure stubs, no business logic)
- 🔴 Stub (directory structure only)
- ⚫ Planned (not yet created)

## Deployment Topology

```
┌─────────────────────────────────────────────────────┐
│ Client Layer (Mobile/Web)                           │
│ Flutter + Next.js 15.1.0                            │
└────────────────┬────────────────────────────────────┘
                 │ HTTPS/gRPC
┌────────────────▼────────────────────────────────────┐
│ API Gateway (AWS CloudFront + Envoy)                │
│ gateway service: JWT validation, routing            │
└────────────────┬────────────────────────────────────┘
                 │
    ┌────────────┼────────────┬──────────────┐
    │            │            │              │
┌───▼───┐   ┌────▼────┐ ┌────▼────┐   ┌────▼────┐
│ Graph │   │  Feed   │ │ Identity │   │ Rooms   │
│Service│   │Service  │ │ Service  │   │Service  │
└───┬───┘   └────┬────┘ └────┬────┘   └────┬────┘
    │            │            │              │
    └────────────┼────────────┴──────────────┘
                 │ Kafka (AWS MSK)
        ┌────────▼────────┐
        │ Event Bus       │
        │ (5 topics)      │
        └────────┬────────┘
                 │
    ┌────────────┼────────────┐
    │            │            │
┌───▼───┐   ┌────▼────┐ ┌────▼────┐
│Behavior│   │Discovery │ │Photoplay│
│Service │   │Service   │ │Service  │
└────────┘   └──────────┘ └─────────┘
```

## Data Layer Configuration

- **Primary Relational**: PostgreSQL 16 (Aurora) - vault_memories, behavioral_events, marketplace
- **Graph Database**: Neo4j Aura Enterprise - relationships, knowledge graph
- **Time-Series**: AWS Keyspaces (Cassandra) - behavioral events, analytics
- **Cache**: Redis 7 Cluster (2 shards, 2 nodes/shard) - sessions, recommendations
- **Event Stream**: AWS MSK (Kafka) - 5 Avro topics, BACKWARD_TRANSITIVE

## Critical Integration Points

### Feed Service Dependencies
- Neo4j (graph traversal for recommendations)
- Redis (feed cache, user preferences)
- Kafka (rank events, behavioral signals)
- PostgreSQL (feed metadata)

### Gateway Critical Path
- JWT validation via Identity Service
- Request routing to 9 backend services
- Rate limiting + RBAC enforcement
- Request/response transformation

## Next Priorities

1. **Gateway Implementation** (unblocks all integration)
   - [ ] JWT middleware
   - [ ] Service discovery/routing table
   - [ ] Rate limiting
   - [ ] Request correlation IDs

2. **Feed Service** (core business logic)
   - [ ] Ranking algorithm implementation
   - [ ] Redis cache integration
   - [ ] Kafka producer wiring
   - [ ] Integration tests

3. **Identity Service** (auth foundation)
   - [ ] JWT token generation
   - [ ] User creation/validation
   - [ ] OAuth2 federation setup

4. **Behavioral Service** (analytics pipeline)
   - [ ] Kafka consumer implementation
   - [ ] Cassandra schema validation
   - [ ] Event aggregation jobs
