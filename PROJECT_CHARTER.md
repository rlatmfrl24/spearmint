# Project Charter: AI Market Decision OS

Last updated: 2026-07-08
Status: **Source Complete v2 — primary market, database, deployment, provider, broker, regulation, and calibration decisions filled**

## 1. One-line Definition

**AI Market Decision OS**는 미국 S&P 500 섹터 ETF 시장을 1차 대상으로 삼아 섹터 리더십, 전환, false leadership, 리스크 신호를 설명하고, 검증이 쌓이면 AI 판단, 종목 후보, 개인화 포트폴리오 조언, 주문 실행, 제한적 자동매매까지 단계적으로 확장하는 투자 의사결정 운영체제다.

## 2. Fixed Product Decisions

| Area | Decision |
|---|---|
| Phase 1 target market | **U.S. S&P 500 Sector ETF universe** |
| Benchmark | **SPY** |
| Primary sector universe | XLC, XLY, XLP, XLE, XLF, XLV, XLI, XLB, XLRE, XLK, XLU |
| Primary database | **Postgres** as canonical system of record |
| Cloudflare role | Workers/Pages API and UI edge, Hyperdrive to Postgres, R2 for raw objects/artifacts, Queues/Cron for orchestration |
| D1 role | Optional edge cache/config/status only, not canonical analytical DB |
| Price provider strategy | Vendor adapter for U.S. ETF OHLCV, default provider profile `massive_us_stocks`; fixtures for tests |
| Official supporting data | SEC EDGAR for filings/XBRL, FRED/ALFRED for macro/vintage data |
| Universe/issuer references | State Street Select Sector ETFs and S&P sector/GICS references; holdings ingestion is license-gated |
| Future broker API | **Interactive Brokers Web API** as strategic broker adapter target for Phase 7+ |
| Regulatory posture | Research-only MVP; advice/execution/auto-trading requires jurisdiction gate, legal memo, user suitability, audit, and broker/compliance approval |
| Forecast calibration | Walk-forward, relative forward labels, reliability diagrams, Brier/log loss/ECE, and minimum sample gates before probabilities/expected returns are exposed |

## 3. Product Thesis

시장은 개별 종목 하나만으로 움직이지 않는다. 큰 흐름은 시장 regime, 섹터 리더십, 섹터 내부 breadth, 거래량 participation, catalyst, 거시 환경의 조합으로 나타난다. 이 프로젝트는 이 흐름을 먼저 구조화한 뒤, 검증된 범위 안에서 AI가 점점 더 적극적인 판단을 수행하도록 설계한다.

초기 MVP는 “무엇을 사라”가 아니라 “시장에서 어떤 힘이 움직이는가”를 설명한다. 장기적으로는 이 설명을 종목 후보, 사용자 포트폴리오, 주문 의도, 자동 실행으로 연결한다.

## 4. Product Phases

| Phase | 제품 성격 | 사용자 노출 기능 | Default gate |
|---|---|---|---|
| Phase 1 | Sector Radar MVP | 시장 흐름, 섹터 리더십, 전환 신호, 리스크, 무효화 조건 | Research only |
| Phase 2 | AI-assisted Research | Layer별 AI 해석, cross-layer research brief | AI Level 1 |
| Phase 3 | AI Judgment Engine | AI scenario, sector stance, rotation watch, dissenting view | AI Level 2 |
| Phase 4 | Validated Forecasting | 검증된 범위의 확률·기대수익·리스크 분포 | AI Level 3 + calibration gate |
| Phase 5 | Stock Candidate Funnel | 섹터 내부 종목 후보와 밸류에이션 후보 | AI Level 4 + security-data gate |
| Phase 6 | Portfolio Advice | 사용자 위험성향·보유자산 기반 개인화 조언 | AI Level 5 + jurisdiction/suitability gate |
| Phase 7 | Broker-connected Orders | 사용자 승인 전제 주문안 생성 및 브로커 연동 | AI Level 6 + broker sandbox + approval |
| Phase 8 | Constrained Auto Trading | 제한된 리스크 한도 내 자동 실행 | AI Level 7 + paper/shadow/live gates |
| Phase 9 | Adaptive AI Operation | 감사·운영·리스크 통제 기반 자율 운용 확장 | AI Level 8 + enterprise governance |

## 5. Active Scope for Initial MVP

MVP는 다음을 구현한다.

- 미국 S&P 500 섹터 ETF universe와 SPY benchmark
- relative strength, RS ratio, RS momentum, RRG quadrant
- ETF-level participation, market breadth proxy, future holdings breadth placeholder
- FRED/ALFRED 기반 macro/risk proxy
- SEC EDGAR 기반 filings/fundamental reference hooks
- manual catalyst ledger
- source registry, license gate, data freshness
- Postgres raw/derived/validation/ai/ops schema
- Cloudflare Workers/Pages API and UI shell
- R2 raw object archive and report artifact archive
- sector rulebook 기반 패턴 해석
- Layer 1~4 dashboard
- historical validation skeleton
- research brief export skeleton

## 6. Deferred Strategic Scope

아래 기능은 현재 phase에서는 user-facing으로 구현하지 않는다. 그러나 장기 비전에서는 핵심 기능이다.

- 자동 매매
- 브로커 주문 연결
- 개인화된 매수·매도 조언
- 목표가 제시
- 기대수익률 제시
- 검증된 상승/하락 확률 제시
- 뉴스 AI 기반 catalyst 판단
- 개별 종목 추천과 Stock Candidate Funnel
- 포트폴리오 비중 제안

이 기능들은 `docs/10_CAPABILITY_GATES.md`, `docs/11_RISK_GOVERNANCE.md`, `docs/18_BROKER_AND_EXECUTION_SELECTION.md`, `docs/19_REGULATORY_SCOPE.md`, `docs/20_FORECAST_CALIBRATION.md`의 조건을 충족한 뒤 feature flag로 단계적으로 개방한다.

## 7. Non-negotiable Principles

1. 지표를 평균 점수 하나로 합치지 않는다.
2. module disagreement는 노이즈가 아니라 신호다.
3. `state`와 `transition`을 분리한다.
4. raw data와 derived data를 분리한다.
5. point-in-time 원칙을 지킨다: `known_at <= asof_at`.
6. 모든 판단에는 `narrative`, `risks`, `invalidation`, `data_freshness`, `validation_status`가 있어야 한다.
7. AI는 적극적인 판단자로 확장할 수 있지만, capability gate와 audit log 밖에서 실행 권한을 갖지 않는다.
8. UI는 API contract에만 의존하고 지표를 직접 계산하지 않는다.
9. 테스트는 deterministic fixture를 우선하며 unit test는 네트워크를 호출하지 않는다.
10. 검증되지 않은 투자 성과 주장, 보정된 확률처럼 보이는 문구, 실행 가능 주문 제안은 현재 phase에서 노출하지 않는다.
11. 미래 기능은 코드 구조에서 미리 수용하되 기본값은 비활성화한다.
12. 데이터 공급자 라이선스가 확정되지 않은 데이터는 내부 연구/fixture 이상의 목적으로 사용하지 않는다.

## 8. Core User Questions

- 현재 어느 섹터가 SPY보다 강한가?
- 그 강세는 모멘텀과 거래량 participation이 확인하는가?
- 현재 RS 리더가 약화되는 중인가?
- 차기 리더 후보는 어디인가?
- 가짜 강세 또는 좁은 리더십 위험은 없는가?
- macro/risk proxy는 이 리더십을 지지하는가?
- 어떤 조건이면 현재 판단을 철회해야 하는가?
- AI는 이 상황을 어떤 base/bull/bear/rotation scenario로 해석하는가?
- 향후 종목 후보나 포트폴리오 조언으로 확장하려면 어떤 검증이 더 필요한가?

## 9. Definition of Done for MVP

- 모든 섹터 판단이 core output contract를 충족한다.
- current RS leader와 momentum leader가 분리되어 표시된다.
- Layer별 source freshness와 license gate 상태가 표시된다.
- Rulebook pattern과 veto가 테스트된다.
- Layer 4는 validation readiness와 sample reliability를 표시한다.
- API contract test가 존재한다.
- dashboard가 fixture 데이터와 Postgres-backed snapshot으로 동작한다.
- Cloudflare Workers API는 Postgres 직접 heavy query를 실행하지 않고 snapshot/materialized read path를 사용한다.
- R2 raw archive와 Postgres run log가 연결된다.
- `features.yaml`에서 Layer 5+ 고위험 기능은 명시적으로 비활성화된다.

## 10. Naming Convention

프로젝트 내부 명칭은 `AI Market Decision OS`를 사용한다. MVP 기능명은 `Sector Radar`를 사용할 수 있다.

```text
AI Market Decision OS
  Sector Radar MVP
  AI Decision Layer
  Stock Candidate Layer
  Portfolio Advice Layer
  Execution Layer
```


## Loop Engineering Development Model

This repository uses loop engineering as the default Codex development model.

A loop is a bounded, reusable work contract with a trigger, goal, verification step, stopping rule, memory, and named terminal state. It is used to make agentic coding repeatable and auditable.

This is distinct from the product's market-analysis loops. Development loops guide implementation work; product loops, data loops, AI judgment loops, and execution loops remain controlled by feature and capability gates.

Loop engineering is required for:

- metric modules
- rulebook patterns
- provider adapters
- API endpoints
- dashboard layers
- validation replay
- AI judgment agents
- report generation
- Postgres migrations
- Cloudflare API/deployment changes
- package self-evaluation and release handoff

The loop engineering source of truth is:

```text
docs/22_LOOP_ENGINEERING.md
docs/23_LOOP_LIBRARY.md
docs/24_AGENTIC_RUNBOOK.md
config/loops.yaml
config/agent_roles.yaml
config/quality_gates.yaml
loops/
loop_memory/
```
