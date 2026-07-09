# 24. Agentic Runbook

## 1. Default Codex Work Cycle

For any task larger than a typo fix, use this cycle:

```text
Select Loop
  -> Read Scope Docs
  -> Create or Update Loop Memory
  -> Plan Minimal Change
  -> Implement
  -> Verify
  -> Critic Review
  -> Repair if Needed
  -> Sync Docs
  -> Stop with Named Terminal State
```

## 2. Minimal Loop Memory Record

Create or update a memory file under:

```text
loop_memory/active/<YYYYMMDD>_<loop_id>_<short_goal>.md
```

Use this template:

```md
# Loop Memory: <loop_id>

- run_id:
- trigger:
- goal:
- scope:
- started_at:
- current_iteration:
- terminal_state:

## Files Touched

## Checks Run

## Decisions

## Failures or Blockers

## Next Action
```

When complete, move the file to `loop_memory/archive/` or summarize it in a package-level handoff.

## 3. No-Progress Detector

A loop is stalled if two consecutive iterations do not change one of the following:

- a failing test result
- a schema mismatch
- a contract inconsistency
- a documented blocker
- a concrete file diff
- an explicit decision record

When stalled, stop as `stalled` and write the smallest useful handoff.

## 4. Verification Before Expansion

Do not proceed to broader scope until the current loop passes its declared verifier.

Examples:

- Metric module loop must pass synthetic metric edge-case tests before dashboard work.
- Rulebook loop must pass pattern/veto tests before report output changes.
- API loop must pass schema contract before frontend changes.
- Provider loop must pass fixture tests and license gate before live ingestion.
- AI judgment loop must pass guardrail validation before user-facing output.
- Execution loop must pass risk and human gates before broker integration.

## 5. Human Escalation Rules

Escalate instead of guessing when the task requires:

- legal interpretation
- provider license approval
- broker approval
- live credential use
- real-money order routing
- user suitability decision
- market data redistribution decision
- ambiguous product scope expansion beyond feature gates

## 6. Handoff Format

Every loop handoff must include:

```text
Terminal state:
What changed:
What was verified:
What was not verified:
Risks or blockers:
Next recommended loop:
```
