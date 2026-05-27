# KinnectAI Testing Standards
*Test pyramid, synthetic data mandate, CI gates, SRS §20.*

## 1. Test Pyramid & Coverage
| Layer | Target | Tooling | Gate |
|-------|--------|---------|------|
| Unit | ≥80% (Go), ≥80% (Dart) | `go test`, `flutter test` | Block merge if < threshold |
| Integration | ≥70% | `testcontainers`, `httpx`, `bloc_test` | Block staging promotion |
| E2E | Critical paths | `integration_test`, `Playwright` | Manual QA sign-off |

## 2. Synthetic Data Mandate (ML-007)
- **NEVER** use real PII, genomic (FASTQ/VCF), or biometric data in tests.
- Use `synthetic-data-generator` or deterministic fixtures.
- CI scan rejects PRs containing `*.vcf`, `*.fastq`, or known PII patterns in `test/`.

## 3. Implementation Rules
- **Unit:** No external deps. Mock interfaces. Fast (<100ms each). Table-driven tests in Go.
- **Integration:** Real Kafka/Neo4j/Redis via Testcontainers. Clean schema per run.
- **E2E:** Full user flows: Onboarding -> Line -> Kinnection -> Photoplay -> Memory Box.
- **Flakiness:** Retries with jitter (1s, 2s, 4s). Deterministic time (`clockwork`/`fake_async`). Auto-quarantine after 3 failures.

## 4. CI/CD Gates
1. `golangci-lint` / `dart analyze` / `eslint` clean.
2. Coverage thresholds met.
3. SAST/DAST: 0 High/Critical CVEs.
4. Brand lexicon: 0 forbidden terms in `lib/ui/` & `apps/web/src/screens/`.
5. Accessibility: ≥95% WCAG 2.2 AA on snapshot tests.
6. PRD traceability: ≥95% features `live` in `prd_traceability`.
