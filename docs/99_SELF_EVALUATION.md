# 99. Self Evaluation — Loop Engineering v3

## Summary

This v3 package extends the complete v2 source documentation with a loop engineering operating model for Codex-driven implementation.

## Score

**94 / 100**

## What Improved from v2

| Area | v2 state | v3 improvement |
|---|---|---|
| Codex workflow | AGENTS + skills | bounded loop specs with verification and terminal states |
| Memory | not explicit | `loop_memory/` operational memory scaffold |
| Verification | tests and docs | five-level loop verification ladder |
| Stop rules | PR checklist | named terminal states: success, no-op, blocked, stalled, exhausted, escalated |
| Reuse | skills only | loop library mapped to metrics, rulebook, provider, API, UI, validation, AI, release |
| Governance | capability gates | loop-specific quality gates and role separation |
| Auditability | run logs | optional Postgres `ops.loop_run_log` and `ops.loop_memory_entry` migration |

## Strengths

- Preserves the sector-first and explainable architecture.
- Preserves module disagreement, state/transition separation, raw/derived/PIT separation, and freshness requirements.
- Keeps U.S. S&P 500 sector ETF market, SPY benchmark, Postgres, and Cloudflare deployment decisions from v2.
- Adds loop specs that Codex can use directly for implementation tasks.
- Introduces role separation between maker, verifier, critic, data guardian, and risk guardian.
- Prevents model-judge self-approval.
- Keeps Layer 5+ AI, advice, execution, and auto-trading features gated.
- Adds explicit blocked/stalled/exhausted terminal states to avoid false success.

## Remaining External Dependencies

These are not document gaps; they require real-world approval or implementation:

- live market data provider plan and redistribution/license approval
- provider credentials and rate-limit testing
- legal review before personalized advice, order routing, or auto-trading
- broker sandbox/production approval
- real historical data calibration runs
- CI/CD environment setup for actual loop execution
- human team agreement on who owns L5 checkpoints

## Risks

| Risk | Mitigation |
|---|---|
| Loop overhead for tiny tasks | AGENTS allows simple typo fixes without loop; non-trivial tasks require loops |
| False confidence from model judge | L4 requires separate critic and must not be represented as deterministic proof |
| Loop memory bloat | memory template stores concise operational facts only |
| Over-automation of trading features | execution loops remain disabled and require risk/legal/broker/human gates |
| Documentation drift | `release/docs_sync.loop.md` and manifest update requirements |

## Readiness

This package is ready to be added to a Codex project as a source-document foundation.

Recommended first implementation sequence:

1. Import v3 docs/config/loops into the repository.
2. Run `release/package_self_evaluation.loop.md` as the first internal verification.
3. Implement config loader using `source/metric_module.loop.md` only after tests scaffold exists.
4. Use `release/pr_self_review.loop.md` on every PR-sized change.
