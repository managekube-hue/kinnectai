# KinnectAI Logging Standards
*SRS §11.2 Structured JSON, Loki/Tempo alignment, Zero-PII enforcement.*

## 1. Canonical Log Envelope (JSON)
```json
{
  "timestamp": "2026-05-11T10:30:00Z",
  "level": "INFO",
  "service": "feed-service",
  "version": "1.4.2",
  "correlation_id": "550e8400-e29b-41d4-a716-446655440000",
  "trace_id": "abc123def456",
  "span_id": "span_001",
  "user_id_hash": "a1b2c3d4e5f6...",
  "region": "us-east-1",
  "consent_flags_snapshot": 8191,
  "event": "feed.assembled",
  "duration_ms": 45,
  "meta": { "cache_hit": true, "fallback_mode": "kc_cached" }
}
```

## 2. Level Definitions
- `DEBUG`: Dev-only, feature flags, trace payloads. Stripped in prod builds.
- `INFO`: Business events, auth success, feed assembly, cache hits.
- `WARN`: Degraded dependencies, fallback activation, rate limits, stale cache.
- `ERROR`: Failed requests, DB timeout, schema mismatch, DLQ drops.
- `FATAL`: Service crash, KMS unreachable, panic recovery, immediate restart.

## 3. PII & Security Redaction
- **MUST REDACT:** `user_id`, `email`, `phone`, `ip_address`, `jwt`, `dek_plaintext`, `raw_snp_data`.
- **MUST HASH:** `user_id_hash` (HMAC-SHA256), `ip_hash` (SHA-256).
- `LOG_HMAC_SECRET` stored in AWS SSM. Rotated quarterly. Never hardcoded.

## 4. Runtime & Transport
- **Go:** `slog` or `zerolog` with context injection middleware.
- **Python:** `structlog` + `contextvars` for async propagation.
- **Dart:** `package:logging` -> `Hive` local buffer -> batch flush on reconnect.
- **Kubernetes:** Stdout/stderr only. No file logging. FluentBit DaemonSet ships to Loki.
- **Compliance:** Audit logs immutable. Separate retention (7y). App logs 30d.
