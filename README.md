# AI Market Decision OS Source Docs — Loop Engineering v3

This repository foundation turns the Sector Radar concept into a commit-ready source documentation package for Codex-driven implementation.

**v3 adds loop engineering**: Codex work is organized around bounded, reusable loop specifications with triggers, goals, verification, stopping rules, memory, and named terminal states.

## Fixed v3 Decisions

- **Primary market:** U.S. S&P 500 sector ETF universe
- **Benchmark:** SPY
- **Sector ETFs:** XLC, XLY, XLP, XLE, XLF, XLV, XLI, XLB, XLRE, XLK, XLU
- **Canonical DB:** Postgres
- **Cloudflare operations:** Pages/Workers + Hyperdrive + R2 + Queues + Cron Triggers
- **D1:** optional edge cache/config/status only
- **Primary price provider profile:** `massive_us_stocks` through a provider adapter and license gate
- **Official supporting data:** SEC EDGAR and FRED/ALFRED
- **Strategic future broker adapter:** Interactive Brokers Web API
- **Regulatory model:** research-only MVP; advice/execution/auto-trading require jurisdiction and capability gates
- **Calibration model:** walk-forward, relative labels, reliability metrics, and exposure gate before probabilities or expected returns
- **Development operating model:** loop engineering with reusable loop specs, verification ladder, loop memory, and terminal states

## Start Here

1. `PROJECT_SOURCE_MANIFEST.md`
2. `PROJECT_CHARTER.md`
3. `AGENTS.md`
4. `docs/15_MARKET_SCOPE_DECISION.md`
5. `docs/16_CLOUDFLARE_POSTGRES_ARCHITECTURE.md`
6. `docs/17_PROVIDER_AND_LICENSE_STRATEGY.md`
7. `docs/20_FORECAST_CALIBRATION.md`
8. `docs/22_LOOP_ENGINEERING.md`
9. `docs/23_LOOP_LIBRARY.md`
10. `docs/24_AGENTIC_RUNBOOK.md`

## MVP

The MVP is a sector-first research dashboard for U.S. S&P 500 sector ETFs. It detects sector leadership, leadership transitions, false leadership, and sector-level risk signals.

The long-term vision is an AI-driven investment decision OS with gated expansion into stock candidates, personalized advice, order intents, broker connection, and constrained automated trading.

All future investment-action features are disabled by default and must pass validation, capability gates, risk governance, audit logging, jurisdiction review, broker approval, and user suitability checks before becoming user-facing.

## Repository Shape

```text
config/       Decision-backed runtime configuration examples
docs/         Product, architecture, data, API, validation, AI, risk, regulation, calibration specs
skills/       Agentic coding playbooks for Codex
loops/        Reusable loop specifications for Codex
loop_memory/  Concise operational memory for loop runs
infra/        Cloudflare deployment guidance and examples
database/     Postgres migration skeletons
src/          Implementation target, not generated here
frontend/     Implementation target, not generated here
tests/        Implementation target, not generated here
```


## Loop Engineering Quickstart

For any non-trivial Codex task:

1. Select a loop from `loops/`.
2. Read `docs/22_LOOP_ENGINEERING.md` and the relevant domain docs.
3. Create a loop memory record in `loop_memory/active/`.
4. Implement within the loop scope.
5. Verify with the declared verification level.
6. Stop with one terminal state: `success`, `no_op`, `blocked`, `stalled`, `exhausted`, or `escalated`.
7. Update docs, config, tests, and manifest when contracts change.

Recommended first loop for implementation work: `loops/release/pr_self_review.loop.md` after each bounded PR.
