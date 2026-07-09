# 04. Metrics and States

Last updated: 2026-07-08

## 1. Metric Module Contract

Every metric module is a pure calculation unit. It must not call providers, databases, APIs, LLMs, or UI code.

Input:

```text
series data
benchmark data
config thresholds
asof date
```

Output:

```json
{
  "state": "strong",
  "transition": "strengthening",
  "direction": "up",
  "strength": 3,
  "evidence": {},
  "warnings": []
}
```

## 2. Standard Enums

### `state`

```text
strong
neutral
weak
leader
laggard
confirmed
unconfirmed
supportive
hostile
unknown
insufficient_data
```

### `transition`

```text
strengthening
weakening
stable
turning_up
turning_down
mixed
unknown
```

### `direction`

```text
up
down
flat
mixed
unknown
```

### `strength`

```text
-3 strong negative
-2 moderate negative
-1 weak negative
 0 neutral / unknown
 1 weak positive
 2 moderate positive
 3 strong positive
```

## 3. Relative Strength

Formula:

```text
rs_raw = sector_close / benchmark_close
rs_ratio = 100 * rs_raw / SMA(rs_raw, rs_window)
rs_momentum = 100 * rs_ratio / SMA(rs_ratio, momentum_window)
```

Default RRG quadrant:

| Condition | Quadrant |
|---|---|
| `rs_ratio >= 100 and rs_momentum >= 100` | Leading |
| `rs_ratio < 100 and rs_momentum >= 100` | Improving |
| `rs_ratio >= 100 and rs_momentum < 100` | Weakening |
| `rs_ratio < 100 and rs_momentum < 100` | Lagging |

RRG `Leading` is an observed state. It is not the same as Rulebook high conviction.

## 4. Momentum

Minimum fields:

```text
rs_momentum
rs_momentum_delta_5d
rs_momentum_delta_20d
price_return_5d
price_return_20d
```

## 5. Breadth

Minimum metrics:

```text
pct_above_20ma
pct_above_50ma
pct_above_200ma
advancing_ratio
```

When holdings/constituents are not available, breadth may be marked as proxy, partial, or unavailable. Do not pretend ETF price alone is breadth.

## 6. Participation

Minimum metrics:

```text
rvol_20
obv_slope_20
cmf_20
volume_confirmed_breakout
```

Participation is confirmation, not a standalone buy/sell signal.

## 7. Market Context

Recommended fields:

```text
volatility_pressure
credit_risk
liquidity_proxy
small_cap_appetite
dollar_pressure
rate_pressure
macro_context_state
```

Context can support or weaken sector interpretation but must not override missing primary data silently.

## 8. Catalyst

MVP catalyst is manual ledger only.

```yaml
sector_code: SMH
catalyst_type: structural
state: positive
transition: strengthening
confidence: high
effective_date: 2026-07-08
source_note: "Manual analyst note"
stale_after: 2026-08-08
```

Future news AI catalyst requires Layer 5+ capability gates.

## 9. Missing Data Rules

- Insufficient lookback returns `insufficient_data`, not an exception unless contract is violated.
- Missing benchmark returns `unknown` and blocks high conviction.
- Zero volume returns participation warning.
- Flat price must be tested.
- Negative volume is data quality error.
- No fake fallback values.

## 10. Threshold Management

Thresholds must live in config.

```yaml
relative_strength:
  rs_window: 50
  momentum_window: 10
  strong_ratio: 102
  weak_ratio: 98
participation:
  rvol_confirmed: 1.2
  cmf_positive: 0.05
breadth:
  healthy_50ma_pct: 0.60
```

## 11. Tests Required for Every Metric

- Normal trend synthetic case
- Weak trend synthetic case
- Missing data case
- Flat price case
- Zero volume case where applicable
- Insufficient lookback case
- Threshold boundary case
