# 11. Risk Governance

Last updated: 2026-07-08

## 1. Purpose

Risk governance makes future advice, order intents, and automated trading possible without allowing uncontrolled AI execution.

## 2. MVP Risk Governance

MVP risk controls are research-level:

- data freshness warnings,
- license warnings,
- validation readiness,
- rulebook vetoes,
- report copy guardrails,
- AI guardrails,
- audit logs for AI and reports.

## 3. Future Execution Risk Controls

Before any order intent:

- user identity and account authorization,
- risk profile and suitability gate,
- jurisdiction gate,
- source freshness gate,
- validation/calibration gate,
- max order notional,
- max portfolio allocation,
- sector concentration limit,
- price band check,
- trading-hours check,
- duplicate order prevention,
- kill switch,
- user approval unless constrained auto policy is active,
- broker sandbox result,
- execution audit log.

## 4. Kill Switch

Kill switch states:

```text
manual_halt
source_halt
risk_halt
broker_halt
jurisdiction_halt
calibration_halt
```

Any halt blocks Level 6+ capabilities.

## 5. Risk Output Contract

```json
{
  "risk_status": "blocked",
  "reason_codes": ["sector_concentration_limit", "broker_disabled"],
  "max_allowed_actionability": "research_only",
  "kill_switch": "manual_halt"
}
```

## 6. Execution Never Bypasses Risk

Execution path:

```text
AI Judgment
  -> Capability Gate
  -> Risk Gate
  -> Order Intent
  -> User Approval or Auto Policy
  -> Broker Adapter
  -> Execution Audit Log
```
