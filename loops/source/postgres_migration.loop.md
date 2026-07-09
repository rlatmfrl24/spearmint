# Loop: Postgres Migration Implementation

## id
`postgres_migration_implementation`

## trigger
Manual request to add or modify Postgres schema, view, index, or migration.

## class
`source_implementation`

## goal
Create a migration that preserves raw/derived/PIT separation, idempotency, auditability, and Cloudflare read-path constraints.

## scope
Allowed: `database/migrations/`, data model docs, tests/fixtures for schema.

Forbidden: destructive migration without rollback notes; using D1 as canonical analytical storage.

## inputs
- `docs/03_DATA_MODEL.md`
- `docs/16_CLOUDFLARE_POSTGRES_ARCHITECTURE.md`
- `config/database.postgres.yaml`

## steps
1. Read data model and storage policy.
2. Add schema/table/view/index with explicit ownership.
3. Add `created_at`, `updated_at`, `asof_at`, `known_at`, or audit fields where appropriate.
4. Add dry-run notes or schema tests.
5. Update data model docs and manifest.
6. Write loop memory.

## verification
- verification_level: `L1_deterministic` + `L2_rule_or_policy`
- required_checks:
  - SQL parses/dry-runs in Postgres-compatible environment when available
  - PIT and raw/derived boundaries preserved
  - no query path assumes heavy Worker compute

## stopping_rule
Success only when migration and docs align. Block if data ownership or PIT semantics are unclear.

## memory
Write `loop_memory/active/<date>_postgres_migration_implementation_<topic>.md`.
