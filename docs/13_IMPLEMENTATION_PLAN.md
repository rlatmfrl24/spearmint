# 13. Implementation Plan

Last updated: 2026-07-08
Status: Updated for Source Complete v2

## Milestone 0: Commit Source Docs

Files:

- `PROJECT_CHARTER.md`
- `AGENTS.md`
- `docs/15_MARKET_SCOPE_DECISION.md`
- `docs/16_CLOUDFLARE_POSTGRES_ARCHITECTURE.md`
- `docs/17_PROVIDER_AND_LICENSE_STRATEGY.md`
- `docs/18_BROKER_AND_EXECUTION_SELECTION.md`
- `docs/19_REGULATORY_SCOPE.md`
- `docs/20_FORECAST_CALIBRATION.md`
- `config/*.yaml`
- `database/migrations/0001_initial.sql`
- `infra/cloudflare/wrangler.example.toml`

Done when docs are committed and reviewed.

## Milestone 1: Postgres Foundation

- create Postgres schemas
- implement migration runner
- implement config loader
- implement source registry loader
- implement run log helpers
- unit tests use local Postgres or test container

## Milestone 2: Provider Adapter Skeleton

- fixture price provider
- Massive/Polygon provider interface, disabled without credentials
- FRED provider interface
- SEC EDGAR provider interface, no large backfill in first PR
- R2 raw payload archive interface
- provider license gate

## Milestone 3: Metrics MVP

- relative strength
- RS ratio
- RS momentum
- RRG quadrant
- participation
- breadth proxy
- missing data states

## Milestone 4: Rulebook MVP

- Strong Leader
- Emerging Leader
- Borderline Leader
- Late Leader
- Mega-cap Dependence
- False Leadership
- Breakdown
- veto rules

## Milestone 5: API and Dashboard Snapshot

- `GET /api/sectors`
- `GET /api/data/status`
- fixture-backed dashboard snapshot
- Postgres-backed dashboard snapshot
- source freshness and license status displayed

## Milestone 6: Layer 1~4 UI

- Layer 1 flow
- Layer 2 context
- Layer 3 leadership/transition
- Layer 4 validation readiness
- no UI-side metric computation

## Milestone 7: Validation Skeleton

- forward labels
- replay run table
- pattern diagnostics
- sample reliability
- probability copy remains blocked

## Milestone 8: AI Scenario Layer

- facts-only AI input
- AI scenario output
- AI skeptic
- guardrail validator
- AI decision log

## Milestone 9: Production Hardening

- Cloudflare deployment
- Hyperdrive connection
- R2 archive
- Queues/Cron orchestration
- observability
- stale snapshot fallback

## Future Milestones

- stock candidate data model
- valuation model
- portfolio advice
- IBKR sandbox adapter
- order intent gate
- paper/shadow validation
- live execution only after legal/compliance approval


## Loop Engineering Implementation Overlay

Before Phase 1 source work begins, establish the loop engineering scaffolding.

### Phase 0A: Loop Foundation

Deliverables:

```text
config/loops.yaml
config/agent_roles.yaml
config/quality_gates.yaml
docs/22_LOOP_ENGINEERING.md
docs/23_LOOP_LIBRARY.md
docs/24_AGENTIC_RUNBOOK.md
loops/templates/loop_spec_template.md
loops/source/*.loop.md
loops/data/*.loop.md
loops/ai/*.loop.md
loops/release/*.loop.md
loop_memory/README.md
database/migrations/0002_loop_engineering.sql
```

Definition of done:

- Every major implementation task maps to at least one loop spec.
- Every loop has trigger, goal, verification, stopping rule, terminal state, and memory.
- PR handoff uses `release/pr_self_review.loop.md`.
- Source package releases use `release/package_self_evaluation.loop.md`.
- Loop memory stores concise operational facts, not private chain-of-thought.

### Loop-to-Phase Mapping

| Project phase | Required loop family |
|---|---|
| Phase 1 data foundation | `data/provider_adapter.loop.md`, `source/postgres_migration.loop.md` |
| Phase 2 metrics MVP | `source/metric_module.loop.md` |
| Phase 3 rulebook MVP | `source/rulebook_pattern.loop.md` |
| Phase 4 dashboard MVP | `source/api_endpoint.loop.md`, `source/dashboard_layer.loop.md` |
| Phase 5 replay/validation | `data/validation_replay.loop.md` |
| Phase 6 source quality | `data/provider_adapter.loop.md`, `data/daily_snapshot_refresh.loop.md` |
| Phase 7 AI analysis | `ai/ai_judgment_agent.loop.md`, `ai/report_generator.loop.md` |
| Phase 8+ execution design | future execution loop with L5 checkpoint only |
