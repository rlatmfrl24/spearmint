# 10. Capability Gates

Last updated: 2026-07-08
Status: Updated for market, provider, DB, broker, regulation, and calibration decisions

## 1. Purpose

Capability gates decide what the system is allowed to expose or execute. They convert feature flags, data quality, license status, validation, calibration, risk state, jurisdiction policy, user profile status, and audit readiness into explicit allow/block decisions.

## 2. AI Capability Levels

| Level | Name | Allowed |
|---|---|---|
| 0 | Description Only | Explain already computed metrics |
| 1 | Structured Interpretation | Interpret rulebook, risks, invalidation |
| 2 | Scenario Judgment | AI base/bull/bear/rotation scenarios |
| 3 | Validated Forecast | Calibrated/validated probability or expected range |
| 4 | Stock Candidate | Candidate generation and ranking |
| 5 | Personalized Advice | User-specific buy/sell/hold/rebalance advice |
| 6 | Order Intent | Broker-ready order proposal requiring approval |
| 7 | Constrained Auto Trading | Limited automated execution within risk limits |
| 8 | Adaptive Auto Operation | Advanced automated portfolio operation |

## 3. Gate Inputs

```json
{
  "feature_flags": {},
  "market_scope": "US_SP500_SECTOR_ETF",
  "data_status": {},
  "license_status": {},
  "validation_stage": "V1",
  "calibration_status": "not_ready",
  "sample_reliability": "not_ready",
  "risk_status": "ok",
  "jurisdiction_status": "research_only",
  "user_suitability_status": "not_applicable",
  "broker_status": "disabled",
  "audit_ready": true,
  "kill_switch": "enabled"
}
```

## 4. Gate Output

```json
{
  "requested_capability": "order_intent",
  "allowed": false,
  "allowed_ai_level": 2,
  "reason_codes": [
    "feature_disabled",
    "validation_not_ready",
    "calibration_not_ready",
    "jurisdiction_blocked",
    "broker_disabled"
  ],
  "blocked_capabilities": [
    "expected_return",
    "personalized_advice",
    "order_intent",
    "auto_trading"
  ]
}
```

## 5. Minimum Conditions by Capability

### Level 2: Scenario Judgment

- Feature flag enabled.
- Data freshness not failed.
- Source license status allows internal research.
- Rulebook output exists.
- Guardrail AI available.
- AI audit logging available.

### Level 3: Validated Forecast

- Validation stage V3+.
- Calibration documented in `docs/20_FORECAST_CALIBRATION.md`.
- Minimum sample gates pass.
- Reliability curve and ECE pass.
- Forecast wording guardrail enabled.
- No target price unless valuation model is documented.

### Level 4: Stock Candidate

- Security-level data model exists.
- Symbol mapping quality OK.
- Candidate ranking validation exists.
- License gate allows security-level data use.
- Recommendation copy guardrail enabled.

### Level 5: Personalized Advice

- User suitability profile exists.
- Portfolio snapshot is fresh.
- Risk profile is valid.
- Jurisdiction gate passes.
- Advice audit log enabled.
- Required disclosures exist.

### Level 6: Order Intent

- User approval required.
- Broker adapter sandbox tested.
- Broker/compliance path documented.
- Risk checks pass.
- Duplicate order prevention exists.
- Kill switch active.
- Execution audit log enabled.

### Level 7: Constrained Auto Trading

- Paper/shadow trading validation complete.
- Legal/regulatory memo complete for target jurisdiction.
- Live risk limits configured.
- Daily loss and position limits configured.
- Manual override available.
- Automated execution explicitly enabled.

## 6. Forbidden Bypass

No code path may call execution adapter directly from AI output. The required path is:

```text
AI Judgment
  -> Capability Gate
  -> Risk Gate
  -> Order Intent
  -> User Approval or Auto Policy
  -> Broker Adapter
  -> Audit Log
```
