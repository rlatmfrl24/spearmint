# Skill: Implement Cloudflare API

Use this when implementing Workers/Pages API endpoints.

1. Read `docs/16_CLOUDFLARE_POSTGRES_ARCHITECTURE.md` and `docs/06_API_CONTRACT.md`.
2. Use Hyperdrive for Postgres access.
3. Read snapshot/materialized/bounded tables only in request path.
4. Do not run full replay, backfill, or model training in a request Worker.
5. Return source freshness, license status, and validation status.
6. Add contract tests.
7. Keep UI free of metric calculations.
