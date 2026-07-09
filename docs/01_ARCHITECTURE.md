# 01. Architecture

Last updated: 2026-07-08
Status: Updated for Source Complete v2

## 1. System Overview

AI Market Decision OS is built as a layered system:

```text
Layer 0  Data & Governance
Layer 1  Market Flow
Layer 2  Sector Capacity & Context
Layer 3  Sector Leadership & Transition
Layer 4  Validation & Reliability
Layer 5  AI Judgment & Scenario
Layer 6  Stock Candidate & Valuation
Layer 7  Portfolio & Personalized Advice
Layer 8  Execution & Auto Trading
Layer 9  Operations, Audit & Risk Control
```

The active MVP implements Layer 0~4 for the U.S. S&P 500 sector ETF universe and exposes selected Layer 5 AI scenarios only as research commentary.

## 2. Fixed Deployment Architecture

```text
Cloudflare Pages / Workers
  -> Hyperdrive
  -> Managed Postgres

Cloudflare R2
  -> raw provider payloads
  -> generated reports
  -> validation artifacts
  -> model artifacts

Cloudflare Queues / Cron Triggers
  -> ingestion dispatch
  -> compute dispatch
  -> retry/dead-letter handling
```

D1 is not canonical. It may be used only for optional edge cache/config/status.

## 3. Data Flow

```text
External Provider
  -> Provider Adapter
  -> License Gate
  -> R2 Raw Payload Archive
  -> Raw Store: raw.series_daily / raw.raw_provider_payload
  -> Metric Engine
  -> Derived Store: derived.sector_metrics_daily
  -> Sector Rulebook
  -> Dashboard Snapshot
  -> Workers API
  -> React View Model
  -> Layer UI
```

## 4. Compute Boundaries

Workers may:

- read compact snapshots,
- serve bounded history,
- enqueue refresh jobs,
- write small run status records,
- serve UI/API.

Workers must not:

- run full historical replay,
- run large backfills,
- train models,
- compute large feature rebuilds,
- place broker orders without gates.

## 5. Source Boundaries

Metrics consume normalized data from Postgres. Metrics do not call providers.

Provider adapters handle:

- API access,
- rate limiting,
- raw payload archive,
- normalization,
- source/license metadata,
- `known_at` and `asof_at`.

## 6. Dependency Rule

```text
UI -> API contract -> application -> domain
infrastructure -> application/domain
metrics -> domain/config only
rules -> domain module states only
ai -> facts/rulebook/validation/capability gates only
execution -> risk governance + user approval + audit only
domain -> no UI, no DB, no provider
```

## 7. Source Layout

```text
config/
  universe.yaml
  thresholds.example.yaml
  source_registry.yaml
  provider_policy.yaml
  features.yaml
  deployment.cloudflare.yaml
  database.postgres.yaml
  broker_policy.yaml
  regulatory_scope.yaml
  calibration.yaml

docs/
  01_ARCHITECTURE.md
  02_LAYER_MODEL.md
  03_DATA_MODEL.md
  ...
  21_DECISION_RECORDS.md

infra/cloudflare/
  wrangler.example.toml
  README.md

database/migrations/
  0001_initial.sql

src/
  domain/
  application/
  data/
  infrastructure/
  metrics/
  rules/
  validation/
  ai/
  reporting/
  risk/
  execution/

frontend/
  src/

tests/
  unit/
  fixtures/
  contract/
  integration/
```

## 8. Critical Gates

- Source license gate before public display.
- Data freshness gate before rulebook conviction.
- Validation gate before probability/expected return output.
- Jurisdiction gate before personal advice or execution.
- Risk gate before order intent.
- Audit gate before broker adapter call.
