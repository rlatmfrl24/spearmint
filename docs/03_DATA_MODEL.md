# 03. Data Model

Last updated: 2026-07-08
Status: Postgres canonical model accepted

## 1. Database Decision

Canonical database: **Postgres**.

Schemas:

```text
core
raw
derived
validation
ai
ops
execution
```

## 2. Point-in-Time Rule

All analysis and validation must respect:

```text
known_at <= asof_at
```

No model, metric, report, or AI judgment may use a fact that was not known at the analysis time.

## 3. Core Tables

### `core.instrument_master`

Tracks ETFs, benchmarks, indices, and future stocks.

Required fields:

```text
instrument_id
symbol
name
instrument_type
market
currency
exchange_code
timezone
active_from
active_to
metadata_json
created_at
updated_at
```

### `core.source_registry`

Database mirror of `config/source_registry.yaml`.

Required fields:

```text
source_id
label
source_class
cadence
stale_after_days
official
license_status
redistribution_allowed
warning
updated_at
```

## 4. Raw Tables

### `raw.series_daily`

Long-format OHLCV and macro series.

```text
instrument_id
trade_date
field
value
currency
source_id
source_class
observed_at
published_at
effective_at
fetched_at
known_at
asof_at
quality_status
license_status
metadata_json
primary key: instrument_id, trade_date, field, source_id
```

### `raw.raw_provider_payload`

Stores raw request/response objects in R2 and references them in Postgres.

```text
payload_id
source_id
request_hash
request_url_safe
r2_uri
content_hash
fetched_at
known_at
license_status
quality_status
metadata_json
```

## 5. Derived Tables

### `derived.sector_metrics_daily`

Stores module states and rulebook output.

```text
sector_code
as_of
rs_ratio
rs_momentum
rrg_quadrant
relative_strength_state
relative_strength_transition
breadth_state
breadth_transition
participation_state
participation_transition
direction
strength
conviction_label
lead_pattern
narrative
risks_json
invalidation_json
source_metrics_json
data_freshness_json
validation_status
license_status
created_at
primary key: sector_code, as_of
```

### `derived.dashboard_snapshot`

Optimized read path for Cloudflare Workers API.

```text
snapshot_id
as_of
benchmark
market_code
payload_json
data_freshness_json
license_status_json
validation_status
created_at
```

## 6. Validation Tables

```text
validation.replay_run
validation.forward_label
validation.pattern_diagnostic
validation.validation_summary
validation.calibration_run
```

Validation tables must store:

- label horizon,
- feature snapshot ID,
- `known_at` policy,
- sample size,
- reliability status,
- calibration metrics.

## 7. AI Tables

```text
ai.ai_decision_log
ai.ai_scenario_set
ai.ai_guardrail_result
```

AI logs must store:

- input fact hash,
- model/provider/version,
- prompt/template version,
- output JSON,
- guardrail result,
- allowed/blocked capabilities,
- audit ID.

## 8. Ops and Execution Tables

```text
ops.run_log
ops.data_quality_event
ops.audit_log
ops.capability_gate_log
execution.order_intent_log
execution.execution_audit_log
```

Order/execution tables can exist before trading is enabled, but no broker call is allowed until gates pass.

## 9. Migration

Initial SQL skeleton: `database/migrations/0001_initial.sql`.
