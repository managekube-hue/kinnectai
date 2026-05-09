# behavioral-service

Behavioral telemetry and scoring pipeline service.

Responsibilities:
- Ingest behavioral/interaction events.
- Run telemetry enrichment and derived-score pipelines.
- Provide behavioral features to downstream services.

Out of scope:
- Feed assembly and feed endpoints (owned by feed-service).
- Intelligence orchestration APIs (owned by kernel-service).
- Candidate generation workflows (owned by discovery-service).
