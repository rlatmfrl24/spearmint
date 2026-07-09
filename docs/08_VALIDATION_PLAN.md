# 08. Validation Plan

Last updated: 2026-07-08
Status: Updated for defined calibration gate

## 1. Purpose

Validation determines what the system is allowed to say and do. It is not only a performance report; it is a capability gate input.

## 2. Validation Stages

| Stage | Purpose | Allowed Output |
|---|---|---|
| V0 | No replay | Qualitative state only |
| V1 | Historical replay connected | Pattern diagnostics without probability-like wording |
| V2 | Forward labels evaluated | Sample-observed diagnostics with reliability caveat |
| V3 | Calibration tested | Limited probability/range output behind gates |
| V4 | Paper trading / shadow testing | Order intent research mode |
| V5 | Live constrained validation | Limited automated execution |

## 3. Replay Pipeline

```text
historical snapshots
  -> metric recomputation
  -> rulebook outputs
  -> forward relative labels
  -> pattern diagnostics
  -> reliability scoring
  -> calibration run
  -> report guardrail
```

## 4. Forward Labels

Primary labels are defined in `docs/20_FORECAST_CALIBRATION.md` and `config/calibration.yaml`.

```text
sector_outperforms_benchmark_20d
sector_outperforms_benchmark_60d
max_relative_drawdown_20d
```

Labels must be generated only from future data relative to the replayed `asof_date`, never used in the original judgment payload.

## 5. Diagnostics

Layer 4 may show:

```text
pattern sample size
evaluated forward labels
sample-observed probability
sample reliability
forward relative median
drawdown median
thin_sample flag
readiness caveat
calibration status
```

Use `sample_observed_probability`, not `probability`, until calibration is validated.

## 6. Reliability Rules

Default rules are in `config/calibration.yaml`.

```text
sample_size < 60 -> thin_sample
out_of_sample_windows < 8 -> not_ready
ECE > 0.05 -> not_calibrated
```

These thresholds can change only with config and docs updates.

## 7. Calibration for Future Forecasting

Before exposing expected returns or probability-like outputs:

- Out-of-sample validation must exist.
- Walk-forward split must exist.
- Calibration error must be measured.
- Regime sensitivity must be checked.
- Transaction cost and slippage assumptions must be documented if actionability is implied.
- Report copy must include horizon, sample size, calibration date, reliability label, and caveat.

## 8. Guardrail Tests

- Probability-like language hidden when validation not ready.
- Thin sample hides numeric claim or downgrades display.
- Buy/sell copy blocked in MVP.
- Expected return blocked unless AI level and validation stage allow it.
- Order intent blocked unless risk, jurisdiction, broker, and approval gates allow it.

## 9. Validation Output Contract

```json
{
  "historical_ready": true,
  "validation_stage": "V2",
  "calibration_status": "not_ready",
  "patterns": [
    {
      "lead_pattern": "Emerging Leader",
      "sample_size": 84,
      "sample_reliability": "limited",
      "sample_observed_probability": 0.57,
      "readiness_caveat": "Observed in replay only; not calibrated."
    }
  ],
  "allowed_ai_level": 2,
  "blocked_capabilities": []
}
```
