# 04. API·이벤트 계약

## 1. 계약 원칙

1. REST는 운영 조회·사람의 명시적 명령, gRPC는 내부 동기 판단, event stream은 상태 변화와 재생이 필요한 사실에 사용한다.
2. 외부 broker 주문은 `at-least-once + idempotency + reconciliation`으로 처리한다. end-to-end exactly-once라고 표현하지 않는다.
3. write API는 `Idempotency-Key`, 인증 주체, 사유, correlation ID를 요구한다.
4. 금액·가격·수량은 JSON에서 decimal string으로 표현한다. 부동소수점으로 ledger를 계산하지 않는다.
5. timestamp는 UTC RFC 3339, trading date와 exchange timezone은 별도 필드로 둔다.
6. 계약은 additive하게 진화한다. 의미 변경·필드 제거·단위 변경은 새 major version을 만든다.
7. paper와 live는 동일한 schema를 사용하되 credential, account, topic prefix, DB, object prefix를 격리한다.

## 2. Topic catalogue

환경 prefix를 사용한다. 예: `paper.market.normalized.v1`, `live.orders.intent.v1`.

| Topic | Producer | 주요 consumer | Partition key | 보존/의미 |
| --- | --- | --- | --- | --- |
| `market.raw.v1` | KIS adapter | normalizer, archive | `market:symbol` | provider 원형에 가까운 수신 사실 |
| `market.normalized.v1` | normalizer | bar builder, quality, research mirror | `market:symbol` | canonical tick/quote/trade |
| `market.bars.v1` | bar builder | feature runtime, storage | `market:symbol` | 완료/수정 bar |
| `market.quality.v1` | quality service | control plane, alerting | `market:symbol` | gap·stale·quarantine |
| `features.updated.v1` | feature runtime | strategy runtime | `market:symbol` | point-in-time feature snapshot |
| `strategy.signals.v1` | strategy runtime | audit, intent builder | `strategy:version:symbol` | 변경 불가 signal |
| `orders.intent.v1` | decision plane | risk gateway | `account_id` | 아직 broker에 제출할 수 없는 의도 |
| `risk.decisions.v1` | risk engine | executor, audit | `account_id` | 승인·거절·수량 축소 |
| `orders.commands.v1` | control plane | single executor | `account_id` | submit/cancel command |
| `broker.order-events.v1` | broker adapter | OMS, ledger, reconciler | `account_id` | ACK/reject/fill/cancel 사실 |
| `ledger.events.v1` | ledger | position read model, UI | `account_id` | append-only 회계 사실 |
| `reconciliation.events.v1` | reconciler | risk, UI, alerting | `account_id` | 대사 결과·불일치 |
| `research.results.v1` | research plane | registry, promotion | `strategy_version_id` | 실험·검증 결과 |
| `strategy.lifecycle.v1` | promotion controller | runtimes, UI, audit | `environment:account` | 배치·승격·중지 사실 |
| `alerts.v1` | all planes | Alertmanager bridge, UI | `severity:service` | 운영 alert 사실 |

주문·ledger topic은 account 단위 순서를 우선한다. symbol 병렬성 때문에 동일 account의 주문 순서를 깨지 않는다. market topic은 symbol 단위 순서를 보장하고 전체 시장 순서는 주장하지 않는다.

## 3. 공통 event envelope

`03_DOMAIN_AND_DATA_MODEL.md`의 envelope를 canonical로 한다. 추가 규칙:

- `event_id`: ULID/UUIDv7. 동일 사실의 retry는 같은 값.
- `sequence`: producer가 보장 가능한 경계에서만 단조 증가. 불가능하면 null이며 거짓 전역 순번을 만들지 않는다.
- `available_at`: 해당 정보가 의사결정 코드에 실제 사용 가능해진 최초 시각.
- `payload_hash`: canonical serialization 기준 SHA-256.
- consumer는 `(consumer_name, event_id)` inbox unique constraint로 중복을 제거한다.
- DB 상태와 event를 동시에 내야 하면 transactional outbox를 사용한다.

### 3.1 Order intent 예시

```json
{
  "event_id": "01J...",
  "event_type": "orders.intent.created",
  "schema_version": 1,
  "source": "decision-plane",
  "environment": "paper",
  "correlation_id": "01J...",
  "causation_id": "01J...",
  "partition_key": "account:paper-main",
  "event_time": "2026-08-13T01:12:30.000Z",
  "provider_time": null,
  "ingested_at": "2026-08-13T01:12:30.010Z",
  "available_at": "2026-08-13T01:12:30.010Z",
  "sequence": 4821,
  "producer_version": "decision-plane@sha256:...",
  "payload_hash": "sha256:...",
  "payload": {
    "intent_id": "01J...",
    "strategy_version_id": "trend-v3@sha256:...",
    "account_id": "paper-main",
    "instrument_id": "KRX:005930",
    "side": "BUY",
    "quantity": "1",
    "order_type": "LIMIT",
    "limit_price": "75000",
    "time_in_force": "DAY",
    "expires_at": "2026-08-13T01:13:00.000Z",
    "ai_risk_multiplier": "0.80",
    "idempotency_key": "sha256:..."
  }
}
```

## 4. REST API

Base path는 `/api/v1`; 모든 응답에 `request_id`, 모든 page 응답에 opaque cursor를 포함한다.

### 4.1 조회

| Method/path | 용도 | 권한 |
| --- | --- | --- |
| `GET /health/live` | process 생존 | public/internal LB |
| `GET /health/ready` | dependency 포함 준비 상태 | internal |
| `GET /api/v1/system/status` | plane, feed, broker, lag, kill switch | viewer |
| `GET /api/v1/market/instruments` | universe·symbol master | viewer |
| `GET /api/v1/strategies` | version·role·validation 상태 | viewer |
| `GET /api/v1/strategies/{id}` | manifest·evidence·deployment | viewer |
| `GET /api/v1/orders` | 주문과 상태 전이 | viewer |
| `GET /api/v1/positions` | internal/broker 비교 포함 position | viewer |
| `GET /api/v1/ledger` | append-only entry 조회 | auditor |
| `GET /api/v1/reconciliation/runs` | 대사 결과와 mismatch | operator |
| `GET /api/v1/risk/status` | 활성 policy와 headroom | operator |
| `GET /api/v1/research/experiments` | run·artifact·metrics | researcher |
| `GET /api/v1/promotions` | 요청·승인·배치 상태 | viewer |
| `GET /api/v1/incidents` | incident timeline | operator |

### 4.2 명령

| Method/path | 필수 입력 | 결과/주의 |
| --- | --- | --- |
| `POST /api/v1/orders/{id}/cancel` | reason | command 접수만 의미; broker 취소 보장 아님 |
| `POST /api/v1/kill-switches` | scope, reason, expires/indefinite | 신규 주문 차단; cancel/flatten과 분리 |
| `DELETE /api/v1/kill-switches/{id}` | reason, approval | 원인 해소 확인 후 해제 |
| `POST /api/v1/reconciliation/runs` | account, reason | 수동 대사 시작 |
| `POST /api/v1/promotions` | candidate, evidence, target | 요청 생성; 자동 실거래 승격 아님 |
| `POST /api/v1/promotions/{id}/approve` | decision, reason, approval scope | 분리된 approver 권한 필요 |
| `POST /api/v1/promotions/{id}/apply` | window, reason | `live_enabled`와 gate를 다시 검사 |
| `POST /api/v1/strategies/{id}/pause` | scope, reason | strategy 신규 intent 중지 |
| `POST /api/v1/emergency/cancel-all` | account, reason, confirmation token | open order 취소 시도; 별도 권한 |
| `POST /api/v1/emergency/flatten` | account, reason, second approval | MVP 기본 비활성; 시장충격 검토 필요 |

모든 명령 endpoint는 성공 시 `202 Accepted`와 `command_id`를 반환한다. 최종 결과는 조회 또는 event로 확인한다. 같은 `Idempotency-Key`와 같은 body는 같은 결과를 반환하고, 같은 key에 다른 body면 `409 IDEMPOTENCY_CONFLICT`다.

### 4.3 오류 형식

```json
{
  "error": {
    "code": "RISK_POLICY_BLOCKED",
    "message": "order intent is blocked by the active risk policy",
    "retryable": false,
    "details": [{"rule": "feed_freshness", "observed_ms": 4200, "limit_ms": 2000}],
    "request_id": "01J..."
  }
}
```

허용 code 예: `VALIDATION_ERROR`, `UNAUTHENTICATED`, `FORBIDDEN`, `NOT_FOUND`, `VERSION_CONFLICT`, `IDEMPOTENCY_CONFLICT`, `DEPENDENCY_UNAVAILABLE`, `BROKER_STATE_UNKNOWN`, `LIVE_DISABLED`, `APPROVAL_REQUIRED`. 내부 stack trace나 credential은 응답에 넣지 않는다.

## 5. 내부 gRPC 계약

초기 구현은 아래 두 경계를 우선한다. 같은 process 안에서 시작하더라도 proto 계약을 유지하면 분리 시 재작성 비용이 줄어든다.

```proto
syntax = "proto3";

message DecimalValue { string value = 1; }

service RiskGateway {
  rpc CheckIntent(CheckIntentRequest) returns (CheckIntentResponse);
}

service ExecutionGateway {
  rpc SubmitApprovedOrder(SubmitOrderRequest) returns (SubmitOrderResponse);
  rpc CancelOrder(CancelOrderRequest) returns (CancelOrderResponse);
}
```

- `CheckIntent` deadline은 feature/strategy 경로 SLO 안에서 명시한다. deadline 초과는 승인으로 간주하지 않고 fail-closed한다.
- `ExecutionGateway`의 timeout은 실패가 아니라 결과 미상일 수 있다. `UNKNOWN`으로 기록하고 broker 조회·대사한다.
- 모든 request에 environment, account, correlation ID, policy/version digest, fencing token을 포함한다.
- retry policy는 method별로 명시하며 side-effect method의 자동 retry는 idempotency 검증 없이는 금지한다.

## 6. Broker adapter interface

KIS 세부 TR/WS 형식을 core domain으로 누출하지 않는다.

```python
class BrokerAdapter(Protocol):
    async def connect_market_stream(self, subscriptions: list[InstrumentId]) -> None: ...
    async def fetch_open_orders(self, account_id: AccountId) -> list[BrokerOrder]: ...
    async def fetch_positions(self, account_id: AccountId) -> list[BrokerPosition]: ...
    async def fetch_cash(self, account_id: AccountId) -> BrokerCash: ...
    async def submit_order(self, command: BrokerOrderCommand) -> BrokerSubmissionResult: ...
    async def cancel_order(self, command: BrokerCancelCommand) -> BrokerCancelResult: ...
    async def stream_order_events(self, account_id: AccountId) -> AsyncIterator[BrokerOrderEvent]: ...
```

adapter 책임:

- token 발급·갱신, app key/account routing, rate limit, provider error normalization
- WS reconnect, resubscribe, heartbeat, sequence gap 탐지
- provider timestamp와 local ingest timestamp 모두 보존
- client order ID를 지원하지 않으면 내부 fingerprint와 broker 조회로 dedupe 보강
- paper/live capability matrix 유지

adapter가 가져서는 안 되는 책임:

- 전략 판단, risk 승인, position truth를 임의 수정, timeout 주문 blind retry, 실거래 활성화

## 7. Schema evolution

- Protobuf field number는 재사용하지 않고 제거 field는 `reserved`로 둔다.
- event payload에 새 optional field를 추가하는 것은 minor change다.
- enum consumer는 unknown value를 안전하게 처리한다.
- 단위, 시간 의미, partition key, required semantics 변경은 새 topic/API major version이다.
- producer/consumer compatibility test를 CI에 둔다.
- schema registry compatibility는 backward 또는 full 중 실제 consumer rollout 순서에 맞춰 고정한다.
- dual-publish는 종료일과 제거 plan이 있는 migration 기간에만 허용한다.

## 8. 인증·권한·감사

권한 role: `viewer`, `researcher`, `operator`, `risk_manager`, `approver`, `auditor`, `admin`.

- service-to-service: workload identity/mTLS 또는 짧은 수명의 service token.
- UI/API: SSO/OIDC, MFA, session timeout.
- live 명령: paper 권한과 분리, 가능한 경우 step-up auth.
- promotion 요청자와 live approver는 원칙적으로 분리한다.
- 명령·승인·policy 변경은 before/after digest, actor, reason, source IP/session, timestamp를 append-only audit에 남긴다.
- secret, access token, account number 원문은 event/log/trace에 넣지 않는다.

## 9. 계약 완료 조건

- [ ] event envelope와 topic schema가 registry에 등록됨
- [ ] decimal/time/null semantics가 golden fixture로 고정됨
- [ ] 각 consumer의 idempotency test가 있음
- [ ] REST OpenAPI와 gRPC descriptor가 CI에서 생성·검증됨
- [ ] KIS paper adapter contract test와 simulator test가 있음
- [ ] timeout→UNKNOWN→reconciliation test가 있음
- [ ] old/new schema 호환 test가 있음
- [ ] live credential 없이 전체 CI가 통과함
