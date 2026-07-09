-- AI Market Decision OS initial Postgres schema
-- Source Complete v2

CREATE SCHEMA IF NOT EXISTS core;
CREATE SCHEMA IF NOT EXISTS raw;
CREATE SCHEMA IF NOT EXISTS derived;
CREATE SCHEMA IF NOT EXISTS validation;
CREATE SCHEMA IF NOT EXISTS ai;
CREATE SCHEMA IF NOT EXISTS ops;
CREATE SCHEMA IF NOT EXISTS execution;

CREATE TABLE IF NOT EXISTS core.instrument_master (
  instrument_id TEXT PRIMARY KEY,
  symbol TEXT NOT NULL,
  name TEXT NOT NULL,
  instrument_type TEXT NOT NULL,
  market TEXT NOT NULL,
  currency TEXT NOT NULL,
  exchange_code TEXT,
  timezone TEXT NOT NULL,
  active_from DATE,
  active_to DATE,
  metadata_json JSONB NOT NULL DEFAULT '{}'::jsonb,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE IF NOT EXISTS core.source_registry (
  source_id TEXT PRIMARY KEY,
  label TEXT NOT NULL,
  source_class TEXT NOT NULL,
  cadence TEXT NOT NULL,
  stale_after_days INTEGER,
  official BOOLEAN NOT NULL DEFAULT false,
  license_status TEXT NOT NULL,
  redistribution_allowed TEXT NOT NULL DEFAULT 'unknown',
  warning TEXT,
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE IF NOT EXISTS raw.raw_provider_payload (
  payload_id TEXT PRIMARY KEY,
  source_id TEXT NOT NULL REFERENCES core.source_registry(source_id),
  request_hash TEXT NOT NULL,
  request_url_safe TEXT,
  r2_uri TEXT NOT NULL,
  content_hash TEXT NOT NULL,
  fetched_at TIMESTAMPTZ NOT NULL,
  known_at TIMESTAMPTZ NOT NULL,
  license_status TEXT NOT NULL,
  quality_status TEXT NOT NULL DEFAULT 'ok',
  metadata_json JSONB NOT NULL DEFAULT '{}'::jsonb
);

CREATE TABLE IF NOT EXISTS raw.series_daily (
  instrument_id TEXT NOT NULL REFERENCES core.instrument_master(instrument_id),
  trade_date DATE NOT NULL,
  field TEXT NOT NULL,
  value NUMERIC NOT NULL,
  currency TEXT,
  source_id TEXT NOT NULL REFERENCES core.source_registry(source_id),
  source_class TEXT NOT NULL,
  observed_at TIMESTAMPTZ,
  published_at TIMESTAMPTZ,
  effective_at TIMESTAMPTZ,
  fetched_at TIMESTAMPTZ NOT NULL,
  known_at TIMESTAMPTZ NOT NULL,
  asof_at TIMESTAMPTZ NOT NULL,
  quality_status TEXT NOT NULL DEFAULT 'ok',
  license_status TEXT NOT NULL DEFAULT 'unknown',
  metadata_json JSONB NOT NULL DEFAULT '{}'::jsonb,
  PRIMARY KEY (instrument_id, trade_date, field, source_id)
);

CREATE INDEX IF NOT EXISTS idx_series_daily_lookup
  ON raw.series_daily (instrument_id, field, trade_date DESC);

CREATE TABLE IF NOT EXISTS derived.sector_metrics_daily (
  sector_code TEXT NOT NULL,
  as_of DATE NOT NULL,
  rs_ratio NUMERIC,
  rs_momentum NUMERIC,
  rrg_quadrant TEXT,
  relative_strength_state TEXT,
  relative_strength_transition TEXT,
  breadth_state TEXT,
  breadth_transition TEXT,
  participation_state TEXT,
  participation_transition TEXT,
  direction TEXT,
  strength INTEGER,
  conviction_label TEXT,
  lead_pattern TEXT,
  narrative TEXT,
  risks_json JSONB NOT NULL DEFAULT '[]'::jsonb,
  invalidation_json JSONB NOT NULL DEFAULT '[]'::jsonb,
  source_metrics_json JSONB NOT NULL DEFAULT '{}'::jsonb,
  data_freshness_json JSONB NOT NULL DEFAULT '{}'::jsonb,
  validation_status TEXT NOT NULL DEFAULT 'not_validated',
  license_status TEXT NOT NULL DEFAULT 'unknown',
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  PRIMARY KEY (sector_code, as_of)
);

CREATE TABLE IF NOT EXISTS derived.dashboard_snapshot (
  snapshot_id TEXT PRIMARY KEY,
  as_of DATE NOT NULL,
  benchmark TEXT NOT NULL,
  market_code TEXT NOT NULL,
  payload_json JSONB NOT NULL,
  data_freshness_json JSONB NOT NULL DEFAULT '{}'::jsonb,
  license_status_json JSONB NOT NULL DEFAULT '{}'::jsonb,
  validation_status TEXT NOT NULL DEFAULT 'not_validated',
  created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX IF NOT EXISTS idx_dashboard_snapshot_latest
  ON derived.dashboard_snapshot (market_code, as_of DESC);

CREATE TABLE IF NOT EXISTS validation.replay_run (
  replay_run_id TEXT PRIMARY KEY,
  market_code TEXT NOT NULL,
  started_at TIMESTAMPTZ NOT NULL,
  finished_at TIMESTAMPTZ,
  status TEXT NOT NULL,
  config_hash TEXT NOT NULL,
  notes TEXT
);

CREATE TABLE IF NOT EXISTS validation.forward_label (
  label_id TEXT PRIMARY KEY,
  instrument_id TEXT NOT NULL,
  as_of DATE NOT NULL,
  label_name TEXT NOT NULL,
  horizon_trading_days INTEGER NOT NULL,
  value NUMERIC,
  class_label TEXT,
  known_at TIMESTAMPTZ NOT NULL,
  metadata_json JSONB NOT NULL DEFAULT '{}'::jsonb
);

CREATE TABLE IF NOT EXISTS validation.calibration_run (
  calibration_run_id TEXT PRIMARY KEY,
  label_name TEXT NOT NULL,
  started_at TIMESTAMPTZ NOT NULL,
  finished_at TIMESTAMPTZ,
  status TEXT NOT NULL,
  metrics_json JSONB NOT NULL DEFAULT '{}'::jsonb,
  sample_size INTEGER,
  reliability_label TEXT,
  artifact_r2_uri TEXT
);

CREATE TABLE IF NOT EXISTS ai.ai_decision_log (
  decision_id TEXT PRIMARY KEY,
  asof_at TIMESTAMPTZ NOT NULL,
  layer TEXT NOT NULL,
  input_fact_hash TEXT NOT NULL,
  model_name TEXT NOT NULL,
  model_version TEXT,
  prompt_version TEXT,
  output_json JSONB NOT NULL,
  guardrail_result TEXT NOT NULL,
  allowed_capabilities_json JSONB NOT NULL DEFAULT '[]'::jsonb,
  blocked_capabilities_json JSONB NOT NULL DEFAULT '[]'::jsonb,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE IF NOT EXISTS ops.run_log (
  run_id TEXT PRIMARY KEY,
  job_name TEXT NOT NULL,
  started_at TIMESTAMPTZ NOT NULL,
  finished_at TIMESTAMPTZ,
  status TEXT NOT NULL,
  records_read INTEGER DEFAULT 0,
  records_written INTEGER DEFAULT 0,
  warnings_json JSONB NOT NULL DEFAULT '[]'::jsonb,
  errors_json JSONB NOT NULL DEFAULT '[]'::jsonb,
  metadata_json JSONB NOT NULL DEFAULT '{}'::jsonb
);

CREATE TABLE IF NOT EXISTS ops.capability_gate_log (
  gate_id TEXT PRIMARY KEY,
  asof_at TIMESTAMPTZ NOT NULL,
  requested_capability TEXT NOT NULL,
  allowed BOOLEAN NOT NULL,
  reason_codes_json JSONB NOT NULL DEFAULT '[]'::jsonb,
  data_status TEXT,
  license_status TEXT,
  validation_status TEXT,
  calibration_status TEXT,
  risk_status TEXT,
  jurisdiction_status TEXT,
  user_suitability_status TEXT,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE IF NOT EXISTS execution.order_intent_log (
  order_intent_id TEXT PRIMARY KEY,
  user_id TEXT,
  asof_at TIMESTAMPTZ NOT NULL,
  source_decision_id TEXT,
  symbol TEXT NOT NULL,
  side TEXT NOT NULL,
  order_type TEXT,
  quantity NUMERIC,
  notional NUMERIC,
  allocation_pct NUMERIC,
  reason_json JSONB NOT NULL DEFAULT '{}'::jsonb,
  risk_check_json JSONB NOT NULL DEFAULT '{}'::jsonb,
  approval_status TEXT NOT NULL DEFAULT 'required',
  execution_allowed BOOLEAN NOT NULL DEFAULT false,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE IF NOT EXISTS execution.execution_audit_log (
  execution_audit_id TEXT PRIMARY KEY,
  order_intent_id TEXT REFERENCES execution.order_intent_log(order_intent_id),
  broker TEXT NOT NULL,
  mode TEXT NOT NULL,
  request_json JSONB NOT NULL DEFAULT '{}'::jsonb,
  response_json JSONB NOT NULL DEFAULT '{}'::jsonb,
  status TEXT NOT NULL,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);
