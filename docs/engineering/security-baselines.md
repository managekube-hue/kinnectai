# KinnectAI Security Baselines
*Zero-trust, consent enforcement, ZK architecture, SRS §12, Appendix J.*

## 1. Authentication & Authorization
- **JWT:** RS256, `go-jose`, 1h TTL, refresh flow. Claims: `sub`, `iss`, `aud`, `scopes`, `consent_tiers`.
- **Step-Up:** `X-Stepup-Auth: biometric|totp`, `X-Stepup-Reason: vault_write|dna_upload`. 300s TTL, single-use, HMAC-signed.
- **Revocation:** Redis `revoked_jti` set. Latency <2ms. Propagates on consent toggle.

## 2. Consent Bitmask Enforcement (`consent_flags`)
- 13-bit integer (`0-8191`). Checked **before** business logic.
- Middleware validates required bit. Returns `403 {error: consent_required, missing_bit: X}`.
- Revocation triggers async JWT scan. Immediate enforcement for bits 1, 5, 6 (DNA/Face/Voice).

## 3. Cryptographic & Data Handling
- **ZK Architecture:** Server stores ONLY `encrypted_dek`, `s3_key`. Never sees plaintext.
- **KMS:** Envelope encryption. DEK rotated per memory. KEK 90d rotation. Lambda re-encrypts <=10K/day.
- **Shamir SSS:** 3-of-5 threshold for T5 data. Ephemeral pod reconstruction. Memory zeroed post-use.
- **Network:** mTLS service-to-service. TLS 1.3 client-facing. VPC PrivateLink for DB/Kafka.

## 4. Compliance Routing
- **GDPR:** Art 6/9 explicit consent. EU data residency. Erasure cascades.
- **BIPA:** Bit 5/6 enforcement. On-device `TFLite` preview only. 3y auto-purge.
- **COPPA:** `<13` accounts: `is_minor=true`. Guardian consent required. DNA/Biometric blocked.
- **HIPAA/GINA:** T4 genomic data isolated. No human access. CloudTrail + SIEM alert.
