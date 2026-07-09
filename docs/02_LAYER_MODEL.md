# 02. Layer Model

Last updated: 2026-07-08

## 1. Layer Summary

| Layer | Name | Phase | Purpose |
|---|---|---|---|
| 0 | Data & Governance | MVP | 원천, freshness, point-in-time 정합성 |
| 1 | Market Flow | MVP | 시장 흐름과 risk-on/risk-off 상태 |
| 2 | Sector Capacity & Context | MVP | 섹터 상승 여력, participation, 거시 환경 |
| 3 | Sector Leadership & Transition | MVP | 현재 리더, 모멘텀 선두, 리더십 전환 |
| 4 | Validation & Reliability | MVP | historical diagnostics, readiness, guardrails |
| 5 | AI Judgment & Scenario | Expansion | AI 판단, 시나리오, dissenting view |
| 6 | Stock Candidate & Valuation | Expansion | 섹터 판단을 종목 후보로 연결 |
| 7 | Portfolio & Personalized Advice | Expansion | 사용자 보유자산·위험성향 기반 조언 |
| 8 | Execution & Auto Trading | Expansion | 주문안, 브로커 연결, 제한적 자동매매 |
| 9 | Operations, Audit & Risk Control | Required for Expansion | 로그, kill switch, drift, compliance guardrail |

## 2. Layer 0: Data & Governance

### Purpose

모든 판단의 원천 신뢰도를 보장한다. 가격, 거래량, benchmark, sector, macro, catalyst, holdings, future portfolio/order data를 raw와 derived로 분리하고 point-in-time 필드를 보존한다.

### Inputs

- Provider payloads
- CSV/fixture payloads
- Manual catalyst entries
- Config files
- Future: portfolio snapshots and broker events

### Outputs

- Raw store
- Derived store
- Source freshness
- Data quality status
- Run log
- AI/execution allowed status

### Gate Role

Layer 0이 `stale`, `partial`, `failed` 상태이면 Layer 5+ 판단 및 Layer 8 실행은 자동으로 차단한다.

## 3. Layer 1: Market Flow

### Purpose

시장 전체가 risk-on, risk-off, mixed, narrow leadership 중 어디에 있는지 판단한다.

### Core Questions

- benchmark가 강한가?
- 상승 breadth가 넓은가?
- 변동성 압력이 커지는가?
- current RS leader는 어디인가?
- AI가 판단을 생성할 만한 data freshness가 있는가?

### Output

```json
{
  "market_regime": "risk_on_but_narrow",
  "current_rs_leader": "XLK",
  "market_bias": "constructive_but_selective",
  "risks": [],
  "invalidation": []
}
```

## 4. Layer 2: Sector Capacity & Context

### Purpose

섹터 강세가 실제 자금 흐름, 거래량, market context에 의해 확인되는지 판단한다.

### Inputs

- Sector price/volume
- Participation metrics
- Market context series
- Source freshness

### Output

```json
{
  "sector": "XLF",
  "participation_state": "confirmed",
  "macro_context": "supportive",
  "eligible_for_leadership_review": true,
  "risk_flags": []
}
```

## 5. Layer 3: Sector Leadership & Transition

### Purpose

현재 리더와 차기 리더 후보를 분리한다. 현재 RS 리더와 모멘텀 선두가 다를 수 있으며, 이는 오류가 아니라 리더십 전환 관찰 신호다.

### Output

```json
{
  "current_rs_leader": "XLK",
  "momentum_leader": "XLF",
  "lead_pattern": "Late Leader",
  "transition_watch": true,
  "narrative": "...",
  "risks": [],
  "invalidation": []
}
```

## 6. Layer 4: Validation & Reliability

### Purpose

Layer 1~3 판단이 어느 정도 검증 준비가 되었는지 표시한다. 이 레이어는 판단을 더 강하게 만드는 화면이 아니라, 검증 전 문구와 검증된 문구를 분리하는 화면이다.

### Output

```json
{
  "historical_ready": false,
  "sample_size": 0,
  "sample_reliability": "not_ready",
  "allowed_ai_level": 2,
  "blocked_capabilities": ["expected_return", "order_intent"]
}
```

## 7. Layer 5: AI Judgment & Scenario

### Purpose

AI가 Rulebook, validation, freshness, market context를 바탕으로 적극적인 판단을 생성한다.

### Agents

- Market Flow AI
- Sector Rotation AI
- Catalyst AI
- Skeptic AI
- Risk AI
- Report Editor AI
- Guardrail AI

### Output

```json
{
  "base_case": "...",
  "bull_case": "...",
  "bear_case": "...",
  "rotation_case": "...",
  "final_stance": "selective_rotation_watch",
  "confidence": "medium",
  "dissenting_view": "..."
}
```

## 8. Layer 6: Stock Candidate & Valuation

### Purpose

섹터 판단을 개별 종목 후보로 확장한다. 기본값은 비활성화다.

### Required Gates

- Sector model validation
- Symbol/issuer mapping quality
- Fundamental data point-in-time readiness
- Candidate ranking tests
- Guardrail for recommendation wording

## 9. Layer 7: Portfolio & Personalized Advice

### Purpose

사용자 보유자산, 위험성향, 투자기간, 제한조건을 반영해 조언을 개인화한다.

### Required Gates

- User suitability profile
- Portfolio snapshot integrity
- Risk limits
- Advice audit log
- Jurisdiction/compliance policy hook

## 10. Layer 8: Execution & Auto Trading

### Purpose

AI 판단을 주문안 또는 자동 실행으로 연결한다. 이 레이어는 capability gate, user approval, risk gate, audit log, kill switch 없이는 동작할 수 없다.

### Execution Stages

1. Order intent only
2. User-approved order
3. Conditional order with fixed rules
4. Constrained automated trading
5. Adaptive strategy operation

## 11. Layer 9: Operations, Audit & Risk Control

### Purpose

AI 판단, 데이터 snapshot, 모델 버전, 주문 의도, 사용자 승인, 체결, 실패를 모두 추적한다.

### Required for

- Layer 5 AI scenario user-facing output
- Layer 6 stock candidate user-facing output
- Layer 7 personalized advice
- Layer 8 execution and automated trading
