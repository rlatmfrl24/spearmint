-- 0002_loop_engineering.sql
-- Adds optional operational tables for loop-engineered Codex runs.
-- These tables are not required for the MVP application runtime, but they define
-- the canonical audit shape if loop execution metadata is persisted to Postgres.

CREATE SCHEMA IF NOT EXISTS ops;

CREATE TABLE IF NOT EXISTS ops.loop_run_log (
  loop_run_id TEXT PRIMARY KEY,
  loop_id TEXT NOT NULL,
  loop_class TEXT NOT NULL,
  trigger_type TEXT NOT NULL,
  goal TEXT NOT NULL,
  verification_level TEXT NOT NULL,
  terminal_state TEXT NOT NULL CHECK (terminal_state IN ('success', 'no_op', 'blocked', 'stalled', 'exhausted', 'escalated')),
  started_at TIMESTAMPTZ NOT NULL,
  ended_at TIMESTAMPTZ,
  files_touched JSONB NOT NULL DEFAULT '[]'::jsonb,
  checks_run JSONB NOT NULL DEFAULT '[]'::jsonb,
  blockers JSONB NOT NULL DEFAULT '[]'::jsonb,
  next_action TEXT,
  metadata JSONB NOT NULL DEFAULT '{}'::jsonb,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX IF NOT EXISTS idx_loop_run_log_loop_id ON ops.loop_run_log(loop_id);
CREATE INDEX IF NOT EXISTS idx_loop_run_log_terminal_state ON ops.loop_run_log(terminal_state);
CREATE INDEX IF NOT EXISTS idx_loop_run_log_started_at ON ops.loop_run_log(started_at DESC);

CREATE TABLE IF NOT EXISTS ops.loop_memory_entry (
  memory_id TEXT PRIMARY KEY,
  loop_run_id TEXT REFERENCES ops.loop_run_log(loop_run_id),
  memory_scope TEXT NOT NULL CHECK (memory_scope IN ('active', 'archive', 'decision', 'blocker')),
  title TEXT NOT NULL,
  summary TEXT NOT NULL,
  related_files JSONB NOT NULL DEFAULT '[]'::jsonb,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX IF NOT EXISTS idx_loop_memory_entry_run ON ops.loop_memory_entry(loop_run_id);
CREATE INDEX IF NOT EXISTS idx_loop_memory_entry_scope ON ops.loop_memory_entry(memory_scope);
