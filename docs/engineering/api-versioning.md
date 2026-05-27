# KinnectAI API Versioning Standards
*URL versioning, deprecation lifecycle, OpenAPI 3.1 alignment, SRS §3.3.*

## 1. Versioning Strategy
- **Path Prefix:** `/v1/`, `/v2/` (Mandatory). No query params or headers for version routing.
- **Content Negotiation:** `Accept: application/vnd.kinnectai.v1+json`
- **Stability:** Minor versions (`/v1.1/`) forbidden. Breaking changes -> `/v2/`.

## 2. Deprecation Headers
```http
Deprecation: true
Sunset: Sat, 01 Nov 2026 00:00:00 GMT
Link: </v2/feed>; rel="successor-version"
```
- Sunset window: 180 days minimum.
- Analytics: Track `/v1/` usage per endpoint. Auto-notify at 30d, 7d, 1d.

## 3. OpenAPI Lifecycle
- Single source of truth: `packages/shared-contracts/openapi/openapi.yaml`
- CI gate: `openapi-diff` blocks PRs with breaking changes without version bump.
- Codegen: `openapi-generator` produces Go stubs, Dart clients, TS SDKs. Manual edits forbidden.

## 4. Backward Compatibility Rules
- Add optional request fields.
- Add new endpoints.
- Remove required fields.
- Change response structure without `x-version-since` tag.
- Client must handle unknown fields gracefully.
