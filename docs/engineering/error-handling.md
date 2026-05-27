# KinnectAI Error Handling Standards
*Deterministic failure propagation, SRS §11.2 alignment, GDPR Art. 17 compliance.*

## 1. Error Taxonomy
| Code | HTTP | Description | Retry Strategy |
|------|------|-------------|----------------|
| `ERR_CONSENT_00X` | 403 | Missing consent bitmask or scope | No retry. Route to consent flow. |
| `ERR_AUTH_401` | 401 | Expired/revoked JWT or step-up | Silent refresh. 300s TTL enforcement. |
| `ERR_RATE_429` | 429 | Sliding window limit exceeded | Respect `Retry-After`. Exponential backoff. |
| `ERR_KERN_DEG` | 503 | Kernel degraded/fallback active | Fallback to `kc_cached` or `chronological`. |
| `ERR_ZK_SEAL` | 500 | Memory Box KMS/S3 failure | Preserve draft. Notify user. Retry 3x. |
| `ERR_DNA_PARSE` | 422 | VCF/PLINK validation failure | Reject. Return `error_code` per SRS §8.1. |

## 2. Language-Specific Implementation
### Go
- Wrap errors: `fmt.Errorf("wrap: %w", err)`
- Check: `errors.Is(err, ErrSpecific)` / `errors.As(err, &typed)`
- Define: Package-level vars (`var ErrNotFound = errors.New("not found")`)
- Never swallow. Log at boundary. Return to caller.

### Dart
- Use `Either<Failure, Success>` pattern (`fpdart` or `dartz`).
- Sealed classes for failures:
  ```dart
  sealed class AppFailure { final String message; const AppFailure(this.message); }
  final class ConsentFailure extends AppFailure { const ConsentFailure() : super("consent_required"); }
  ```

### Python
- Custom exception hierarchy inheriting from `Exception`.
- Use `raise NewError from original_error` for chaining (`__cause__`).
- Catch broad exceptions only at top-level handlers.

## 3. Observability & Compliance
- All errors emit to Prometheus: `error_total{service, code, retryable}`.
- PII/GDPR: **Never** log raw `user_id`, JWT, DEK, or genomic data. Use `HMAC-SHA256(user_id, LOG_HMAC_SECRET)[:16]`.
- User-facing messages separated from internal stack traces.
- Circuit breakers trip on `5xx` > 50% over 30s window.
