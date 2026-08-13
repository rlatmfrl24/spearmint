# AGENTS.md

## Mission

Build Spearmint Quant Evolution as a replayable, fail-safe, low-frequency Korean-market quant platform. Optimize for correctness, auditability, deterministic replay, and safe paper trading before feature count or latency micro-optimization.

User-facing explanations and handoffs are written in Korean. Code identifiers, schemas, commits, and concise technical comments use English.

## Read first

Before changing code, read:

1. `README.md`
2. `docs/00_PROJECT_SPEC.md`
3. `docs/01_ARCHITECTURE.md`
4. `docs/07_IMPLEMENTATION_ROADMAP.md`
5. The document specific to the subsystem being changed

For work longer than one focused change, create or update an execution plan under `plans/active/` using `PLANS.md`.

## Non-negotiable safety invariants

- Default environment is `dev` or `paper`. `live_enabled` remains false unless the owner explicitly approves live activation in the current task.
- Never submit a real broker order during tests, previews, migrations, or debugging.
- Strategy and AI components emit `OrderIntent`; only the independent risk/control plane may authorize broker submission.
- AI output may only reduce exposure with a multiplier in `[0, 1]`. It cannot create orders, increase risk, bypass limits, change a champion, or edit its own policy.
- Long/cash only. Reject leverage, short exposure, and orders that increase a losing position (no averaging down).
- Never claim end-to-end exactly-once across an external broker. Use at-least-once processing plus idempotency, outbox/inbox, a single fenced executor, and broker reconciliation.
- A broker timeout produces `UNKNOWN/RECONCILING`, not blind resubmission.
- Preserve `event_time`, `provider_time`, `ingested_at`, and `available_at`. Never replace point-in-time logic with the latest corrected value.
- Challengers have no live order credentials or order-topic permission. Promotion always requires recorded evidence and human approval.
- Never commit secrets, account numbers, tokens, personal identifiers, or production data samples.
- Preserve unrelated user changes. Do not use destructive Git or filesystem operations without explicit instruction.

## Engineering rules

- Start with the smallest end-to-end vertical slice; do not scaffold every future microservice at once.
- Keep domain logic pure where possible. Broker, clock, storage, network, and LLM are ports/adapters.
- All external calls have deadlines, bounded retries with jitter, rate-limit handling, and observable errors.
- Every side effect uses a stable idempotency key and correlation ID.
- Every schema change has compatibility analysis, migration, rollback notes, and contract tests.
- Use UTC internally; store exchange timezone metadata and render Asia/Seoul at the UI boundary.
- Use decimal/fixed-point types for money and quantities. Never use binary float for ledger balances or order notional.
- Persist immutable audit records for signals, risk decisions, order intents, orders, fills, promotions, and kill-switch changes.
- Add dependencies only when the current milestone needs them. Record architecture-impacting changes as ADRs.
- Do not optimize with Rust/Go, Flink, ClickHouse, Feast, Temporal, or Kubernetes until the documented adoption trigger is measured.

## Repository discovery rule

The current repository implementation is not verified by this handoff package. The first task is M00 in `docs/07_IMPLEMENTATION_ROADMAP.md`.

- Inspect existing code, configuration, tests, deployment, and current broker integrations before restructuring.
- Treat past references to React/Vite, Cloudflare, Alpaca paper, Gmail, or Notion as unverified legacy hints.
- Reuse working components when they satisfy the target boundaries.
- Do not delete or replace a legacy integration until its replacement has parity tests and a documented migration.
- Update this file with real build/test commands after M00; do not invent successful commands.

## Verification

For every behavior change:

1. Add or update the smallest relevant tests.
2. Run formatting, lint, type checks, unit tests, and affected integration/contract tests.
3. For event or trading changes, run deterministic replay tests.
4. For broker/OMS/risk changes, run fault-injection cases for timeout, duplicate, partial fill, and mismatch.
5. Review the diff for secret leakage, unsafe live defaults, future-data leakage, non-idempotent side effects, and undocumented schema changes.
6. Report what changed, what was verified, and what remains unverified.

When M00 establishes repository commands, maintain one canonical `make check` or equivalent command that CI also runs.

## Definition of done

A task is done only when:

- Acceptance criteria in the active plan are met.
- Tests cover the new happy path and material failure paths.
- Relevant docs, examples, schemas, migrations, and runbooks match the code.
- Dev and paper defaults remain safe; live behavior is unchanged unless explicitly authorized.
- No critical warning is hidden behind a TODO.
- The final response is concise, in Korean, and names any assumption or unverified external dependency.

## Review rules

Flag as blocking:

- Any path that can submit an order without independent risk approval.
- Float-based money/quantity calculations.
- Missing broker reconciliation after ambiguous submission.
- Use of corrected/future information before `available_at`.
- Strategy promotion based only on a single backtest metric.
- Challenger access to live execution credentials.
- Silent fallbacks that increase exposure.
- Default-on live trading, logging of secrets, or credentials in frontend code.

## Documentation discipline

- Keep this file concise and durable. Put subsystem detail in `docs/`.
- Record decisions and unresolved questions in `docs/12_MIGRATION_AND_TBD.md`.
- When architecture changes, add an ADR using the template in `PLANS.md`.
- When a repeated Codex mistake is corrected, add the smallest practical rule here or in the closest nested `AGENTS.md`.

