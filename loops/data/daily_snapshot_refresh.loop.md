# Loop: Daily Snapshot Refresh

## id
`daily_snapshot_refresh`

## trigger
Scheduled or manual refresh after market close or after bounded provider update.

## class
`data_pipeline`

## goal
Refresh the dashboard snapshot for the configured U.S. sector ETF universe while preserving freshness, audit logs, and bounded compute.

## scope
Allowed: ingestion dispatch, snapshot builder, run logs, dashboard snapshot tables/views.

Forbidden: unbounded replay, direct external provider calls from public unauthenticated endpoints, ignoring stale source warnings.

## inputs
- `config/universe.yaml`
- `config/source_registry.yaml`
- `docs/16_CLOUDFLARE_POSTGRES_ARCHITECTURE.md`

## steps
1. Check source freshness requirements.
2. Fetch or load approved provider payloads through adapters.
3. Upsert raw series.
4. Compute derived metrics for bounded as-of date.
5. Build dashboard snapshot.
6. Write run log and loop memory.

## verification
- verification_level: `L2_rule_or_policy` + optional `L3_delayed_field_truth`
- required_checks:
  - run log written
  - freshness status present
  - snapshot has benchmark and all configured sectors

## stopping_rule
Success only when snapshot is complete or explicitly partial with warnings. Block if provider/license/credential is unavailable.

## memory
Write `loop_memory/active/<date>_daily_snapshot_refresh.md`.
