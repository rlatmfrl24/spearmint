# Loop: Validation Replay Implementation

## id
`validation_replay_implementation`

## trigger
Manual request to add historical replay, forward labels, pattern diagnostics, or calibration readiness.

## class
`data_pipeline`

## goal
Implement replay diagnostics that distinguish sample-observed findings from calibrated probabilities.

## scope
Allowed: `src/validation/`, validation tables, tests, `docs/08_VALIDATION_PLAN.md`, `docs/20_FORECAST_CALIBRATION.md`.

Forbidden: exposing probabilities, hit rates, expected returns, or target prices before gates pass.

## inputs
- `docs/08_VALIDATION_PLAN.md`
- `docs/20_FORECAST_CALIBRATION.md`
- `config/calibration.yaml`

## steps
1. Define replay universe, horizon, and forward relative labels.
2. Implement deterministic replay on fixtures first.
3. Add sample reliability and thin-sample handling.
4. Add API/contract guardrails for Layer 4 only.
5. Update docs and loop memory.

## verification
- verification_level: `L1_deterministic` + `L3_delayed_field_truth`
- required_checks:
  - fixture replay deterministic
  - thin_sample hides unreliable numeric claims
  - Layer 4 labeling distinguishes diagnostics from calibrated probabilities

## stopping_rule
Success only when replay outputs are reliable and guarded. Block if historical data or labels are missing.

## memory
Write `loop_memory/active/<date>_validation_replay_implementation.md`.
