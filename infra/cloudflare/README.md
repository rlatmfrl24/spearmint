# Cloudflare Infrastructure Notes

Cloudflare is used for edge serving and orchestration, not as the canonical analytical database.

## Required

- Cloudflare Pages for frontend
- Cloudflare Workers for API
- Hyperdrive binding to Managed Postgres
- R2 buckets for raw payloads and report artifacts
- Queues for ingestion/compute dispatch
- Cron Triggers for scheduled refresh

## Optional

- D1 for edge cache/config/status only

## Forbidden

- Full historical replay inside request-serving Worker
- Large backfill inside request-serving Worker
- Model training inside request-serving Worker
- Broker live order call without capability/risk/jurisdiction/audit gates

## Example

See `wrangler.example.toml`.
