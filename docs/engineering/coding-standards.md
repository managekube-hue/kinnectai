# KinnectAI Coding Standards
*Authoritative reference for polyglot monorepo development. Violations fail CI.*

## 1. Naming Conventions
| Language | Types/Classes | Functions/Methods | Variables/Constants | Files |
|----------|---------------|-------------------|---------------------|-------|
| Go | `PascalCase` | `camelCase` (exported) / `camelCase` (private) | `camelCase` / `SCREAMING_SNAKE` | `snake_case.go` |
| Dart | `PascalCase` | `camelCase` | `camelCase` / `kCamelCase` | `snake_case.dart` |
| TS/Next.js | `PascalCase` | `camelCase` | `camelCase` / `UPPER_SNAKE` | `kebab-case.tsx` |
| Python | `PascalCase` | `snake_case` | `snake_case` / `UPPER_SNAKE` | `snake_case.py` |
| Terraform | `snake_case` | N/A | `snake_case` | `main.tf`, `variables.tf` |

## 2. File Organization & Boundaries
- **Go:** `cmd/` (entry), `internal/` (domain/app/infra/transport), `pkg/` (shared), `test/`
- **Dart:** Feature-first. `lib/features/{feature}/`, `lib/cubits/`, `lib/models/dtos/`, `lib/core/`
- **Python:** `app/` or `src/`, `domain/`, `application/`, `infrastructure/`, `policy/`
- **Never** cross-boundary imports (e.g., Flutter client -> Neo4j driver). All data flows through `/v1` REST/gRPC.

## 3. Immutability & State
- Go: Structs with value semantics where possible. Avoid global mutable state.
- Dart: `freezed` unions for all DTOs/States. `const` constructors by default.
- TS: `readonly` interfaces. Zustand/Redux slices must not mutate state directly.
- Python: `pydantic` v2 models with `frozen=True` for domain events.

## 4. Concurrency & Async
- Go: `context.Context` mandatory in all I/O/signatures. Use `errgroup` for fan-out. `defer cancel()` on every spawn.
- Dart: `Isolate.compute` for CPU-heavy parsing. Never block UI thread >16ms.
- TS: `async/await` only. Wrap external calls in `AbortController` for timeouts.
- Python: `asyncio` for I/O. Use `aiohttp` or `httpx` over `requests`. Never use `time.sleep()` in async contexts.

## 5. PRD Lexicon Enforcement
- UI/UX copy must use KinnectAI-native terms: `The Line`, `Pulse`, `Kinnection`, `Branch`, `Memory Box`, `Root`, `Photoplay`, `Echoes`.
- Forbidden: `Feed`, `Like`, `Follow`, `Story`, `Group`, `Post`. CI gate: `lexicon-check.yml`.
- API response strings must match SRS §22.3 schemas exactly.

## 6. Compliance & Security Defaults
- All external inputs validated at boundary (`go-playground/validator`, `pydantic`, `zod`).
- No plaintext secrets. Use AWS SSM/Secrets Manager injected at runtime.
- Consent bitmask (`consent_flags`) checked before ANY business logic execution.
