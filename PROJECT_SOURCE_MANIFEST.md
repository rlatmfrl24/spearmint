# Project Source Manifest — Loop Engineering v3

This manifest describes the v3 source documentation package for AI Market Decision OS.

## v3 Additions

- Loop engineering adopted as the default Codex operating model.
- New loop specifications in `loops/`.
- New loop memory scaffold in `loop_memory/`.
- New loop configs: `config/loops.yaml`, `config/agent_roles.yaml`, `config/quality_gates.yaml`.
- New docs: `docs/22_LOOP_ENGINEERING.md`, `docs/23_LOOP_LIBRARY.md`, `docs/24_AGENTIC_RUNBOOK.md`.
- New optional migration: `database/migrations/0002_loop_engineering.sql`.
- New PR loop checklist template: `.github/pull_request_template.md`.

## Fixed Decisions Retained from v2

- Phase 1 market: U.S. S&P 500 sector ETF universe.
- Benchmark: SPY.
- Canonical DB: Postgres.
- Cloudflare: Workers/Pages + Hyperdrive + R2 + Queues/Cron.
- D1: optional edge cache/config/status only.
- Layer 5+ investment-action capabilities remain gated and disabled by default.

## File Inventory

- `.github/pull_request_template.md`
- `AGENTS.md`
- `CHECKSUMS.sha256`
- `PROJECT_CHARTER.md`
- `PROJECT_SOURCE_MANIFEST.md`
- `README.md`
- `config/agent_roles.yaml`
- `config/broker_policy.yaml`
- `config/calibration.yaml`
- `config/catalysts.manual.example.yaml`
- `config/database.postgres.yaml`
- `config/deployment.cloudflare.yaml`
- `config/features.yaml`
- `config/loops.yaml`
- `config/provider_policy.yaml`
- `config/quality_gates.yaml`
- `config/regulatory_scope.yaml`
- `config/source_registry.yaml`
- `config/thresholds.example.yaml`
- `config/universe.yaml`
- `database/migrations/0001_initial.sql`
- `database/migrations/0002_loop_engineering.sql`
- `docs/01_ARCHITECTURE.md`
- `docs/02_LAYER_MODEL.md`
- `docs/03_DATA_MODEL.md`
- `docs/04_METRICS_AND_STATES.md`
- `docs/05_RULEBOOK.md`
- `docs/06_API_CONTRACT.md`
- `docs/07_UI_SPEC.md`
- `docs/08_VALIDATION_PLAN.md`
- `docs/09_AI_DECISION_ARCHITECTURE.md`
- `docs/10_CAPABILITY_GATES.md`
- `docs/11_RISK_GOVERNANCE.md`
- `docs/12_REPORTING_SPEC.md`
- `docs/13_IMPLEMENTATION_PLAN.md`
- `docs/14_TESTING_STRATEGY.md`
- `docs/15_MARKET_SCOPE_DECISION.md`
- `docs/16_CLOUDFLARE_POSTGRES_ARCHITECTURE.md`
- `docs/17_PROVIDER_AND_LICENSE_STRATEGY.md`
- `docs/18_BROKER_AND_EXECUTION_SELECTION.md`
- `docs/19_REGULATORY_SCOPE.md`
- `docs/20_FORECAST_CALIBRATION.md`
- `docs/21_DECISION_RECORDS.md`
- `docs/22_LOOP_ENGINEERING.md`
- `docs/23_LOOP_LIBRARY.md`
- `docs/24_AGENTIC_RUNBOOK.md`
- `docs/99_SELF_EVALUATION.md`
- `infra/cloudflare/README.md`
- `infra/cloudflare/wrangler.example.toml`
- `loop_memory/README.md`
- `loop_memory/active/.gitkeep`
- `loop_memory/archive/.gitkeep`
- `loops/README.md`
- `loops/ai/ai_judgment_agent.loop.md`
- `loops/ai/forecast_calibration.loop.md`
- `loops/ai/report_generator.loop.md`
- `loops/data/daily_snapshot_refresh.loop.md`
- `loops/data/provider_adapter.loop.md`
- `loops/data/validation_replay.loop.md`
- `loops/release/docs_sync.loop.md`
- `loops/release/package_self_evaluation.loop.md`
- `loops/release/pr_self_review.loop.md`
- `loops/source/api_endpoint.loop.md`
- `loops/source/cloudflare_api.loop.md`
- `loops/source/dashboard_layer.loop.md`
- `loops/source/metric_module.loop.md`
- `loops/source/postgres_migration.loop.md`
- `loops/source/rulebook_pattern.loop.md`
- `loops/templates/loop_spec_template.md`
- `skills/author_loop_spec.md`
- `skills/implement_ai_judgment_agent.md`
- `skills/implement_api_endpoint.md`
- `skills/implement_broker_adapter.md`
- `skills/implement_calibration_model.md`
- `skills/implement_cloudflare_api.md`
- `skills/implement_dashboard_layer.md`
- `skills/implement_metric_module.md`
- `skills/implement_postgres_migration.md`
- `skills/implement_provider_adapter.md`
- `skills/implement_provider_license_gate.md`
- `skills/implement_report_generator.md`
- `skills/implement_rulebook_pattern.md`
- `skills/implement_validation_replay.md`
- `skills/run_loop_review.md`
- `skills/update_loop_memory.md`
