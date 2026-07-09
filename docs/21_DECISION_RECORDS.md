# 21. Decision Records

Last updated: 2026-07-08

## ADR-001: Primary Market

Decision: Use U.S. S&P 500 sector ETF universe for Phase 1.

Reason: Clean sector-first structure, SPY benchmark, compact universe, strong validation path.

## ADR-002: Database

Decision: Use Postgres as canonical DB.

Reason: raw/derived/PIT/validation/AI/audit data requires relational consistency, JSON evidence, indexes, and durable history.

## ADR-003: Cloudflare Architecture

Decision: Use Cloudflare Workers/Pages/Hyperdrive/R2/Queues/Cron; D1 optional cache only.

Reason: Cloudflare fits edge serving and orchestration. Canonical analytical data belongs in Managed Postgres.

## ADR-004: Price Provider Profile

Decision: Use `prices.massive_us_stocks` provider profile for U.S. ETF OHLCV behind license gate, with fixture fallback for tests.

Reason: The API supports U.S. stock reference and aggregate bar data. Provider abstraction allows replacement.

## ADR-005: Official Supporting Data

Decision: SEC EDGAR and FRED/ALFRED are official supporting sources.

Reason: SEC filings/XBRL and macro/vintage data are core to future stock and macro layers.

## ADR-006: Broker API

Decision: Interactive Brokers Web API is the strategic future broker adapter target.

Reason: Broad market coverage and documented trading/account workflows make it suitable for Phase 7+.

## ADR-007: Regulation

Decision: MVP remains research-only. Advice/execution requires jurisdiction gate and legal review.

Reason: Personalized advice and auto execution are high-risk and jurisdiction-sensitive.

## ADR-008: Calibration

Decision: Probabilities/expected returns/target prices require walk-forward validation and calibration gates.

Reason: Uncalibrated probability-like output would undermine trust and increase regulatory/product risk.


## DR-006: Adopt Loop Engineering for Codex Development

Status: accepted

Decision:

The project adopts loop engineering as the default operating model for non-trivial Codex development tasks.

Rationale:

- The project has high contract density across metrics, rulebook, API, UI, data governance, validation, AI, and future execution gates.
- Step-by-step prompting is not reliable enough to preserve these contracts over time.
- Reusable loop specs make work bounded, verifiable, auditable, and easier to resume.

Consequences:

- New directory: `loops/`.
- New directory: `loop_memory/`.
- New configs: `config/loops.yaml`, `config/agent_roles.yaml`, `config/quality_gates.yaml`.
- New docs: `docs/22_LOOP_ENGINEERING.md`, `docs/23_LOOP_LIBRARY.md`, `docs/24_AGENTIC_RUNBOOK.md`.
- New optional migration: `database/migrations/0002_loop_engineering.sql`.
- Non-trivial PRs must use or define a loop spec and stop with a named terminal state.

Rejected alternative:

Continue using only AGENTS.md and ad-hoc prompts. This was rejected because it leaves verification, stopping rules, and memory implicit.
