# 22. Loop Engineering Architecture

## 1. Decision

This project adopts **loop engineering** as the default operating model for Codex-driven development.

Loop engineering is not a product feature and it is not a trading loop. It is the repository-level method for making agentic coding reliable: a bounded, reusable loop specification tells Codex what starts the work, what goal is being pursued, how success is verified, when to stop, where to persist memory, and when to escalate.

## 2. Why This Project Needs Loops

AI Market Decision OS is not a simple CRUD app. It combines market data ingestion, point-in-time storage, metrics, rulebook interpretation, AI judgment, validation, reporting, Cloudflare deployment, risk gates, and future execution constraints.

A one-off prompt is too weak for this. Codex needs durable, repeatable work patterns so that every change preserves:

- sector-first architecture
- module disagreement as signal
- state/transition separation
- raw/derived/PIT data separation
- source freshness and provider-license gates
- capability gates for AI judgment, stock candidates, advice, orders, and auto-trading
- documentation and API contract synchronization
- testable output contracts

## 3. Loop Specification Anatomy

Every loop specification in this repository must include the following fields.

```yaml
id: loop_id
name: Human readable name
trigger: manual | scheduled | event
class: source_implementation | documentation_sync | data_pipeline | ai_judgment | execution_or_trading
goal: Verifiable target outcome
scope: Files, modules, and layers the loop may touch
inputs: Required docs, config files, and source files
steps: Bounded sequence of work phases
verification: Deterministic, rule-based, delayed, model-judged, or human checkpoint checks
stopping_rule: Success, no-op, blocked, stalled, exhausted, or escalated
memory: Where the loop records decisions, failures, terminal state, and next action
safety_constraints: What the loop may not do
files_to_update: Source, tests, docs, config, migrations, and manifests
handoff_summary: Required final summary format
```

## 4. Verification Ladder

Loops must declare the strongest actual verifier available.

| Level | Name | Examples | Autonomous? |
|---|---|---|---|
| L1 | deterministic | unit test exit code, schema snapshot, SQL dry-run, golden JSON | yes |
| L2 | rule or policy | lint, typecheck, guardrail scan, capability-gate check | yes |
| L3 | delayed field truth | CI, staging deploy, replay output, provider sync, calibration run | partial |
| L4 | model judge | separate critic model reviews a rubric | assisted |
| L5 | human checkpoint | product/legal/broker/domain owner review | no |

Do not pretend a model judge is deterministic verification. If L4 is used, a separate critic must evaluate the maker output.

## 5. Named Terminal States

A loop must end in exactly one of these states.

| State | Meaning | Done? |
|---|---|---:|
| success | Goal met and verification passed | yes |
| no_op | No eligible work after trigger | yes |
| blocked | External dependency or decision required | no |
| stalled | No material progress after allowed attempts | no |
| exhausted | Budget or iteration limit reached | no |
| escalated | Human review required | no |

`blocked`, `stalled`, and `exhausted` are not failures to hide. They are required safety signals.

## 6. Memory

Every loop must persist a short memory record under `loop_memory/active/` while work is active and move or summarize it under `loop_memory/archive/` after the final state.

Memory records should include:

```yaml
loop_id:
run_id:
started_at:
trigger:
goal:
files_touched:
checks_run:
terminal_state:
what_changed:
what_failed:
next_action:
open_risks:
```

Loop memory is not a private chain of thought. It is a concise operational artifact for future Codex runs and human maintainers.

## 7. Project-Specific Loop Classes

### 7.1 Source Implementation Loops

Use for metrics, rulebook patterns, API endpoints, dashboard layers, migrations, Cloudflare API, and provider adapters.

Required checks:

- unit or contract tests
- docs update when contract changes
- no network calls in unit tests
- no financial output guardrail drift

### 7.2 Documentation Synchronization Loops

Use when scope, API, output contract, feature gates, or architecture decisions change.

Required checks:

- manifest updated
- decision records updated
- README and AGENTS updated if the development workflow changes
- self-evaluation updated for major packages

### 7.3 Data Pipeline Loops

Use for provider ingestion, source registry, freshness, raw payload archiving, and Postgres/R2 workflows.

Required checks:

- source/license policy gate
- idempotent upsert behavior
- PIT field presence
- raw/derived separation

### 7.4 AI Judgment Loops

Use for Layer 5+ AI scenario or judgment behavior.

Required checks:

- facts-only input payload
- no hidden provider lookup by the AI agent
- guardrail validator
- AI decision log
- capability level check
- separate critic for model-judged output

### 7.5 Execution or Trading Loops

These are disabled by default. Use only for future Phase 7+ design and paper-trading scaffolds.

Required checks:

- capability gate
- risk gate
- jurisdiction gate
- broker sandbox gate
- audit log
- human checkpoint
- kill switch design

## 8. Loop Selection Rule

Use a loop only when feedback from one iteration changes the next action. If a task simply runs once on a schedule and does not adapt, it is a scheduled job, not a loop.

## 9. Anti-Patterns

Avoid these patterns:

- unbounded iteration
- vague goals with no verifier
- same agent writes and approves its own model-judged output
- treating test failure as partial success
- changing thresholds without updating config and docs
- enabling Layer 5+ capability via UI before capability gates pass
- using D1 as canonical analytical storage
- running full replay or model training in Cloudflare Workers
- using loop memory as a dumping ground for raw chain-of-thought

## 10. Codex Entry Rule

For any non-trivial task, Codex must:

1. choose a loop spec from `loops/`, or create a new one from `loops/templates/loop_spec_template.md`;
2. declare the verification level;
3. perform the work within scope;
4. run or describe the applicable checks;
5. write loop memory;
6. stop with a named terminal state.
