# 07. UI Spec

Last updated: 2026-07-08
Status: Updated for U.S. sector ETF MVP and license/freshness gates

## 1. Product Shape

The UI is a dense research dashboard, not a marketing landing page.

Active MVP market:

```text
U.S. S&P 500 Sector ETF Radar
Benchmark: SPY
Universe: XLC, XLY, XLP, XLE, XLF, XLV, XLI, XLB, XLRE, XLK, XLU
```

## 2. Dashboard Shell

```text
Top Bar
  as_of
  market code
  benchmark
  data mode
  Postgres snapshot timestamp
  validation gate
  source/license status
  active layer freshness

Layer Switch
  Layer 1 Market Flow
  Layer 2 Capacity & Context
  Layer 3 Leadership & Transition
  Layer 4 Validation & Reliability
  Future: Layer 5 AI Scenario

Surface Switch
  Results
  Collection
  Validation
```

## 3. Layer 1 UI

Shows:

- market regime
- benchmark tape
- current RS leader
- momentum leader
- narrow/broad leadership cue
- risk-on/risk-off/mixed context

Must show if data is stale or license-blocked.

## 4. Layer 2 UI

Shows:

- sector participation
- breadth proxy scope
- FRED macro/risk context
- source cadence and stale state
- risk trigger watchlist

Must distinguish:

```text
holdings breadth available
proxy breadth only
breadth unavailable
license blocked
```

## 5. Layer 3 UI

Shows:

- current RS leader detail
- momentum leader detail
- RRG quadrant/path
- selected sector inspector
- narrative, risks, invalidation
- module disagreement as signal

Current RS leader and momentum leader may differ. This is not an error.

## 6. Layer 4 UI

Shows:

- validation readiness
- replay coverage
- sample reliability
- calibration status
- blocked capabilities
- copy guardrails

Do not show probabilities, expected returns, or target prices unless calibration and capability gates allow it.

## 7. Future UI Gates

Layer 5 AI scenario may be visible if Level 2 gate passes.

Layer 6+ stock, advice, and execution views must show locked/gated state by default:

```text
feature_disabled
validation_not_ready
calibration_not_ready
jurisdiction_blocked
broker_disabled
risk_gate_missing
```

## 8. Forbidden UI Behavior

- Calculating financial metrics in React components.
- Hiding source/license warnings.
- Showing stale data as current.
- Rendering fake numbers for unavailable functions.
- Displaying buy/sell/target/expected-return copy before gates pass.
- Offering order buttons before broker, risk, jurisdiction, and audit gates pass.

## 9. Allowed Copy in MVP

```text
리서치 관점에서 강세가 확인됩니다.
현재 RS 리더와 모멘텀 선두가 달라 전환 관찰 구간입니다.
이 판단은 RS Momentum이 2주 연속 둔화되면 약화됩니다.
표본 관측치는 보정 완료 확률이 아니라 historical diagnostics입니다.
데이터 라이선스 상태가 확인되지 않아 일부 표시가 제한됩니다.
```

## 10. Contract

The UI must consume `GET /api/sectors`, `GET /api/data/status`, and `GET /api/validation`. No UI component should import metric modules.
