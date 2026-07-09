# 06. API Contract

Last updated: 2026-07-08
Status: Updated for U.S. sector ETF market, Postgres/Cloudflare, and license gates

## 1. API Principles

- UI must not calculate financial metrics.
- API must return display-ready structured evidence.
- All user-facing judgments must include freshness, license status, and validation status.
- Gated capabilities must be represented explicitly as allowed/blocked.
- Unknown, stale, license-blocked, or jurisdiction-blocked data must be encoded explicitly.
- Workers API should read `derived.dashboard_snapshot` or bounded/materialized views, not perform heavy analytics.

## 2. MVP Endpoints

```text
GET /api/sectors
GET /api/history
GET /api/validation
GET /api/validation/status
GET /api/data/status
GET /api/source/status
POST /api/refresh
```

`POST /api/refresh` may be disabled in public deployment and replaced by scheduled workers and queues.

## 3. `GET /api/sectors`

Purpose: primary dashboard snapshot.

Response shape:

```json
{
  "as_of": "2026-07-08",
  "market": {
    "code": "US_SP500_SECTOR_ETF",
    "timezone": "America/New_York",
    "currency": "USD"
  },
  "benchmark": "SPY",
  "data_mode": "fixture|provider|mixed",
  "persistence": {
    "canonical_db": "postgres",
    "edge": "cloudflare_workers",
    "read_path": "derived.dashboard_snapshot"
  },
  "validation": {
    "historical_ready": false,
    "status": "not_ready",
    "allowed_ai_level": 2
  },
  "layer1_flow": {
    "market_regime": "mixed",
    "current_rs_leader": "XLK",
    "momentum_leader": "XLF",
    "narrative": "...",
    "risks": [],
    "invalidation": []
  },
  "sectors": [
    {
      "sector_id": "XLK",
      "name": "Technology",
      "metrics": {
        "relative_strength": {},
        "breadth": {"source_scope": "proxy_or_holdings_if_licensed"},
        "participation": {}
      },
      "rulebook": {
        "direction": "up",
        "strength": 2,
        "conviction_label": "rule_aligned",
        "lead_pattern": "Late Leader",
        "narrative": "...",
        "risks": [],
        "invalidation": [],
        "source_metrics": {},
        "data_freshness": {},
        "validation_status": "not_validated"
      }
    }
  ],
  "source_freshness": {},
  "license_status": {
    "public_display_allowed": false,
    "blocked_sources": []
  },
  "data_quality": {},
  "capability_gates": {
    "allowed_capabilities": ["research_brief", "ai_scenario"],
    "blocked_capabilities": ["stock_recommendation", "order_intent", "auto_trading"]
  }
}
```

## 4. `GET /api/history`

Purpose: bounded RRG path, sector history, replay coverage.

Required query params:

```text
sector_id
lookback
as_of optional
```

Response must include:

```text
path[]
coverage
warnings
license_status
```

## 5. `GET /api/validation`

Purpose: Layer 4 diagnostics.

Response:

```json
{
  "as_of": "2026-07-08",
  "historical_ready": false,
  "calibration_status": "not_ready",
  "patterns": [
    {
      "lead_pattern": "Emerging Leader",
      "sample_size": 0,
      "evaluated_forward_labels": [],
      "sample_observed_probability": null,
      "sample_reliability": "not_ready",
      "thin_sample": true,
      "readiness_caveat": "Insufficient historical replay."
    }
  ],
  "blocked_outputs": ["probability", "expected_return", "target_price"]
}
```

## 6. `GET /api/data/status`

Purpose: source freshness, provider status, run status.

```json
{
  "as_of": "2026-07-08",
  "sources": [
    {
      "source_id": "prices.massive_us_stocks",
      "label": "Massive/Polygon U.S. Stocks API",
      "source_class": "vendor",
      "latest_date": "2026-07-08",
      "frequency": "daily_or_intraday_by_plan",
      "status": "stale|ok|failed|license_blocked",
      "license_status": "license_required",
      "public_display_allowed": false,
      "warning": "Verify commercial plan before production."
    }
  ],
  "runs": []
}
```

## 7. `GET /api/source/status`

Purpose: compact license/source gate status.

```json
{
  "public_dashboard_allowed": false,
  "blocked_reasons": ["price_provider_redistribution_not_recorded"],
  "sources": []
}
```

## 8. Future Endpoints Behind Gates

```text
GET /api/ai/scenarios
GET /api/stocks/candidates
GET /api/portfolio/advice
POST /api/orders/intents
POST /api/execution/approve
POST /api/execution/kill-switch
```

These endpoints must return `403 capability_not_enabled` if feature flag, capability gate, license gate, jurisdiction gate, risk gate, or audit gate is not satisfied.

## 9. Error Format

```json
{
  "error": {
    "code": "capability_not_enabled",
    "message": "Layer 8 order intents are disabled by feature flag.",
    "details": {
      "reason_codes": ["feature_disabled", "jurisdiction_blocked"]
    }
  }
}
```

## 10. Contract Tests

- Schema snapshot for every endpoint.
- Missing data case.
- License-blocked case.
- Capability disabled case.
- Validation not ready case.
- Current RS leader and momentum leader separation case.
- Cloudflare snapshot read path case.
