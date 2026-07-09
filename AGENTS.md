# AGENTS.md

This file defines how Codex and other agentic coding tools must work in this repository.

## 1. Mission

Build a local-first, testable, explainable **AI Market Decision OS**.

The initial MVP is a U.S. S&P 500 sector ETF research dashboard that detects sector leadership, leadership transitions, false leadership, and sector-level risk signals. The long-term roadmap includes AI judgment, stock candidates, personalized portfolio advice, broker-connected order intents, and constrained automated trading, but those future capabilities must remain gated until validation, risk governance, audit logging, jurisdiction review, broker approval, and user suitability checks exist.

## 2. Read Before Coding

Before implementing any source change, read the relevant docs:

1. `PROJECT_CHARTER.md`
2. `docs/15_MARKET_SCOPE_DECISION.md`
3. `docs/16_CLOUDFLARE_POSTGRES_ARCHITECTURE.md`
4. `docs/17_PROVIDER_AND_LICENSE_STRATEGY.md`
5. `docs/01_ARCHITECTURE.md`
6. `docs/02_LAYER_MODEL.md`
7. `docs/22_LOOP_ENGINEERING.md` for any non-trivial task
8. `docs/23_LOOP_LIBRARY.md` to select the right reusable loop
9. `docs/24_AGENTIC_RUNBOOK.md` for loop memory and handoff rules
10. The domain-specific document for the task
11. The relevant `skills/*.md` playbook

## 3. Fixed Technical Decisions

- Primary market is `US_SP500_SECTOR_ETF`.
- Benchmark is `SPY`.
- Sector universe is `XLC`, `XLY`, `XLP`, `XLE`, `XLF`, `XLV`, `XLI`, `XLB`, `XLRE`, `XLK`, `XLU`.
- Canonical DB is Postgres.
- Cloudflare Workers/Pages are API/UI edge, not heavy analytical compute.
- Cloudflare Hyperdrive connects Workers to Managed Postgres.
- R2 stores raw provider payloads, reports, validation artifacts, and model artifacts.
- Queues/Cron orchestrate ingestion and background dispatch.
- D1 is optional cache/config/status only, not the canonical analytical database.
- Interactive Brokers Web API is the strategic future broker adapter target, but broker execution is disabled until Phase 7+ gates pass.

## 4. Active Scope vs Deferred Strategic Scope

Active MVP scope:

- U.S. sector ETF universe and SPY benchmark
- Relative strength, RS ratio, RS momentum, RRG quadrant
- Breadth proxy and participation metrics
- Manual catalyst ledger
- Market context and source freshness
- Source/license registry
- Postgres raw/derived/validation/ops schema
- Sector rulebook
- Layer 1~4 dashboard
- Validation skeleton
- Research brief skeleton

Deferred strategic scope:

- Buy/sell advice
- Target prices
- Expected returns
- Validated probabilities
- Stock recommendations
- Personalized portfolio advice
- Broker order routing
- Automated trading
- News AI autonomous catalyst decisions

Deferred does **not** mean forbidden forever. It means gated, validated, logged, jurisdiction-reviewed, and disabled by default.

## 5. Non-negotiable Development Rules

- Do not collapse relative strength, momentum, breadth, participation, catalyst, and market context into one average score.
- Preserve module disagreement as a signal.
- Keep `state` and `transition` separate.
- Keep raw data and derived data separate.
- Use long-format time series for raw market data.
- Make ingestion and calculation idempotent.
- Preserve point-in-time correctness: `known_at <= asof_at`.
- Keep thresholds in config, never hard-code them inside metric logic.
- UI must depend on API/JSON contracts only.
- React components must not calculate financial metrics.
- Unit tests must not call the network.
- Provider adapters must respect `config/provider_policy.yaml` and `config/source_registry.yaml`.
- Every sector output must include `direction`, `strength`, `conviction_label`, `lead_pattern`, `narrative`, `risks`, `invalidation`, `source_metrics`, `data_freshness`, and `validation_status`.
- Layer 5+ capabilities must be controlled by `config/features.yaml` and `docs/10_CAPABILITY_GATES.md`.
- AI may generate active judgments only within the allowed capability level.
- Execution-related code must not bypass risk gates, audit logs, user approval gates, broker sandbox checks, or jurisdiction gates.
- Non-trivial tasks must be run through a loop spec from `loops/` or a new loop created from `loops/templates/loop_spec_template.md`.
- Every loop must declare trigger, goal, verification, stopping rule, memory, and terminal state.
- Failed verification, exhausted budget, or stalled progress must not be reported as success.

## 6. Architecture Rules

Dependency direction:

```text
UI -> API contract -> application -> domain
infrastructure -> application/domain
metrics -> domain/config only
rules -> domain module states only
ai -> facts/rulebook/validation/capability gates only
execution -> risk governance + user approval + audit only
domain -> no UI, no DB, no provider
```

Cloudflare rule:

```text
Workers API -> Hyperdrive -> Postgres read-optimized snapshot/materialized view
Workers Cron -> Queue message -> external/batch compute or bounded refresh task
R2 -> raw payload and artifact archive
D1 -> optional cache/config/status only
```

Recommended source layout:

```text
config/
docs/
skills/
infra/cloudflare/
database/migrations/
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
tests/
```

## 7. Output Contracts

Metric module output:

```json
{
  "state": "strong",
  "transition": "strengthening",
  "direction": "up",
  "strength": 3,
  "evidence": {},
  "warnings": []
}
```

Rulebook output:

```json
{
  "direction": "up",
  "strength": 3,
  "conviction_label": "rule_aligned",
  "lead_pattern": "Emerging Leader",
  "narrative": "...",
  "risks": [],
  "invalidation": [],
  "source_metrics": {},
  "data_freshness": {},
  "validation_status": "not_validated"
}
```

AI judgment output must additionally include:

```json
{
  "ai_judgment": {
    "stance": "rotation_watch",
    "confidence": "medium",
    "base_case": "...",
    "bull_case": "...",
    "bear_case": "...",
    "dissenting_view": "..."
  },
  "actionability_level": "research_only",
  "allowed_capabilities": [],
  "blocked_capabilities": [],
  "audit_id": "..."
}
```

## 8. PR Review Checklist

Every PR must answer:

- Did this PR preserve module disagreement?
- Are state and transition separated?
- Are raw and derived data separated?
- Are point-in-time fields preserved?
- Are thresholds in config?
- Are provider and license gates respected?
- Are risks and invalidation included in outputs?
- Is data freshness visible in the relevant API/UI layer?
- Are probability-like, buy/sell, target price, expected return, or order-related outputs gated?
- Are unit tests network-free?
- Did the PR update docs when contracts changed?
- Did the PR include fixture or synthetic tests for edge cases?
- Does any Cloudflare Worker query avoid heavy analytical work and use snapshot/materialized read paths?

## 9. Feature Flag Defaults

Layer 5+ features must be disabled unless explicitly enabled by config and gates.

```yaml
features:
  layer5_ai_scenarios: true
  layer6_stock_candidates: false
  layer7_personalized_advice: false
  layer8_order_intents: false
  layer8_auto_trading: false
```

## 10. Safe Defaults

When uncertain, return `unknown`, `insufficient_data`, `license_blocked`, `jurisdiction_blocked`, or `not_ready`. Do not fabricate metrics, probabilities, target prices, or order recommendations.

## 11. Agentic Coding Prompt Template

When starting a task, use this internal checklist:

```text
I am modifying [module].
I will read [docs].
I will preserve the output contract.
I will add or update tests.
I will not expose gated features unless capability gates allow it.
I will update docs if API, metrics, thresholds, provider, DB, or rulebook behavior changes.
```


## 12. Loop Engineering Rules

Codex must use loop engineering for non-trivial changes.

Default cycle:

```text
Select Loop
  -> Read Scope Docs
  -> Create/Update Loop Memory
  -> Plan Minimal Change
  -> Implement
  -> Verify
  -> Critic Review if needed
  -> Repair
  -> Sync Docs
  -> Stop with Named Terminal State
```

Required loop fields:

```text
trigger
goal
scope
inputs
steps
verification
stopping_rule
terminal_states
memory
safety_constraints
handoff_summary
```

Allowed terminal states:

```text
success | no_op | blocked | stalled | exhausted | escalated
```

Verification ladder:

```text
L1 deterministic checks
L2 rule or policy checks
L3 delayed field truth / CI / replay / calibration
L4 separate model judge
L5 human checkpoint
```

The maker agent must not be the only verifier for model-judged output. Execution/trading loops require risk, capability, jurisdiction, broker, audit, and human gates before any user-facing or live behavior.

Before final handoff, use `loops/release/pr_self_review.loop.md` or explain why the task was simple enough not to require a loop.
