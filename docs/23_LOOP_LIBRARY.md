# 23. Loop Library

This document indexes the reusable loop specifications shipped with the source package.

## 1. Source Implementation Loops

| Loop | Purpose | Primary verifier |
|---|---|---|
| `source/metric_module.loop.md` | Add or modify a metric module | L1 unit tests, L2 financial guardrails |
| `source/rulebook_pattern.loop.md` | Add or modify a rulebook pattern or veto | L1 pattern tests, L2 output contract |
| `source/api_endpoint.loop.md` | Add or modify API contract and endpoint | L1 schema tests, L2 API policy |
| `source/dashboard_layer.loop.md` | Add or modify UI layer behavior | L1 component tests, L2 API-only policy |
| `source/postgres_migration.loop.md` | Add DB migration or view | L1 SQL dry-run, L2 PIT/storage policy |
| `source/cloudflare_api.loop.md` | Add Worker/API integration | L1 contract tests, L2 Cloudflare compute policy |

## 2. Data Pipeline Loops

| Loop | Purpose | Primary verifier |
|---|---|---|
| `data/provider_adapter.loop.md` | Add or modify a provider adapter | L1 fixture tests, L2 license gate |
| `data/daily_snapshot_refresh.loop.md` | Refresh bounded daily snapshots | L2 freshness policy, L3 scheduled run |
| `data/validation_replay.loop.md` | Add replay or forward-label diagnostics | L1 replay fixture, L3 full replay output |

## 3. AI and Reporting Loops

| Loop | Purpose | Primary verifier |
|---|---|---|
| `ai/ai_judgment_agent.loop.md` | Add Layer 5 AI judgment behavior | L2 guardrail validator, L4 critic |
| `ai/report_generator.loop.md` | Generate research brief or report payload | L1 schema, L2 citation/guardrail checks |
| `ai/forecast_calibration.loop.md` | Add calibrated probability/expected-return model | L3 calibration run, L5 approval before exposure |

## 4. Release and Review Loops

| Loop | Purpose | Primary verifier |
|---|---|---|
| `release/docs_sync.loop.md` | Synchronize docs, config, manifest, README, AGENTS | L2 docs consistency checklist |
| `release/pr_self_review.loop.md` | Run final PR self-review before handoff | L1/L2 checklist, optional L4 critic |
| `release/package_self_evaluation.loop.md` | Evaluate a source-doc package before delivery | L2 self-evaluation rubric |

## 5. Loop Selection Table

| User task type | Recommended loop |
|---|---|
| “Add RS metric” | `source/metric_module.loop.md` |
| “Add False Leadership pattern” | `source/rulebook_pattern.loop.md` |
| “Create `/api/sectors` endpoint” | `source/api_endpoint.loop.md` |
| “Implement dashboard Layer 3” | `source/dashboard_layer.loop.md` |
| “Add FRED provider” | `data/provider_adapter.loop.md` |
| “Add replay validation” | `data/validation_replay.loop.md` |
| “Add AI scenario analysis” | `ai/ai_judgment_agent.loop.md` |
| “Update documentation after architecture decision” | `release/docs_sync.loop.md` |
| “Prepare PR for review” | `release/pr_self_review.loop.md` |
