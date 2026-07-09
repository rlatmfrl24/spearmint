# Skill: Implement Validation Replay

Use this when adding replay or validation diagnostics.

## Steps

1. Read `docs/08_VALIDATION_PLAN.md`.
2. Replay historical snapshots using only data known at each as-of date.
3. Generate forward labels separately from original judgments.
4. Mark sample reliability.
5. Hide probability-like outputs when sample is thin or calibration is missing.
6. Add guardrail tests for Layer 4 wording.

## Required Outputs

```text
sample_size
forward labels
sample reliability
thin_sample
readiness caveat
```
