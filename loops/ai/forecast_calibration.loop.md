# Loop: Forecast Calibration Implementation

## id
`forecast_calibration_implementation`

## trigger
Manual request to add probability, expected-return, target-price, or forecast calibration model.

## class
`ai_judgment`

## goal
Implement calibration infrastructure that can support future gated probability/expected-return exposure without making unvalidated claims.

## scope
Allowed: validation/calibration code, calibration config, docs, tests, internal-only diagnostics.

Forbidden: user-facing probability, target price, or expected return unless gates pass.

## inputs
- `docs/20_FORECAST_CALIBRATION.md`
- `config/calibration.yaml`
- `docs/10_CAPABILITY_GATES.md`

## steps
1. Define forward labels and horizon.
2. Implement walk-forward split.
3. Compute Brier score, log loss, ECE, reliability curves, precision@k, drawdown diagnostics.
4. Add thin-sample and regime-sensitivity handling.
5. Keep output internal until gates pass.
6. Update docs and loop memory.

## verification
- verification_level: `L3_delayed_field_truth` + `L5_human_checkpoint` before exposure
- required_checks:
  - calibration run artifacts exist
  - gate remains closed by default
  - UI/API exposure blocked unless approved

## stopping_rule
Success for internal calibration infrastructure only. Escalate before user-facing forecast exposure.

## memory
Write `loop_memory/active/<date>_forecast_calibration_implementation.md`.
