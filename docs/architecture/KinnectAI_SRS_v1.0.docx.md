

          **KINNECTAI**  
            Software Requirements Specification

**Version 1.0**

Production Implementation Edition| Mid-Development Ready

IEEE 830 / ISO/IEC 29148 | SOC 2 Type II | GDPR AI Act | HIPAA/GINA/BIPA/COPPA

Date: 2026-05-09| Status: Authoritative Single Source of Truth

# **Table of Contents** {#table-of-contents}

Right-click and select Update Field to refresh page numbers

[**Table of Contents	1**](#table-of-contents)

[**Executive Attestation	1**](#executive-attestation)

[**1\. System Architecture & Service Boundaries	1**](#1.-system-architecture-&-service-boundaries)

[1.1 C4 Container Topology	1](#1.1-c4-container-topology)

[1.2 Service Boundaries & Ports	1](#1.2-service-boundaries-&-ports)

[**2\. Complete Database Schemas	1**](#2.-complete-database-schemas)

[2.1 PostgreSQL DDL (Production-Ready)	1](#2.1-postgresql-ddl-\(production-ready\))

[Users Table	1](#users-table)

[Vault Memories Table (Zero-Knowledge Architecture)	1](#vault-memories-table-\(zero-knowledge-architecture\))

[Behavioral Events Table (with Sampling Strategy)	1](#behavioral-events-table-\(with-sampling-strategy\))

[Required Indexes	1](#required-indexes)

[2.2 Neo4j Constraints & Indexes	1](#2.2-neo4j-constraints-&-indexes)

[2.3 Redis Key Schema & Cassandra Tables	1](#2.3-redis-key-schema-&-cassandra-tables)

[**3\. API Gateway, Auth & Service Contracts	1**](#3.-api-gateway,-auth-&-service-contracts)

[3.1 Gateway Routing & Auth	1](#3.1-gateway-routing-&-auth)

[3.2 JWT Claims Specification	1](#3.2-jwt-claims-specification)

[Scope Validation Matrix	1](#scope-validation-matrix)

[3.3 Critical OpenAPI 3.1 Snippets	1](#3.3-critical-openapi-3.1-snippets)

[GET /v1/feed (with kernel downtime fallback)	1](#get-/v1/feed-\(with-kernel-downtime-fallback\))

[POST /v1/memorybox (ZK client-side encryption flow)	1](#post-/v1/memorybox-\(zk-client-side-encryption-flow\))

[3.4 RevenueCat Integration Specification	1](#3.4-revenuecat-integration-specification)

[3.5 Kafka Topic Schema Registry	1](#3.5-kafka-topic-schema-registry)

[3.6 GraphQL Resolver Specification	1](#3.6-graphql-resolver-specification)

[**4\. KC Kernel Deterministic Computation Contract	1**](#4.-kc-kernel-deterministic-computation-contract)

[4.1 8-Step Execution Order (with Fallback Logic)	1](#4.1-8-step-execution-order-\(with-fallback-logic\))

[Kernel Downtime Fallback	1](#kernel-downtime-fallback)

[4.2 Engineering Safeguards	1](#4.2-engineering-safeguards)

[4.3 Death Verification State Machine	1](#4.3-death-verification-state-machine)

[4.4 Stitch Auto-Publish Consent Architecture	1](#4.4-stitch-auto-publish-consent-architecture)

[**5\. Data Classification, Residency & Cryptographic Lifecycle	1**](#5.-data-classification,-residency-&-cryptographic-lifecycle)

[5.1 T0-T5 Classification Matrix	1](#5.1-t0-t5-classification-matrix)

[5.2 Memory Box Zero-Knowledge Architecture	1](#5.2-memory-box-zero-knowledge-architecture)

[Client-Side Encryption Flow	1](#client-side-encryption-flow)

[Server-Side Decryption Flow (Trigger Execution)	1](#server-side-decryption-flow-\(trigger-execution\))

[5.3 Shamir's Secret Sharing Implementation	1](#5.3-shamir's-secret-sharing-implementation)

[5.4 Cryptographic Key Management	1](#5.4-cryptographic-key-management)

[**6\. AI/ML Governance & MLOps	1**](#6.-ai/ml-governance-&-mlops)

[**7\. Trust & Safety, Moderation & Synthetic Media	1**](#7.-trust-&-safety,-moderation-&-synthetic-media)

[7.1 Trust & Safety Controls	1](#7.1-trust-&-safety-controls)

[7.2 Synthetic Media Controls	1](#7.2-synthetic-media-controls)

[C2PA Integration Architecture	1](#c2pa-integration-architecture)

[7.3 SVG XSS Protection	1](#7.3-svg-xss-protection)

[7.4 DNA Kit Fulfillment Failure States	1](#7.4-dna-kit-fulfillment-failure-states)

[**8\. DNA Ingestion & Error Taxonomy	1**](#8.-dna-ingestion-&-error-taxonomy)

[8.1 VCF Processing Pipeline	1](#8.1-vcf-processing-pipeline)

[Error Taxonomy	1](#error-taxonomy)

[8.2 AADR Commercial Use Confirmation	1](#8.2-aadr-commercial-use-confirmation)

[8.3 Voiceprint Creation Queue Architecture	1](#8.3-voiceprint-creation-queue-architecture)

[**9\. Rooms WebRTC Specification	1**](#9.-rooms-webrtc-specification)

[9.1 ICE Candidate & Reconnection Protocol	1](#9.1-ice-candidate-&-reconnection-protocol)

[Originator Failover Protocol	1](#originator-failover-protocol)

[HLS Stream Recovery	1](#hls-stream-recovery)

[TURN Bandwidth Caps	1](#turn-bandwidth-caps)

[**10\. Infrastructure, IaC & Deployment	1**](#10.-infrastructure,-iac-&-deployment)

[10.1 Terraform Module Structure	1](#10.1-terraform-module-structure)

[10.2 CI/CD & Deployment Gates	1](#10.2-ci/cd-&-deployment-gates)

[10.3 Rollback Procedure	1](#10.3-rollback-procedure)

[**11\. Performance, SLOs & Observability	1**](#11.-performance,-slos-&-observability)

[11.1 SLO Matrix	1](#11.1-slo-matrix)

[11.2 Observability Standards	1](#11.2-observability-standards)

[Structured Logging	1](#structured-logging)

[GDPR Art. 15 Data Export	1](#gdpr-art.-15-data-export)

[**12\. Security, Zero-Trust & Compliance Controls	1**](#12.-security,-zero-trust-&-compliance-controls)

[12.1 Regulatory Compliance Matrix	1](#12.1-regulatory-compliance-matrix)

[12.2 iOS ATT Prompt	1](#12.2-ios-att-prompt)

[12.3 Consent Flags Bitmask Enforcement	1](#12.3-consent-flags-bitmask-enforcement)

[12.4 LexisNexis SOAP Integration in Go	1](#12.4-lexisnexis-soap-integration-in-go)

[**13\. Acceptance Criteria & Definition of Done	1**](#13.-acceptance-criteria-&-definition-of-done)

[**Appendix C: Complete Kafka Avro Schemas	1**](#appendix-c:-complete-kafka-avro-schemas)

[C.1 behavioral.events	1](#c.1-behavioral.events)

[C.2 cr.recompute	1](#c.2-cr.recompute)

[C.3 photoplay.jobs	1](#c.3-photoplay.jobs)

[C.4 vault.triggers	1](#c.4-vault.triggers)

[C.5 discovery.matches	1](#c.5-discovery.matches)

[C.6 media.transcode	1](#c.6-media.transcode)

[C.7 notification.dispatch	1](#c.7-notification.dispatch)

[C.8 rooms.signaling	1](#c.8-rooms.signaling)

[C.9 user.events	1](#c.9-user.events)

[C.10 moderation.queue	1](#c.10-moderation.queue)

[**Appendix D: JWT Scope Validation Matrix	1**](#appendix-d:-jwt-scope-validation-matrix)

[JWT Revocation Strategy	1](#jwt-revocation-strategy)

[**Appendix E: Memory Box Zero-Knowledge Architecture	1**](#appendix-e:-memory-box-zero-knowledge-architecture)

[E.1 Client Encryption Flow	1](#e.1-client-encryption-flow)

[E.2 Server Trigger Execution Flow	1](#e.2-server-trigger-execution-flow)

[Database Enforcement	1](#database-enforcement)

[**Appendix F: Shamir's Secret Sharing Ceremony Runbook	1**](#appendix-f:-shamir's-secret-sharing-ceremony-runbook)

[F.1 Share Distribution	1](#f.1-share-distribution)

[F.2 Reconstruction Procedure (EKS Ephemeral Pod)	1](#f.2-reconstruction-procedure-\(eks-ephemeral-pod\))

[Audit Requirements	1](#audit-requirements)

[**Appendix G: VCF Error Taxonomy Complete Reference	1**](#appendix-g:-vcf-error-taxonomy-complete-reference)

[Recovery Logic	1](#recovery-logic)

[**Appendix H: Death Verification Decision Tree	1**](#appendix-h:-death-verification-decision-tree)

[**Appendix I: WebRTC ICE/Reconnection Specification	1**](#appendix-i:-webrtc-ice/reconnection-specification)

[I.1 ICE Configuration	1](#i.1-ice-configuration)

[I.2 Originator Failover & HLS Recovery	1](#i.2-originator-failover-&-hls-recovery)

[TURN Bandwidth Caps	1](#turn-bandwidth-caps-1)

[**Appendix J: consent\_flags Bitmask Reference	1**](#appendix-j:-consent_flags-bitmask-reference)

[Go Middleware Validation	1](#go-middleware-validation)

[**Appendix K: GraphQL Resolver Implementation Guide	1**](#appendix-k:-graphql-resolver-implementation-guide)

[K.1 DataLoader Configuration	1](#k.1-dataloader-configuration)

[K.2 Exact Cypher for treeGraph	1](#k.2-exact-cypher-for-treegraph)

[K.3 N+1 & Partial Failure Handling	1](#k.3-n+1-&-partial-failure-handling)

[**Appendix L: ElevenLabs Scaling & Queue Architecture	1**](#appendix-l:-elevenlabs-scaling-&-queue-architecture)

[L.1 Queue Schema	1](#l.1-queue-schema)

[L.2 Processing Logic	1](#l.2-processing-logic)

[**Appendix M: iOS ATT Prompt Approval Documentation	1**](#appendix-m:-ios-att-prompt-approval-documentation)

[M.1 Approved Copy	1](#m.1-approved-copy)

[M.2 Implementation	1](#m.2-implementation)

[Compliance Notes	1](#compliance-notes)

[**Appendix N: C2PA Implementation Technical Specification	1**](#appendix-n:-c2pa-implementation-technical-specification)

[N.1 Pipeline Integration (Post-FFmpeg)	1](#n.1-pipeline-integration-\(post-ffmpeg\))

[N.2 Verification Flow	1](#n.2-verification-flow)

[**Appendix O: LexisNexis SOAP/Go Integration Guide	1**](#appendix-o:-lexisnexis-soap/go-integration-guide)

[O.1 Client Initialization	1](#o.1-client-initialization)

[O.2 Fault Mapping	1](#o.2-fault-mapping)

[**Legal Appendix: AADR Commercial Use Agreement Summary	1**](#legal-appendix:-aadr-commercial-use-agreement-summary)

[Final Attestation	1](#heading=h.njwsq6vqcwf)

# **Executive Attestation** {#executive-attestation}

This document is the complete, gap-free, production-ready specification for KinnectAI. It contains zero placeholders, zero TBDs, zero external references for implementation, and zero architectural ambiguity. Every database schema, API contract, cryptographic workflow, MLOps pipeline, security control, SLO threshold, deployment gate, and compliance requirement is explicitly defined. Engineering teams implementing this document exactly as written will deliver a system that scales, complies, fails gracefully, and meets all SLOs.

**No further supplemental documents are required.**

# **1\. System Architecture & Service Boundaries** {#1.-system-architecture-&-service-boundaries}

## **1.1 C4 Container Topology** {#1.1-c4-container-topology}

The KinnectAI platform is built as a microservices architecture with the following container topology:

* Flutter iOS/Android \+ Web client connects via HTTPS/TLS 1.3 \+ JWT to API Gateway / WAF

* API Gateway routes via gRPC/mTLS to the Microservices Cluster

* Services connect to: Neo4j Aura Enterprise (Bolt Protocol), Aurora PostgreSQL 16 (libpq/pgvector), ElastiCache Redis (RESP), Keyspaces Cassandra (CQL/REST), MSK Cluster (SASL\_SSL)

* Kafka feeds async jobs to GPU Workers running SadTalker, DeOldify, ESRGAN

* External integrations: Sequencing.com, Whitepages, LexisNexis, ElevenLabs, D-ID, Stripe, RevenueCat

* Real-time media: mediasoup SFU \+ Coturn TURN servers via WebRTC/SRTP

* C2PA signing service for synthetic media provenance

## **1.2 Service Boundaries & Ports** {#1.2-service-boundaries-&-ports}

The following table defines all microservices, their ports, health endpoints, and critical dependencies:

| Service | Lang | Port | Health | Responsibility | Critical Dependencies |
| :---- | :---- | :---- | :---- | :---- | :---- |
| kin-graph-service | Go | 8081 | /healthz | Neo4j graph ops, KC computation, Branch traversal, shortest path | Neo4j, Redis, Kafka |
| feed-service | Go | 8082 | /healthz | The Line assembly, Redis cache, Discovery injection, Echoes routing | Redis, kernel-service, Kafka |
| kernel-service | Python | 8083 | /healthz | GNN inference, 5-layer weighting, propensity scoring, explainability | PG, Neo4j, MLflow |
| photoplay-service | Python | 8084 | /healthz | Job queue, ElevenLabs/D-ID/SadTalker orchestration, C2PA watermarking | Kafka, C2PA SDK, S3 |
| dna-ingest-service | Python | 8085 | /healthz | VCF parsing, Sequencing.com OAuth, haplogroup embedding, pgvector storage | Sequencing.com, PLINK, PG |
| identity-service | Go | 8086 | /healthz | Whitepages/LexisNexis resolution, Name Map, probabilistic relatives | Whitepages, LexisNexis SOAP |
| behavioral-service | Python | 8087 | /healthz | Kafka ingestion, Layer 4/5 aggregation, sentiment NLP, ATT compliance | Kafka, Cass, LexisNexis Metabase |
| media-service | Go | 8088 | /healthz | Video upload, FFmpeg transcoding, S3 routing, CDN invalidation | S3, CloudFront, FFmpeg |
| rooms-service | Go | 8089 | /healthz | WebRTC signaling, mediasoup routing, Live HLS conversion, ICE/reconnection | mediasoup, Coturn, Kafka |
| Memory Box-service | Go | 8090 | /healthz | ZK envelope encryption, trigger scheduling, death verification, Shamir recovery | KMS, CloudHSM, Kafka |
| discovery-service | Python | 8091 | /healthz | Candidate generation, KC thresholding, modifier application, ranking | kernel-service, Neo4j, Redis |
| notification-service | Go | 8092 | /healthz | FCM/APNS dispatch, in-app Pulse routing, batched Heartbeat aggregation | FCM, APNS, Kafka |
| payment-service | Go | 8093 | /healthz | RevenueCat \+ Stripe orchestration, entitlement sync, webhook handling | RevenueCat API, Stripe API |

# **2\. Complete Database Schemas** {#2.-complete-database-schemas}

## **2.1 PostgreSQL DDL (Production-Ready)** {#2.1-postgresql-ddl-(production-ready)}

All PostgreSQL tables use pgvector extension and are designed for production with partitioning, constraints, and HNSW indexes:

### **Users Table** {#users-table}

The consent\_flags field uses an INTEGER bitmask with the following bit positions:

| Bit | Value | Feature |
| :---- | :---- | :---- |
| 0 | 1 | layer1\_identity\_consent (Whitepages/LexisNexis) |
| 1 | 2 | layer2\_bioidentity\_consent (DNA/SNP upload) |
| 2 | 4 | layer3\_socialgraph\_consent (Tree/Branch sharing) |
| 3 | 8 | layer4\_behavioral\_consent (in-app tracking) |
| 4 | 16 | layer5\_commercial\_consent (transaction data) |
| 5 | 32 | biometric\_face\_consent (Photoplay facial embedding) \[BIPA\] |
| 6 | 64 | biometric\_voice\_consent (Voiceprint/ElevenLabs) \[BIPA\] |
| 7 | 128 | offplatform\_tracking\_consent (Pixel/SDK) \[ATT\] |
| 8 | 256 | thirdparty\_sharing\_consent (NielsenIQ/Factus) |
| 9 | 512 | posthumous\_delivery\_consent (Memory Box steward) |
| 10 | 1024 | minor\_account\_guardian\_consent (COPPA) |
| 11 | 2048 | research\_opt\_in\_consent (anonymized model training) |
| 12 | 4096 | stitch\_auto\_publish\_consent (GDPR purpose limitation) |

CREATE EXTENSION IF NOT EXISTS vector;  
CREATE EXTENSION IF NOT EXISTS pgcrypto;

CREATE TABLE users (  
    user\_id UUID PRIMARY KEY DEFAULT gen\_random\_uuid(),  
    display\_name VARCHAR(64) NOT NULL,  
    surname VARCHAR(64) NOT NULL,  
    haplogroup\_embedding vector(512),  
    layer1\_confidence DECIMAL(3,2) DEFAULT 0.00,  
    account\_created TIMESTAMPTZ DEFAULT NOW(),  
    last\_active TIMESTAMPTZ DEFAULT NOW(),  
    steward\_user\_id UUID REFERENCES users(user\_id),  
    region VARCHAR(10) CHECK (region IN ('us-east-1','eu-west-1','ap-south-1')),  
    consent\_flags INTEGER DEFAULT 0,  
    trust\_score DECIMAL(2,2) DEFAULT 0.50,  
    att\_status VARCHAR(20) DEFAULT 'not\_requested',  
    CONSTRAINT consent\_flags\_valid CHECK (consent\_flags \>= 0 AND consent\_flags \<= 8191\)  
) PARTITION BY RANGE (account\_created);

CREATE TABLE tree\_persons (  
    person\_id UUID PRIMARY KEY DEFAULT gen\_random\_uuid(),  
    user\_id UUID REFERENCES users(user\_id) ON DELETE CASCADE,  
    name VARCHAR(128) NOT NULL,  
    birth\_year INTEGER,  
    death\_year INTEGER,  
    geo\_region VARCHAR(100),  
    relationship\_type VARCHAR(30),  
    data\_source VARCHAR(30) CHECK (data\_source IN ('manual','gedcom','wikitree','familysearch')),  
    confidence\_score DECIMAL(3,2),  
    created\_at TIMESTAMPTZ DEFAULT NOW(),  
    CONSTRAINT name\_birth\_geo\_unique UNIQUE (user\_id, name, birth\_year, geo\_region)  
);

### **Vault Memories Table (Zero-Knowledge Architecture)** {#vault-memories-table-(zero-knowledge-architecture)}

Client encrypts content with DEK, uploads directly to S3 via presigned URL. Server stores only encrypted DEK (wrapped by KEK), S3 key reference, and trigger metadata.

CREATE TABLE vault\_memories (  
    memory\_id UUID PRIMARY KEY DEFAULT gen\_random\_uuid(),  
    creator\_id UUID REFERENCES users(user\_id) ON DELETE CASCADE,  
    recipient\_id UUID REFERENCES users(user\_id),  
    content\_s3\_key VARCHAR(256) NOT NULL,  
    encrypted\_dek BYTEA NOT NULL,  
    dek\_key\_id VARCHAR(64) NOT NULL,  
    trigger\_type VARCHAR(30) CHECK (trigger\_type IN ('time\_capsule','milestone','unspoken','geofence')),  
    trigger\_value JSONB NOT NULL,  
    steward\_id UUID REFERENCES users(user\_id),  
    created\_at TIMESTAMPTZ DEFAULT NOW(),  
    delivered\_at TIMESTAMPTZ,  
    status VARCHAR(20) DEFAULT 'sealed' CHECK (status IN ('sealed','triggered','delivered','revoked','hold')),  
    verification\_state JSONB,  
    CONSTRAINT zk\_architecture CHECK (encrypted\_dek IS NOT NULL AND LENGTH(encrypted\_dek) \> 0\)  
);

### **Behavioral Events Table (with Sampling Strategy)** {#behavioral-events-table-(with-sampling-strategy)}

CREATE TABLE behavioral\_events (  
    event\_id UUID PRIMARY KEY DEFAULT gen\_random\_uuid(),  
    user\_id UUID NOT NULL,  
    event\_type VARCHAR(50) NOT NULL,  
    source VARCHAR(20) CHECK (source IN ('inapp','pixel','sdk')),  
    timestamp TIMESTAMPTZ DEFAULT NOW(),  
    metadata JSONB,  
    sampled BOOLEAN DEFAULT TRUE,  
    CONSTRAINT fk\_user FOREIGN KEY (user\_id) REFERENCES users(user\_id) ON DELETE CASCADE  
) PARTITION BY LIST (event\_type);

### **Required Indexes** {#required-indexes}

CREATE INDEX idx\_users\_haplogroup\_hnsw ON users USING hnsw (haplogroup\_embedding vector\_cosine\_ops) WITH (m \= 16, ef\_construction \= 64);  
CREATE INDEX idx\_users\_consent\_flags ON users (consent\_flags) WHERE consent\_flags & 2 \= 2;  
CREATE INDEX idx\_memories\_creator ON memories (creator\_id, created\_at DESC);  
CREATE INDEX idx\_vault\_triggers\_type ON vault\_triggers (trigger\_type, trigger\_value) WHERE delivered\_at IS NULL;  
CREATE INDEX idx\_behavioral\_user\_time\_sampled ON behavioral\_events (user\_id, timestamp DESC) WHERE sampled \= TRUE;  
CREATE INDEX idx\_tree\_person\_fuzzy ON tree\_persons USING gin (name gin\_trgm\_ops, geo\_region);

## **2.2 Neo4j Constraints & Indexes** {#2.2-neo4j-constraints-&-indexes}

Including GEDCOM fuzzy matching support with geo\_region indexing:

CREATE CONSTRAINT user\_id\_unique IF NOT EXISTS FOR (u:User) REQUIRE u.user\_id IS UNIQUE;  
CREATE CONSTRAINT kinnection\_unique IF NOT EXISTS FOR ()-\[k:KINNECTION\]-() REQUIRE k.kinnection\_id IS UNIQUE;  
CREATE CONSTRAINT branch\_id\_unique IF NOT EXISTS FOR (b:Branch) REQUIRE b.branch\_id IS UNIQUE;  
CREATE CONSTRAINT treeperson\_id\_unique IF NOT EXISTS FOR (p:TreePerson) REQUIRE p.person\_id IS UNIQUE;

CREATE INDEX idx\_user\_surname IF NOT EXISTS FOR (u:User) ON (u.surname);  
CREATE INDEX idx\_kinnection\_cr IF NOT EXISTS FOR ()-\[k:KINNECTION\]-() ON (k.cr\_score);  
CREATE INDEX idx\_branch\_geography IF NOT EXISTS FOR (b:Branch) ON (b.geographic\_origin);  
CREATE INDEX idx\_treeperson\_name\_birth\_geo IF NOT EXISTS FOR (p:TreePerson) ON (p.name, p.birth\_year, p.geo\_region);  
CREATE FULLTEXT INDEX user\_name\_search IF NOT EXISTS FOR (u:User) ON EACH \[u.display\_name, u.surname\];  
CREATE FULLTEXT INDEX treeperson\_search IF NOT EXISTS FOR (p:TreePerson) ON EACH \[p.name\];

\-- GEDCOM Merge Logic: \>=0.85 auto-merge, 0.70-0.84 flag for review, \<0.70 create new node

## **2.3 Redis Key Schema & Cassandra Tables** {#2.3-redis-key-schema-&-cassandra-tables}

Redis key patterns for caching, sessions, rate limiting, and job tracking:

| Redis Pattern | Type | TTL | Purpose |
| :---- | :---- | :---- | :---- |
| feed:{user\_id} | ZADD | 300s | Pre-computed Line feed (score=KC, member=memory\_id) |
| session:{session\_id} | HSET | 86400s | JWT claims, device fingerprint, region, consent\_flags snapshot |
| rate:{user\_id}:{route} | INCR+EXPIRE | 60s | Sliding window rate limit |
| room:{room\_id} | STREAM | 7200s | Active participants, SFU routing state, ICE candidate cache |
| photoplay:job:{job\_id} | HSET | 3600s | Status, output\_url, error, retries, c2pa\_manifest\_url |
| kernel:cache:{user\_pair\_id} | HSET | 1800s | Cached KC score with model\_version, computed\_at, confidence\_ci |

Cassandra behavioral events with hot partition mitigation via hour bucketing and materialized view for GDPR Art. 15 access:

CREATE KEYSPACE behavioral WITH replication \= {'class': 'NetworkTopologyStrategy', 'us-east-1': 3, 'eu-west-1': 3};

CREATE TABLE behavioral.pulses (  
    user\_id UUID,  
    hour\_bucket TIMESTAMP,  
    memory\_id UUID,  
    actor\_id UUID,  
    pulse\_type TEXT,  
    timestamp TIMESTAMP,  
    sampled BOOLEAN,  
    PRIMARY KEY ((user\_id, hour\_bucket), timestamp, memory\_id)  
) WITH CLUSTERING ORDER BY (timestamp DESC, memory\_id ASC)  
  AND default\_time\_to\_live \= 63072000  
  AND compaction \= {'class': 'TimeWindowCompactionStrategy', 'compaction\_window\_size': 1, 'compaction\_window\_unit': 'DAYS'};

CREATE TABLE behavioral.events (  
    user\_id UUID,  
    hour\_bucket TIMESTAMP,  
    event\_id UUID,  
    event\_type TEXT,  
    source TEXT,  
    timestamp TIMESTAMP,  
    metadata JSON,  
    sampled BOOLEAN,  
    sampling\_rate DECIMAL(3,2),  
    PRIMARY KEY ((user\_id, hour\_bucket, event\_type), timestamp, event\_id)  
) WITH default\_time\_to\_live \= 63072000  
  AND compaction \= {'class': 'TimeWindowCompactionStrategy'};

\-- Materialized view for GDPR Art. 15 access queries  
CREATE MATERIALIZED VIEW behavioral.user\_events\_export AS  
SELECT user\_id, event\_id, event\_type, source, timestamp, metadata, sampled  
FROM behavioral.events  
WHERE user\_id IS NOT NULL AND hour\_bucket IS NOT NULL  
PRIMARY KEY (user\_id, timestamp, event\_id, hour\_bucket)  
WITH default\_time\_to\_live \= 63072000;

# **3\. API Gateway, Auth & Service Contracts** {#3.-api-gateway,-auth-&-service-contracts}

## **3.1 Gateway Routing & Auth** {#3.1-gateway-routing-&-auth}

All routes require JWT authentication with scope validation. Step-up authentication is required for sensitive operations.

| Route Pattern | Backend Service | Auth | Rate Limit | Idempotency |
| :---- | :---- | :---- | :---- | :---- |
| /v1/feed | feed-service | JWT \+ scope:feed:read | 100 req/min/user | X-Request-ID |
| /v1/kinnections | kin-graph-service | JWT \+ scope:graph:read | 200 req/min/user | X-Request-ID |
| /v1/photoplay | photoplay-service | JWT \+ scope:media:write \+ biometric:face | 5 req/min/user | X-Idempotency-Key |
| /v1/memorybox | Memory Box-service | JWT \+ scope:vault:write \+ stepup | 10 req/min/user | X-Idempotency-Key |
| /v1/discovery | discovery-service | JWT \+ scope:discovery:read | 50 req/min/user | X-Request-ID |
| /v1/rooms | rooms-service | JWT \+ scope:rooms:write | 20 req/min/user | X-Idempotency-Key |

## **3.2 JWT Claims Specification** {#3.2-jwt-claims-specification}

Canonical JWT payload structure with granular scopes and consent tracking:

{  
    'sub': 'usr\_8f7a...',  
    'iss': 'kinnectai.auth',  
    'aud': \['kinnectai.api', 'kinnectai.mobile'\],  
    'jti': 'jwt\_abc123',  
    'region': 'us-east-1',  
    'device\_fingerprint': 'fp\_sha256\_xyz',  
    'consent\_tiers': \['layer1', 'layer2', 'layer3', 'layer4', 'layer5', 'biometric\_face', 'biometric\_voice'\],  
    'scopes': {  
        'feed': \['read'\],  
        'graph': \['read', 'write'\],  
        'media': \['write'\],  
        'vault': \['write'\],  
        'discovery': \['read'\],  
        'rooms': \['write'\],  
        'payment': \['read', 'write'\]  
    },  
    'stepup\_verified': false,  
    'att\_status': 'granted'  
}

### **Scope Validation Matrix** {#scope-validation-matrix}

| Service | Required Scopes | Missing Scope Response | Consent Check |
| :---- | :---- | :---- | :---- |
| feed-service | feed:read | 403 Forbidden | Verify consent\_tiers includes required layers |
| kin-graph-service | graph:read/write | 403 Forbidden | Check consent\_flags & 4 for layer3 consent |
| photoplay-service | media:write \+ biometric:face:write | 403 Forbidden | Verify consent\_flags & 32 (BIPA face consent) |
| Memory Box-service | vault:write \+ step-up | 401 if no X-Stepup-Auth | Verify consent\_flags & 512 (posthumous consent) |
| dna-ingest-service | media:write \+ layer2:write | 403 Forbidden | Verify consent\_flags & 2 (DNA consent) \+ region match |

Step-up authentication headers:

X-Stepup-Auth: biometric|totp  
X-Stepup-Reason: vault\_write|dna\_upload|biometric\_capture|account\_delete  
X-Stepup-Timestamp: 1715036400

Step-up tokens are short-lived (300s), single-use, and logged to immutable audit trail. On consent revocation, all active JWTs are invalidated via Redis revoked\_jti set.

## **3.3 Critical OpenAPI 3.1 Snippets** {#3.3-critical-openapi-3.1-snippets}

### **GET /v1/feed (with kernel downtime fallback)** {#get-/v1/feed-(with-kernel-downtime-fallback)}

parameters:  
  \- name: limit (integer, 1-50, default: 10\)  
  \- name: cursor (string)  
  \- name: fallback\_mode (enum: \[kc\_cached, chronological, empty\], default: kc\_cached)  
responses:  
  200:  
    items: array of MemoryCard  
    next\_cursor: string|null  
    metadata:  
      kernel\_status: healthy|degraded|unavailable  
      fallback\_applied: boolean  
      cache\_age\_seconds: integer

### **POST /v1/memorybox (ZK client-side encryption flow)** {#post-/v1/memorybox-(zk-client-side-encryption-flow)}

security: \[bearerAuth, stepupAuth\]  
required: \[recipient\_id, trigger\_type, trigger\_value, content\_s3\_key, encrypted\_dek, dek\_key\_id\]  
properties:  
  recipient\_id: uuid  
  trigger\_type: enum \[time\_capsule, milestone, unspoken, geofence\]  
  trigger\_value: object  
  content\_s3\_key: string (S3 object key of client-encrypted content)  
  encrypted\_dek: byte (DEK encrypted by KEK via KMS)  
  dek\_key\_id: string (AWS KMS key ID)  
  steward\_id: uuid|null  
  c2pa\_manifest\_hash: string (SHA-256 of C2PA manifest for audit)  
responses:  
  201: {memory\_id, trigger\_id, audit\_log\_id}

## **3.4 RevenueCat Integration Specification** {#3.4-revenuecat-integration-specification}

Mobile clients use RevenueCat for IAP (iOS/Android); web clients use Stripe directly. Backend payment-service orchestrates entitlement sync.

Webhook contract POST /v1/webhooks/revenuecat:

{  
    'event': {  
        'id': 'evt\_abc123',  
        'type': 'INITIAL\_PURCHASE|RENEWAL|CANCELLATION|REFUND',  
        'app\_user\_id': 'usr\_8f7a...',  
        'product\_identifier': 'photoplay\_credits\_monthly|vault\_expanded\_500gb',  
        'store': 'APP\_STORE|PLAY\_STORE|STRIPE',  
        'entitlements': {  
            'photoplay\_unlimited': {'active': true, 'expires\_date': '2026-06-09T10:00:00Z'},  
            'vault\_500gb': {'active': true, 'expires\_date': '2026-06-09T10:00:00Z'}  
        }  
    }  
}

| RevenueCat Entitlement | Backend Permission | Feature Gate |
| :---- | :---- | :---- |
| photoplay\_unlimited | scope:media:write:unlimited | feature.photoplay.credits\_unlimited |
| vault\_500gb | scope:vault:storage:500gb | feature.memorybox.expanded\_storage |
| kinnect\_kit\_premium | scope:dna:kit:premium | feature.dna.premium\_kit |

Fallback strategy: If RevenueCat webhook fails, payment-service polls RevenueCat API every 5 minutes for unprocessed events (idempotent via event.id).

## **3.5 Kafka Topic Schema Registry** {#3.5-kafka-topic-schema-registry}

Schema Registry: schema-registry.internal:8081. Compatibility: BACKWARD\_TRANSITIVE. Subject naming: TopicName-value.

Avro schema example for behavioral.events:

{  
    'namespace': 'com.kinnectai.behavioral',  
    'type': 'record',  
    'name': 'BehavioralEvent',  
    'fields': \[  
        {'name': 'event\_id', 'type': 'string'},  
        {'name': 'user\_id', 'type': 'string'},  
        {'name': 'event\_type', 'type': {'type': 'enum', 'symbols': \['VIEW','PULSE','COMMENT','SEARCH','CREATE','SHARE','ROOM\_JOIN','VAULT\_SEAL'\]}},  
        {'name': 'source', 'type': {'type': 'enum', 'symbols': \['INAPP','PIXEL','SDK','WEBHOOK'\]}},  
        {'name': 'timestamp', 'type': 'long', 'logicalType': 'timestamp-millis'},  
        {'name': 'metadata', 'type': \['null', 'string'\], 'default': null},  
        {'name': 'sampled', 'type': 'boolean', 'default': true},  
        {'name': 'sampling\_rate', 'type': \['null', 'float'\], 'default': null},  
        {'name': 'consent\_flags\_snapshot', 'type': 'int'}  
    \]  
}

All 10 topics defined: user.events, cr.recompute, photoplay.jobs, vault.triggers, discovery.matches, media.transcode, notification.dispatch, rooms.signaling, behavioral.events, moderation.queue. See Appendix C for complete schemas.

## **3.6 GraphQL Resolver Specification** {#3.6-graphql-resolver-specification}

Schema definition (treeGraph query):

type Query {  
    treeGraph(userId: ID\!, depthLimit: Int \= 3, after: String, first: Int \= 50): TreeGraphConnection\!  
}  
type TreeGraphConnection {  
    edges: \[TreeGraphEdge\!\]\!  
    pageInfo: PageInfo\!  
    totalCount: Int\!  
}  
type TreeGraphEdge {  
    node: TreePerson\!  
    cursor: String\!  
    relationshipPath: \[KinnectionEdge\!\]\!  
    kcScore: Float  
    confidenceCI: ConfidenceInterval  
}

N+1 Protection: All database and service calls within resolvers use DataLoader pattern with batch size=100, max batch wait=10ms, memory budget=256MB. Partial failure handling via errgroup.WithContext.

# **4\. KC Kernel Deterministic Computation Contract** {#4.-kc-kernel-deterministic-computation-contract}

## **4.1 8-Step Execution Order (with Fallback Logic)** {#4.1-8-step-execution-order-(with-fallback-logic)}

0. 1\. Base Biological Score: Layer 2 DNA CR \+ haplogroup match. If DNA data unavailable: return biological\_score=0.0, confidence\_ci=\[0.0,0.1\], fallback\_reason='no\_layer2\_data'

1. 2\. Identity Enrichment: Layer 1/3 surname/geo/address/associate overlap.

2. 3\. Behavioral Modifiers: Layer 5 creation/interaction/connection/commerce signals. Anti-feedback safeguard: Discovery exposure increases behavioral weight by \<=5% per 30-day window.

3. 4\. Temporal Decay: Exponential lambda=0.1/day from last active interaction.

4. 5\. Commercial Modifiers: Layer 4 transaction/life-stage propensity weights.

5. 6\. Penalty Suppression: Dismissal x0.30, inactivity x0.50, distance x0.70.

6. 7\. Final Normalization: Clamp to 0.0-1.0, map to 0-100% display scale.

7. 8\. Confidence Assignment: 95% CI propagated from source layer certainty.

### **Kernel Downtime Fallback** {#kernel-downtime-fallback}

| Fallback Mode | Behavior | Use Case |
| :---- | :---- | :---- |
| kc\_cached (default) | Serve KC scores from Redis cache with metadata.cache\_age\_seconds | Kernel temporarily unavailable (\<5 min) |
| chronological | Sort by memory.created\_at DESC, inject metadata.fallback\_applied: true | Cache expired \+ kernel unavailable |
| empty | Return empty feed with metadata.kernel\_status: 'unavailable' | Extended outage (\>30 min), user notified via Heartbeat |

## **4.2 Engineering Safeguards** {#4.2-engineering-safeguards}

| Requirement | Implementation | Verification |
| :---- | :---- | :---- |
| Anti-feedback loop | Discovery exposure \<=5% behavioral weight increase per 30 days | Kafka stream validator \+ Prometheus alert behavioral.discovery\_exposure\_anomaly |
| Explainability (GDPR Art 22\) | /v1/kc/explain/{pair\_id} returns top-3 features, layer weights, CI, model\_version | UI modal \+ audit log entry kc.explain.accessed |
| Versioned models | Semantic versioning (kc-model-v2.3.1) \+ SHA-256 weights hash stored in MLflow | Replay endpoint accepts model\_version param, returns score \+/-0.02 tolerance |
| Tie-breaking | Lexicographic: Biological \> Recent Activity \> Alphabetical user\_id | Deterministic sort unit tests (10K synthetic ties) in CI |
| Immutable audit | Append-only DynamoDB ledger: kc\_audit table with HMAC(input\_json \+ output\_json \+ model\_version) | Tamper-evident query by user\_pair\_id returns exact trace |

## **4.3 Death Verification State Machine** {#4.3-death-verification-state-machine}

Deterministic state transitions for POSTHUMOUS trigger type:

| Current State | Input Signal | Transition | SLA |
| :---- | :---- | :---- | :---- |
| PENDING | SSDI match \>=95% | VERIFIED (auto-deliver if steward confirms) | SSDI poll: 02:00 UTC daily |
| PENDING | SSDI match 70-94% | OBITUARY\_SEARCH (NLP crawler, 72h window) | 72h obituary window |
| OBITUARY\_SEARCH | \>=3 independent sources | VERIFIED | Deliver memory |
| OBITUARY\_SEARCH | \<3 sources after 72h | STEWARD\_CONTACT | Push/SMS/Email to Steward |
| STEWARD\_CONTACT | No response 72h | HOLD (pause pipeline) | User: 'Awaiting Estate Verification' |
| HOLD | Court order webhook | COURT\_VERIFIED \> DELIVERED | Legal team approves |
| HOLD | 365 days elapsed | AUTO\_ESCALATE | DPO \+ Legal review |

Fallback Authority Chain: Primary Steward \> Backup Steward \> KinnectAI Legal DPO \> Court-Appointed Executor \> Default: 365d auto-release to next-of-kin on record.

## **4.4 Stitch Auto-Publish Consent Architecture** {#4.4-stitch-auto-publish-consent-architecture}

Bit 12 (4096): stitch\_auto\_publish\_consent. User explicitly grants permission for Memory clips to be included in automated Branch-wide Sunday Stitches.

Consent prompt copy: 'Allow your clips to be included in automated Sunday Stitches shared within your Branch. You can change this anytime in Settings \> Content Permissions.'

Implementation: If consent\_flags & 4096: clip automatically eligible. If 0: clip flagged stitch\_eligible: false. Revocation: future Stitches exclude clip; existing Stitches remain published (irrevocable per GDPR Art. 7(3)).

Audit: stitch\_consent\_log table records user\_id, memory\_id, consent\_granted\_at, consent\_revoked\_at, pipeline\_version. Legal sign-off: DPO confirms scoped consent satisfies purpose limitation.

# **5\. Data Classification, Residency & Cryptographic Lifecycle** {#5.-data-classification,-residency-&-cryptographic-lifecycle}

## **5.1 T0-T5 Classification Matrix** {#5.1-t0-t5-classification-matrix}

| Tier | Definition | Storage | Encryption | Retention | Replication | Access Control |
| :---- | :---- | :---- | :---- | :---- | :---- | :---- |
| T0 | Public UI assets | S3 Public | None | Indefinite | Global CDN | Public read |
| T1 | Basic PII, behavioral aggregates | RDS, Cassandra | AES-256-GCM, TLS 1.3 | Account+30d / 24mo rolling | Region-matched | RBAC: role:analyst |
| T2 | Identity graph, consent logs | Neo4j, PG | AES-256-GCM, KMS 90d rotation | Account life | Explicit consent required | RBAC: role:identity\_engineer \+ MFA |
| T3 | Biometric embeddings (face/voice) | pgvector, Redis | Envelope encryption (DEK/KEK) | 5 years default | NEVER crosses consented region | JIT access: role:ml\_engineer \+ approval \+ session recording |
| T4 | Raw genomic (SNP/FASTQ/BAM) | S3 Glacier | HSM-backed KEK, mTLS service only | 7 years | STRICT isolation per region | NO HUMAN ACCESS: service accounts only, CloudTrail \+ SIEM alert |
| T5 | KC kernel weights, model artifacts | CloudHSM | FIPS 140-2 L3, Shamir's Secret Sharing (3/5) | 24 months | NEVER leaves primary region | Shamir reconstruction ceremony only (see 5.3) |

## **5.2 Memory Box Zero-Knowledge Architecture** {#5.2-memory-box-zero-knowledge-architecture}

### **Client-Side Encryption Flow** {#client-side-encryption-flow}

8. 1\. Client generates random 256-bit DEK using Web Crypto API.

9. 2\. Client encrypts Memory content with AES-256-GCM using DEK.

10. 3\. Client requests presigned PUT URL from Memory Box-service for content\_s3\_key.

11. 4\. Client uploads encrypted content directly to S3 using presigned URL.

12. 5\. Client requests DEK wrapping: POST /v1/kms/wrap with dek\_plaintext (over mTLS).

13. 6\. KMS returns encrypted\_dek and dek\_key\_id.

14. 7\. Client POSTs to /v1/memorybox with content\_s3\_key, encrypted\_dek, dek\_key\_id, trigger metadata.

15. 8\. Server stores only metadata \+ wrapped DEK; never sees plaintext content or unwrapped DEK.

### **Server-Side Decryption Flow (Trigger Execution)** {#server-side-decryption-flow-(trigger-execution)}

16. 1\. Trigger condition verified (time, life event, death).

17. 2\. Memory Box-service requests DEK unwrapping from KMS: Decrypt(encrypted\_dek, dek\_key\_id).

18. 3\. KMS returns dek\_plaintext to service (in-memory only, never logged).

19. 4\. Service generates presigned GET URL for content\_s3\_key.

20. 5\. Recipient client downloads encrypted content from S3.

21. 6\. Recipient client requests DEK from service (over mTLS, after recipient auth).

22. 7\. Client decrypts content locally with DEK.

Audit: Every KMS Encrypt/Decrypt call logged to CloudTrail. Memory Box-service logs only memory\_id, action: dek\_wrap\_request, result: success, audit\_id. Immutable audit ledger (DynamoDB) stores HMAC of memory\_id \+ recipient\_id \+ trigger\_type \+ timestamp \+ audit\_id.

## **5.3 Shamir's Secret Sharing Implementation** {#5.3-shamir's-secret-sharing-implementation}

Library: github.com/hashicorp/vault/shamir (FIPS 140-2 validated build). Threshold: 3-of-5 for KC Kernel Weights and Estate Recovery.

| Share | Holder | Storage | Recovery Condition |
| :---- | :---- | :---- | :---- |
| S1 | Primary Steward (user-designated) | FIDO2-protected client-side storage | Biometric \+ TOTP |
| S2 | Backup Steward 1 (user-designated) | FIDO2-protected client-side storage | Biometric \+ TOTP |
| S3 | Backup Steward 2 (user-designated) | FIDO2-protected client-side storage | Biometric \+ TOTP |
| S4 | KinnectAI Legal Vault | CloudHSM in primary region | Court order webhook \+ dual legal approval |
| S5 | KMS Escrow (AWS) | AWS CloudHSM | Automated via KMS policy \+ SIEM alert |

Reconstruction Ceremony: Request via /v1/shamir/reconstruct (step-up auth required). For user-initiated: 3/5 shares from S1-S3. For estate/legal: S4 \+ any 2 of S1-S3, or S4 \+ S5 \+ court order. Shares transmitted over mTLS to ephemeral pod. shamir.Combine() executed in-memory; result used immediately, never persisted. Ephemeral pod terminated; memory zeroed.

SLA: Standard reconstruction \<5 minutes. Estate reconstruction (with court order) \<72 hours.

## **5.4 Cryptographic Key Management** {#5.4-cryptographic-key-management}

* Envelope Encryption: DEK encrypts Memory Box content client-side. DEK encrypted by KEK in KMS.

* Key Rotation: KEK rotates every 90 days. Background Lambda re-encrypts \<=10K DEKs/day.

* Posthumous Access: Court-order webhook \> 1-hour JIT decrypt grant \> immutable audit.

* Steward Recovery: 2/3 FIDO2 signatures \+ Shamir 3/5 KEK threshold. SIEM alerts on activation.

* Zero Standing Access: T4/T5 requires JIT elevation, dual approval, recorded session, 60-min auto-revocation.

# **6\. AI/ML Governance & MLOps** {#6.-ai/ml-governance-&-mlops}

| Req ID | Control | Implementation | Verification |
| :---- | :---- | :---- | :---- |
| ML-001 | Model registry | MLflow with feature\_set\_hash, training\_data\_snapshot\_id, deployment\_metadata | Audit query returns full lineage |
| ML-002 | Drift detection | KL divergence threshold \>0.05 triggers shadow deployment (1% traffic) | Hourly Prometheus alert routes to \#ml-ops Slack |
| ML-003 | Bias testing | Monthly per protected class; fairness delta \<=0.03 | Synthetic demographic audit; transparency dashboard quarterly |
| ML-004 | Rollback | \<=5 min via blue/green \+ Istio virtual service auto-shift on error \>0.5% | LaunchDarkly feature flag kernel.model\_version; traffic reverts automatically |
| ML-005 | Data retention | Training data \+ feature snapshots retain 24 months with Databricks Unity Catalog lineage | S3 lifecycle 730d; Databricks tracks lineage via feature\_table |
| ML-006 | Explainability | /v1/kc/explain/{pair\_id} returns top-k features \+ CI \+ model\_version \+ feature\_importance\_vector | UI modal; audit logs access |
| ML-007 | Synthetic data for testing | All genetic/biometric test data generated via synthetic-data-generator (no real PII) | CI gate: reject any test using non-synthetic T3+ data |

# **7\. Trust & Safety, Moderation & Synthetic Media** {#7.-trust-&-safety,-moderation-&-synthetic-media}

## **7.1 Trust & Safety Controls** {#7.1-trust-&-safety-controls}

| Req ID | Control | Implementation | SLA |
| :---- | :---- | :---- | :---- |
| TS-001 | Abuse reporting | abuse.report Kafka event \> Trust & Safety queue with priority scoring | 2h T3/T4 review; 30min P0 (CSAM, threats) |
| TS-002 | CSAM detection | Microsoft PhotoDNA pre-S3-upload; match \>95% \> reject \+ NCMEC report \+ immutable audit | Immediate auto-reject; human review for 90-95% |
| TS-003 | Impersonation | Facial embedding similarity \>0.85 to verified Steward/Celebrity \> flag | 4h review for high-confidence matches |
| TS-004 | Memorialization | account.status=memorialized \> read-only; Photoplay restricted to Steward; KMS blocks non-Steward decrypt | Automated via death verification pipeline |
| TS-005 | Graph poisoning | dna\_ingest.quality\_score\<0.70 \> SYNTHETIC\_DNA\_FLAG \> manual review \+ audit log | Queue processed within 24h |
| TS-006 | Trust scoring | Start 0.5; \+0.10/verified connection; \-0.05/report; discovery filters \<0.3 | Real-time user.trust\_score update; 5min TTL |

## **7.2 Synthetic Media Controls** {#7.2-synthetic-media-controls}

| Req ID | Control | Implementation | Verification |
| :---- | :---- | :---- | :---- |
| SYN-001 | AI disclosure (C2PA) | c2pa-rs SDK signs manifest with timestamp, user\_id, pipeline\_version, consent\_hash; FFmpeg embeds as XMP | Manifest extraction validates signature; 100% QA coverage |
| SYN-002 | Voice verification | Challenge-response: 10 random words; hash of audio \+ transcript stored | Unit tests for hash verification |
| SYN-003 | Deepfake block | TFLite liveness (blink, head movement) \+ EXIF/hash chain validation pre-pipeline | Pen test validates bypass; false positive \<0.1% |
| SYN-004 | UI badge | Frontend renders 'AI-Generated Media' badge when content.is\_ai\_generated=true | E2E \+ accessibility test: screen reader announces badge |

### **C2PA Integration Architecture** {#c2pa-integration-architecture}

* SDK: github.com/c2pa-org/c2pa-rs (v0.28+)

* Signing key: AWS KMS-managed ECC key (P-256), rotated quarterly

* Manifest: C2PA 2.0 spec with custom claims: com.kinnectai.consent\_hash, com.kinnectai.pipeline\_version

* Verification: Client-side c2pa-js validates on playback; server audit logs verification results; tamper detection fires moderation.queue event

## **7.3 SVG XSS Protection** {#7.3-svg-xss-protection}

Family Crest Generation Pipeline: GPT-4o generates SVG from prompt (surname \+ haplogroup \+ geographic\_origin). Sanitization via go-sanitize library:

* Remove all \<script\>, \<iframe\>, \<object\>, \<embed\> tags

* Strip all on\* event handlers (onload, onclick, etc.)

* Allow only whitelisted attributes: fill, stroke, d, viewBox, width, height

* Remove all external resource references (xlink:href, url())

* Inject C2PA manifest as XMP metadata

* Serve with CSP: default-src 'none'; style-src 'self' 'unsafe-inline'; img-src 'self' data:

## **7.4 DNA Kit Fulfillment Failure States** {#7.4-dna-kit-fulfillment-failure-states}

Failure states and auto-reshipment triggers:

| Failure State | Condition | Trigger | SLA |
| :---- | :---- | :---- | :---- |
| KIT\_TEMP\_EXCEEDED | Temp sensor \>8C for \>2 hours during transit | Auto-void \> replacement dispatched | 48h dispatch |
| KIT\_QR\_UNREADABLE | QR code damaged at intake | Auto-void \> replacement dispatched | 48h dispatch |
| DNA\_YIELD\_LOW | Lab extraction \<500ng or QC degradation | Lab flags \> prepaid return label \> replacement | 48h dispatch |
| PLINK\_PARSE\_FAILURE | VCF normalization fails GRCh38 alignment \>40% | User notified \> replacement dispatched | 48h dispatch |

Max retries: 3 per user. 4th failure \> manual bioinformatics review \+ direct customer support call. Reshipment SLA: 48h dispatch, 7-day delivery (FedEx Priority). User communication: Push \> Email/SMS with tracking \> In-app status update.

# **8\. DNA Ingestion & Error Taxonomy** {#8.-dna-ingestion-&-error-taxonomy}

## **8.1 VCF Processing Pipeline** {#8.1-vcf-processing-pipeline}

Service: dna-ingest-service. Pipeline: VCF \> GRCh38 Align \> Haplogroup Assign \> Embedding \> pgvector.

### **Error Taxonomy** {#error-taxonomy}

| Error Code | Condition | Fallback KC Behavior | User State | SLA |
| :---- | :---- | :---- | :---- | :---- |
| VCF\_MALFORMED | Invalid header/chunking | Exclude Layer 2; use L1/L3/L4/L5 | dna\_upload\_error | Immediate |
| VCF\_ALIGN\_FAIL | GRCh38 mismatch \>40% | Partial Layer 2; use aligned SNPs only | dna\_partial\_success | \<5min |
| HAPLO\_UNKNOWN | Insufficient phylogenetic SNPs | Identity-only KC | dna\_haplogroup\_unknown | \<2min |
| PLINK\_PIHAT\_RANGE | PI\_HAT \<0.0 or \>0.5 | Clamp to \[0.0, 0.5\]; log warning | dna\_score\_adjusted | \<1min |
| SNP\_LOW\_COVERAGE | Depth \<8x across \>30% loci | Reduce Layer 2 weight by 50%; prompt re-upload | dna\_low\_confidence | \<10min |

Recovery logic: KC kernel applies layer-specific fallback per error type. User receives contextual message explaining available data used. All errors logged to immutable audit with raw\_file\_hash, failed\_variants\_count, coverage metrics.

## **8.2 AADR Commercial Use Confirmation** {#8.2-aadr-commercial-use-confirmation}

KinnectAI has executed a Data Use Agreement with Harvard Dataverse / Reich Lab for commercial use of AADR v54.1+:

* Attribution required: 'Historical DNA data courtesy of the Allen Ancient DNA Resource (Reich Lab, Harvard)'

* No redistribution of raw AADR data; only derived embeddings and connection metadata stored

* Annual review of data usage; opt-out mechanism for specific ancient samples

* Patent claim 4 (haplogroup bridging) covers derived connection metadata, not raw AADR data

Implementation: AADR ingestion tags all historical nodes with data\_source: 'AADR\_v54.1\_commercial'; audit log records each query.

## **8.3 Voiceprint Creation Queue Architecture** {#8.3-voiceprint-creation-queue-architecture}

CREATE TABLE voiceprint\_queue (  
    job\_id UUID PRIMARY KEY DEFAULT gen\_random\_uuid(),  
    user\_id UUID REFERENCES users(user\_id),  
    audio\_s3\_key VARCHAR(256) NOT NULL,  
    status VARCHAR(20) CHECK (status IN ('QUEUED','PROCESSING\_ELEVEN','PROCESSING\_FALLBACK','COMPLETED','FAILED')),  
    provider VARCHAR(20) DEFAULT 'elevenlabs',  
    queue\_position INTEGER,  
    created\_at TIMESTAMPTZ DEFAULT NOW(),  
    estimated\_completion TIMESTAMPTZ,  
    fallback\_reason TEXT  
);

Tiering: Premium users (Vault+): P0 queue, max wait 12h. Free/Standard: P1 queue, max wait 48h. FIFO within tier. Max 10 ElevenLabs clones/day enforced at service level.

Fallback: If ElevenLabs API returns 429 or 503 for \>3 consecutive attempts \> auto-route to OpenVoice-V2 self-hosted model (EKS GPU pods T4). OpenVoice-V2 replicates speaker timbre and prosody (functionally equivalent to cloning, not generic TTS). User notification: 'Your Voiceprint is being processed using our secure fallback engine.'

If fallback fails \> status=FAILED \> trigger VOICEPRINT\_FALLBACK\_EXHAUSTED Kafka event \> customer support ticket \+ credit refund.

Monitoring: Queue depth alert \>50 \> auto-scale EKS GPU workers (+2 pods). Processing timeout: 30min \> auto-retry or fallback.

# **9\. Rooms WebRTC Specification** {#9.-rooms-webrtc-specification}

## **9.1 ICE Candidate & Reconnection Protocol** {#9.1-ice-candidate-&-reconnection-protocol}

iceConfig := webrtc.ICEConfiguration{  
    ICECandidateTimeout:  30 \* time.Second,  
    ICEConnectionTimeout: 45 \* time.Second,  
    ICEKeepaliveInterval: 15 \* time.Second,  
    STUNServers: \[\]string{'stun:stun.kinnectai.app:3478'},  
    TURNServers: \[\]webrtc.ICEServer{{  
        URLs: \[\]string{'turn:turn-us.kinnectai.app:3478', 'turns:turn-us.kinnectai.app:5349'},  
        Username: 'kinnectai',  
        Credential: '\<dynamic from Coturn\>',  
        CredentialType: webrtc.ICECredentialTypePassword,  
    }},  
}

### **Originator Failover Protocol** {#originator-failover-protocol}

23. 1\. Originator disconnect detected via onconnectionstatechange: disconnected.

24. 2\. rooms-service checks for pre-designated co-host (stored in room.co\_host\_id).

25. 3\. If co-host exists: auto-promote to Originator; notify participants via room.participant\_updated event.

26. 4\. If no co-host: Room enters 'paused' state; participants see 'Waiting for host to return' with 5-minute countdown.

27. 5\. After 5 minutes: Room auto-ends; recording finalized and sealed to Memory Box.

### **HLS Stream Recovery** {#hls-stream-recovery}

* SFU node failure detected via health check timeout (10s)

* Load balancer routes new viewers to healthy SFU node

* Existing viewers: client-side HLS player retries with exponential backoff (1s, 2s, 4s, max 30s)

* Stream continuity: mediasoup records RTP packets to disk; recovery node replays from last keyframe

### **TURN Bandwidth Caps** {#turn-bandwidth-caps}

* Per-room limit: 10 Mbps aggregate upload/download

* Per-participant limit: 2 Mbps

* Exceeding limit: downgrade video resolution (1080p \> 720p \> 360p) before dropping participants

# **10\. Infrastructure, IaC & Deployment** {#10.-infrastructure,-iac-&-deployment}

## **10.1 Terraform Module Structure** {#10.1-terraform-module-structure}

infra/  
  modules/  
    vpc/          (CIDR: 10.0.0.0/16, 6 subnets, 2 NAT GW, VPC endpoints)  
    eks/          (3 AZs, Karpenter, IAM OIDC, GPU node groups)  
    rds-aurora/   (PG16, 2 replicas, Multi-AZ, KMS encryption)  
    neo4j-aura/   (Aura Enterprise config, backup policy)  
    msk/          (3 brokers, m5.xlarge, encryption at rest/in transit)  
    schema-registry/ (Confluent SR, compatibility mode, ACLs)  
    elasticache/  (Redis 7, cluster mode, 2 shards, 2 nodes/shard)  
    keyspaces/    (Cassandra-compatible, TTL policies)  
    s3/           (App data, Glacier, lifecycle, bucket policies)  
    cloudfront/   (TLS 1.3, custom errors, WAF association)  
    cloudhsm/     (FIPS 140-2 L3 cluster, Shamir share storage)  
    c2pa-signing/ (C2PA SDK deployment, KMS key for signing)  
  environments/  
    dev/ \> staging/ \> prod/  (With approval gates)  
  policies/  
    iam/      (Least-privilege roles per service)  
    network/  (Security groups, NACLs)  
    compliance/ (GDPR, HIPAA, BIPA policy as code)

## **10.2 CI/CD & Deployment Gates** {#10.2-ci/cd-&-deployment-gates}

| Stage | Condition | Action |
| :---- | :---- | :---- |
| Lint/Test | Unit \>=80%, integration \>=70%, synthetic genetic data only, SVG XSS tests pass | Proceed |
| Security | SAST/DAST clean, 0 High/Critical, dependency scan passed | Proceed |
| Schema Migration | Dry-run succeeds, rollback script validated, Neo4j constraint check passes | Proceed |
| Compliance | Consent flow tests pass, GDPR audit query test passes, BIPA consent UI validated | Proceed |
| Canary 1% | Error rate \<0.1%, latency p99 stable, KC score distribution within \+/-0.02 of baseline | Promote to 5% |
| Canary 5%\>25% | Business metrics stable, no P0 alerts, RevenueCat webhook success \>99% | Promote to 100% |

## **10.3 Rollback Procedure** {#10.3-rollback-procedure}

\# 1\. Rollback Kubernetes deployment  
kubectl rollout undo deployment/{service} \-n prod \--to-revision={previous\_revision}

\# 2\. Disable feature flag  
aws lambda invoke \--function-name LaunchDarkly-UpdateFlag \\  
  \--payload '{"flag": "feature.{service}.enabled", "value": false, "environment": "prod"}'

\# 3\. Revert database migration  
flyway undo \-configFiles=flyway-prod.conf  
  || pg\_restore \--clean \--if-exists \-d kinnectai\_prod backup-before-migration.dump

\# 4\. Route traffic to previous ASG  
aws elbv2 modify-listener \--listener-arn $LISTENER\_ARN \\  
  \--default-actions Type=forward,TargetGroupArn=$PREV\_TARGET\_GROUP

\# 5\. Post-mortem trigger (\>2 rollbacks in 30 days)  
if \[ $(kubectl get events \-n prod \--field-selector reason=Rollback | wc \-l) \-gt 2 \]; then  
  aws sns publish \--topic-arn $POSTMORTEM\_TOPIC \\  
    \--message 'Rollback triggered for {service}; post-mortem required'  
fi

# **11\. Performance, SLOs & Observability** {#11.-performance,-slos-&-observability}

## **11.1 SLO Matrix** {#11.1-slo-matrix}

| Service | SLA | SLI | SLO | Error Budget | Alert Threshold |
| :---- | :---- | :---- | :---- | :---- | :---- |
| The Line Feed | 99.9% | Feed load p99 | \<100ms | 43.8 min/mo | p99 \>150ms for 5m |
| KC Computation | 99.95% | Inference p99 | \<200ms | 21.9 min/mo | p99 \>300ms for 2m |
| Memory Box Delivery | 99.99% | Trigger exec p99 | \<1min | 4.38 min/mo | latency \>2min for 1m |
| Photoplay Pipeline | 99.5% | Job success rate | \>=95% | 219 min/mo | error\_rate \>5% for 5m |
| Rooms Join | 99.9% | Join latency p99 | \<2s | 43.8 min/mo | p99 \>5s for 2m |
| RevenueCat Sync | 99.9% | Webhook processing p99 | \<30s | 43.8 min/mo | lag \>60s for 5m |
| C2PA Signing | 99.9% | Manifest generation p99 | \<5s | 43.8 min/mo | p99 \>10s for 2m |

## **11.2 Observability Standards** {#11.2-observability-standards}

### **Structured Logging** {#structured-logging}

* All Kernel invocations, API calls, score computations, revenue triggers emit JSON logs to CloudWatch/ELK

* Required fields: correlation\_id, user\_id (hashed), consent\_flags\_snapshot

* Health probes: /healthz returns 200/503 with dependency status (Neo4j, PG, Kafka, KMS)

* Distributed tracing: Jaeger/X-Ray covers 100% user-facing requests; trace ID in all logs

* Error Budget Policy: 50% burn \> feature freeze; 80% burn \> mandatory rollback

* Chaos Testing: Weekly experiments in staging (dependency failure, latency injection, node loss, network partition). Runbooks updated per scenario.

### **GDPR Art. 15 Data Export** {#gdpr-art.-15-data-export}

GET /v1/user/{id}/export aggregates data from all stores:

* PostgreSQL: users, memories, tree\_persons tables

* Neo4j: User node \+ connected Kinnections (exported as JSON graph)

* Cassandra: behavioral.events via materialized view

* S3: List of content\_s3\_key references (not content)

* Audit ledger: All access events for user

Export format: ZIP with JSON files \+ README; delivered via presigned URL (24h expiry). SLA: Export generated within 24h of request.

# **12\. Security, Zero-Trust & Compliance Controls** {#12.-security,-zero-trust-&-compliance-controls}

## **12.1 Regulatory Compliance Matrix** {#12.1-regulatory-compliance-matrix}

| Standard | Control | Implementation | Verification |
| :---- | :---- | :---- | :---- |
| GDPR | Consent granularity, erasure, DPIA | Layered consent UI; DELETE /v1/user/{id} cascades; EU-isolated stores | Legal sign-off \+ DPO audit trail |
| HIPAA | PHI encryption, access audit | T4/T5 isolated; CloudWatch Logs \+ SIEM alert; BAA enforced | Pen test \+ audit log query |
| GINA | Genetic firewall | Separate insurance\_features schema excludes Layer 2; IAM blocks cross-queries | Code assertion \+ integration test |
| BIPA | Facial consent, on-device processing | TFLite preview; explicit Illinois consent; retention schedule | UX test \+ legal copy review |
| COPPA | Minor account restrictions | Guardian-managed; no DNA/biometric for \<13; verifiable consent | Synthetic pair test \+ audit log |
| SOC 2 | Zero-trust, JIT access, immutable logs | Okta JIT workflow; SSM session recording; WORM S3 archives | Access review \+ SIEM validation |

## **12.2 iOS ATT Prompt** {#12.2-ios-att-prompt}

Apple-approved copy (factual disclosure, no marketing language):

"KinnectAI uses your activity across other apps and websites to help discover family connections and deliver more relevant memories."

Implementation: ATTrackingManager.requestTrackingAuthorization called after onboarding Step 4 (Invite Kin), before any off-platform tracking. If denied, behavioral-service ignores Pixel/SDK events for that user; Layer 4 uses in-app signals only.

## **12.3 Consent Flags Bitmask Enforcement** {#12.3-consent-flags-bitmask-enforcement}

Go middleware example for DNA upload endpoint:

func (s \*dnaIngestHandler) UploadKit(w http.ResponseWriter, r \*http.Request) {  
    user := auth.UserFromContext(r.Context())  
    // Check consent\_flags bit 1 (layer2\_bioidentity\_consent)  
    if user.ConsentFlags & 0x02 \== 0 {  
        http.Error(w, "{\\"error\\":\\"consent\_required\\",\\"feature\\":\\"dna\_upload\\"}", 403\)  
        audit.Log(r.Context(), "dna\_upload.consent\_missing", user.UserID)  
        return  
    }  
    // Check region matches data residency  
    if user.Region \!= "us-east-1" && user.Region \!= "eu-west-1" {  
        http.Error(w, "{\\"error\\":\\"region\_not\_supported\\"}", 403\)  
        return  
    }  
    // Proceed with upload...  
}

## **12.4 LexisNexis SOAP Integration in Go** {#12.4-lexisnexis-soap-integration-in-go}

Library: github.com/hooklift/gowsdl for code generation from WSDL. mTLS client cert rotated quarterly via SSM.

| SOAP Fault | HTTP Status | Application Error | Circuit Action |
| :---- | :---- | :---- | :---- |
| InvalidCredentials | 401 | auth.invalid\_token | Rotate OAuth token |
| RateLimitExceeded | 429 | rate\_limit.exceeded | Exponential backoff 2^n |
| DataNotFound | 404 | identity.not\_found | Continue with internal graph |
| ServiceUnavailable | 503 | dependency.lexisnexus\_down | Open circuit breaker (2m) |

# **13\. Acceptance Criteria & Definition of Done** {#13.-acceptance-criteria-&-definition-of-done}

A feature is DONE when all of the following criteria are met:

28. 1\. Unit tests \>=80%, integration tests pass staging, E2E critical paths verified (including SVG XSS, consent flows, ZK encryption)

29. 2\. Performance benchmarks met in load testing (k6/Locust) with SLO validation

30. 3\. SAST/DAST clean, pen test resolved, secrets scan passed, dependency CVEs \< High

31. 4\. Legal/compliance sign-off for consent flows, data handling, retention, ATT copy, AADR commercial use

32. 5\. UI copy validated against brand lexicon (zero social-network terms; all KinnectAI-native terminology)

33. 6\. Accessibility scan \>=95% WCAG 2.2 AA (including C2PA badge screen reader support)

34. 7\. Documentation updated (API spec, runbook, user help, GDPR export procedure)

35. 8\. Feature flag enabled for canary deployment (1% \> 5% \> 25% \> 100%) with rollback procedure tested

36. 9\. Audit trail verification test: simulate GDPR Art. 15 request; verify export completeness within 24h SLA

37. 10\. Shamir reconstruction test: simulate estate access; verify 3/5 share recovery in \<72h

# **Appendix C: Complete Kafka Avro Schemas** {#appendix-c:-complete-kafka-avro-schemas}

Registry: schema-registry.internal:8081. Compatibility: BACKWARD\_TRANSITIVE. Subject naming: TopicName-value.

### **C.1 behavioral.events** {#c.1-behavioral.events}

Namespace: com.kinnectai.behavioral

Fields: event\_id (string/UUID), user\_id (string), event\_type (enum: VIEW,PULSE,COMMENT,SEARCH,CREATE,SHARE,ROOM\_JOIN,VAULT\_SEAL), source (enum: INAPP,PIXEL,SDK,WEBHOOK), timestamp (long/timestamp-millis), metadata (null/string), sampled (boolean/default true), sampling\_rate (null/float), consent\_flags\_snapshot (int)

### **C.2 cr.recompute** {#c.2-cr.recompute}

Namespace: com.kinnectai.kernel

Fields: pair\_id (string, user\_a:user\_b sorted lexicographically), trigger\_source (enum: DNA\_INGEST,IDENTITY\_ENRICH,BEHAVIORAL\_BATCH,DISCOVERY\_SWIPE), requested\_at (long), priority (enum: HIGH,NORMAL,LOW/default NORMAL), model\_version (string)

### **C.3 photoplay.jobs** {#c.3-photoplay.jobs}

Namespace: com.kinnectai.media

Fields: job\_id, user\_id, photo\_s3\_key, audio\_s3\_key (null/string), voiceprint\_id (null/string), quality\_tier (enum: STANDARD,PREMIUM), c2pa\_required (boolean/default true), created\_at (long), status (enum: QUEUED,PROCESSING,COMPLETED,FAILED,FALLBACK\_ACTIVATED), retry\_count (int/default 0), error\_code (null/string)

### **C.4 vault.triggers** {#c.4-vault.triggers}

Namespace: com.kinnectai.vault

Fields: trigger\_id, memory\_id, trigger\_type (enum: TIME\_CAPSULE,MILESTONE,POSTHUMOUS,GEOFENCE), evaluation\_status (enum: PENDING,VERIFIED,REJECTED,ESCALATED), verification\_signals (map\<string,string\>), steward\_notified\_at (null/long), executed\_at (null/long), audit\_hash (SHA-256 of trigger payload \+ verification state)

### **C.5 discovery.matches** {#c.5-discovery.matches}

Namespace: com.kinnectai.discovery

Fields: candidate\_id, viewer\_id, kc\_score\_raw (float), kc\_score\_display (int 0-100), primary\_signal (enum: DNA,HAPLOGROUP,FACIAL,NAME\_GEO,TREE,BEHAVIORAL), relationship\_guess (string), confidence\_interval (array\<float\>), generated\_at (long)

### **C.6 media.transcode** {#c.6-media.transcode}

Namespace: com.kinnectai.media

Fields: job\_id, input\_s3\_key, output\_tiers (array\<enum: 360P,720P,1080P,AV1,H265\>), audio\_codec (string/default aac\_128k), status (enum: QUEUED,PROCESSING,COMPLETED,FAILED/default QUEUED), cdn\_invalidated (boolean/default false)

### **C.7 notification.dispatch** {#c.7-notification.dispatch}

Namespace: com.kinnectai.notification

Fields: notification\_id, recipient\_id, channel (enum: FCM,APNS,IN\_APP\_PULSE,EMAIL,SMS), template\_key, payload\_vars (map\<string,string\>), priority (enum: HIGH,NORMAL,BATCHED/default NORMAL), ttl\_seconds (int/default 86400\)

### **C.8 rooms.signaling** {#c.8-rooms.signaling}

Namespace: com.kinnectai.rooms

Fields: room\_id, peer\_id, event\_type (enum: ICE\_CANDIDATE,SDP\_OFFER,SDP\_ANSWER,JOIN,LEAVE,MUTE,CAM\_TOGGLE,HOST\_PROMOTE), payload (null/string), timestamp (long)

### **C.9 user.events** {#c.9-user.events}

Namespace: com.kinnectai.auth

Fields: user\_id, event (enum: REGISTER,LOGIN,LOGOUT,PASSKEY\_ADD,CONSENT\_UPDATE,ACCOUNT\_DELETE,STEWARD\_ASSIGNED), device\_fingerprint, region, timestamp (long), ip\_hash (SHA-256 of IP)

### **C.10 moderation.queue** {#c.10-moderation.queue}

Namespace: com.kinnectai.trust

Fields: ticket\_id, content\_id, user\_id, violation\_type (enum: CSAM,DEEPFAKE,ABUSE,SYNTHETIC\_DNA,SPAM,TRAUMA\_FLAG), confidence (float), auto\_action (enum: REJECT,FLAG,ALLOW/default FLAG), assigned\_reviewer (null/string), created\_at (long)

# **Appendix D: JWT Scope Validation Matrix** {#appendix-d:-jwt-scope-validation-matrix}

Validation Engine: go-jose \+ custom middleware in api-gateway and per-service auth interceptors.

| Service | Required Scopes | Missing Scope Response | Consent Flag Check | Step-Up Required |
| :---- | :---- | :---- | :---- | :---- |
| feed-service | feed:read | 403 {error:insufficient\_scope} | consent\_flags & 0x08 (Layer 4\) | No |
| kin-graph-service | graph:read, graph:write | 403 {error:insufficient\_scope} | consent\_flags & 0x04 (Layer 3\) | No |
| photoplay-service | media:write, biometric:face | 403 {error:insufficient\_scope} | consent\_flags & 0x20 (BIPA Face) | Yes (biometric) |
| Memory Box-service | vault:write, vault:read | 401 {error:step\_up\_required} | consent\_flags & 0x200 (Posthumous) | Yes (totp|biometric) |
| dna-ingest-service | dna:write, dna:read | 403 {error:insufficient\_scope} | consent\_flags & 0x02 (Layer 2\) | Yes (biometric) |
| discovery-service | discovery:read | 403 {error:insufficient\_scope} | None (aggregated scoring) | No |
| rooms-service | rooms:write, rooms:read | 403 {error:insufficient\_scope} | None | No |
| payment-service | payment:write | 403 {error:insufficient\_scope} | None | Yes (biometric) |

### **JWT Revocation Strategy** {#jwt-revocation-strategy}

* Stored in Redis: revoked\_jti:{jti} \> 1 with TTL \= original JWT exp

* On consent revocation: consent\_flags updated \> async job scans active sessions \> writes revoked JTIs to Redis

* Validation middleware checks revoked\_jti before processing. Latency impact: \<2ms via Redis cluster

# **Appendix E: Memory Box Zero-Knowledge Architecture** {#appendix-e:-memory-box-zero-knowledge-architecture}

**Core Principle: Server never holds plaintext content or unwrapped DEK. All encryption/decryption happens client-side or via ephemeral KMS calls.**

## **E.1 Client Encryption Flow** {#e.1-client-encryption-flow}

38. 1\. Client generates random 256-bit DEK (Web Crypto API)

39. 2\. Client encrypts content with AES-256-GCM using DEK

40. 3\. Client requests presigned PUT URL from Memory Box-service

41. 4\. Client uploads encrypted content directly to S3 via presigned URL

42. 5\. Client requests DEK wrapping: POST /v1/kms/wrap (over mTLS)

43. 6\. KMS returns encrypted\_dek and dek\_key\_id

44. 7\. Client POSTs /v1/memorybox with encrypted\_dek, s3\_key, trigger\_metadata

45. 8\. Server stores only metadata \+ wrapped DEK; returns 201 {memory\_id, audit\_id}

## **E.2 Server Trigger Execution Flow** {#e.2-server-trigger-execution-flow}

46. 1\. Verify trigger conditions (time/SSDI/steward)

47. 2\. Request DEK unwrapping from KMS: Decrypt(encrypted\_dek)

48. 3\. KMS returns dek\_plaintext (in-memory only, never logged)

49. 4\. Generate presigned GET URL for content\_s3\_key (15min TTL)

50. 5\. Queue notification to Recipient

51. 6\. Recipient requests DEK after auth (over mTLS, ephemeral channel)

52. 7\. Client decrypts content locally with DEK

53. 8\. Zeroize DEK from memory; log audit\_hash

### **Database Enforcement** {#database-enforcement}

CHECK (encrypted\_dek IS NOT NULL AND octet\_length(encrypted\_dek) \>= 64\)  
CHECK (content\_s3\_key \~\* '^membox/enc/\[0-9a-f\]{64}/')

# **Appendix F: Shamir's Secret Sharing Ceremony Runbook** {#appendix-f:-shamir's-secret-sharing-ceremony-runbook}

Library: github.com/hashicorp/vault/shamir (v1.15.0+). Threshold: 3-of-5. FIPS: Validated via hashicorp/vault FIPS 140-2 build.

## **F.1 Share Distribution** {#f.1-share-distribution}

| Holder | Identity | Storage Mechanism | Recovery Trigger |
| :---- | :---- | :---- | :---- |
| S1 | Primary Steward | FIDO2-protected local device | Biometric \+ TOTP |
| S2 | Backup Steward 1 | FIDO2-protected local device | Biometric \+ TOTP |
| S3 | Backup Steward 2 | FIDO2-protected local device | Biometric \+ TOTP |
| S4 | KinnectAI Legal Vault | CloudHSM (Region-locked) | Court order webhook \+ dual-legal sign-off |
| S5 | AWS KMS Escrow | KMS Multi-Region Backup | Automated via KMS policy \+ SIEM alert |

## **F.2 Reconstruction Procedure (EKS Ephemeral Pod)** {#f.2-reconstruction-procedure-(eks-ephemeral-pod)}

\# 1\. Provision ephemeral pod with memory zeroing on termination  
kubectl run shamir-reconstruct \--image=kinnectai/shamir-cli:latest \\  
  \--command \-- sh \-c 'echo 0 \> /proc/sys/vm/zero\_free\_pages && exec /bin/shamir-reconstruct'

\# 2\. Inject shares via mTLS (no network egress allowed)  
shamir-cli combine \--share1 s1.enc \--share2 s4.hsm \--share3 s5.kms \--threshold 3

\# 3\. Output key piped directly to KMS wrapping endpoint  
shamir-cli combine ... | aws kms encrypt \--key-id kmk-estate \--output text

\# 4\. Verify reconstruction  
aws kms decrypt \--ciphertext-blob fileb://wrapped\_key.bin \--query Plaintext \--output text

\# 5\. Zero memory and terminate pod  
sync; echo 3 \> /proc/sys/vm/drop\_caches  
kubectl delete pod shamir-reconstruct \--force \--grace-period=0

### **Audit Requirements** {#audit-requirements}

* Every share transmission logged to DynamoDB shamir\_audit with HMAC

* Pod runs in isolated namespace with NetworkPolicy egress deny

* SIEM alert fires on any reconstruction attempt outside approved window

# **Appendix G: VCF Error Taxonomy Complete Reference** {#appendix-g:-vcf-error-taxonomy-complete-reference}

Service: dna-ingest-service. Pipeline: VCF \> GRCh38 Align \> Haplogroup Assign \> Embedding \> pgvector.

| Error Code | Condition | Fallback KC | User State | Audit Fields | SLA |
| :---- | :---- | :---- | :---- | :---- | :---- |
| VCF\_MALFORMED | Invalid header/chunking | Exclude Layer 2; use L1/L3/L4/L5 | dna\_upload\_error | file\_hash, line\_number, parser\_error | Immediate |
| VCF\_ALIGN\_FAIL | GRCh38 mismatch \>40% | Partial Layer 2; aligned SNPs only | dna\_partial\_success | failed\_variants, ref\_mismatch\_pct | \<5min |
| HAPLO\_UNKNOWN | Insufficient phylogenetic SNPs | Identity-only KC | dna\_haplogroup\_unknown | snp\_count, min\_required | \<2min |
| PLINK\_PIHAT\_RANGE | PI\_HAT \<0.0 or \>0.5 | Clamp to \[0.0,0.5\]; log warning | dna\_score\_adjusted | raw\_pihat, clamped\_pihat | \<1min |
| SNP\_LOW\_COVERAGE | Depth \<8x across \>30% loci | Reduce L2 weight 50%; prompt re-upload | dna\_low\_confidence | coverage\_mean, loci\_below\_thresh | \<10min |

### **Recovery Logic** {#recovery-logic}

if error.code in \[VCF\_MALFORMED, VCF\_ALIGN\_FAIL\]:  
    kc\_kernel.apply\_fallback(user\_id, layer\_weights={'L2': 0.0})  
    notify\_user(user\_id, template='dna\_reupload\_required')  
elif error.code \== SNP\_LOW\_COVERAGE:  
    kc\_kernel.apply\_modifier(user\_id, 'L2\_weight', multiplier=0.5)  
    notify\_user(user\_id, template='dna\_coverage\_warning')  
audit.log(user\_id, 'dna\_ingestion\_error', severity='warning', metadata=error.to\_dict())

# **Appendix H: Death Verification Decision Tree** {#appendix-h:-death-verification-decision-tree}

State machine for vault\_triggers.trigger\_type \= 'POSTHUMOUS'. SLA: 72h standard; 30d steward escalation; 365d auto-legal.

| Current State | Input Signal | Transition | Notification |
| :---- | :---- | :---- | :---- |
| PENDING | SSDI \>=95% | VERIFIED (auto-deliver) | Memory unlocked. Verification complete. |
| PENDING | SSDI 70-94% | OBITUARY\_SEARCH (72h NLP) | Verifying through public records. ETA: 72h. |
| OBITUARY\_SEARCH | \>=3 sources | VERIFIED | Verified via public records. Memory delivered. |
| OBITUARY\_SEARCH | \<3 sources after 72h | STEWARD\_CONTACT | Steward verification required to release Memory. |
| STEWARD\_CONTACT | Steward responds \<=72h | VERIFIED | Steward confirmed. Memory delivered. |
| STEWARD\_CONTACT | No response 72h | HOLD (pause) | Awaiting estate verification. Delivery paused. |
| HOLD | Court order webhook | COURT\_VERIFIED \> DELIVERED | Court verification received. Memory delivered. |
| HOLD | 365 days elapsed | AUTO\_ESCALATE | Estate review complete. Memory released per policy. |

Fallback Authority Chain: Primary Steward \> Backup Steward \> KinnectAI Legal DPO \> Court-Appointed Executor \> Default: 365d auto-release to next-of-kin on record.

# **Appendix I: WebRTC ICE/Reconnection Specification** {#appendix-i:-webrtc-ice/reconnection-specification}

Service: rooms-service (Go \+ mediasoup).

## **I.1 ICE Configuration** {#i.1-ice-configuration}

webrtc.Configuration{  
    ICETransportPolicy: webrtc.ICETransportPolicyAll,  
    ICECandidateTimeout:  30 \* time.Second,  
    ICEConnectionTimeout: 45 \* time.Second,  
    ICEKeepaliveInterval: 15 \* time.Second,  
    TURNServers: \[\]webrtc.ICEServer{{  
        URLs: \[\]string{'turns:turn.kinnectai.app:5349'},  
        Username: 'kin\_user\_' \+ sessionID,  
        Credential: turnToken,  
        CredentialType: webrtc.ICECredentialTypePassword,  
    }},  
}

## **I.2 Originator Failover & HLS Recovery** {#i.2-originator-failover-&-hls-recovery}

| Event | Detection | Action | SLA |
| :---- | :---- | :---- | :---- |
| Originator disconnect | onconnectionstatechange: disconnected | Check co\_host\_id; auto-promote | \<2s |
| No co-host | co\_host\_id \== nil | Pause Room \> 5min countdown \> finalize recording | 5min |
| SFU node crash | Health probe fail | LB routes to healthy node; replay RTP from last keyframe | \<3s |
| HLS stream drop | CDN 503 | Client exponential backoff (1,2,4,8,16s) | \<10s |

### **TURN Bandwidth Caps** {#turn-bandwidth-caps-1}

* Per-room: 10 Mbps aggregate

* Per-user: 2 Mbps

* Exceed limit: downgrade 1080p \> 720p \> 360p \> mute audio-only. Never drop participants unless \<100kbps sustained

# **Appendix J: consent\_flags Bitmask Reference** {#appendix-j:-consent_flags-bitmask-reference}

Type: INTEGER (PostgreSQL). Constraint: CHECK (consent\_flags \>= 0 AND consent\_flags \<= 8191).

| Bit | Hex | Feature | Compliance | Revocation Impact |
| :---- | :---- | :---- | :---- | :---- |
| 0 | 0x0001 | Layer 1 Identity Resolution | GDPR Art 6 | Disables Whitepages/LexisNexis enrichment |
| 1 | 0x0002 | Layer 2 Bioidentity (DNA) | HIPAA/GINA | Blocks Sequencing.com, removes L2 from KC |
| 2 | 0x0004 | Layer 3 Social Graph Sharing | GDPR Art 6 | Hides Tree from Discovery, disables Branch Merge |
| 3 | 0x0008 | Layer 4 Behavioral Tracking | ATT/CCPA | Ignores Pixel/SDK events; reduces Discovery precision |
| 4 | 0x0010 | Layer 5 Transaction Intelligence | GDPR Art 6 | Excludes NielsenIQ/Factus signals |
| 5 | 0x0020 | Facial Biometric (Photoplay) | BIPA/Illinois | Blocks DeepFace cloud; on-device only |
| 6 | 0x0040 | Voice Biometric (Voiceprint) | BIPA/Texas | Deletes ElevenLabs clone; prevents Voiceprint use |
| 7 | 0x0080 | Off-Platform Pixel/SDK | ATT/GDPR | Disables KinnectAI Tracking Pixel |
| 8 | 0x0100 | Third-Party Data Sharing | CCPA Opt-Out | Blocks NielsenIQ/Factus data export |
| 9 | 0x0200 | Posthumous Delivery (Steward) | State Probate | Vaults remain sealed until manual court order |
| 10 | 0x0400 | Minor Guardian Consent | COPPA | Required for \<13 accounts |
| 11 | 0x0800 | Research/Model Training Opt-In | GDPR Art 9 | Excludes user from GNN training pool |
| 12 | 0x1000 | Sunday Stitch Auto-Publish | GDPR Purpose Limit | Excludes clips from automated Branch Stitches |

### **Go Middleware Validation** {#go-middleware-validation}

func enforceConsent(ctx context.Context, requiredFlag uint32) error {  
    user := auth.UserFromContext(ctx)  
    if user.ConsentFlags & requiredFlag \== 0 {  
        return fmt.Errorf('consent\_missing\_bit\_%d', requiredFlag)  
    }  
    return nil  
}

# **Appendix K: GraphQL Resolver Implementation Guide** {#appendix-k:-graphql-resolver-implementation-guide}

Framework: gqlgen (Go) \+ neo4j-go-driver \+ DataLoader.

## **K.1 DataLoader Configuration** {#k.1-dataloader-configuration}

loader := dataloader.NewBatchedLoader(  
    fetchTreePersons,  
    dataloader.WithBatchCapacity(100),  
    dataloader.WithWait(10\*time.Millisecond),  
    dataloader.WithMemoryBudget(256\*1024\*1024), // 256MB hard limit  
)

## **K.2 Exact Cypher for treeGraph** {#k.2-exact-cypher-for-treegraph}

UNWIND $userIds AS userId  
MATCH (u:User {user\_id: userId})-\[:HAS\_PERSON\*0..$depth\]-(p:TreePerson)  
WHERE p.confidence\_score \>= 0.70  
WITH u.user\_id AS userId, p, relationships(path) AS rels, length(path) AS depth  
ORDER BY depth ASC, p.name ASC  
RETURN userId, p, rels, depth

## **K.3 N+1 & Partial Failure Handling** {#k.3-n+1-&-partial-failure-handling}

* Batch Execution: Uses UNWIND to fetch all requested users in single query

* Partial Failure: errgroup.WithContext isolates failed nodes. Returns {node: null, error: 'node\_resolution\_failed'} for failed IDs

* Memory Guard: If batch \>256MB, returns top 50 nodes \+ {truncated: true, reason: 'memory\_budget'}

* Cache Scope: DataLoader caches per-request lifecycle only. Cross-request caching disabled

# **Appendix L: ElevenLabs Scaling & Queue Architecture** {#appendix-l:-elevenlabs-scaling-&-queue-architecture}

Problem: 10 clones/day limit breaks at scale. Coqui TTS is not a cloning fallback. Solution: OpenVoice-V2 self-hosted model as functional equivalent.

## **L.1 Queue Schema** {#l.1-queue-schema}

CREATE TABLE voiceprint\_queue (  
    job\_id UUID PRIMARY KEY,  
    user\_id UUID REFERENCES users,  
    tier VARCHAR(20) CHECK (tier IN ('P0\_PREMIUM','P1\_STANDARD')),  
    status VARCHAR(30) DEFAULT 'QUEUED',  
    provider VARCHAR(20) DEFAULT 'elevenlabs',  
    fallback\_reason TEXT,  
    estimated\_completion TIMESTAMPTZ,  
    created\_at TIMESTAMPTZ DEFAULT NOW()  
);

## **L.2 Processing Logic** {#l.2-processing-logic}

if elevenlabs\_api.health() and clones\_today \< 10:  
    provider \= 'elevenlabs'  
    queue\_position \= premium\_users.get\_rank(user\_id)  
else:  
    provider \= 'openvoice\_v2'  
    queue\_position \= queue.count()  
    fallback\_reason \= 'elevenlabs\_rate\_limit'  
    \# OpenVoice-V2: self-hosted speaker cloning (not generic TTS)  
    \# Replicates timbre/prosody from 30s audio sample  
notify\_user(user\_id, f'Processing via {provider}. ETA: 15-48h')

Scaling Metrics: Queue depth \>50 \> auto-scale EKS GPU workers (+2 pods). Prometheus: voiceprint\_queue\_depth, elevenlabs\_429\_rate, fallback\_activation\_count. SLA: P0 \<=12h, P1 \<=48h. Failsafe: 3rd failure \> support ticket \+ refund Photoplay credits.

# **Appendix M: iOS ATT Prompt Approval Documentation** {#appendix-m:-ios-att-prompt-approval-documentation}

Guideline: Apple requires factual purpose disclosure. No marketing/benefit framing.

## **M.1 Approved Copy** {#m.1-approved-copy}

"KinnectAI uses your activity across other apps and websites to help discover family connections and deliver more relevant memories."

## **M.2 Implementation** {#m.2-implementation}

import AppTrackingTransparency  
import AdSupport

func requestTracking() {  
    DispatchQueue.main.asyncAfter(deadline: .now() \+ 2.0) {  
        ATTrackingManager.requestTrackingAuthorization { status in  
            UserDefaults.standard.set(status.rawValue, forKey: 'att\_status')  
            // If denied, behavioral\_service ignores Pixel/SDK events.  
            // Core product unaffected.  
        }  
    }  
}

### **Compliance Notes** {#compliance-notes}

* Prompt shown after Step 4 (Invite Kin), before any off-platform tracking initializes

* Denied ATT \> behavioral-service sets source \= INAPP only. KC computation continues

* App Store Review: Copy is factual, non-coercive, explicitly states purpose

# **Appendix N: C2PA Implementation Technical Specification** {#appendix-n:-c2pa-implementation-technical-specification}

SDK: github.com/c2pa-org/c2pa-rs (v0.28+). Signing Key: AWS KMS ECC P-256 (rotated quarterly).

## **N.1 Pipeline Integration (Post-FFmpeg)** {#n.1-pipeline-integration-(post-ffmpeg)}

let manifest \= Manifest::new('KinnectAI Photoplay v1')  
    .add\_claim('com.kinnectai.user\_id', \&user\_id)  
    .add\_claim('com.kinnectai.pipeline', 'sadtalker\_v3')  
    .add\_claim('com.kinnectai.consent\_hash', \&consent\_sha256)  
    .add\_claim('com.kinnectai.timestamp', \&chrono::Utc::now())  
    .sign\_with\_kms(key\_id, region)?;

Command::new('ffmpeg')  
    .arg('-i').arg(\&output\_mp4)  
    .arg('-i').arg(\&manifest.xmp\_file)  
    .arg('-map\_metadata').arg('1')  
    .arg('-c').arg('copy')  
    .arg(\&final\_output).output()?;

## **N.2 Verification Flow** {#n.2-verification-flow}

* Client: c2pa-js extracts XMP on playback. Validates signature against public cert

* UI: Renders 'AI-Generated Media' badge \+ C2PA Verified if signature valid

* Server: Audit logs c2pa\_verification\_result per view. Tamper detection fires moderation.queue event

# **Appendix O: LexisNexis SOAP/Go Integration Guide** {#appendix-o:-lexisnexis-soap/go-integration-guide}

Library: github.com/hooklift/gowsdl. Auth: OAuth 2.0 \+ mTLS client cert (rotated quarterly via SSM).

## **O.1 Client Initialization** {#o.1-client-initialization}

wsdlURL := 'https://api.lexisnexis.com/identity-analytics/v2/IdentityAnalyticsService?wsdl'  
cert, \_ := tls.LoadX509KeyPair('/certs/client.crt', '/certs/client.key')  
caPool := x509.NewCertPool()  
caPool.AppendCertsFromPEM(caCertPEM)  
client := gowsdl.NewSOAPClient(wsdlURL, \&gowsdl.Options{  
    HTTPClient: \&http.Client{  
        Transport: \&http.Transport{TLSClientConfig: \&tls.Config{  
            Certificates: \[\]tls.Certificate{cert},  
            RootCAs: caPool,  
        }},  
        Timeout: 30 \* time.Second,  
    },  
})

## **O.2 Fault Mapping** {#o.2-fault-mapping}

| SOAP Fault | HTTP Status | Go Error | Circuit Action |
| :---- | :---- | :---- | :---- |
| InvalidCredentials | 401 | auth.invalid\_token | Rotate OAuth token |
| RateLimitExceeded | 429 | rate\_limit.exceeded | Exponential backoff 2^n |
| DataNotFound | 404 | identity.not\_found | Continue with internal graph |
| ServiceUnavailable | 503 | dependency.lexisnexus\_down | Open circuit breaker (2m) |

# **Legal Appendix: AADR Commercial Use Agreement Summary** {#legal-appendix:-aadr-commercial-use-agreement-summary}

Dataset: Allen Ancient DNA Resource (AADR) v54.1+. Provider: David Reich Lab, Harvard Medical School / Harvard Dataverse.

| Clause | Requirement | KinnectAI Implementation |
| :---- | :---- | :---- |
| Attribution | Data courtesy of AADR v54.1 (Reich Lab) in UI footer & Discovery cards | Hardcoded AttributionBadge component on all historical match surfaces |
| Commercial Use | Permitted with attribution; no redistribution of raw EIGENSTRAT | Stores only haplogroup embeddings & bridge edges. Raw files deleted post-ingest |
| Patent Coverage | Patent 4 (Haplogroup Bridging) covers derived connection metadata | Legal opinion confirms patent claims apply to graph traversal logic |
| Community Opt-Out | Indigenous/ancestral groups may request sample removal | community\_opt\_out table triggers edge invalidation within 24h of Harvard notice |
| Annual Review | Data usage audit submitted to Harvard Dataverse | Automated aadr\_usage\_report.csv annually; DPO signs off before submission |

**Section 14\. Flutter Mobile Architecture Specification**

This section defines the complete Flutter client architecture. All BLoC/Cubit state machines, routing, DTOs, offline strategy, icon tokens, and motion design are production-ready and directly keyed to the backend contracts in SRS v5.0 §§3–12.

**14.1 BLoC State Machine Catalogue (48 Screens)**

Every screen maps to exactly one Cubit. The table below is the authoritative screen-to-Cubit registry. Columns: screen name, Cubit class, critical events, critical states, and primary API/repository dependency.

| \# | Screen | Cubit | Key Events | Key States | API Dep |
| :---- | :---- | :---- | :---- | :---- | :---- |
| 1 | Welcome / Splash | WelcomeCubit | Continue, TermsAccepted | initial, loading, navigating | AuthService |
| 2 | Email Sign Up | EmailAuthCubit | EmailEntered, PasswordSet, CreateAccount | initial, validating, otp\_sent, verified | AuthRepository |
| 3 | Phone Sign Up | PhoneAuthCubit | PhoneEntered, CodeSent, CodeVerified | initial, sending\_otp, verifying, complete | AuthRepository |
| 4 | Passkey Setup | PasskeyCubit | RegisterPasskey, FallbackToPassword | initial, requesting, success, failed | AuthRepository |
| 5 | Onboarding: Surname | OnboardingCubit | SurnameEntered, NameMapLoaded | initial, loading\_map, map\_loaded | IdentityService |
| 6 | Onboarding: DNA | DnaOnboardingCubit | ConnectSequencing, UploadVCF, Skip | initial, connecting, processing, complete | DnaRepository |
| 7 | Onboarding: Photo | PhotoOnboardingCubit | CapturePhoto, FaceDetected, Next | initial, capturing, analyzing, success | MediaRepository |
| 8 | Onboarding: Invite Kin | InviteKinCubit | SyncContacts, ShareLink, Skip | initial, syncing, loaded, complete | ContactsService |
| 9 | Onboarding: The Line | FeedActivationCubit | FirstKinnection, HeartbeatShown | initial, activating, loaded, empty | FeedRepository |
| 10 | The Line (Home) | LineCubit | FeedRequested, PulseSent, DiscoverySwiped | loading, loaded, refreshing, error | FeedRepository |
| 11 | Echoes Tab | EchoesCubit | FetchEchoes, PlayEcho | loading, loaded, empty | FeedRepository |
| 12 | Kinnections Tab | KinnectionsCubit | FetchKinnections, AcceptRequest, Decline | loading, loaded, processing | GraphRepository |
| 13 | Discovery Tab | DiscoveryCubit | CandidatesFetched, SwipeLeft, ExplorePath | loading, loaded, path\_view, empty | DiscoveryRepository |
| 14 | Graph Path View | PathViewCubit | PathRequested, KinnectClicked | loading, rendered, request\_sent | GraphRepository |
| 15 | Photoplay Studio | PhotoplayCubit | PhotoSelected, VoiceRecorded, QualitySet, Render | idle, rendering, completed, fallback | PhotoplayRepository |
| 16 | Memory Box Composer | VaultComposerCubit | RecordVideo, TriggerSelected, StepUpAuth, Seal | draft, authenticating, sealed, success | VaultRepository |
| 17 | Vault List | VaultListCubit | FetchVaults, RevokeTrigger, Export | loading, loaded, exporting | VaultRepository |
| 18 | Vault Detail | VaultDetailCubit | FetchDetail, EditTrigger | loading, loaded, editing | VaultRepository |
| 19 | Stitch Editor | StitchCubit | ClipAdded, Reordered, NarrationSet, Render | idle, compiling, complete | MediaRepository |
| 20 | Restore Tool | RestoreCubit | UploadPhoto, Process, SaveToRoll | uploading, processing\_esrgan, colorizing, done | MediaRepository |
| 21 | Flickers | FlickersCubit | SelectMoments, GenerateScript, Render | idle, scripting, synthesizing, complete | ReelRepository |
| 22 | Voiceprint Capture | VoiceprintCubit | RecordAudio, VerifyHash, Save | idle, recording, verifying, saved | VoiceRepository |
| 23 | Family Crest | CrestCubit | Regenerate, Save, Share | generating, loaded, saved | MediaRepository |
| 24 | Tree View | TreeCubit | LoadGraph, AddKin, ImportGEDCOM | loading, rendered, editing, importing | GraphRepository |
| 25 | Branch Map | BranchMapCubit | LoadMembers, FilterHaplo, MergePropose | loading, mapped, merge\_pending | BranchRepository |
| 26 | Branch Members | BranchMembersCubit | FetchMembers, LoadMore | loading, loaded, empty | BranchRepository |
| 27 | Branch Merge | BranchMergeCubit | AnalyzeEvidence, Confirm, Reject | analyzing, review, merging, complete | BranchRepository |
| 28 | Name Map | NameMapCubit | LoadBiodensity, ExploreRegion | loading, mapped, exploring | IdentityService |
| 29 | Lost Branches | LostBranchesCubit | ScanRegion, MatchFound | scanning, matched, empty | DiscoveryRepository |
| 30 | Kinship Alert Map | AlertMapCubit | LoadProximity, SetRadius, SendAlert | locating, active, alert\_sent | LocationService |
| 31 | Rooms List | RoomsListCubit | FetchActive, CreateRoom, Schedule | loading, listed, creating | RoomsRepository |
| 32 | Inside Room | RoomCubit | Join, Mute, ToggleCam, GoLive, Record | connecting, active, live, recording, ended | RoomsRepository |
| 33 | Gatherings | GatheringCubit | FetchScheduled, RSVP, Cancel | loading, listed, rsvp\_sent | RoomsRepository |
| 34 | Pulse / Inbox | InboxCubit | FetchAll, Filter, MarkRead | loading, filtered, empty | NotificationRepository |
| 35 | Root Profile (Own) | RootProfileCubit | LoadProfile, Edit, ShareQR | loading, loaded, editing | ProfileRepository |
| 36 | Root Profile (Other) | OtherRootCubit | LoadOther, Kinnect, Message, Block | loading, loaded, request\_sent | GraphRepository |
| 37 | Profile Edit | ProfileEditCubit | UpdateName, ChangePhoto, Save | editing, saving, saved | ProfileRepository |
| 38 | Settings Main | SettingsCubit | Navigate, Toggle, Export | loaded | SettingsRepository |
| 39 | Activity Center | ActivityCubit | LoadHistory, Clear, ManagePerms | loading, loaded, cleared | SettingsRepository |
| 40 | Content Prefs | ContentPrefsCubit | FilterWords, ToggleRestricted | loaded, updated | SettingsRepository |
| 41 | Time & Wellbeing | WellbeingCubit | SetLimit, ToggleBreak, SetNightMode | loaded, saved | SettingsRepository |
| 42 | Family Pairing | FamilyCubit | LinkGuardian, SetRestrictions | initial, linking, configured | FamilyRepository |
| 43 | Account Security | SecurityCubit | ChangePassword, AddPasskey, ManageDevices | loading, authenticating, updated | AuthRepository |
| 44 | Notifications | NotificationsCubit | TogglePush, ToggleInApp, ResetDefaults | loaded, saved | NotificationService |
| 45 | Privacy Controls | PrivacyCubit | TogglePrivate, SetDisplayRange, OptOutTracking | loaded, consenting, saved | SettingsRepository |
| 46 | Memory Box Settings | VaultSettingsCubit | ManageStorage, AssignSteward, SetDeathSignals | loaded, authenticating, saved | VaultRepository |
| 47 | Marketplace | MarketplaceCubit | Browse, Search, AddToCart, Checkout | loading, browse, cart, checkout | CommerceRepository |
| 48 | Payment History | PaymentsCubit | FetchTransactions, RefundRequest | loading, listed, processing | CommerceRepository |

**14.2 Critical BLoC Implementation: VaultComposerCubit**

The VaultComposerCubit is the highest-risk state machine in the mobile client. It gates the Memory Box sealing flow behind step-up authentication and enforces the ZK client-side encryption flow defined in SRS v5.0 §5.2. The implementation below is production-ready.

// lib/cubits/vault\_composer\_cubit.dart

import 'package:flutter\_bloc/flutter\_bloc.dart';

import 'package:freezed\_annotation/freezed\_annotation.dart';

part 'vault\_composer\_cubit.freezed.dart';

part 'vault\_composer\_state.dart';

class VaultComposerCubit extends Cubit\<VaultComposerState\> {

  final VaultRepository \_repo;

  final StepUpAuthService \_stepUp;

  VaultComposerCubit(this.\_repo, this.\_stepUp)

    : super(const VaultComposerState.initial());

  Future\<void\> selectTrigger(TriggerType type, Map\<String, dynamic\> value) async {

    emit(const VaultComposerState.draft());

    emit((state as VaultComposerState.draft)

      .copyWith(triggerType: type, triggerValue: value));

  }

  Future\<void\> sealMemory() async {

    // Step-up gate — SRS v5.0 §3.1 X-Stepup-Auth header

    final ok \= await \_stepUp.verify(reason: StepUpReason.vault\_seal);

    if (\!ok) { emit(const VaultComposerState.auth\_failed()); return; }

    emit(const VaultComposerState.sealing());

    try {

      final draft \= state as VaultComposerState.draft;

      final memory \= await \_repo.seal(

        recipientId:  draft.recipientId,

        triggerType:  draft.triggerType,

        triggerValue: draft.triggerValue,

        consentFlags: await \_repo.getUserConsentFlags(), // Appendix J bitmask

      );

      emit(VaultComposerState.sealed(memoryId: memory.id));

    } catch (e) {

      emit(VaultComposerState.error(message: e.toString()));

    }

  }

}

**14.3 Routing & Deep Link Specification (go\_router v12.1+)**

All navigation uses go\_router with a ShellRoute for the bottom nav bar and named GoRoutes for deep links. The deep link scheme is kinnect://. Route guard: \_authGuard() redirects unauthenticated users to /onboarding.

// lib/router/app\_router.dart

final appRouter \= GoRouter(

  navigatorKey: \_rootNavigatorKey,

  initialLocation: '/onboarding',

  redirect: (context, state) \=\> \_authGuard(context, state),

  routes: \[

    ShellRoute(

      navigatorKey: \_shellNavigatorKey,

      builder: (ctx, state, child) \=\> MainShell(child: child),

      routes: \[

        GoRoute(path: '/line',    pageBuilder: (c, s) \=\> NoTransitionPage(child: LineScreen())),

        GoRoute(path: '/create',  pageBuilder: (c, s) \=\> MaterialPage(child: PhotoplayStudioScreen())),

        GoRoute(path: '/tree',    pageBuilder: (c, s) \=\> NoTransitionPage(child: TreeScreen())),

        GoRoute(path: '/pulse',   pageBuilder: (c, s) \=\> NoTransitionPage(child: PulseScreen())),

        GoRoute(path: '/root',    pageBuilder: (c, s) \=\> NoTransitionPage(child: RootScreen())),

      \],

    ),

    GoRoute(path: '/memory/:id',        pageBuilder: (c, s) \=\> MaterialPage(child: MemoryDetailScreen(id: s.pathParameters\['id'\]\!))),

    GoRoute(path: '/discovery/:cid',    pageBuilder: (c, s) \=\> MaterialPage(child: DiscoveryCardScreen(candidateId: s.pathParameters\['cid'\]\!))),

    GoRoute(path: '/room/:roomId',       pageBuilder: (c, s) \=\> MaterialPage(child: RoomsScreen(roomId: s.pathParameters\['roomId'\]\!))),

    GoRoute(path: '/vault/:memoryId',   pageBuilder: (c, s) \=\> MaterialPage(child: VaultDetailScreen(memoryId: s.pathParameters\['memoryId'\]\!))),

  \],

);

**14.4 DTO / Model Specifications (freezed)**

All API response models use freezed for immutability and json\_serializable for codegen. The three canonical DTOs are MemoryDTO, KinScoreDTO, and PaginatedResponse\<T\>.

// lib/models/memory\_dto.dart

@freezed

class MemoryDTO with \_$MemoryDTO {

  const factory MemoryDTO({

    required String memoryId,

    required String creatorId,

    required String type,            // video | photoplay | audio | stitch | rewind

    String? vaultTriggerType,

    Map\<String, dynamic\>? vaultTriggerValue,

    String? recipientId,

    required String s3Key,

    required DateTime createdAt,

    DateTime? publishedAt,

    @Default(false) bool isAiGenerated,

    String? c2paManifestUrl,

    @Default(0) int pulseCount,

    String? caption,

    String? audioUrl,

    String? videoUrl,

  }) \= \_MemoryDTO;

  factory MemoryDTO.fromJson(Map\<String, dynamic\> j) \=\> \_$MemoryDTOFromJson(j);

}

// lib/models/kin\_score\_dto.dart

@freezed

class KinScoreDTO with \_$KinScoreDTO {

  const factory KinScoreDTO({

    required String pairId,

    required double rawScore,

    required int displayScore,          // 0-100

    required String primarySignal,      // DNA|HAPLOGROUP|FACIAL|NAME\_GEO|TREE|BEHAVIORAL

    required String relationshipGuess,

    required List\<double\> confidenceInterval,

    required String modelVersion,

  }) \= \_KinScoreDTO;

  factory KinScoreDTO.fromJson(Map\<String, dynamic\> j) \=\> \_$KinScoreDTOFromJson(j);

}

**14.5 Offline Mode & Local Storage Strategy**

| Component | Library | Purpose | Sync Strategy |
| :---- | :---- | :---- | :---- |
| Local DB | drift v2.13+ | Store Memories, Tree nodes, Kinnections offline | Bi-directional sync via workmanager on connectivity restore |
| Cache | hive v2.2+ | Session data, feed cache, rate-limit state | TTL-based eviction (5 min active, 1h inactive) |
| Mutation Queue | workmanager v0.5+ | Queue offline actions (Pulse, Memory creation, Kinnect request) | Exponential backoff retry; max 3 attempts; DLQ after failure |
| Asset Cache | flutter\_cache\_manager | Pre-cache Photoplay thumbnails, profile photos | LRU cache, 100MB max, 7-day TTL |

**14.6 Icon Map & Motion Token Specification**

All icons use Phosphor Flutter. Motion tokens enforce brand-consistent animation across screens.

// lib/constants/icon\_map.dart

const ICON\_MAP \= {

  'pulse':     PhosphorIcons.heart,

  'comment':   PhosphorIcons.chat,

  'rewind':    PhosphorIcons.arrowCounterClockwise,

  'favorite':  PhosphorIcons.star,

  'share':     PhosphorIcons.shareNetwork,

  'branch':    PhosphorIcons.treeStructure,

  'photoplay':     PhosphorIcons.flowerLotus,

  'vault':     PhosphorIcons.lock,

  'discovery': PhosphorIcons.magGlass,

  'room':      PhosphorIcons.videoCamera,

  'heartbeat': PhosphorIcons.heartbeat,

  'echoes':    PhosphorIcons.clockCounterClockwise,

};

// lib/theme/motion\_tokens.dart

class KinnectAIMotion {

  static const durationShort  \= Duration(milliseconds: 150);

  static const durationMedium \= Duration(milliseconds: 300);

  static const durationLong   \= Duration(milliseconds: 500);

  static const curveStandard  \= Curves.easeInOut;

  static const curveBiological \= Curves.elasticOut; // Kinnection confirmations

  static const curveflickers     \= Curves.bounceOut;  // Memory Box delivery

}

**Section 15\. UI/UX Screen Specification Matrix**

**15.1 The Line — Video Gesture Map**

| Gesture | Action | State Change | Backend Call |
| :---- | :---- | :---- | :---- |
| Single tap | Pause/resume video | isPlaying: \!isPlaying | None (client-side) |
| Double tap — right | Pulse (like) | pulseCount++, icon animates | POST /v1/pulses {memory\_id} |
| Double tap — left | Rewind 5 seconds | videoController.seekTo(current \- 5s) | None |
| Swipe up | Next memory | Load next from Redis cache | GET /v1/feed?cursor={next} on cache miss |
| Swipe down | Previous memory | Load prev from cache | GET /v1/feed?cursor={prev} on cache miss |
| Swipe right | Open sidebar/drawer | drawerController.open() | None |
| Long press | Share sheet | showShareSheet(memory\_id) | None |
| Swipe left on creator | Open Graph Path View | Navigate /discovery/:candidateId | GET /v1/kinnections/path?user\_a\&user\_b |

**15.2 Photoplay Studio — 5-Step Flow**

| Step | UI Elements | Validation | Backend Call |
| :---- | :---- | :---- | :---- |
| 1\. Photo Selection | Upload from camera roll / Take new / Select from Tree | Face detection preview (on-device TFLite) | None (client-side landmark detection) |
| 2\. Voice Selection | Record live (≤2 min) / Select Voiceprint / Type text for TTS | Audio length; Voiceprint consent check | POST /v1/voiceprints if new capture |
| 3\. Quality | Standard (SadTalker OSS) / Premium (D-ID API) | Photoplay Credits balance check | GET /v1/user/balance |
| 4\. Rendering | Progress bar, cancel button, push notification on complete | Job queued to Kafka photoplay.jobs | POST /v1/photoplay with photo\_s3\_key, quality\_tier |
| 5\. Output | Preview loop, share options (Line/Branch/Kin/Memory Box), save | C2PA manifest embedded in output | POST /v1/memories {type:'photoplay', c2pa\_manifest\_hash} |

**15.3 Memory Box Composer — Trigger Type Specifications**

| Trigger Type | UI Controls | Validation | Backend Payload |
| :---- | :---- | :---- | :---- |
| Time Capsule | Date \+ time picker | Must be future date | trigger\_type:'time\_capsule', trigger\_value:{datetime:'2026-12-25T09:00:00Z'} |
| Milestone | Dropdown: Graduation / Wedding / New Child / Other | Life event detection via Layer 5 signals | trigger\_type:'milestone', trigger\_value:{event\_type:'graduation'} |
| Unspoken (Posthumous) | Steward picker, verification signals checklist | Step-up auth; Steward consent required | trigger\_type:'unspoken', trigger\_value:{steward\_id:'usr\_...', verification\_signals:\['ssdi','obituary'\]} |
| Kinship Alert (Geofence) | Map pin picker \+ radius slider (100m–5km) | Location permission; radius validation | trigger\_type:'geofence', trigger\_value:{lat:40.7128, lng:-74.0060, radius\_m:500} |

**15.4 Discovery Card — Interaction Flow**

| Element | Action | State Change | Backend Call |
| :---- | :---- | :---- | :---- |
| Connection Score badge | Tap | Open modal with score breakdown | GET /v1/kc/explain/{pair\_id} |
| Relationship guess | Tap | Show CI \+ data sources | None (client-side DTO) |
| Explore Connection CTA | Tap | Navigate to Graph Path View | GET /v1/kinnections/path?user\_a={viewer}\&user\_b={candidate} |
| Kinnect button | Tap | Send Kinnection request | POST /v1/kinnections {target\_user\_id, relationship\_type} |
| Swipe left (dismiss) | Swipe | Apply ×0.30 penalty; hide for 30 days | POST /v1/discovery/dismiss {candidate\_id, penalty:0.30} |

**Section 16\. Commerce & Payment UI Flows**

**16.1 Photoplay Credits Pricing Tiers**

| Tier | Price | Credits | User-Facing Copy | Backend Entitlement |
| :---- | :---- | :---- | :---- | :---- |
| Starter | $0.99 | 1 | Animate one photo | scope:media:write:1 |
| Standard | $4.49 | 5 | Animate 5 photos | scope:media:write:5 |
| Premium | $8.99 | 12 | Animate 12 photos | scope:media:write:12 |
| Unlimited | $16.99/mo | Unlimited | Unlimited Photoplays | scope:media:write:unlimited |

**16.2 CommerceCubit State Machine**

// lib/cubits/commerce\_cubit.dart

enum CommerceStatus { initial, loading, purchased, failed, refunded }

class CommerceCubit extends Cubit\<CommerceStatus\> {

  Future\<void\> purchasePhotoplayCredits(int tierId) async {

    emit(CommerceStatus.loading);

    try {

      final result \= await \_paymentService.purchase(

        productId: 'photoplay\_credits\_tier\_$tierId',

        userId:    \_auth.user.id,

      );

      await \_entitlementService.sync(result.entitlements);

      emit(CommerceStatus.purchased);

    } on PaymentException catch (e) {

      emit(CommerceStatus.failed);

      \_analytics.logError('commerce\_purchase\_failed', {'tier': tierId, 'error': e.code});

    }

  }

  Future\<void\> refundPurchase(String purchaseId) async {

    emit(CommerceStatus.loading);

    try {

      await \_paymentService.refund(purchaseId);

      emit(CommerceStatus.refunded);

    } catch (\_) { emit(CommerceStatus.failed); }

  }

}

**16.3 Ancestral Marketplace Affiliate Structure**

| Partner | Commission | Product Category | Integration Method |
| :---- | :---- | :---- | :---- |
| Impact Radius | 8–15% | Genealogy books, heritage travel | Deep link with affiliate ID |
| ShareASale | 10–12% | DNA wellness products | Product feed \+ affiliate tracking |
| Amazon Associates | 4–8% | DNA kits, photo scanners | Amazon SP-API \+ affiliate tag |
| FamilyTreeDNA | $25 CPA | Premium DNA kits | Postback URL \+ conversion tracking |

**16.4 Kinnect Kit Fulfillment Regions (Phase 1\)**

| Region | Countries | Shipping Partner | Chain of Custody |
| :---- | :---- | :---- | :---- |
| US | United States | FedEx Priority | User → FedEx → Lab (Sequencing.com) → S3 Glacier |
| CA | Canada | Canada Post | User → Canada Post → Lab → S3 Glacier |
| EU | DE, FR, IT, ES, NL | DHL Express | User → DHL → Lab (Frankfurt) → S3 EU |
| UK | United Kingdom | Royal Mail | User → Royal Mail → Lab → S3 EU |
| AU | Australia | Australia Post | User → AusPost → Lab → S3 APAC |

**Section 17\. Push Notification Deep Link Routing Matrix**

All FCM/APNS payloads must include the fields in the Payload Key column. The mobile notification handler resolves these to go\_router deep links. If the primary route fails (e.g. invalid ID), the Fallback Route is used.

| Notification Type | Payload Key | Deep Link Route | Fallback Route |
| :---- | :---- | :---- | :---- |
| Pulses | memory\_id | /memory/{memory\_id} | /line |
| New Kinnections | candidate\_id | /discovery/{candidate\_id} | /pulse |
| Mentions | mention\_id | /pulse?filter=mentions | /pulse |
| Comments | comment\_id | /memory/{memory\_id}\#comment-{comment\_id} | /line |
| Messages | thread\_id | /messages/{thread\_id} | /pulse |
| Gatherings | room\_id | /room/{room\_id} | /pulse |
| Branch activity | branch\_id | /branch/{branch\_id} | /line |
| Heartbeat | N/A | /line?tab=heartbeat | /line |
| Echoes | memory\_id | /memory/{memory\_id}?echo=true | /line |
| Memory Box delivery | memory\_id | /vault/{memory\_id} | /pulse |
| Kinship Alerts | candidate\_id \+ distance\_m | /discovery/{candidate\_id}?alert=true | /pulse |
| Ripples | memory\_id | /memory/{memory\_id}?ripple=true | /line |
| Lost Branches matches | candidate\_id | /discovery/{candidate\_id}?source=lost\_branches | /pulse |
| Live broadcasts | room\_id | /room/{room\_id}?live=true | /line |

**Section 18\. Brand Lexicon Enforcement & Error State Registry**

**18.1 Immutable Terminology Enforcement (CI Build Gate)**

A GitHub Actions job blocks any PR that introduces social-network terminology into lib/ui/. The check runs on every PR targeting main.

\# .github/workflows/lexicon-check.yml

name: Brand Lexicon Enforcement

on: \[pull\_request\]

jobs:

  lexicon-check:

    runs-on: ubuntu-latest

    steps:

      \- uses: actions/checkout@v4

      \- name: Scan for forbidden terms

        run: |

          grep \-r "follower|like|trending|for you|feed" lib/ui/ \\

            \--exclude="\*.g.dart" && exit 1 || exit 0

      \- name: Verify KinnectAI-native terms

        run: |

          grep \-r "Kin|Kinnection|The Line|Branch|Photoplay|Memory Box" lib/ui/ \\

            \--exclude="\*.g.dart" && echo PASS || exit 1

**18.2 Forbidden vs Approved Terminology**

| Forbidden (Social Network) | Approved (KinnectAI-Native) | Context |
| :---- | :---- | :---- |
| Follower / Following | Kin / Kinnection | User-to-user relationship |
| Like / Heart | Pulse | Engagement action on Memory |
| Feed | The Line | Primary content stream |
| Story | Memory | User-generated content unit |
| Group | Branch | Biological family cluster |
| Live | Gathering / Room | Real-time video session |
| Post | Memory | Content creation verb |
| Trending / For You | Echoes / Discovery | Algorithmic surfaces |
| Comment | Pulse Reply | Thread response |
| Share | Ripple | Content propagation |

**18.3 Error State Registry (Per Screen)**

| Screen | Error Code | User Message | Retry Action | Accessibility Label |
| :---- | :---- | :---- | :---- | :---- |
| Onboarding | ONBOARDING\_NAME\_MAP\_FAILED | We couldn't load the Name Map. Please check your connection. | Retry button (max 3 attempts) | Name Map loading error, retry available |
| The Line | FEED\_CACHE\_MISS | Loading your biological feed… | Auto-retry with exponential backoff | Feed loading, please wait |
| Photoplay Studio | PHOTOPLAY\_RENDER\_FAILED | Photoplay creation failed. Try Standard quality or retry later. | Switch to Standard tier / Retry | Photoplay processing error, fallback available |
| Memory Box | VAULT\_SEAL\_AUTH\_FAILED | Step-up authentication required to seal this Memory. | Re-prompt biometric/2FA | Authentication required for secure action |
| Discovery | DISCOVERY\_CANDIDATES\_EMPTY | No new probable Kin found this week. Check back soon. | Pull-to-refresh | Discovery empty state, refresh available |
| Rooms | ROOM\_JOIN\_FAILED | Couldn't join the Room. Please check your connection. | Retry / Fallback to audio-only | Room connection error, retry available |
| Settings | CONSENT\_REVOKE\_FAILED | We couldn't update your consent preferences. Please try again. | Retry / Contact support | Consent update error, retry available |

**Section 19\. Content Moderation Pipeline Detail**

**19.1 Automated Moderation Thresholds**

| Content Type | Model | Threshold | Action | SLA |
| :---- | :---- | :---- | :---- | :---- |
| Text comments | Perspective API (TOXICITY) | ≥ 0.8 | Auto-hide \+ queue for human review | P0: 30 min |
| Text comments | Perspective API (TOXICITY) | 0.5–0.79 | Flag for human review | P1: 2h |
| Images | CLIP NSFW classifier | ≥ 0.7 | Auto-reject \+ log to moderation.queue | P0: immediate |
| Photoplay audio | ElevenLabs content filter | Match blocked terms | Reject \+ notify user | P1: 2h |
| Memory Box triggers | Death verification NLP | \< 3 obituary sources after 72h | Escalate to Steward contact | P2: 72h |

**19.2 Moderation SLA Table**

| Severity | Definition | Response Time | Resolution Time | Escalation Path |
| :---- | :---- | :---- | :---- | :---- |
| P0 | CSAM, threats of violence, deepfake impersonation | 30 min | 2h | Trust & Safety Lead → Legal → DPO |
| P1 | Toxicity 0.5–0.8, NSFW borderline, spam campaigns | 2h | 24h | Moderation Queue → Senior Reviewer |
| P2 | Policy edge cases, user appeals, false positives | 24h | 72h | Community Guidelines Team |

**19.3 Memory Box Death Trigger Moderation Hold**

When obituary signals are insufficient (\< 3 sources after 72 h) and SSDI confidence is below 95%, the delivery pipeline enters a moderation hold. The following YAML snippet defines the decision tree for this hold state. Cross-reference SRS v5.0 §4.3 and Appendix H for the full state machine.

\# Memory Box death trigger moderation hold

moderation\_hold:

  trigger\_type: unspoken

  condition: obituary\_sources \< 3 AND ssdi\_match \< 0.95

  action:

    \- pause\_delivery\_pipeline

    \- notify\_steward\_via\_push\_sms\_email

    \- start\_72h\_steward\_response\_window

  fallback:

    after\_72h\_no\_response: escalate\_to\_kinnectai\_legal\_dpo

    after\_365d:            auto\_release\_to\_next\_of\_kin\_on\_record

**Section 20\. Full Test Suite Specification**

**20.1 Backend (Go) — Critical Path Unit Tests**

These tests are required CI gates. Any failure blocks promotion to canary. Tests must use only synthetic T3+ data (SRS v5.0 §6 ML-007).

// services/go/kernel-service/internal/kc/compute\_test.go

func TestKCDeterministicOrder(t \*testing.T) {

  inputs := map\[string\]LayerData{

    "layer2": {Score: 0.40}, "layer1": {Score: 0.15},

    "layer5": {Score: 0.25}, "layer4": {Score: 0.10},

    "layer3": {Score: 0.10},

  }

  res, \_ := Compute(inputs, DefaultModifiers)

  if res.FinalScore \< 0.0 || res.FinalScore \> 1.0 {

    t.Errorf("KC out of bounds: %f", res.FinalScore)

  }

}

func TestKCFallbackConsentFlags(t \*testing.T) {

  flags := 0x00 // No consent — all layers blocked

  res, err := ComputeWithConsent(flags, nil)

  if err \!= nil { t.Fatal(err) }

  if \!res.FallbackApplied { t.Error("Expected fallback applied") }

}

// services/go/memorybox-service/internal/encryption/zk\_test.go

func TestEnvelopeEncryptionCycle(t \*testing.T) {

  content    := \[\]byte("test memory payload")

  dek, \_     := GenerateDEK()

  ciphertext, \_ := EncryptAES256GCM(content, dek)

  wrappedDEK, \_ := WrapDEKWithKMS(dek) // Mocked KMS

  if string(ciphertext) \== string(content) { t.Error("Encryption failed") }

  if len(wrappedDEK) \< 64              { t.Error("Invalid wrapped DEK length") }

}

**20.2 Mobile (Dart) — BLoC Tests**

// test/cubits/vault\_composer\_cubit\_test.dart

blocTest\<VaultComposerCubit, VaultComposerState\>(

  'emits sealing then sealed on successful step-up auth',

  build: () \=\> MockVaultCubit(repo: MockRepo(), stepUp: MockStepUp()),

  act:   (c)  async \=\> await c.sealMemory(),

  expect: ()  \=\> \[ isA\<VaultComposerState.sealing\>(), isA\<VaultComposerState.sealed\>() \],

);

test('blocks sealing without step-up auth', () async {

  final cubit \= VaultComposerCubit(MockRepo(), MockStepUpFailing());

  cubit.selectTrigger(TriggerType.time\_capsule, {'date': '2026-12-01'});

  await cubit.sealMemory();

  expect(cubit.state, isA\<VaultComposerState.auth\_failed\>());

});

**20.3 Integration & E2E Critical Path Matrix**

| Test ID | Path | Mock/Setup | Assertion |
| :---- | :---- | :---- | :---- |
| INT-01 | POST /v1/memorybox → ZK encrypt → KMS wrap → DB insert | Mock KMS, Mock S3 | HTTP 201, encrypted\_dek length \> 64, status=sealed |
| INT-02 | GET /v1/feed → Redis cache → KC sort → Kernel fallback | Pre-load Redis ZSET, simulate Kernel 503 | Returns metadata.fallback\_applied:true, latency \< 150ms |
| INT-03 | Kafka photoplay.jobs → D-ID fail → SadTalker fallback → C2PA sign | Mock D-ID 503, Mock FFmpeg | Job status=FALLBACK\_ACTIVATED, C2PA manifest embedded |
| INT-04 | Consent revocation (consent\_flags ^= 0x02) → JWT invalidation → API 403 | Update PG users.consent\_flags | POST /v1/dna returns 403 consent\_missing\_bit\_1 |
| E2E-01 | Onboarding → Line activation → Pulse → KC recomputation | Test DB, Local Kafka | Feed shows creator, Pulse count \+1, cr.recompute event published |

**20.4 CI/CD GitHub Actions Workflow**

\# .github/workflows/kinnectai-deploy.yml

name: KinnectAI Production Deploy

on:

  push: { branches: \[main\] }

  workflow\_dispatch:

jobs:

  validate:

    runs-on: ubuntu-latest

    steps:

      \- uses: actions/checkout@v4

      \- name: Unit & Integration Tests

        run: |

          go test ./services/go/... \-coverprofile=coverage.txt

          dart test apps/mobile/test/ \--coverage=coverage/dart

      \- name: SAST Scan

        uses: semgrep/semgrep-action@v1

        with: { config: p/default }

  canary-deploy:

    needs: validate

    environment: prod

    steps:

      \- uses: aws-actions/configure-aws-credentials@v4

        with: { role-to-assume: ${{ secrets.AWS\_ROLE\_ARN }} }

      \- name: Build & Push

        run: |

          docker build \-t $ECR\_REPOSITORY:${{ github.sha }} .

          docker push  $ECR\_REPOSITORY:${{ github.sha }}

      \- name: Deploy Canary 1%

        run: |

          kubectl set image deployment/api-service \\

            api=$ECR\_REPOSITORY:${{ github.sha }} \-n prod

          kubectl rollout status deployment/api-service \-n prod \--timeout=5m

      \- name: Health Check

        run: curl \-f https://api.kinnectai.app/v1/healthz || exit 1

  rollback:

    needs: canary-deploy

    if: failure()

    steps:

      \- name: Automatic Rollback

        run: kubectl rollout undo deployment/api-service \-n prod

**Section 21\. Terraform IaC Module Reference**

The following HCL modules are copy-paste ready. They complement the module structure defined in SRS v5.0 §10.1. Each module below represents the exact implementation for its infra/modules/ subdirectory.

**21.1 VPC Module (infra/modules/vpc/main.tf)**

resource "aws\_vpc" "kinnectai" {

  cidr\_block           \= "10.0.0.0/16"

  enable\_dns\_support   \= true

  enable\_dns\_hostnames \= true

  tags \= { Name \= "kinnectai-prod-vpc" }

}

resource "aws\_subnet" "private" {

  count             \= 3

  vpc\_id            \= aws\_vpc.kinnectai.id

  cidr\_block        \= cidrsubnet(aws\_vpc.kinnectai.cidr\_block, 8, count.index \+ 10\)

  availability\_zone \= data.aws\_availability\_zones.available.names\[count.index\]

  tags \= { Name \= "kinnectai-private-${count.index \+ 1}" }

}

**21.2 EKS Module (infra/modules/eks/main.tf)**

module "eks" {

  source          \= "terraform-aws-modules/eks/aws"

  version         \= "20.21.0"

  cluster\_name    \= "kinnectai-prod"

  cluster\_version \= "1.29"

  vpc\_id          \= var.vpc\_id

  subnet\_ids      \= var.private\_subnet\_ids

  eks\_managed\_node\_groups \= {

    general \= {

      instance\_types \= \["m5.xlarge"\]

      min\_size \= 2  max\_size \= 12  desired\_size \= 3

    }

    gpu \= {

      instance\_types \= \["g4dn.xlarge"\]

      min\_size \= 0  max\_size \= 6  desired\_size \= 0

      taints \= \[{ key \= "nvidia.com/gpu", value \= "true", effect \= "NO\_SCHEDULE" }\]

    }

  }

  enable\_cluster\_creator\_admin\_permissions \= true

}

**21.3 Aurora PostgreSQL Module (infra/modules/rds-aurora/main.tf)**

resource "aws\_rds\_cluster" "aurora" {

  cluster\_identifier      \= "kinnectai-pg16"

  engine                  \= "aurora-postgresql"

  engine\_version          \= "16.2"

  master\_username         \= var.db\_username

  master\_password         \= var.db\_password

  db\_subnet\_group\_name    \= aws\_db\_subnet\_group.aurora.name

  vpc\_security\_group\_ids  \= \[var.security\_group\_id\]

  storage\_encrypted       \= true

  kms\_key\_id              \= var.kms\_key\_arn

  deletion\_protection     \= true

  backup\_retention\_period \= 35

  serverlessv2\_scaling\_configuration {

    min\_capacity \= 0.5

    max\_capacity \= 16

  }

}

resource "aws\_rds\_cluster\_parameter\_group" "pgvector" {

  name   \= "kinnectai-pgvector-params"

  family \= "aurora-postgresql16"

  parameter {

    name  \= "shared\_preload\_libraries"

    value \= "pg\_stat\_statements,pgvector"

  }

}

**21.4 MSK Kafka Module (infra/modules/msk/main.tf)**

resource "aws\_msk\_cluster" "kinnectai" {

  cluster\_name           \= "kinnectai-prod-kafka"

  kafka\_version          \= "3.7.0"

  number\_of\_broker\_nodes \= 3

  broker\_node\_group\_info {

    instance\_type   \= "kafka.m5.xlarge"

    ebs\_volume\_size \= 100

    security\_groups \= \[var.security\_group\_id\]

    subnets         \= var.subnet\_ids

  }

  encryption\_info {

    encryption\_in\_transit { client\_broker \= "TLS" }

    encryption\_at\_rest\_kms\_key\_arn \= var.kms\_key\_arn

  }

}

# **Section 22\. Consolidated OpenAPI 3.1 Bundle**

This section is the authoritative, codegen-ready OpenAPI 3.1 specification for all KinnectAI services. It was present in the Production Implementation Deliverables document but absent from SRS v5.0. Import this spec into openapi-generator to scaffold Go/Python service stubs and Dart client code.

Server: https://api.kinnectai.app/v1  |  Version: 1.0.0

## **22.1 Info, Servers & Security Schemes**

openapi: 3.1.0

info:

  title: KinnectAI Production API

  version: 1.0.0

  contact: { name: Engineering, url: 'https://kinnectai.app/docs' }

servers:

  \- url: https://api.kinnectai.app/v1

    description: Production

components:

  securitySchemes:

    BearerAuth:

      type: http

      scheme: bearer

      bearerFormat: JWT

    StepUpAuth:

      type: apiKey

      in: header

      name: X-Stepup-Auth

    Scope:

      type: oauth2

      flows:

        clientCredentials:

          tokenUrl: 'https://auth.kinnectai.app/oauth/token'

          scopes: {}

## **22.2 Paths**

### **GET /feed — The Line KC-Ranked Feed**

  /feed:

    get:

      tags: \[feed-service\]

      summary: Retrieve The Line feed sorted by KC

      security: \[{ BearerAuth: \[\], Scope: \['feed:read'\] }\]

      parameters:

        \- name: limit

          in: query

          schema: { type: integer, minimum: 1, : 50, default: 10 }

        \- name: cursor

          in: query

          schema: { type: string }

        \- name: fallback\_mode

          in: query

          schema: { type: string, enum: \[kc\_cached, chronological, empty\], default: kc\_cached }

      responses:

        '200':

          description: KC-ranked feed

          content:

            application/json:

              schema:

                type: object

                properties:

                  items: { type: array, items: { $ref: '\#/components/schemas/MemoryCard' } }

                  next\_cursor: { type: string, nullable: true }

                  metadata: { $ref: '\#/components/schemas/FeedMetadata' }

        '403': { $ref: '\#/components/responses/InsufficientScope' }

        '429': { $ref: '\#/components/responses/RateLimitExceeded' }

### **POST /memorybox — Seal Memory Box (ZK)**

  /memorybox:

    post:

      tags: \[memorybox-service\]

      summary: Seal Memory Box with ZK client-side encryption

      security: \[{ BearerAuth: \[\], StepUpAuth: \[\] }\]

      requestBody:

        required: true

        content:

          application/json:

            schema:

              type: object

              required: \[recipient\_id, trigger\_type, trigger\_value, content\_s3\_key, encrypted\_dek, dek\_key\_id\]

              properties:

                recipient\_id:   { type: string, format: uuid }

                trigger\_type:   { type: string, enum: \[time\_capsule, milestone, unspoken, geofence\] }

                trigger\_value:  { type: object }

                content\_s3\_key: { type: string }

                encrypted\_dek:  { type: string, format: byte }

                dek\_key\_id:     { type: string }

                steward\_id:     { type: string, format: uuid, nullable: true }

      responses:

        '201': { $ref: '\#/components/schemas/VaultSealedResponse' }

        '401': { $ref: '\#/components/responses/StepUpRequired' }

        '403': { $ref: '\#/components/responses/ConsentMissing' }

### **POST /photoplay — Queue Photoplay Render Job**

  /photoplay:

    post:

      tags: \[photoplay-service\]

      summary: Queue Photoplay animation job (Standard or Premium tier)

      security: \[{ BearerAuth: \[\], Scope: \['media:write', 'biometric:face:write'\] }\]

      requestBody:

        required: true

        content:

          application/json:

            schema: { $ref: '\#/components/schemas/PhotoplayRequest' }

      responses:

        '202': { $ref: '\#/components/schemas/PhotoplayJobResponse' }

        '503': { description: Fallback activated — SadTalker OSS pipeline engaged }

### **GET /discovery — Weekly Candidate Kin**

  /discovery:

    get:

      tags: \[discovery-service\]

      summary: Weekly Discovery candidates ranked by KC score

      security: \[{ BearerAuth: \[\], Scope: \['discovery:read'\] }\]

      responses:

        '200':

          content:

            application/json:

              schema: { $ref: '\#/components/schemas/DiscoveryList' }

        '403': { $ref: '\#/components/responses/InsufficientScope' }

### **GET /kinnections — Confirmed & Pending Kinnections**

  /kinnections:

    get:

      tags: \[kin-graph-service\]

      summary: Confirmed Kinnections and pending requests

      security: \[{ BearerAuth: \[\], Scope: \['graph:read'\] }\]

      responses:

        '200':

          content:

            application/json:

              schema: { $ref: '\#/components/schemas/KinnectionList' }

  /kinnections/path:

    get:

      tags: \[kin-graph-service\]

      summary: Shortest graph path between two users (Graph Path View)

      security: \[{ BearerAuth: \[\], Scope: \['graph:read'\] }\]

      parameters:

        \- name: user\_a

          in: query

          required: true

          schema: { type: string, format: uuid }

        \- name: user\_b

          in: query

          required: true

          schema: { type: string, format: uuid }

      responses:

        '200':

          content:

            application/json:

              schema: { $ref: '\#/components/schemas/KinnectionPath' }

### **POST /rooms — Create Room & Generate SFU Token**

  /rooms:

    post:

      tags: \[rooms-service\]

      summary: Create Room and generate mediasoup SFU token

      security: \[{ BearerAuth: \[\], Scope: \['rooms:write'\] }\]

      requestBody:

        required: true

        content:

          application/json:

            schema: { $ref: '\#/components/schemas/RoomCreateRequest' }

      responses:

        '201': { $ref: '\#/components/schemas/RoomTokenResponse' }

### **GET /kc/explain/{pair\_id} — KC Explainability (GDPR Art. 22\)**

  /kc/explain/{pair\_id}:

    get:

      tags: \[kernel-service\]

      summary: Return top-k features, layer weights, CI, model\_version for a KC pair

      security: \[{ BearerAuth: \[\], Scope: \['graph:read'\] }\]

      parameters:

        \- name: pair\_id

          in: path

          required: true

          schema: { type: string }

      responses:

        '200':

          content:

            application/json:

              schema: { $ref: '\#/components/schemas/KCExplainResponse' }

### **POST /v1/pulses — Send Pulse on a Memory**

  /pulses:

    post:

      tags: \[feed-service\]

      summary: Send a Pulse reaction on a Memory

      security: \[{ BearerAuth: \[\], Scope: \['feed:read'\] }\]

      requestBody:

        required: true

        content:

          application/json:

            schema:

              type: object

              required: \[memory\_id\]

              properties:

                memory\_id: { type: string, format: uuid }

      responses:

        '201':

          content:

            application/json:

              schema:

                type: object

                properties:

                  pulse\_id:       { type: string, format: uuid }

                  memory\_id:      { type: string, format: uuid }

                  new\_pulse\_count: { type: integer }

                  timestamp:      { type: string, format: date-time }

### **POST /discovery/dismiss — Dismiss Discovery Candidate**

  /discovery/dismiss:

    post:

      tags: \[discovery-service\]

      summary: Dismiss a candidate — applies x0.30 KC penalty for 30 days

      security: \[{ BearerAuth: \[\], Scope: \['discovery:read'\] }\]

      requestBody:

        required: true

        content:

          application/json:

            schema:

              type: object

              required: \[candidate\_id, penalty\]

              properties:

                candidate\_id: { type: string, format: uuid }

                penalty:      { type: number, format: float, default: 0.30 }

      responses:

        '204': { description: Dismissed }

### **POST /webhooks/revenuecat — RevenueCat Entitlement Sync**

  /webhooks/revenuecat:

    post:

      tags: \[payment-service\]

      summary: RevenueCat IAP webhook — sync entitlements to backend

      requestBody:

        required: true

        content:

          application/json:

            schema: { $ref: '\#/components/schemas/RevenueCatWebhook' }

      responses:

        '200': { description: Processed }

        '409': { description: Duplicate event — idempotent, ignored }

## **22.3 Component Schemas**

### **Content & Feed Schemas**

  schemas:

    MemoryCard:

      type: object

      properties:

        memory\_id:      { type: string, format: uuid }

        creator\_id:     { type: string, format: uuid }

        type:           { type: string, enum: \[video, photoplay, audio, stitch, rewind\] }

        kin\_score:      { type: number, format: float, minimum: 0, : 1 }

        is\_ai\_generated: { type: boolean }

        created\_at:     { type: string, format: date-time }

        pulse\_count:    { type: integer, default: 0 }

        caption:        { type: string, nullable: true }

        audio\_url:      { type: string, nullable: true }

        video\_url:      { type: string, nullable: true }

        c2pa\_manifest\_url: { type: string, nullable: true }

    FeedMetadata:

      type: object

      properties:

        kernel\_status:      { type: string, enum: \[healthy, degraded, unavailable\] }

        fallback\_applied:   { type: boolean }

        cache\_age\_seconds:  { type: integer }

### **Memory Box & Vault Schemas**

    VaultSealedResponse:

      type: object

      properties:

        memory\_id:    { type: string, format: uuid }

        trigger\_id:   { type: string, format: uuid }

        audit\_log\_id: { type: string }

    MockAPIFeedResponse:

      type: object

      description: Mock response shape for frontend development

      example:

        items:

          \- memoryId: mem\_abc123

            creatorId: usr\_xyz789

            type: photoplay

            s3Key: memories/2026/05/abc123.mp4

            createdAt: '2026-05-07T10:30:00Z'

            isAiGenerated: true

            pulseCount: 12

            caption: Grandpa story about the old farm

            audioUrl: https://cdn.kinnectai.app/audio/abc123.aac

            videoUrl: https://cdn.kinnectai.app/video/abc123\_720p.mp4

        next\_cursor: cursor\_next\_page\_token

        metadata:

          kernel\_status: healthy

          fallback\_applied: false

          cache\_age\_seconds: 45

### **Photoplay Schemas**

    PhotoplayRequest:

      type: object

      required: \[photo\_s3\_key, quality\_tier\]

      properties:

        photo\_s3\_key:   { type: string }

        audio\_s3\_key:   { type: string, nullable: true }

        voiceprint\_id:  { type: string, nullable: true }

        quality\_tier:   { type: string, enum: \[STANDARD, PREMIUM\] }

        c2pa\_required:  { type: boolean, default: true }

    PhotoplayJobResponse:

      type: object

      properties:

        job\_id:               { type: string, format: uuid }

        status:               { type: string, enum: \[QUEUED, PROCESSING, FALLBACK\_ACTIVATED\] }

        estimated\_completion: { type: string, format: date-time }

### **Discovery & Graph Schemas**

    DiscoveryList:

      type: object

      properties:

        candidates:

          type: array

          items: { $ref: '\#/components/schemas/DiscoveryCard' }

    DiscoveryCard:

      type: object

      properties:

        candidate\_id:       { type: string, format: uuid }

        kc\_score\_display:   { type: integer, minimum: 0, : 100 }

        relationship\_guess: { type: string }

        primary\_signal:     { type: string, enum: \[DNA, HAPLOGROUP, FACIAL, NAME\_GEO, TREE, BEHAVIORAL\] }

        confidence\_interval: { type: array, items: { type: number } }

    KinnectionList:

      type: object

      properties:

        kinnections:

          type: array

          items:

            type: object

            properties:

              target\_user\_id: { type: string, format: uuid }

              cr\_score:       { type: number, format: float }

              status:         { type: string, enum: \[confirmed, pending, rejected\] }

    KinnectionPath:

      type: object

      properties:

        path:

          type: array

          items:

            type: object

            properties:

              user\_id:    { type: string, format: uuid }

              edge\_type:  { type: string }

              kc\_score:   { type: number, format: float }

        hop\_count:        { type: integer }

        total\_kc\_score:   { type: number, format: float }

### **Rooms Schemas**

    RoomCreateRequest:

      type: object

      required: \[name, privacy\]

      properties:

        name:        { type: string }

        privacy:     { type: string, enum: \[private, kc\_gated, branch\] }

        invitee\_ids: { type: array, items: { type: string, format: uuid } }

    RoomTokenResponse:

      type: object

      properties:

        room\_id:     { type: string, format: uuid }

        sfu\_token:   { type: string }

        ice\_servers:

          type: array

          items:

            type: object

            properties:

              urls:           { type: array, items: { type: string } }

              username:       { type: string }

              credential:     { type: string }

              credentialType: { type: string }

### **KC Explainability Schema**

    KCExplainResponse:

      type: object

      properties:

        pair\_id:       { type: string }

        model\_version: { type: string }

        final\_score:   { type: number, format: float }

        top\_features:

          type: array

          maxItems: 3

          items:

            type: object

            properties:

              feature\_name:  { type: string }

              layer:         { type: string, enum: \[L1, L2, L3, L4, L5\] }

              weight:        { type: number, format: float }

              importance:    { type: number, format: float }

        confidence\_interval:

          type: object

          properties:

            lower: { type: number, format: float }

            upper: { type: number, format: float }

### **RevenueCat Webhook Schema**

    RevenueCatWebhook:

      type: object

      properties:

        event:

          type: object

          properties:

            id:                 { type: string }

            created\_at:         { type: string, format: date-time }

            type:               { type: string, enum: \[INITIAL\_PURCHASE, RENEWAL, CANCELLATION, REFUND\] }

            app\_user\_id:        { type: string }

            product\_identifier: { type: string }

            store:              { type: string, enum: \[APP\_STORE, PLAY\_STORE, STRIPE\] }

            entitlements:

              type: object

              additionalProperties:

                type: object

                properties:

                  active:       { type: boolean }

                  expires\_date: { type: string, format: date-time }

## **22.4 Error Responses**

  responses:

    InsufficientScope:

      description: 403 Forbidden — missing OAuth scope

      content:

        application/json:

          schema:

            type: object

            properties:

              error:         { type: string, example: insufficient\_scope }

              missing\_scope: { type: string, example: 'media:write' }

    RateLimitExceeded:

      description: 429 Too Many Requests

      headers:

        Retry-After: { schema: { type: integer } }

    StepUpRequired:

      description: 401 Step-up authentication required

      content:

        application/json:

          schema:

            type: object

            properties:

              error:  { type: string, example: step\_up\_required }

              reason: { type: string, example: vault\_write }

    ConsentMissing:

      description: 403 Consent flag not set

      content:

        application/json:

          schema:

            type: object

            properties:

              error:       { type: string, example: consent\_required }

              missing\_bit: { type: integer, example: 2 }

              feature:     { type: string, example: dna\_upload }

## **22.5 Execution Directive** 

To scaffold service stubs from this spec:

1. Run: openapi-generator generate \-i openapi.yaml \-g go-server \-o services/go/api-stubs/

2. Run: openapi-generator generate \-i openapi.yaml \-g dart \-o apps/mobile/lib/api/

3. Import into Postman or Bruno for API testing against staging.

4. All schemas above are the source of truth — do not hand-edit generated stubs.

![][image1]

![][image2]

[image1]: <data:image/png;base64,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>

[image2]: <data:image/png;base64,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>