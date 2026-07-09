# Skill: Run Loop Review

Use this skill before final handoff.

## Steps

1. Identify the loop used.
2. Confirm scope did not expand silently.
3. Confirm verification level was honestly declared.
4. Confirm checks were run or named as not run.
5. Confirm terminal state is one of `success`, `no_op`, `blocked`, `stalled`, `exhausted`, `escalated`.
6. Confirm loop memory was written.
7. Confirm docs/config/API/manifest were updated if contracts changed.
8. Confirm future capabilities remain gated by default.

## Output

```text
Loop:
Terminal state:
Verification level:
Checks run:
Files changed:
Docs synced:
Blockers:
Next loop:
```
