# Loop Specifications

This directory contains reusable loop specifications for Codex and other coding agents.

A loop specification is a bounded work contract. It is not a programming loop and not the agent's internal tool-use cycle. It is the external pilot that tells the agent what starts the work, what goal is pursued, how success is checked, when to stop, and what memory to write.

Use `loops/templates/loop_spec_template.md` when a new loop is needed.

## Directory Map

```text
loops/
  templates/        Reusable blank spec
  source/           Source implementation loops
  data/             Provider, ingestion, validation loops
  ai/               AI judgment, report, calibration loops
  release/          Docs sync, PR review, package evaluation loops
```

## Required Terminal State

Every loop must end as one of:

```text
success | no_op | blocked | stalled | exhausted | escalated
```

A loop that cannot verify its result must not end as `success`.
