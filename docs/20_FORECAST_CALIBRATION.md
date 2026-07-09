# 20. Forecast Calibration

Last updated: 2026-07-08
Decision status: **Defined; not yet validated**

## 1. Purpose

This document defines the minimum validation and calibration standard before the system may expose probabilities, expected returns, target ranges, or forecast-driven recommendations.

## 2. Current Policy

MVP output may show:

- `state`
- `transition`
- `lead_pattern`
- `qualitative conviction`
- `risks`
- `invalidation`
- `sample reliability` in Layer 4

MVP output must not show:

- calibrated-looking probabilities,
- expected returns,
- target prices,
- user-specific buy/sell/hold advice.

## 3. Forward Labels

Primary relative label:

```text
sector_outperforms_benchmark_20d
= return(sector, t+20) - return(SPY, t+20)
```

Positive threshold:

```text
+100 bps relative to SPY over 20 trading days
```

Neutral band:

```text
±50 bps
```

Secondary relative label:

```text
sector_outperforms_benchmark_60d
= return(sector, t+60) - return(SPY, t+60)
```

Risk label:

```text
max_relative_drawdown_20d
```

## 4. Validation Protocol

- Use walk-forward validation.
- Use `known_at <= asof_at` for all features.
- Minimum training history: 5 years.
- Minimum out-of-sample windows: 8.
- Use an embargo period when labels overlap.
- Compare against base-rate and simple rulebook baselines.
- Include transaction-cost sensitivity for any strategy-like evaluation.

## 5. Calibration Metrics

Classification/probability:

- Brier score
- Log loss
- Expected calibration error
- Reliability curve
- Precision@K
- Recall@K
- Decile monotonicity

Return/range:

- MAE
- Pinball loss
- P10/P90 coverage
- calibration by decile

Strategy shadow diagnostics:

- relative hit rate
- average relative return
- max drawdown
- turnover
- transaction-cost sensitivity

## 6. Exposure Gates

User-facing probability is blocked unless:

- pattern sample size >= 60,
- out-of-sample windows >= 8,
- ECE <= 0.05,
- Brier score improves over base rate,
- calibration curve is documented,
- decile ranking is directionally monotonic,
- thin sample handling is implemented,
- copy includes horizon, sample size, calibration date, reliability label, and caveat.

Expected return is blocked unless:

- return distribution model is documented,
- P10/P50/P90 coverage is validated,
- transaction cost sensitivity is shown,
- historical period and regime limits are disclosed.

Target price is blocked unless:

- valuation model exists,
- input assumptions are visible,
- scenario range is shown,
- target is tied to time horizon and uncertainty.

## 7. Output Contract After Gate

```json
{
  "forecast": {
    "horizon": "20_trading_days",
    "label": "sector_outperforms_benchmark_20d",
    "probability": 0.58,
    "reliability_label": "calibrated_medium",
    "sample_size": 134,
    "calibration_date": "2026-07-08",
    "brier_score": 0.21,
    "ece": 0.04,
    "caveat": "Historical, sample-observed and calibrated within this universe only."
  }
}
```

## 8. Config

See `config/calibration.yaml`.
