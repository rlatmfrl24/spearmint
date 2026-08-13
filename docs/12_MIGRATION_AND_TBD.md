# 12. 이관·결정 상태·TBD

## 1. 상태 표기

| 상태 | 의미 | 구현 처리 |
| --- | --- | --- |
| `CONFIRMED` | 사용자 결정 또는 승인된 ADR | 그대로 구현; 변경은 새 결정 필요 |
| `PROPOSED` | 현재 권고안 | paper prototype 가능, live gate 근거 아님 |
| `UNVERIFIED` | 과거 힌트/외부 정보, 현재 repo에서 미확인 | M00에서 근거 수집 전 의존 금지 |
| `TBD-BLOCKING` | live/중요 경계를 위해 반드시 결정 | 값이 없으면 fail-closed |
| `TBD-NONBLOCKING` | 해당 milestone 전까지 결정 가능 | backlog와 owner 유지 |

## 2. 현재 결정 register

### 2.1 CONFIRMED

| ID | 결정 |
| --- | --- |
| C-001 | 국내 유동성 ETF·대형주, 15분~5거래일을 1차 범위로 한다. |
| C-002 | long/cash-only이며 leverage, short, 손실 position 물타기를 금지한다. |
| C-003 | KIS paper를 첫 broker vertical slice로 한다. |
| C-004 | 전략 family는 trend, mean reversion, event다. |
| C-005 | AI는 event/risk overlay multiplier 0..1만 제공하고 exposure를 늘릴 수 없다. |
| C-006 | AI는 주문, risk 우회, 전략 승격, 자기수정을 할 수 없다. |
| C-007 | 독립 risk engine과 single fenced executor, broker reconciliation을 둔다. |
| C-008 | 외부 broker를 포함한 end-to-end exactly-once를 주장하지 않는다. |
| C-009 | 전략 교체는 강건한 검증, paper/shadow, 사람 승인, rollback을 요구한다. |
| C-010 | 초기 물리 단위는 data/decision/control/research 4 backend와 web이며 과도한 microservice를 피한다. |
| C-011 | Docker Compose부터 시작하고 Kubernetes 등은 측정 trigger 뒤 검토한다. |
| C-012 | `live_enabled=false`가 기본이며 이 문서는 실거래를 승인하지 않는다. |
| C-013 | 첨부 ISA·IRP·연금저축 자료는 단기 자동매매 범위 밖이다. |

### 2.2 PROPOSED

| ID | 제안 | 승인/검증 시점 |
| --- | --- | --- |
| P-001 | Python 3.13, FastAPI, asyncio, Pydantic, Polars | M00 toolchain 확인 후 M01 ADR |
| P-002 | Redpanda/Kafka, Protobuf/gRPC, schema registry | M01 local spike |
| P-003 | Postgres+Timescale, Parquet/S3, Redis ephemeral | M01/M02 load·ops 검증 |
| P-004 | vectorbt screen + LEAN event replay | M07 reproducibility spike |
| P-005 | Dagster, MLflow, DVC | M07 workflow/lineage 검증 |
| P-006 | Prometheus/Grafana/Alertmanager/OTel/Loki | M01/M06 기존 stack 확인 |
| P-007 | DSR ≥0.95, PBO 목표 ≤0.10, paper ≥30 거래일 | risk/research owner 승인 |
| P-008 | AI failure 시 neutral multiplier 1 또는 더 보수적 fixed fallback | strategy별 risk review |
| P-009 | MVP에서 control-plane 내부 별도 risk process 후 필요 시 분리 | failure isolation 측정 |
| P-010 | frontend React/Vite 유지 | M00에서 실제 상태·건강성 확인 |

### 2.3 UNVERIFIED legacy hints

과거 대화/프로젝트 기억에는 다음이 언급됐으나 이 package를 작성할 때 repository에 접근해 확인하지 못했다.

- GitHub repository 이름 또는 위치: `rlatmfrl24/spearmint` 가능성
- React/Vite frontend와 Cloudflare 배포
- Alpaca paper integration
- Gmail/Notion 연동

이 정보는 migration 대상 식별을 위한 검색어일 뿐이다. M00에서 실제 file, commit, deployment를 확인하기 전 삭제·유지·교체 결정을 내리지 않는다.

## 3. TBD register

### 3.1 Paper MVP 전 결정

| ID | 질문 | 상태/owner | 안전한 default |
| --- | --- | --- | --- |
| T-001 | 실제 repository URL/branch와 배포 대상은? | `TBD-BLOCKING`, owner | read-only M00만 수행 |
| T-002 | KIS paper app/account와 REST/WS capability·rate/subscription limit은? | `TBD-BLOCKING`, broker owner | simulator, credential 없으면 contract test skip |
| T-003 | MVP 정확한 allowlist와 liquidity 기준은? | `TBD-BLOCKING`, owner+risk | 소수 paper symbol, live 금지 |
| T-004 | 거래 session/auction/halt/order type 정책은? | `TBD-BLOCKING`, risk | 정규장 limit order만 또는 주문 차단 |
| T-005 | paper에서 사용할 가상 capital과 position/turnover/loss limit은? | `TBD-BLOCKING`, risk | config sample은 PROPOSED, live 불가 |
| T-006 | market/news/DART/GDELT data license·retention은? | `TBD-BLOCKING`, owner/legal | metadata/허용 raw만, 외부 재배포 금지 |
| T-007 | 기존 frontend/backend/toolchain 중 보존 대상은? | `TBD-BLOCKING`, M00 | 삭제 금지 |
| T-008 | 개발/CI 배포 platform과 secret manager는? | `TBD-NONBLOCKING`, platform | local Compose, secret 미주입 |

### 3.2 Limited live 전 결정

| ID | 질문 | 안전 gate |
| --- | --- | --- |
| T-101 | 승인 자본, 종목·position·daily/weekly loss·drawdown·turnover 한도 | 모두 approved numeric 값 없으면 live startup 실패 |
| T-102 | operator/approver/on-call과 escalation 연락망 | 24/7 여부 포함 roster 없으면 live 금지 |
| T-103 | RTO/RPO, backup/restore와 DR 장소 | rehearsal 결과 없으면 live 금지 |
| T-104 | kill/cancel-all/reduce-only/flatten 정책과 권한 | 의미·시장충격·second approval 확정 |
| T-105 | KIS live vs paper 차이와 오류 code/timeout 관측 | small dry run+capability matrix |
| T-106 | 주문 가격 band, slippage, participation/capacity | 보수적 수치와 test |
| T-107 | 세금·수수료·규제·broker 약관·market data license | 적격 검토 완료 기록 |
| T-108 | strategy promotion/rollback safe window와 open position ownership | rehearsal 통과 |
| T-109 | live enable 승인 만료·회수·break-glass | two-person audited workflow |

## 4. 기존 repository 이관 방법

### 4.1 원칙

- target architecture는 방향이지 기존 코드를 무조건 폐기하는 명령이 아니다.
- 먼저 characterization test로 현재 동작을 고정한다.
- adapter/strangler 방식으로 한 flow씩 교체한다.
- broker write path는 마지막에 바꾸며, 동시에 두 writer를 켜지 않는다.
- old/new shadow 비교와 rollback 기간을 둔다.

### 4.2 Keep/adapt/replace 판단표

M00에서 각 component에 채운다.

| Component | 현재 근거 | 안전/계약 적합성 | 결정 | Parity test | Rollback |
| --- | --- | --- | --- | --- | --- |
| frontend | UNKNOWN | UNKNOWN | inspect | status/action E2E | old deployment |
| broker adapter | UNKNOWN | UNKNOWN | inspect | adapter contract | paper simulator |
| strategy | UNKNOWN | UNKNOWN | inspect | golden signal replay | shadow old logic |
| data store | UNKNOWN | UNKNOWN | inspect | row/event checksum | dual-read window |
| deployment | UNKNOWN | UNKNOWN | inspect | health/smoke | previous artifact |

결정 criteria:

- `KEEP`: 계약·test·보안 경계를 만족하고 유지 비용이 낮음
- `ADAPT`: core 동작은 유효하나 port/adapter 또는 schema wrapper 필요
- `REPLACE`: safety/재현성/유지보수 조건을 충족하기 어렵고 parity/rollback 가능
- `REMOVE`: 사용처 없음이 실제 검색·runtime·owner 확인으로 증명됨
- `UNKNOWN`: 근거 부족; 변경 금지

### 4.3 단계적 strangler 순서

1. observability/correlation을 기존 flow에 추가
2. broker simulator와 characterization fixtures 확보
3. canonical contract와 anti-corruption adapter 추가
4. raw event/outbox/inbox/ledger를 shadow로 생성
5. old/new normalized/decision 결과 비교
6. paper read path 전환
7. paper order writer를 safe window에서 single handoff
8. 충분한 reconciliation/rollback 관찰 후 legacy code 제거 제안

## 5. 외부 연동 이관

### Alpaca가 실제 존재하는 경우

- 즉시 삭제하지 않고 `BrokerAdapter` contract의 reference/simulator 역할 평가
- account/order semantics 차이를 capability matrix로 기록
- KIS paper parity가 확보될 때까지 paper-only path 보존 가능
- 같은 account/environment에 두 executor가 write하지 않게 config/ACL 차단

### Cloudflare가 실제 존재하는 경우

- frontend hosting 또는 edge API 범위를 확인
- broker secret·order write가 edge/client에 있으면 critical finding으로 분리
- WebSocket/SSE, server runtime, long-lived connection 제약을 실제 plan과 대조
- 적합하면 web hosting은 보존하고 backend plane은 별도 운영 가능

### Gmail/Notion이 실제 존재하는 경우

- notification/reporting의 optional outbound adapter로만 격리
- 주문·risk·promotion의 authoritative state로 사용하지 않음
- 민감한 account/order data 최소화와 permission/retention 검토
- 연동 장애가 trading path를 막거나 risk를 완화하지 않도록 async 처리

### Toss adapter

- 공식 API 계약/접근권한/capability/rate limit이 확인되기 전에는 skeleton 이상 구현하지 않는다.
- KIS core domain이 provider-specific field에 오염되지 않았다는 portability test로 사용한다.
- multi-broker routing은 별도 ADR와 risk project이며 MVP 범위 밖이다.

## 6. 첨부 자료 처리

입력으로 제공된 두 자료는 ISA, IRP, 연금저축, 장기 투자 상품 비교 내용이다. Spearmint의 단기·중립적 자동매매 architecture 결정에 직접 사용하지 않았다.

추후 연결하려면 별도 경계를 둔다.

- `capital-policy`는 사람 승인된 장기 자산배분/현금 한도를 read-only 제공
- 자동 매매 engine은 연금/절세 account에 주문하지 않음
- 계좌 유형별 규정·세금·상품 허용 범위는 전문가 검토
- 첨부 문서의 수치/추천을 실시간 risk limit이나 전략 parameter로 자동 전환하지 않음

## 7. 문서와 코드의 차이 처리

1. 차이를 발견한 agent는 사실 근거와 영향 범위를 기록한다.
2. safety invariant와 충돌하면 구현을 멈추고 fail-closed behavior를 유지한다.
3. 단순 implementation detail이면 문서 또는 코드를 같은 PR에서 정합화한다.
4. architecture/scope 결정이면 ADR을 Proposed로 만들고 owner 승인 전 확정하지 않는다.
5. `PROPOSED`/`TBD`를 숨기기 위해 임의 값을 넣지 않는다.

## 8. M00 종료 시 이 문서에서 갱신할 것

- UNVERIFIED legacy hint 각각을 CONFIRMED/REJECTED로 전환하고 근거 path/commit 추가
- 실제 build/test/run/deploy 명령
- repository layout과 nested `AGENTS.md` 필요 위치
- dependency/version와 current vulnerabilities
- 현재 data/order/risk flow와 broker write credential 경계
- 기존 환경/배포/DB migration/backup 사실
- T-001, T-002, T-007, T-008 owner와 다음 결정일
- 승인된 M01 architecture deviations와 ADR link
