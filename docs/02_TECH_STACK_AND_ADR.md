# 02. 기술 스택과 기준 ADR

## 1. 선택 원칙

- 현재 거래 horizon과 운영 인력에 필요한 만큼만 복잡하게 만든다.
- open protocol과 adapter를 사용해 broker·cloud·AI provider 종속을 줄인다.
- 연구 생산성은 Python, 주문 안전성은 상태기계·DB 제약·격리로 확보한다.
- 기술의 이론적 기능보다 장애복구, replay, 라이선스, 운영 부담을 함께 평가한다.
- 모든 런타임·이미지·의존성은 lockfile과 digest로 pin한다. 아래 version은 기준선이며 M00에서 실제 호환성을 확인한다.

## 2. 권장 스택

### 2.1 Runtime·개발도구

| 영역 | 선택 | 사용 범위 | 비고 |
| --- | --- | --- | --- |
| Backend | Python 3.13 | data/decision/control/research | ecosystem 호환성 기준; patch pin |
| Async API | FastAPI + asyncio | REST/control/research API | 외부 call deadline 필수 |
| Contracts | Pydantic v2 + Protobuf | boundary validation | JSON은 UI/외부 API |
| Dataframes | Polars | feature/data QA | lazy/streaming 사용은 profiling 후 |
| Numeric | NumPy, SciPy, Numba | 연구·indicator | money/ledger에는 float 금지 |
| Models | LightGBM, scikit-learn | numeric model | artifact digest 고정 |
| Inference | in-process 또는 ONNX Runtime | latency-sensitive numeric inference | network model service 기본 금지 |
| Python package | uv | lock, workspace, commands | M00에서 기존 도구와 조정 |
| Web | React + TypeScript + Vite | 운영 UI | 기존 UI가 있으면 우선 재사용 |
| Web state | TanStack Query + Zod | server state·schema | broker 직접 접근 금지 |
| JS package | pnpm | workspace·lock | 기존 lockfile 우선 |
| Task runner | Makefile 또는 just | canonical commands | CI와 동일 명령 사용 |

정확한 Node version은 M00에서 기존 앱과 현재 LTS 호환성을 확인해 `.tool-versions` 또는 Volta로 pin한다.

### 2.2 데이터·통신

| 영역 | 선택 | 이유 | 대안/재검토 |
| --- | --- | --- | --- |
| Event log | Redpanda(Kafka-compatible) | 단일 노드 개발 편의, replay, Kafka ecosystem, schema registry | managed Kafka로 무코드/저코드 이전 가능성 유지 |
| Sync RPC | gRPC + Protobuf | typed risk decision, deadline | 같은 process 내부는 direct interface |
| REST | FastAPI OpenAPI | UI·운영 명령 | 모든 mutation idempotency/reason 필요 |
| UI push | WebSocket 또는 SSE | 상태·경보 | 주문 command channel로 사용 금지 |
| Primary DB | PostgreSQL + TimescaleDB | ledger transaction + 시계열 | managed PostgreSQL 우선 가능 |
| Raw/research | immutable Parquet + filesystem/S3 adapter | replay와 저비용 보존 | production은 versioning 가능한 object storage |
| Cache | Redis | latest snapshot, rate limit, ephemeral locks | 권위 상태 금지 |
| Local research | DuckDB | Parquet ad-hoc query | production ledger query 금지 |

Redpanda의 edition별 보안·관리 기능은 도입 시 최신 조건을 재검토한다. Kafka protocol 밖의 전용 기능에 강하게 결합하지 않는다.

### 2.3 연구·검증·MLOps

| 영역 | 선택 | 역할 | 금지/주의 |
| --- | --- | --- | --- |
| Fast screening | vectorbt + Polars | 아이디어·parameter surface 선별 | 실거래 근거 단독 사용 금지 |
| Event backtest | LEAN | fill/fee/slippage/event parity | KIS adapter·calendar 검증 필요 |
| 대안 engine | NautilusTrader | Rust core·event-driven 대안 | 초기 live에 두 engine 동시 운영 금지 |
| Experiment tracking | MLflow | run, metrics, artifacts, lineage, aliases | alias 변경만으로 자동 자본 배정 금지 |
| Data version | DVC | dataset/pipeline digest | 데이터 lake 확대 시 lakeFS 검토 |
| Batch orchestration | Dagster | assets, schedules, backfill, checks | order hot path 금지 |
| Hyperparameter | Optuna | bounded search | trial budget 사전 고정·전체 기록 |
| Validation helper | skfolio + 자체 구현 | walk-forward/CPCV 보조 | 금융 label overlap test 필수 |
| Data quality | Pydantic, Pandera, Dagster checks | boundary/batch/persisted asset | 동일 규칙을 중복 구현하지 않도록 공통 계약화 |

### 2.4 운영·보안

| 영역 | 선택 | 역할 |
| --- | --- | --- |
| Metrics | Prometheus | freshness, lag, latency, order/risk counters |
| Dashboard | Grafana | 운영·SLO·incident view |
| Alerts | Alertmanager | grouping, inhibition, routing |
| Traces | OpenTelemetry | signal→risk→order→fill correlation |
| Logs | Loki | 구조화 application logs |
| Audit | PostgreSQL append-only ledger | 운영 로그와 별도 권위 기록 |
| Local orchestration | Docker Compose + systemd | MVP와 paper 운영 |
| Secrets | ignored local env for dev; SOPS/age 또는 managed secret for paper/live | 환경·권한 분리 |
| CI | GitHub Actions | lint/type/test/build/scan/replay fixture |
| Supply chain | pinned images, SBOM, dependency scan, provenance | tag `latest` 금지 |

### 2.5 가용 구현 방향 전체 지도

아래는 조사한 선택지를 버리는 목록이 아니라, 현재 선택·대안·도입 trigger를 남긴 기술 지도다.

| 영역 | 현재 권고 | 현실적인 대안 | 유보/도입 trigger |
| --- | --- | --- | --- |
| 외부 실시간 연결 | broker WebSocket + heartbeat/reconnect | REST polling/snapshot | raw TCP/FIX/direct feed는 기관 계약·고빈도 요구 시 별도 트랙 |
| 외부 주문 | REST adapter + 조회 대사 | provider별 SDK를 adapter 내부 사용 | FIX order routing은 broker 지원·운영 인력 확보 시 |
| UI 실시간 | SSE 또는 WebSocket read channel | 짧은 polling | UI→broker socket/주문은 금지 |
| 이벤트 계약 | Protobuf + registry | Avro, JSON Schema | 무계약 JSON 금지; 조직 표준이 있으면 M01 ADR |
| 이벤트 backbone | Redpanda/Kafka | NATS JetStream, managed Pub/Sub | Pulsar는 multi-tenant/geo 요구; Redis Streams는 보조 queue |
| stream 처리 | Python asyncio consumer | Kafka Streams, RisingWave, Materialize | Flink는 대규모 state/watermark; Spark/Beam은 lake·batch 통합 요구 |
| 동기 내부 호출 | gRPC + deadline | typed internal REST/direct interface | 무기한 RPC와 side-effect 자동 retry 금지 |
| transaction/message 결합 | outbox/inbox + idempotency | Kafka transaction이 닫힌 내부 경계 | 외부 broker 포함 EOS 주장 금지 |
| 운영 DB | PostgreSQL + Timescale | managed PostgreSQL | distributed SQL은 multi-region transaction 요구 시 |
| 분석/시계열 | Timescale + Parquet/DuckDB | ClickHouse read model | tick/news/trace query가 운영 SLO를 실제 침해할 때 |
| object/data version | immutable Parquet + DVC | lakeFS, Iceberg/Delta 계열 | 대규모 동시 branch/lakehouse 요구 시 |
| cache/state | Redis ephemeral | in-process cache | 권위 order/ledger 저장 금지 |
| feature platform | versioned bitemporal tables | Feast | 다수 모델의 online/offline feature 공유·skew 문제가 반복될 때 |
| numeric runtime | Python/Polars/NumPy/Numba | Rust/Go native extension/service | profile로 CPU/GC/serialization 병목 확인 시 hot path만 |
| backtest | vectorbt→LEAN | NautilusTrader, Qlib 연구 flow | 두 live engine 동시 운영 금지 |
| workflow | Dagster | Airflow/Prefect, Temporal | 장기 보상·승인 workflow가 DB state machine 한계일 때 Temporal |
| 모델 serving | in-process/ONNX | dedicated model service, vLLM/Ray Serve | volume/privacy/GPU 요구가 측정될 때 |
| 서비스 구조 | 4 plane modular deployables | 더 작은 microservices | 독립 scale·failure isolation·팀 ownership이 측정될 때 분리 |
| 배포 | Linux+Compose/systemd | managed containers, single-node k3s 학습 | 실제 HA는 3+ node/managed stateful/Kubernetes 조건 충족 시 |
| application rollout | Compose controlled restart | Argo CD/Rollouts on Kubernetes | strategy capital promotion과 반드시 분리 |
| observability | Prometheus/Grafana/Alertmanager+OTel+Loki | hosted observability | 주문·risk audit를 일반 log로 대체 금지 |

소켓 선택 원칙:

- provider가 제공하는 WebSocket을 사용하고 자체 binary/raw TCP protocol을 새로 만들지 않는다.
- socket 수신 thread/task는 parsing·raw publish까지만 하며 전략이나 broker 주문을 직접 호출하지 않는다.
- reconnect 후 “연결됨”만으로 정상으로 보지 않고 subscription, sequence, snapshot, freshness를 다시 확인한다.
- REST snapshot은 stream gap 복구에 유용하지만 과거의 실제 도착시각을 소급 생성하지 않는다.
- 내부 persistent event는 socket 자체가 아니라 durable log에 남겨 consumer restart와 replay를 가능하게 한다.

서비스 구조 선택 원칙:

- modular monolith는 transaction과 로컬 debugging이 단순하고 현재 팀·거래 빈도에 적합하다.
- microservice는 독립 확장·장애격리·배포 ownership을 주지만 network failure, schema evolution, observability, 운영비를 추가한다.
- 따라서 논리 경계와 계약은 처음부터 두되 물리 분리는 계측된 이유가 있는 component에만 적용한다.

## 3. 핵심 ADR

### ADR-0001: KIS paper를 첫 broker로 사용

- Status: Accepted
- Decision: 한국투자증권 Open Trading API의 WebSocket 시세와 REST 주문/조회, 모의투자를 첫 vertical slice로 사용한다.
- 이유: 공식 예제에 REST/WebSocket, 모의/실전, 전략 빌더와 LEAN 백테스터 흐름이 있다.
- Consequence: KIS rate limit·token·TR ID·모의/실전 차이를 adapter 내부에서 캡슐화한다.
- Alternative: 기존 Alpaca paper adapter가 있다면 삭제하지 않고 contract reference implementation으로 유지할 수 있다.
- Source: [KIS Open Trading API](https://github.com/koreainvestment/open-trading-api)

### ADR-0002: Toss는 2차 REST adapter

- Status: Proposed
- Decision: Toss는 broker port의 두 번째 adapter로 설계하되 MVP 실시간 feed로 사용하지 않는다.
- 이유: 2026-08-13 확인한 공식 OpenAPI 1.2.14는 REST 주문/조회/조건부 주문을 제공하지만 WebSocket을 추후 지원으로 안내한다.
- Revisit: 공식 WebSocket 공개, rate limit·paper 환경·주문 idempotency 확인 후.
- Source: [Toss OpenAPI](https://openapi.tossinvest.com/openapi-docs/latest/openapi.json)

### ADR-0003: Kafka-compatible durable log를 canonical event backbone으로 사용

- Status: Proposed; M01 spike 후 승인
- Decision: 개발/MVP는 Redpanda, API contract는 Kafka-compatible topic/schema로 제한한다.
- 이유: replay·consumer group·schema evolution·Flink 확장 경로가 필요하다.
- 대안: NATS JetStream은 소규모 운영 대안이나 analytics ecosystem과 장기 audit backbone 기준에서 2순위다. Redis Streams는 보조 queue만 허용한다. Pulsar는 현재 규모에 과하다.
- Source: [Kafka docs](https://kafka.apache.org/documentation/), [Redpanda schema registry](https://docs.redpanda.com/streaming/current/manage/schema-reg/schema-reg-overview/)

### ADR-0004: end-to-end exactly-once를 요구사항에서 제외

- Status: Accepted
- Decision: 내부 compatible path의 transaction 기능은 사용할 수 있으나 외부 broker까지 포함한 보장은 `at-least-once + idempotency + reconciliation`로 명세한다.
- 이유: end-to-end exactly-once는 replayable source와 transactional/idempotent sink 조건을 요구하며 broker REST가 그 경계에 포함되지 않는다.
- Source: [Flink fault tolerance](https://nightlies.apache.org/flink/flink-docs-stable/docs/learn-flink/fault_tolerance/)

### ADR-0005: Python-first, 성능 병목만 다른 언어

- Status: Proposed; M00 toolchain 확인 후 승인
- Decision: 연구와 운영의 공통 domain/strategy code는 Python으로 시작한다.
- 이유: 15분~5일 horizon에서는 개발·검증 속도와 parity가 microsecond 최적화보다 중요하다.
- Revisit: profiling으로 수집/serialization/GC가 SLO를 반복 위반할 때 해당 adapter만 Rust/Go로 교체한다.

### ADR-0006: PostgreSQL ledger와 Timescale time-series를 한 운영 경계로 시작

- Status: Proposed; M01 storage spike 후 승인
- Decision: order/fill/cash/position/audit는 PostgreSQL transaction, bars/features는 Timescale hypertable을 사용한다.
- 이유: 초기에는 transaction·운영 단순성이 ClickHouse 분리보다 중요하다.
- Revisit: 분석 query가 order path에 영향을 주거나 데이터 규모가 측정 임계치를 초과할 때 ClickHouse read model을 추가한다.
- Source: [Timescale continuous aggregates](https://docs.timescale.com/use-timescale/latest/continuous-aggregates/)

### ADR-0007: 빠른 screening과 event backtest를 분리

- Status: Proposed; M07 재현성 spike 후 승인
- Decision: vectorbt는 탐색, LEAN은 event/fill parity gate로 사용한다.
- 이유: vectorized speed와 현실적 order state simulation은 서로 다른 문제다.
- Revisit: KIS/한국시장 adapter 구현 비용이 과도하거나 NautilusTrader가 동일 요구를 더 단순하게 충족할 때 ADR로 변경한다.
- Source: [vectorbt](https://vectorbt.dev/), [LEAN](https://www.quantconnect.com/docs/v2/lean-engine/getting-started), [NautilusTrader](https://nautilustrader.io/docs/latest/concepts/architecture/)

### ADR-0008: MLflow alias는 증거 포인터, 자본 스위치가 아님

- Status: Proposed technology, accepted safety principle
- Decision: MLflow `champion` alias는 approved artifact를 가리키지만 promotion controller의 사람 승인·signed manifest·safe window 없이는 control plane이 reload하지 않는다.
- 이유: registry 편의 기능과 재무적 승격 권한을 분리한다.
- Source: [MLflow Model Registry](https://mlflow.org/docs/latest/ml/model-registry/)

### ADR-0009: AI는 비동기 risk-reduction overlay

- Status: Accepted
- Decision: provider-neutral LLM adapter가 strict schema를 반환하며, numeric exposure에 0~1 배수만 적용한다.
- 이유: 비결정성·timeout·provider drift가 order/risk hot path를 지배하지 않게 한다.
- Revisit: 없음. AI가 hard risk를 대체하는 변경은 새 제품 범위와 별도 승인 필요.

### ADR-0010: Compose first, Kubernetes later

- Status: Accepted
- Decision: 전용 Linux host의 Docker Compose/systemd로 dev·paper를 시작한다.
- 이유: 단일 노드 Kubernetes는 host HA를 만들지 않으며 stateful cluster 운영 부담을 늘린다.
- Revisit: 3개 이상의 host, 명시적 RTO/RPO, rolling update, multi-tenant isolation이 필요할 때 3-node k3s/Kubernetes와 managed stateful services를 검토한다.
- Source: [K3s HA embedded etcd](https://docs.k3s.io/datastore/ha-embedded)

## 4. 도입을 유보하는 스택

| 기술 | 지금 하지 않는 이유 | 도입 증거 |
| --- | --- | --- |
| Flink | checkpoint/state/watermark 운영비 | consumer lag·late join·state size 측정 |
| Spark Structured Streaming | micro-batch/lake 중심 규모가 아님 | 대규모 batch+stream 통합 요구 |
| RisingWave/Materialize | feature SQL만으로 단순화되는지 미확인 | 증분 SQL view가 Python feature를 대체할 명확한 비율 |
| ClickHouse | Timescale/Parquet로 시작 가능 | query latency/volume/retention 수치 |
| Feast | 단일/소수 모델, bitemporal table로 충분 | 다중 모델 feature 재사용·online latency 문제 |
| lakeFS | DVC로 시작 가능 | object data 규모·동시 branch가 DVC 운영 한계 초과 |
| Temporal | promotion은 초기 DB state machine으로 충분 | 장기 workflow 재시도·승인 복잡도 |
| Kubernetes/Argo | HA/scale 요구 미확정 | 3+ host와 운영 인력/RTO/RPO 승인 |
| Vault | local/paper 규모에서 SOPS/managed secret 가능 | 다중 사용자·rotation·dynamic credentials |
| vLLM/Ray Serve | AI volume/privacy 요구 미확정 | 비용·보안·throughput 분석 |
| DPDK/RDMA/kdb+ | HFT 범위 아님 | 제품 horizon 자체 변경 |

## 5. 의존성 승인 기준

새 production dependency를 추가하기 전에 기록한다.

1. 현재 마일스톤의 어떤 요구사항을 해결하는가?
2. 표준 라이브러리/현재 stack으로 해결할 수 없는가?
3. 라이선스, 유지보수, 보안, Windows/WSL·Linux 호환성은 어떤가?
4. 상태 저장, network hop, 장애면을 추가하는가?
5. 제거·교체 가능한 port가 있는가?
6. 테스트와 관측을 어떻게 할 것인가?

핵심 의존성·프로토콜·저장소 변경은 ADR 없이 병합하지 않는다.

## 6. Pinning·재현성

- Python: `pyproject.toml` + `uv.lock`, Python patch version pin
- Web: `package.json` + `pnpm-lock.yaml`, Node LTS pin
- Protobuf: `buf.yaml`/`buf.lock`, breaking check
- Containers: image tag + digest, `latest` 금지
- DB: ordered migrations, schema checksum
- Strategy: package digest, config digest, feature schema digest
- Data: DVC/object version + content hash
- Environment: build metadata와 SBOM을 release artifact에 연결

## 7. 라이선스·계약 확인

구현 완료와 별개로 다음은 live 전 법적/계약 검토가 필요하다.

- KRX·broker 실시간 데이터 저장·재배포·상업적 이용 조건
- 뉴스·논문 원문 저장과 LLM 처리 권한
- broker API의 자동주문, 동시연결, rate limit, 계정 정책
- 오픈소스 engine·indicator·model의 배포 라이선스
- Redpanda 및 관리형 서비스의 사용 edition 조건
