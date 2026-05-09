# discovery-service

Candidate generation service.

Responsibilities:
- Generate kin candidate sets from graph/intelligence signals.
- Apply candidate filtering and candidate-level ranking policies.

Out of scope:
- Feed rendering/assembly (owned by feed-service).
- Kernel orchestration core APIs (owned by kernel-service).
- Behavioral event ingestion and long-running telemetry pipelines (owned by behavioral-service).

