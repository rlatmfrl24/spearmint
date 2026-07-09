# Loop: Cloudflare API Implementation

## id
`cloudflare_api_implementation`

## trigger
Manual request to add Workers, Pages Functions, Hyperdrive usage, Queues, Cron, R2, or deployment config.

## class
`source_implementation`

## goal
Implement bounded Cloudflare edge/API behavior that uses Hyperdrive for Postgres read paths, R2 for objects/artifacts, and Queues/Cron for orchestration.

## scope
Allowed: `infra/cloudflare/`, API handlers, config, docs.

Forbidden: full replay, full backfill, model training, or long analytical jobs inside Workers.

## inputs
- `docs/16_CLOUDFLARE_POSTGRES_ARCHITECTURE.md`
- `config/deployment.cloudflare.yaml`
- `config/database.postgres.yaml`

## steps
1. Read Cloudflare/Postgres architecture.
2. Determine whether task belongs in Worker, Queue, external batch, R2, or Postgres.
3. Implement minimal bounded edge behavior.
4. Add contract tests or smoke-check notes.
5. Update infra docs and loop memory.

## verification
- verification_level: `L1_deterministic` + `L2_rule_or_policy`
- required_checks:
  - no heavy compute in Workers
  - secrets are not committed
  - Hyperdrive/R2 bindings are documented examples only

## stopping_rule
Success only when deployment config and docs are aligned. Block if provider credentials or account-specific IDs are required.

## memory
Write `loop_memory/active/<date>_cloudflare_api_implementation_<topic>.md`.
