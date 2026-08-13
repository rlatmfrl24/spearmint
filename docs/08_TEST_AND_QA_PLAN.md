# 08. 테스트·QA 계획

## 1. 테스트 철학

이 프로젝트의 테스트는 단순 코드 정확성보다 “중복·지연·재시작·불완전한 외부 상태에서도 자본 불변식을 지키는가”를 증명해야 한다.

- deterministic clock, seeded randomness, immutable fixture를 기본으로 한다.
- broker와 market provider는 simulator를 우선하고, KIS paper contract test를 별도 둔다.
- 성과가 좋은 backtest는 소프트웨어 correctness 증거가 아니다.
- live credential/API write를 CI에서 사용하지 않는다.
- production incident는 재현 fixture 또는 regression test로 남긴다.
- test만 통과시키기 위해 safety check를 mock/skip하지 않는다.

## 2. Test pyramid와 suite

| Suite | 대상 | 실행 시점 | 도구 후보 |
| --- | --- | --- | --- |
| Unit | domain rule, parser, state transition, math | 모든 commit | pytest |
| Property | risk/ledger/idempotency 불변식 | PR·nightly | Hypothesis |
| Contract | event/API/proto/broker adapter | PR | schema registry, golden fixture |
| Component | service+실제 DB/broker | PR | Testcontainers/Compose |
| Integration | Kafka/Postgres/Redis/object path | PR·main | Compose |
| Replay/golden | raw→bar→feature→signal→intent checksum | PR·nightly | replay CLI |
| Fault/chaos | timeout, duplicate, split brain, restart | nightly/release | Toxiproxy/custom faults |
| E2E paper | KIS paper vertical flow | 장중 schedule/manual | isolated paper account |
| Performance | latency, throughput, lag, soak | release/nightly | k6/Locust/custom load |
| Security | SAST, secret, dependency, image, authz | PR/release | approved scanners |
| Research validation | leakage/CV/metrics/reproducibility | research run | pytest/reference datasets |

## 3. Unit·property 불변식

### 3.1 Risk

- `0 <= ai_multiplier <= 1`
- `final_exposure <= base_exposure`
- projected position `>= 0`
- committed cash가 allowed cash를 넘지 않음
- losing long에 projected BUY가 있으면 averaging-down 차단
- expired/stale/NaN/infinite/negative input은 승인되지 않음
- limit을 작게 할수록 승인 수량이 증가하지 않는 monotonicity
- kill switch가 켜지면 신규 risk-increasing command 0
- policy/env/account/artifact digest mismatch는 fail-closed

### 3.2 Order·idempotency

- 같은 intent/idempotency key는 최대 하나의 internal order
- 같은 broker fill은 ledger에 정확히 한 번
- duplicate/out-of-order broker event가 terminal fact를 되돌리지 않음
- submit timeout은 `UNKNOWN`, 자동 `SUBMITTING` retry가 아님
- canceled order의 late fill을 유실하지 않음
- stale fencing token은 side effect 0

### 3.3 Ledger

- 모든 entry batch의 debit/credit 또는 quantity/cash conservation 균형
- position snapshot은 ledger replay 결과와 같음
- partial fill+fee+tax 후 cash/position 정확성
- correction은 원 entry 변경이 아니라 compensating entry
- Decimal serialization round-trip 일치

### 3.4 Time·data

- `available_at > decision_time` 데이터는 feature/signal에서 보이지 않음
- exchange timezone/DST가 없는 KRX라도 UTC/session conversion fixture 고정
- holiday/half-day/auction/halt session 처리
- duplicate/gap/out-of-order가 quality 상태에 반영
- OHLC, volume, tick/lot, symbol validity invariant

## 4. Broker simulator

simulator는 다음을 scriptable scenario로 제공한다.

```yaml
scenario: submit-timeout-then-fill
steps:
  - on: submit_order
    effect: persist_at_broker
    response: timeout
  - after: 500ms
    emit: ACKNOWLEDGED
  - after: 800ms
    emit: PARTIAL_FILL
  - on: fetch_open_orders
    return: persisted_order
```

필수 scenario:

- immediate ACK/fill
- reject before ACK
- partial fills 여러 번 후 fill/cancel
- ACK/event duplicate, fill duplicate
- fill before ACK, late fill after cancel request
- submit/cancel timeout with broker side effect yes/no
- reconnect 중 event gap과 REST snapshot 복구
- rate limit/throttle/token expiry
- malformed/provider unknown status
- broker position/cash mismatch
- two executors with stale token

simulator와 KIS adapter는 같은 contract test suite를 구현한다. KIS가 지원하지 않는 기능은 capability matrix에서 명시적으로 skip하되 의미를 core에서 숨기지 않는다.

## 5. Golden replay

고정 fixture pack:

- raw market payload와 수신 시각
- symbol/calendar/corporate-action version
- normalized event/bar expected checksum
- feature snapshot/signals/intents/risk decisions
- broker scenario와 fills
- final ledger/position/cash/reconciliation

실행은 event offset 또는 virtual clock을 사용하고 wall clock/network에 의존하지 않는다. 변경이 의도적이면:

1. 차이 report를 생성
2. contract/algorithm/fixture 중 무엇이 바뀌었는지 설명
3. reviewer가 financial impact를 승인
4. 새 checksum과 version을 함께 갱신

snapshot을 무심코 overwrite하는 update command는 만들지 않는다.

## 6. Integration test matrix

| Case | 주입 | 기대 결과 |
| --- | --- | --- |
| Consumer crash | DB commit 후 offset 전 crash | inbox dedupe, side effect 1회 |
| Producer crash | DB commit 후 publish 전 crash | outbox relay 재발행 |
| Kafka duplicate | 같은 event 2회 | consumer result 동일 |
| Kafka lag | backlog 증가 | freshness gate/alert, 무제한 메모리 증가 없음 |
| Postgres restart | transaction 중단 | rollback, recovery 후 replay |
| Redis loss | cache/lease 장애 | authoritative state 손실 없음, writer fail-safe |
| Object store down | raw archive 실패 | 정책에 따른 ingest pause/quarantine, 유실 숨김 금지 |
| Broker timeout | 결과 미상 | UNKNOWN→reconciliation, blind retry 없음 |
| WS disconnect | gap/reconnect | resubscribe, quality event, backfill/replay |
| Clock skew | producer 시간 왜곡 | skew alert, decision gate |
| Executor split | 두 instance active 시도 | 최신 fencing token 하나만 write |
| Policy update race | 주문 중 version 변경 | snapshot policy로 일관 결정, audit |
| Promotion race | open order 중 apply | safe window 대기/거절 |

## 7. Research 검증 테스트

### 7.1 Leakage traps

- 미래 row를 fixture에 삽입하고 `available_at` 조건이 없으면 test 실패
- survivorship-only universe와 point-in-time universe 결과 차이 검출
- revised corporate action/fundamental value가 과거에 보이지 않음
- label overlap에 purge/embargo 적용 확인
- parameter search 결과 중 best만 제공하면 report validation 실패

### 7.2 통계 reference

- 작은 synthetic dataset에서 purged walk-forward/CPCV split index 정답 고정
- DSR/PBO를 독립 reference implementation 또는 논문 예제와 tolerance 비교
- constant/zero variance/short series/NaN/serial correlation edge cases
- search budget 증가가 multiple-testing penalty에 반영
- fee/slippage 증가 시 net result가 비정상적으로 개선되지 않는 monotonic check

### 7.3 Reproducibility

- 같은 manifest/seed/container는 metric tolerance 내 동일
- code/data/config digest 하나 변경 시 새 run lineage
- missing artifact/dataset/lockfile면 promotion evidence 불완전
- failed/canceled trial도 registry에 존재

## 8. UI QA

- paper/live banner가 모든 화면과 확인 dialog에 노출
- stale, UNKNOWN, mismatch, kill switch가 색만이 아니라 text/icon으로 전달
- order lineage가 signal/risk/broker/fill/audit까지 연결
- destructive/high-risk action은 reason, scope, 결과, second approval 필요 여부 표시
- API `202`를 최종 성공으로 표현하지 않고 pending→final 갱신
- keyboard navigation, focus, contrast, screen reader label
- desktop 우선이되 tablet에서 incident/kill action을 안전하게 수행
- secret/account 전체 번호가 DOM/telemetry에 노출되지 않음

## 9. Performance·SLO 검증

정확한 목표값은 M00/M01에서 KIS 제약과 workload를 측정해 승인한다. 먼저 latency budget을 단계별로 계측한다.

| 구간 | 측정 |
| --- | --- |
| provider→ingest | provider/ingested timestamp 차이 |
| ingest→normalized/bar | stream processing latency |
| bar→feature→signal | decision latency |
| intent→risk | risk p50/p95/p99, timeout |
| risk→broker call | queue/executor latency |
| broker call→ACK/fill | provider latency 별도 |
| event→UI | observable freshness |

load profile:

- target universe 정상 장중
- 시가/종가 burst
- reconnect 후 backlog replay
- 2x/5x synthetic volume
- 장시간 soak와 log/disk growth

pass 조건은 throughput만이 아니라 gap 0 또는 탐지된 gap, duplicate side effect 0, bounded lag/backpressure, risk deadline 준수다.

## 10. Security test

- secret pattern과 high-entropy scan
- authn/authz matrix: role별 endpoint 허용/거절
- paper token으로 live resource 접근 불가
- live write에 step-up/two-person gate
- IDOR/account scope, mass assignment, replay/idempotency abuse
- malicious event/schema/payload size, decompression/JSON depth limits
- prompt injection fixture가 tool/order/promotion으로 이어지지 않음
- log injection과 PII/credential redaction
- dependency/container vulnerability·SBOM·signature verification
- backup/object artifact 접근권한과 restore 권한

## 11. CI/CD gate 제안

### PR fast gate

1. format/lint
2. type check
3. unit/property fast profile
4. contract/schema compatibility
5. component test with ephemeral dependencies
6. secret/SAST/dependency scan
7. frontend test/build
8. docs link/config schema validation

### Main/nightly

- full property seed set
- golden replay
- fault/chaos matrix
- research statistical reference
- integration against pinned dependency versions
- performance smoke/soak schedule

### Release

- immutable artifact/signature/SBOM
- migration forward/backward rehearsal
- Compose paper canary and smoke
- rollback rehearsal
- open critical/high findings 0
- manual approval for any live-targeted artifact

실제 명령은 M00에서 repository toolchain을 확인해 README와 CI를 단일 source로 맞춘다. 확인 전 `make test` 같은 명령을 사실처럼 가정하지 않는다.

## 12. 결함 우선순위

| 등급 | 예 | release 영향 |
| --- | --- | --- |
| Critical | 중복 주문, risk 우회, secret 유출, short/leverage 가능 | 즉시 중지·release 차단 |
| High | 대사 불일치 은폐, look-ahead, rollback 실패 | release 차단 |
| Medium | 관측 공백, 비핵심 UI 오류, 성능 headroom 감소 | owner 기한부 승인 가능 |
| Low | 문구·비핵심 정리 | backlog 가능 |

## 13. MVP acceptance scenario

한 개의 deterministic 시나리오가 다음을 모두 증명해야 한다.

1. recorded KIS-style market event ingest/replay
2. bar/feature/signal 생성
3. AI multiplier가 base exposure를 축소
4. intent와 independent risk 승인/거절 evidence
5. broker simulator의 timeout+partial fill
6. UNKNOWN 대사와 중복 없는 ledger
7. UI에서 complete lineage와 alert 확인
8. process restart 후 checksum 일치
9. kill switch 후 신규 위험 0
10. strategy shadow 비교·승격 요청은 가능하나 승인 없이 적용 불가

이 scenario가 clean environment와 CI에서 통과해야 paper MVP가 완료된다.
