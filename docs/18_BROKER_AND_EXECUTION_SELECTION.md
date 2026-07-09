# 18. Broker and Execution Selection

Last updated: 2026-07-08
Decision status: **Strategic future selection; disabled in MVP**

## 1. Decision

The strategic future broker adapter target is **Interactive Brokers Web API**.

This does not enable trading in the MVP. It only defines the future adapter direction for Phase 7+.

## 2. Rationale

Interactive Brokers is preferred as the long-term adapter because:

- It supports broad market access compared with many U.S.-only APIs.
- Its Web API documentation covers trading, account management, market data, orders, portfolio/positions, live orders, executions, and advisor/third-party workflows.
- It provides a clearer path for institutional/third-party approval and compliance review than an informal broker integration.
- It is appropriate for a future system that may expand beyond U.S. ETFs.

## 3. Broker Gate

Broker functionality remains disabled until all conditions pass:

```text
AI Judgment
  -> Capability Gate
  -> Risk Gate
  -> Order Intent
  -> User Approval or Auto Policy
  -> Broker Adapter
  -> Execution Audit Log
```

No code may call the broker adapter directly from UI, Rulebook, or AI output.

## 4. Execution Modes

| Mode | Status | Purpose |
|---|---|---|
| research_only | Active | No orders; research only |
| paper_trading | Future | Test order generation and risk gates without live execution |
| user_approved_live_order | Future | User confirms each order |
| constrained_auto_trading | Future | Limited auto execution within pre-approved risk policies |
| adaptive_auto_operation | Future | Advanced autonomous operation, enterprise governance required |

## 5. MVP Implementation Rule

The MVP may create interfaces and database tables for `order_intent_log`, `execution_audit_log`, and `broker_adapter_config`, but must not enable broker credentials, live order routes, or order UI actions.

## 6. Required Risk Controls Before Any Order

- user identity and account authorization
- risk profile and suitability gate
- position limit
- sector concentration limit
- order size limit
- duplicate order prevention
- price band check
- trading-hours check
- kill switch
- audit log
- broker sandbox test
- jurisdiction policy gate

## 7. Config

See `config/broker_policy.yaml`.
