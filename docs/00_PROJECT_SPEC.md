# 00. 프로젝트 명세

## 1. 제품 정의

**Spearmint Quant Evolution**은 국내 유동성 ETF·대형주의 15분~5영업일 전략을 연구, 모의실행, 검증, 제한적 실전 전환할 수 있는 개인/소규모 운용용 퀀트 플랫폼이다.

제품의 핵심 가치는 다음 세 가지다.

1. **같은 입력을 다시 재생할 수 있음** — 실시간 판단이 어떤 데이터와 코드로 발생했는지 재현한다.
2. **모호한 주문 실패를 안전하게 닫음** — 중복 주문보다 거래 중단을 선택한다.
3. **전략의 연구와 자본 승격을 분리함** — 좋은 백테스트만으로 전략이 자동 교체되지 않는다.

## 2. 문제 정의

일반적인 개인 자동매매 구현은 다음 문제를 가진다.

- WebSocket 수신 코드를 전략에 직접 연결해 단절·중복·역순 데이터를 재현하지 못한다.
- 백테스트와 실전의 signal, fill, fee, slippage 모델이 달라 결과가 과대평가된다.
- 주문 timeout을 실패로 간주해 재전송하며 중복 체결 위험을 만든다.
- 공시·뉴스·수정 재무데이터의 실제 공개시점을 기록하지 않아 미래정보가 누출된다.
- 수많은 파라미터 중 최고 결과만 선택하고 trial 수를 숨긴다.
- 애플리케이션 배포와 전략 자본 승격을 같은 canary 개념으로 처리한다.
- AI가 설명 도구를 넘어 주문 또는 risk 결정을 사실상 지배한다.

Spearmint는 이 문제들을 성능 최적화보다 먼저 해결한다.

## 3. 사용자와 행위자

| 행위자 | 책임/권한 |
| --- | --- |
| Owner/Operator | universe·risk·promotion 승인, kill switch, 실거래 전환 |
| Researcher | 논문·가설 등록, 데이터셋·실험·백테스트 생성 |
| Strategy runtime | deterministic signal과 `OrderIntent` 생성 |
| AI overlay | 이벤트 해석, 신뢰도·위험 축소 배수 제공 |
| Risk engine | hard limit 적용, 승인/거절; 우회 불가 |
| OMS/Executor | 승인된 intent를 broker order로 변환하고 상태 추적 |
| Broker adapter | KIS/Toss 프로토콜·rate limit·조회·주문 추상화 |
| Promotion controller | 증거 수집, 승인 워크플로, champion alias 변경 |
| Observer | dashboard·보고서 읽기만 가능; 주문 권한 없음 |

## 4. 제품 범위

### 4.1 포함

- KIS 모의투자 시세·주문·체결·잔고 연동
- WebSocket 실시간 시세, REST snapshot/주문/조회
- OpenDART 공시, ECOS 거시지표, 선택적 GDELT 이벤트 수집
- raw/normalized/bar/feature 데이터 계층과 결정적 replay
- 추세·평균회귀·이벤트 전략 SDK
- long/cash 포트폴리오와 독립 hard risk
- OMS 주문 상태기계, 부분체결·취소·timeout 처리
- broker와 내부 ledger의 정기/이벤트 기반 대사
- vectorized screening과 event-driven backtest
- 논문 메타데이터·가설·구현·실험 lineage
- champion 1개와 shadow challenger N개의 비교
- 사람 승인, 제한 자본, 즉시 rollback 기반 승격
- 운영 dashboard, 경보, 감사 로그, 일일 reconciliation 보고서
- dev/paper/live 환경과 credential 분리

### 4.2 제외

- HFT, co-location, direct exchange feed, sub-millisecond execution
- 옵션·선물·마진·공매도·암호화폐
- 레버리지 ETF를 포함한 레버리지 운용
- AI 자율 주문, AI 자율 전략 작성·배포·승격
- 실거래 자본의 무인 증액
- 외부 고객 대상 주문 대행·투자자문 SaaS
- ISA·IRP·연금저축의 장기 자산배분 자동화
- 세금 신고·회계 장부의 법적 대체

## 5. 전략 및 자본 불변조건

`INV-*`는 코드, 테스트, risk policy에 중복으로 표현한다.

| ID | 불변조건 |
| --- | --- |
| INV-001 | net exposure는 0 이상이며 short가 될 수 없다. |
| INV-002 | 현금·승인된 보유자산 범위를 넘는 주문을 거절한다. |
| INV-003 | 손실 중인 기존 long 포지션의 수량을 늘리는 주문을 거절한다. |
| INV-004 | AI overlay 배수는 0~1이며 원 signal보다 노출을 늘릴 수 없다. |
| INV-005 | 전략은 broker credential과 broker order API에 접근하지 않는다. |
| INV-006 | challenger는 broker order permission이 없다. |
| INV-007 | 모든 order intent는 한 번의 risk decision과 연결된다. |
| INV-008 | 결과 불명 주문은 조회·대사 전까지 재제출하지 않는다. |
| INV-009 | live 활성화, champion 교체, risk limit 완화에는 사람 승인이 필요하다. |
| INV-010 | strategy code/model/policy는 자기 자신을 수정하거나 배포할 수 없다. |

## 6. 기능 요구사항

### 6.1 데이터 수집·정규화

| ID | 요구사항 | 완료 증거 |
| --- | --- | --- |
| FR-DATA-001 | KIS WebSocket 연결·재연결·heartbeat·sequence gap을 관리한다. | 단절/복구 통합 테스트와 gap metric |
| FR-DATA-002 | 수신 원문을 변환 전에 immutable raw log로 보존한다. | 하루 입력을 byte/hash로 조회 가능 |
| FR-DATA-003 | snapshot과 delta를 canonical market event로 정규화한다. | schema contract test |
| FR-DATA-004 | 모든 이벤트에 event/provider/ingest/available time을 저장한다. | DB/schema test |
| FR-DATA-005 | duplicate, out-of-order, stale, missing field를 격리한다. | quality fixture와 dead-letter 기록 |
| FR-DATA-006 | 거래일·시간대·휴장·종목상태·corporate action을 point-in-time으로 관리한다. | 과거일 replay fixture |
| FR-DATA-007 | OpenDART/ECOS/GDELT 수집은 source/version/license metadata를 보존한다. | lineage 조회 |

### 6.2 Feature·판단

| ID | 요구사항 | 완료 증거 |
| --- | --- | --- |
| FR-DEC-001 | 동일 ordered events와 config는 동일 feature·signal을 만든다. | deterministic replay hash |
| FR-DEC-002 | feature는 `available_at <= decision_time` 조건을 강제한다. | 미래정보 sentinel test |
| FR-DEC-003 | 시장 상태와 전략 상태를 versioned snapshot으로 저장한다. | decision trace 조회 |
| FR-DEC-004 | 전략은 typed `OrderIntent`만 발행한다. | broker import 금지 architecture test |
| FR-DEC-005 | AI 장애·timeout·schema 오류는 사전 정책대로 neutral 또는 closed 처리한다. | fault test |

### 6.3 Risk·OMS·실행

| ID | 요구사항 | 완료 증거 |
| --- | --- | --- |
| FR-CTL-001 | global/account/strategy/symbol risk limit을 독립 적용한다. | policy matrix unit/property tests |
| FR-CTL-002 | stale feed, daily/weekly loss, position mismatch, clock drift에서 신규 진입을 차단한다. | fault-injection E2E |
| FR-CTL-003 | 모든 intent는 안정적인 idempotency key를 가진다. | duplicate submission test |
| FR-CTL-004 | 주문 상태는 명시적 상태기계로만 전이한다. | transition property test |
| FR-CTL-005 | timeout은 `UNKNOWN` 후 broker 조회·대사로 해결한다. | ambiguous timeout scenario |
| FR-CTL-006 | 부분체결·취소 경쟁에서 remaining quantity와 position limit을 재계산한다. | broker simulator tests |
| FR-CTL-007 | 내부 position/cash/order와 broker snapshot을 일일 및 이벤트 기반 대사한다. | reconciliation report |
| FR-CTL-008 | kill switch는 global/strategy/symbol 범위를 지원하고 감사된다. | operator E2E와 audit record |

### 6.4 연구·검증·승격

| ID | 요구사항 | 완료 증거 |
| --- | --- | --- |
| FR-RSCH-001 | 논문 ID, 버전, 가설, 데이터, horizon, 비용 가정, 실패 조건을 기록한다. | research record |
| FR-RSCH-002 | 모든 실험은 code/data/config/environment digest와 trial 수를 기록한다. | MLflow/DVC lineage |
| FR-RSCH-003 | 빠른 screening 후 event-driven replay를 필수 통과한다. | linked run IDs |
| FR-RSCH-004 | purging/embargo, walk-forward/CPCV, DSR/PBO, 비용·regime stress를 실행한다. | validation report |
| FR-RSCH-005 | challenger는 live feed shadow signal과 가상체결만 생성한다. | ACL test |
| FR-RSCH-006 | promotion은 versioned policy와 사람 승인, rollback target을 요구한다. | signed manifest/audit |
| FR-RSCH-007 | champion 교체 중 orphan order나 position ownership 공백이 없어야 한다. | transition rehearsal |

### 6.5 운영 UI·보고

| ID | 요구사항 | 완료 증거 |
| --- | --- | --- |
| FR-OPS-001 | feed freshness, consumer lag, signal/risk/order latency를 표시한다. | dashboard panels |
| FR-OPS-002 | signal→risk→order→fill을 correlation ID로 추적한다. | trace link |
| FR-OPS-003 | broker/internal mismatch와 미해결 UNKNOWN 주문을 최상위 경보로 표시한다. | alert test |
| FR-OPS-004 | 승인·kill switch·risk 변경은 재확인과 reason을 요구한다. | UI E2E |
| FR-OPS-005 | 일일 paper/live 결과를 비용·slippage·오류까지 요약한다. | generated report fixture |

## 7. 비기능 요구사항

### 7.1 정확성과 재현성

- raw event는 append-only로 보존하고 payload hash를 기록한다.
- 모든 계산은 versioned code/config/data digest를 가진다.
- money/quantity는 `Decimal` 또는 DB `NUMERIC`을 사용한다.
- event time과 processing time을 분리한다.
- CI에서 미래정보 sentinel과 replay golden test를 실행한다.

### 7.2 설계 SLO

아래는 관측치가 아니라 초기 설계 목표다. 실제 KIS 계정·네트워크 측정 후 확정한다.

| 구간 | 초기 목표 |
| --- | --- |
| WebSocket ingest→canonical event | p95 ≤ 1초 |
| feature 갱신 | p95 ≤ 1초 |
| numeric strategy 판단 | p95 ≤ 100ms |
| hard risk decision | p95 ≤ 50ms |
| broker REST acknowledgement | p95 ≤ 2초(외부 의존) |
| 가격 기반 event→order acknowledgement | p95 ≤ 3초 |
| stale-data 감지 | 설정 freshness의 1주기 이내 |

15분 이상 horizon이므로 latency보다 누락·순서·복구가 우선이다.

### 7.3 신뢰성과 복구

- consumer 재시작 후 offset과 상태를 복구한다.
- DB migration은 forward/rollback 또는 명시적 restore 절차를 가진다.
- broker와 내부 상태가 불일치하면 신규 진입보다 정지를 선택한다.
- paper 환경에서 RPO 0에 가까운 order ledger와 raw event 보존을 목표로 한다.
- live RTO/RPO는 `docs/12_MIGRATION_AND_TBD.md`의 필수 결정 전까지 미확정이다.

### 7.4 보안

- 환경별 broker credential과 DB를 분리한다.
- frontend, logs, traces, fixtures에 secret·계좌번호를 남기지 않는다.
- execution adapter만 order credential을 읽을 수 있다.
- 승인·risk 완화·kill switch 해제는 강한 인증과 감사 사유를 요구한다.
- dependency/SBOM/vulnerability scan을 CI gate에 포함한다.

### 7.5 유지보수성

- 계약 우선, port/adapter, 작은 배포 단위를 지향한다.
- 전략 로직과 broker/clock/storage를 분리한다.
- public behavior 변경은 문서와 예제를 함께 수정한다.
- optional platform은 adoption trigger 전에는 추가하지 않는다.

## 8. 성공 지표

제품 성과와 투자 성과를 구분한다.

### 8.1 엔지니어링 성공

- 30거래일 이상 KIS paper 무인 실행
- 중복 주문 0, 미해결 position mismatch 0
- 모든 거래일 replay 성공 및 decision hash 설명 가능
- Sev-1 장애 시나리오 100% fail-safe 통과
- champion·challenger 결과가 동일 비용·fill 모델로 비교됨
- 배포·전략 rollback rehearsal 성공

### 8.2 연구 성공

- 모든 trial과 실패 run이 기록됨
- 단순 benchmark 대비 비용 후 성과와 위험을 비교함
- validation policy를 통과하지 못한 전략의 승격 0
- 데이터 누출 fixture를 의도적으로 주입했을 때 gate가 차단함

### 8.3 투자 성과

수익률 목표는 현재 명세에서 확정하지 않는다. 실전 자본과 risk budget이 정해진 뒤 별도 versioned policy로 관리한다. 어떠한 수익률도 engineering 완료 기준을 대체하지 않는다.

## 9. 전체 출시 게이트

### Paper 활성화

- owner가 paper 계정 credential을 별도 주입
- raw replay, risk, OMS, reconciliation E2E 통과
- 실거래 endpoint 차단 테스트 통과

### Limited live 준비 완료

- `docs/06_RISK_SECURITY_RUNBOOK.md`의 live checklist 전부 통과
- 최소 paper 관찰기간 및 promotion policy 충족
- broker timeout/partial fill/mismatch/kill switch rehearsal 통과
- live credential 분리와 최소권한 검증
- owner의 명시적 승인

### Full allocation

본 패키지 범위 밖이다. limited live의 충분한 관찰, 별도 risk review, 추가 승인 없이는 진행하지 않는다.

