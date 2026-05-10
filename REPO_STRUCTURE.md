# KinnectAI Repository Structure

**Last Updated:** May 9, 2026  
**Total Tracked Files:** 783  

---

## Directory Tree

```
KinnectAI-1/
├── .env.example
├── .github/
│   └── workflows/
│       ├── flutter.yml
│       ├── flutter-ci.yml
│       ├── go.yml
│       └── prd-coverage-gate.yml
├── .gitignore
├── .vscode/
│   ├── extensions.json
│   └── settings.json
│
├── apps/
│   ├── mobile/                          # Flutter iOS/Android/Web (55-65% complete)
│   │   ├── analysis_options.yaml
│   │   ├── build.yaml
│   │   ├── pubspec.yaml
│   │   ├── android/                     # Android project (Gradle, manifests, resources)
│   │   ├── ios/                         # iOS project (XCode, Swift, assets)
│   │   ├── linux/                       # Linux desktop target
│   │   ├── macos/                       # macOS desktop target
│   │   ├── windows/                     # Windows desktop target
│   │   ├── web/                         # Web target (Flutter Web)
│   │   ├── config/
│   │   │   └── error_registry.yaml
│   │   ├── lib/
│   │   │   ├── main.dart
│   │   │   ├── app.dart
│   │   │   ├── api/                     # OpenAPI generated client (~150 files)
│   │   │   ├── blocs/                   # Business Logic components
│   │   │   │   ├── discovery_bloc.dart
│   │   │   │   ├── tree_graph_bloc.dart
│   │   │   │   └── steward_cubit.dart
│   │   │   ├── cubits/                  # State management (~25 cubits)
│   │   │   │   ├── auth_cubit.dart
│   │   │   │   ├── memory_box_cubit.dart
│   │   │   │   ├── marketplace_cubit.dart
│   │   │   │   └── ... (19 more)
│   │   │   ├── features/                # Feature-based screens
│   │   │   │   ├── auth/screens/
│   │   │   │   ├── home/screens/
│   │   │   │   ├── tree/screens/
│   │   │   │   ├── vault/screens/
│   │   │   │   ├── rooms/screens/
│   │   │   │   ├── messaging/screens/
│   │   │   │   ├── profile/screens/
│   │   │   │   └── ... (10+ more features)
│   │   │   ├── screens/                 # 100+ screen files
│   │   │   │   ├── welcome_screen.dart
│   │   │   │   ├── login_screen.dart
│   │   │   │   ├── home_screen.dart
│   │   │   │   ├── tree_screen.dart
│   │   │   │   ├── discovery_card_screen.dart
│   │   │   │   ├── memory_box_screen.dart
│   │   │   │   ├── rooms_screen.dart
│   │   │   │   ├── marketplace_cart_screen.dart
│   │   │   │   └── ... (90+ more)
│   │   │   ├── models/
│   │   │   │   ├── dtos/               # Data Transfer Objects
│   │   │   │   │   ├── user_dto.dart
│   │   │   │   │   ├── memory_dto.dart
│   │   │   │   │   ├── discovery_candidate_dto.dart
│   │   │   │   │   └── ... (15+ more)
│   │   │   │   └── ... (30+ model files)
│   │   │   ├── repositories/           # Repository pattern (~20 repos)
│   │   │   │   ├── feed_repository.dart
│   │   │   │   ├── discovery_repository.dart
│   │   │   │   ├── memory_box_repository.dart
│   │   │   │   └── ... (17 more)
│   │   │   ├── services/               # API services
│   │   │   │   ├── api_service.dart
│   │   │   │   ├── auth_service.dart
│   │   │   │   ├── api/
│   │   │   │   │   ├── feed_service_api.dart
│   │   │   │   │   ├── discovery_service_api.dart
│   │   │   │   │   ├── kernel_service_api.dart
│   │   │   │   │   └── ... (8 service APIs)
│   │   │   │   └── ... (10 more services)
│   │   │   ├── router/                 # Navigation
│   │   │   │   ├── app_router.dart
│   │   │   │   ├── app_nav.dart
│   │   │   │   └── go_router_config.dart
│   │   │   ├── guards/                 # Route guards
│   │   │   │   ├── auth_route_guard.dart
│   │   │   │   └── step_up_route_guard.dart
│   │   │   ├── foundation/             # Core functionality
│   │   │   │   ├── app_bootstrap.dart
│   │   │   │   ├── offline/           # Offline sync
│   │   │   │   │   ├── offline_sync_manager.dart
│   │   │   │   │   ├── offline_database.dart
│   │   │   │   │   ├── conflict_resolver.dart
│   │   │   │   │   └── mutation_queue.dart
│   │   │   │   └── error_boundary.dart
│   │   │   ├── core/                  # Core utilities
│   │   │   │   ├── errors/
│   │   │   │   ├── storage/
│   │   │   │   └── consent/
│   │   │   ├── constants/
│   │   │   │   └── icon_mapping.dart
│   │   │   └── config/
│   │   │       └── line_config.dart
│   │   └── assets/                     # Images, fonts, etc.
│   │
│   └── web/                             # Next.js web app (40-50% complete)
│       ├── package.json
│       ├── package-lock.json
│       ├── next.config.mjs
│       ├── tsconfig.json
│       ├── tailwind.config.js
│       ├── app/
│       │   ├── layout.tsx
│       │   ├── page.tsx
│       │   ├── [route]/                 # Dynamic routes
│       │   ├── auth/
│       │   ├── api/                     # API routes
│       │   └── ... (15+ route groups)
│       ├── src/
│       │   ├── screens/                 # Page components
│       │   ├── stores/                  # Zustand state management
│       │   ├── api/                     # API clients (TanStack Query)
│       │   ├── components/
│       │   │   ├── design-system/       # Reusable UI components
│       │   │   ├── common/
│       │   │   └── features/
│       │   ├── utils/
│       │   ├── types/                   # TypeScript types
│       │   └── hooks/                   # Custom React hooks
│       ├── public/                      # Static assets
│       └── node_modules/                # Dependencies (not tracked)
│
├── services/
│   ├── gateway/                         # API/auth boundary (NOT CREATED YET)
│   │
│   ├── go/                              # Go microservices
│   │   ├── feed-service/                # Feed assembly & caching (77 files, 60-70% scaffolded)
│   │   │   ├── cmd/api/
│   │   │   │   └── main.go
│   │   │   ├── internal/
│   │   │   │   ├── feed/
│   │   │   │   ├── moderation/
│   │   │   │   ├── cache/
│   │   │   │   └── ... (15 domains)
│   │   │   ├── pkg/
│   │   │   │   ├── middleware/
│   │   │   │   ├── database/
│   │   │   │   └── types/
│   │   │   ├── go.mod
│   │   │   ├── Dockerfile
│   │   │   └── README.md
│   │   │
│   │   ├── kin-graph-service/           # Neo4j graph ops (Basic scaffolding)
│   │   │   ├── cmd/api/main.go
│   │   │   ├── go.mod
│   │   │   ├── Dockerfile
│   │   │   └── README.md
│   │   │
│   │   ├── identity-service/            # Whitepages/LexisNexis resolution
│   │   │   ├── cmd/api/main.go
│   │   │   ├── go.mod
│   │   │   ├── Dockerfile
│   │   │   └── README.md
│   │   │
│   │   ├── media-service/               # FFmpeg transcoding
│   │   │   ├── cmd/api/main.go
│   │   │   ├── go.mod
│   │   │   ├── Dockerfile                # (jrottenberg/ffmpeg base)
│   │   │   └── README.md
│   │   │
│   │   ├── rooms-service/               # WebRTC signaling
│   │   │   ├── cmd/api/main.go
│   │   │   ├── go.mod
│   │   │   ├── Dockerfile
│   │   │   └── README.md
│   │   │
│   │   ├── memorybox-service/           # ZK envelope encryption
│   │   │   ├── cmd/api/main.go
│   │   │   ├── go.mod
│   │   │   ├── Dockerfile
│   │   │   └── README.md
│   │   │
│   │   ├── notification-service/        # FCM/APNS dispatch
│   │   │   ├── cmd/api/main.go
│   │   │   ├── go.mod
│   │   │   ├── Dockerfile
│   │   │   └── README.md
│   │   │
│   │   └── payment-service/             # RevenueCat + Stripe
│   │       ├── cmd/api/main.go
│   │       ├── go.mod
│   │       ├── Dockerfile
│   │       └── README.md
│   │
│   └── python/                          # Python microservices
│       ├── photoplay-service/           # Media orchestration (FastAPI)
│       │   ├── app/
│       │   │   └── main.py
│       │   ├── requirements.txt
│       │   ├── Dockerfile
│       │   └── README.md
│       │
│       ├── behavioral-service/          # Behavioral event aggregation
│       │   ├── app/
│       │   │   └── main.py
│       │   ├── requirements.txt
│       │   ├── Dockerfile
│       │   └── README.md
│       │
│       ├── kernel-service/              # KC computation (Stub)
│       ├── dna-ingest-service/          # VCF processing (Stub)
│       └── discovery-service/           # Candidate ranking (Stub)
│
├── packages/
│   ├── auth-sdk/
│   │   └── README.md
│   │
│   ├── consent-engine/
│   │   └── README.md
│   │
│   ├── design-system/
│   │   └── README.md
│   │
│   ├── shared-contracts/
│   │   ├── README.md
│   │   ├── avro/
│   │   ├── event-schemas/
│   │   ├── graphql/
│   │   ├── openapi/
│   │   ├── protobuf/
│   │   └── kafka-schemas/              # Avro schemas
│   │       ├── behavioral-events-value.avsc
│   │       ├── cr-recompute-value.avsc
│   │       ├── vault-triggers-value.avsc
│   │       ├── discovery-matches-value.avsc
│   │       └── photoplay-jobs-value.avsc
│   │
│   ├── telemetry/
│   │   └── README.md
│   │
│   └── shared-libs/
│       ├── go/
│       │   ├── auth/
│       │   │   └── jwt.go
│       │   └── database/
│       │       └── connections.go
│       └── python/
│           ├── auth/
│           │   └── jwt.py
│           └── database/
│               └── connections.py
│
├── infra/
│   ├── cassandra/                       # Cassandra/Keyspaces config
│   ├── helm/                            # Kubernetes Helm
│   │   └── kinnectai/
│   │       └── Chart.yaml
│   ├── kafka/                           # Kafka/MSK config
│   ├── kubernetes/                      # K8s manifests
│   │   ├── helm/
│   │   ├── overlays/
│   │   │   ├── dev/
│   │   │   ├── staging/
│   │   │   └── prod/
│   │   │       └── namespace.yaml
│   │   └── base/
│   ├── monitoring/                      # Observability
│   ├── neo4j/                           # Neo4j config
│   ├── postgres/                        # PostgreSQL config
│   ├── redis/                           # Redis config
│   └── terraform/                       # Terraform IaC
│       ├── modules/                     # 12 infrastructure modules
│       │   ├── vpc/
│       │   │   ├── main.tf
│       │   │   └── variables.tf
│       │   ├── eks/
│       │   │   ├── main.tf
│       │   │   └── variables.tf
│       │   ├── rds-aurora/
│       │   │   ├── main.tf
│       │   │   └── variables.tf
│       │   ├── neo4j-aura/
│       │   ├── msk/
│       │   ├── schema-registry/
│       │   ├── elasticache/
│       │   ├── keyspaces/
│       │   ├── s3/
│       │   ├── cloudfront/
│       │   ├── cloudhsm/
│       │   └── c2pa-signing/
│       └── environments/                # 3 deployment environments
│           ├── dev/
│           │   ├── main.tf
│           │   ├── variables.tf
│           │   └── outputs.tf
│           ├── staging/
│           │   ├── main.tf
│           │   ├── variables.tf
│           │   └── outputs.tf
│           └── prod/
│               ├── main.tf
│               ├── variables.tf
│               └── outputs.tf
│
├── infrastructure/                      # Terraform modules structure (Alternative)
│   └── terraform/
│       ├── modules/                     # 12 modules (same as /infra/terraform/modules)
│       ├── environments/
│       └── policies/
│           ├── iam/
│           ├── network/
│           └── compliance/
│
├── migrations/
│   ├── postgres/
│   │   ├── 000_baseline_schema.sql
│   │   ├── 001_initial_schema.sql
│   │   ├── 002_marketplace_schema.sql
│   │   ├── 003_moderation_schema.sql
│   │   ├── 004_vault_memories.sql       # NEW: ZK architecture
│   │   ├── 005_behavioral_events.sql    # NEW: Sampled events
│   │   └── 20260509_create_moderation_tables.sql
│   │
│   ├── neo4j/
│   │   ├── 001_initial_schema.cypher
│   │   ├── 002_constraints.cypher
│   │   └── 003_graph_indexes.cypher     # NEW: Graph operations
│   │
│   └── cassandra/
│       ├── 001_initial_schema.cql
│       └── 002_behavioral_schema.cql    # NEW: Time-series with TTL
│
├── observability/
│   ├── prometheus/
│   │   └── prometheus.yml
│   ├── grafana/
│   │   └── dashboards.md
│   ├── loki/
│   │   └── loki.yml
│   ├── jaeger/
│   │   └── jaeger.yml
│   └── otel/
│       └── otel-collector.yml
│
├── security/
│   ├── kms/
│   │   └── kms-policies.md
│   ├── policies/
│   │   └── security-policies.md
│   └── compliance/
│       └── compliance-matrix.md
│
├── docs/
│   ├── architecture/
│   │   ├── KinnectAI_SRS_v1.0.docx.md
│   │   ├── prd.docx.md
│   │   ├── monorepo-conventions.md
│   │   └── service-ownership.md
│   ├── api/                             # API documentation
│   ├── compliance/                      # Compliance docs
│   ├── diagrams/                        # Architecture diagrams
│   ├── product/
│   ├── runbooks/
│   └── prd_traceability.json
│
├── deploy/
│   ├── README.md
│   ├── local/README.md
│   ├── production/README.md
│   ├── staging/README.md
│   └── bootstrap/                       # Deployment automation
│
├── scripts/
│   ├── bootstrap/
│   │   ├── init-cassandra.ps1
│   │   └── migrate-postgres.ps1
│   ├── ci/
│   │   ├── lint_icon_palette.ps1
│   │   ├── validate_prd_trace.py
│   │   ├── verify-foundation.ps1
│   │   └── verify-production.sh
│   ├── dev/
│   │   ├── dev-api.ps1
│   │   ├── dev-stack.ps1
│   │   └── flutter_test_windows.ps1
│   ├── release/
│   └── data/                            # Data seeding scripts
│
├── tests/
│   ├── contracts/                       # API contract tests
│   ├── e2e/                             # End-to-end tests
│   │   └── services/
│   │       └── conftest.py
│   ├── integration/                     # Integration tests
│   │   └── kafka/
│   │       └── test_kafka_flow.py
│   ├── load/                            # Load tests (k6)
│   │   └── load-test.js
│   └── chaos/                           # Chaos engineering
│       └── chaos-experiments.md
│
├── tools/
│   └── prd_coverage_gate/               # PRD validation tooling
│
├── docker-compose.yml                   # Local development orchestration
├── README.md
└── REPO_STRUCTURE.md                    # This file

```

---

## File Count Summary

| Category | Count |
|----------|-------|
| **Total Tracked Files** | 783 |
| **Flutter Mobile** | 250+ |
| **Next.js Web** | 120+ |
| **Go Services** | 80+ |
| **Python Services** | 20+ |
| **Terraform/IaC** | 50+ |
| **Migrations/Schemas** | 15+ |
| **Tests** | 10+ |
| **CI/CD & Scripts** | 20+ |
| **Docs** | 15+ |

---

## Service Ports

| Service | Port | Language | Status |
|---------|------|----------|--------|
| API Gateway | 8000 | Go | Not Created |
| Discovery Service | 8091 | Python | Stub |
| Kernel Service | 8083 | Python | Stub |
| Behavioral Service | 8087 | Python | Basic |
| DNA Ingest Service | 8085 | Python | Stub |
| Photoplay Service | 8084 | Python | Basic |
| Kin Graph Service | 8081 | Go | Basic |
| Identity Service | 8086 | Go | Basic |
| Feed Service | 8080 | Go | 60-70% |
| Media Service | 8088 | Go | Basic |
| Rooms Service | 8089 | Go | Basic |
| Memorybox Service | 8090 | Go | Basic |
| Notification Service | 8092 | Go | Basic |
| Payment Service | 8093 | Go | Basic |

---

## Data Layer

### PostgreSQL
- `vault_memories` - ZK encrypted memory storage
- `behavioral_events` - Sampled, partitioned event stream
- Plus 7 existing migration files

### Neo4j
- Graph indexes for genealogical relationships
- Kinnection scoring (CR) computation
- Branch traversal queries

### Cassandra/Keyspaces
- Time-series behavioral events (TWCS compaction)
- 730-day TTL, 2 replicas
- Materialized view for GDPR Art. 15 access

### Redis
- Cluster mode, 2 shards, 2 nodes per shard
- Cache & session state

### Kafka (AWS MSK)
- 5+ Avro topic schemas defined
- BACKWARD_TRANSITIVE compatibility
- Schema Registry integration

---

## Infrastructure

### Terraform Modules (12)
1. VPC - 6 subnets, 2 NAT gateways
2. EKS - 3 AZs, Karpenter, IAM OIDC
3. RDS Aurora - PostgreSQL 16, Multi-AZ
4. Neo4j Aura - Enterprise config
5. MSK - 3 brokers, TLS encrypted
6. Schema Registry - Confluent
7. ElastiCache - Redis 7, cluster mode
8. Keyspaces - Cassandra-compatible
9. S3 - App data & lifecycle
10. CloudFront - TLS 1.3, WAF
11. CloudHSM - FIPS 140-2 L3
12. C2PA Signing - Media authentication

### Environments
- **dev/** - Full stack, minimal resources
- **staging/** - Production-like, limited scale
- **prod/** - Full scale, 3 AZs, HA

### Policies
- IAM policies (Zero-trust, JIT access)
- Network policies (security groups, NACLs)
- Compliance (GDPR, HIPAA, GINA, BIPA)

---

## Observability Stack

- **Prometheus** - Metrics collection & SLO tracking
- **Grafana** - Dashboards (Feed, KC, Memory Box, Photoplay, Rooms)
- **Loki** - Log aggregation (structured logs, user_id hashed)
- **Jaeger** - Distributed tracing (100% trace coverage)
- **OTel Collector** - Centralized telemetry pipeline

---

## Code Generation & Contracts

### Kafka Schemas (5 Avro)
1. `behavioral-events-value.avsc` - Event stream
2. `cr-recompute-value.avsc` - Kinnection recomputation
3. `vault-triggers-value.avsc` - Memory delivery triggers
4. `discovery-matches-value.avsc` - Candidate matches
5. `photoplay-jobs-value.avsc` - Media pipeline jobs

### Shared Libraries
- **Go Auth** - JWT validation, consent enforcement, step-up verification
- **Go Database** - Connection pooling, Neo4j, PostgreSQL, Redis, Cassandra
- **Python Auth** - JWT middleware, consent validation
- **Python Database** - SQLAlchemy integration, connection pools

---

## CI/CD

### Workflows
- `.github/workflows/flutter.yml` - Mobile build & test
- `.github/workflows/go.yml` - Go service testing
- `.github/workflows/prd-coverage-gate.yml` - PRD traceability validation

### Scripts
- `scripts/ci/verify-monorepo-structure.ps1` - Structure validation
- `scripts/ci/validate_prd_trace.py` - PRD traceability
- `scripts/bootstrap/` - Database initialization
- `scripts/dev/` - Local development helpers

---

## Monorepo Conventions

✅ **Enforced Rules:**
- All Go services in `services/go/<name>/`
- All Python services in `services/python/<name>/`
- No stubs without README + owner
- Migrations grouped by datastore
- Docs grouped by domain
- Scripts grouped by lifecycle (bootstrap, ci, dev, release, data)

🔍 **Verified by:** `scripts/ci/verify-monorepo-structure.ps1`

---

**Next Phase:** Service business logic implementation + Terraform module AWS resource definitions
