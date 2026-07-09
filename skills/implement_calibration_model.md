# Skill: Implement Calibration Model

Use this for future probability, expected-return, or forecast work.

1. Read `docs/20_FORECAST_CALIBRATION.md` and `config/calibration.yaml`.
2. Use walk-forward validation.
3. Enforce `known_at <= asof_at`.
4. Create forward labels without overlap leakage.
5. Report Brier, log loss, ECE, reliability curve, sample size, and base-rate comparison.
6. Do not expose user-facing probabilities unless exposure gates pass.
7. Add guardrail tests for probability/expected-return copy.
