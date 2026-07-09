# 16. Cloudflare + Postgres Architecture

Last updated: 2026-07-08
Decision status: **Accepted**

## 1. Decision

Use **Postgres as the canonical database** and use **Cloudflare as the edge/API/orchestration platform**.

```text
Cloudflare Pages / Workers
  -> Hyperdrive
  -> Managed Postgres

Cloudflare Workers / Cron / Queues
  -> ingestion/compute dispatch
  -> Postgres metadata
  -> R2 raw/artifact archive
```

D1 is not the canonical analytical DB. D1 may be used only for optional edge cache, feature flag mirror, status cache, or small read-only operational state.

## 2. Why Postgres

This project needs:

- long-format time series
- raw/derived separation
- point-in-time fields
- idempotent upserts
- JSON evidence and freshness payloads
- validation/replay history
- AI decision logs
- audit logs
- future portfolio and order intent logs

Postgres supports this better than a small edge SQLite-style database.

## 3. Why Cloudflare Still Fits

Cloudflare fits the serving and orchestration layer:

- Workers/Pages for global API and frontend.
- Hyperdrive for efficient Postgres access from Workers.
- R2 for raw provider payloads, validation artifacts, model artifacts, and generated reports.
- Queues for ingestion and compute dispatch with retries/dead-letter handling.
- Cron Triggers for scheduled refresh.

## 4. Role Separation

| Component | Role | Must not do |
|---|---|---|
| Workers API | Serve bounded dashboard/API reads | Full replay, large backfill, model training |
| Pages | Frontend | Metric calculation |
| Hyperdrive | Postgres connection acceleration/pooling | Act as database of record |
| Managed Postgres | Canonical raw/derived/validation/ops data | Store large raw files better suited to R2 |
| R2 | Raw payloads and artifacts | Serve as query engine |
| Queues | Dispatch and retry work | Hide failed jobs without run logs |
| Cron Triggers | Scheduled refresh kickoff | Long-running compute |
| D1 | Optional cache/config/status | Canonical analytical storage |

## 5. Recommended Postgres Providers

Development speed:

- Neon
- Supabase

Production maturity:

- AWS RDS PostgreSQL
- Aurora PostgreSQL
- Google Cloud SQL PostgreSQL

Time-series expansion:

- Timescale Cloud or Timescale extension on Postgres, only when scale requires it.

## 6. API Read Path

Workers should read from:

- `derived.dashboard_snapshot`
- `derived.sector_metrics_daily`
- bounded `validation.validation_summary`
- compact `ops.data_quality_event`

Workers should not compute full metric history in request path.

## 7. Compute Path

```text
Scheduled trigger
  -> queue message
  -> provider adapter
  -> R2 raw payload archive
  -> raw schema upsert
  -> metric engine
  -> derived schema upsert
  -> rulebook
  -> dashboard snapshot
  -> ops run_log
```

Large backfills and validation sweeps should run in external batch compute or a dedicated worker runtime, then write results to Postgres/R2.

## 8. Failure Policy

- If Postgres is unavailable, Workers may serve the last cached snapshot with `stale` warning.
- If source ingestion fails, keep prior derived outputs but lower freshness status.
- If license status is unknown or blocked, hide affected source-derived claims.
- If R2 archive write fails, mark run as incomplete even if Postgres upsert succeeded.

## 9. Implementation Artifacts

- `config/deployment.cloudflare.yaml`
- `config/database.postgres.yaml`
- `infra/cloudflare/wrangler.example.toml`
- `database/migrations/0001_initial.sql`
