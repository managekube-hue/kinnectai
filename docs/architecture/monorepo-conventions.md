# Monorepo Conventions

This document is the structure contract for KinnectAI. The goal is a codebase that is readable, predictable, and safe to scale with new engineers.

## Directory Contract

- apps/mobile: Flutter app only.
- apps/web: Next.js app only.
- services/gateway: API/auth boundary service.
- services/go: Go services.
- services/python: Python services.
- packages: shared contracts, SDKs, and reusable libraries.
- infra: infrastructure code by platform/domain.
- migrations: database/schema migrations grouped by datastore.
- docs: architecture, product, compliance, API, runbooks, ADRs, diagrams.
- scripts: grouped by lifecycle (bootstrap, dev, ci, release, data).
- tests: integration, e2e, load, contracts.

## Service Placement Rules

- No service directory is allowed directly under services except gateway, go, and python.
- All Go services must live in services/go/<service-name>.
- All Python services must live in services/python/<service-name>.
- Each service folder must contain real code files:
  - Go services require at least one .go file.
  - Python services require at least one .py file.

## Web App Rules

- apps/web must use Next.js App Router.
- Required files:
  - apps/web/next.config.mjs
  - apps/web/app/layout.tsx
  - apps/web/app/page.tsx
- Route hardening requires segment boundaries where applicable:
  - loading.tsx
  - error.tsx
  - not-found.tsx (for dynamic routes where useful)

## Stub Prevention Policy

A folder is considered a stub if it has only docs/config and no executable code for its language.

- Stubs are allowed only during an explicit bootstrap phase and must include an owner + completion date in README.
- Production branches should not merge new long-lived stubs.
- CI should fail on placeholder services without code.

## Definition Of Done (Structure)

- Path matches the contract above.
- Imports, scripts, and workflows reference current paths.
- CI structure verification passes.
- No orphaned or legacy duplicate paths remain.

## Enforcement

Run:

```powershell
./scripts/ci/verify-monorepo-structure.ps1
```

This check is designed to fail fast when folder drift or placeholder sprawl appears.
