# 11. Codex 바이브 코딩 플레이북

## 1. 이 문서의 사용법

이 문서는 “한 번에 전체 시스템을 만들어 달라”는 큰 프롬프트를 피하고, Codex가 저장소 사실을 읽고 작은 검증 단위로 구현하도록 안내한다. 루트 `AGENTS.md`는 매 작업의 durable rule이고, 이 문서는 세션별 작업 prompt와 review loop다.

Codex 공식 지침에 맞춰:

- `AGENTS.md`는 짧고 지속적인 규칙만 유지한다.
- 상세 설계는 `docs/`로 분리한다.
- 한 세션에는 하나의 집중된 목표를 준다.
- prompt는 `Goal / Context / Constraints / Done when`을 포함한다.
- 큰 작업은 먼저 plan을 만들고 구현·test·review를 반복한다.

참고: [AGENTS.md 공식 가이드](https://learn.chatgpt.com/docs/agent-configuration/agents-md), [Codex 모범 사례](https://learn.chatgpt.com/guides/best-practices).

## 2. 저장소에 패키지를 넣은 직후

1. 이 package의 `AGENTS.md`, `PLANS.md`, `docs/`, `config/`를 repository root에 복사한다.
2. 기존 동명 파일은 덮어쓰기 전에 diff하고 필요한 지침을 병합한다.
3. Codex를 repository root에서 시작한다.
4. Plan mode로 아래 M00 prompt를 실행한다.
5. M00에서 실제 build/test/deploy 명령을 발견할 때까지 scaffold나 dependency를 대량 추가하지 않는다.
6. M00 산출물을 사람이 검토한 후 M01 prompt로 진행한다.

## 3. 첫 번째 프롬프트 — M00 저장소 감사

아래를 그대로 복사하고 `<...>`만 채운다.

```text
Goal
Spearmint 저장소의 현재 구현을 읽기 전용으로 감사하고, 목표 명세와의 gap 및 안전한 이관 계획을 작성하세요. 이번 작업에서는 제품 코드를 구현하거나 기존 파일을 삭제하지 마세요.

Context
- 먼저 AGENTS.md, README.md, PLANS.md를 읽으세요.
- 이어 docs/00_PROJECT_SPEC.md, docs/01_ARCHITECTURE.md, docs/07_IMPLEMENTATION_ROADMAP.md, docs/12_MIGRATION_AND_TBD.md를 읽으세요.
- 과거의 React/Vite, Cloudflare, Alpaca, Gmail, Notion 언급은 검증되지 않은 힌트입니다.
- 목표 1차 broker는 KIS paper이며 live_enabled는 false입니다.

Constraints
- 사용자 변경과 secret을 보존하세요. secret 값은 출력하지 마세요.
- git 상태, entrypoint, dependencies, services, schemas, migrations, tests, CI/CD, deployment, broker/data integrations를 실제 파일 근거로 확인하세요.
- 가능하면 secret 없이 기존 build/test를 실행하되 외부 write나 broker 주문은 금지합니다.
- 확인되지 않은 사실은 UNKNOWN/TBD로 표시하세요.
- 교체 제안 전에 reuse 가능성과 parity test를 평가하세요.

Done when
- docs/current-state.md: 현재 topology, 데이터/주문 flow, 기술/명령 inventory, 근거 파일 경로
- docs/gap-analysis.md: keep/adapt/replace/remove/unknown matrix와 위험
- docs/adr/0000-repository-migration.md: 단계적 이관과 rollback
- plans/active/M01-foundation.md: 작은 첫 vertical slice, acceptance tests
- 실행한 명령/결과, 미실행 이유, 질문 목록을 최종 보고

먼저 조사 계획을 제시한 뒤 수행하세요. 파일을 수정하기 전에는 산출물 문서 외 변경이 없는지 다시 확인하세요.
```

## 4. 공통 구현 프롬프트 template

```text
Goal
<이번 세션에서 구현할 하나의 사용자 관찰 가능 결과>

Context
- 읽을 문서: AGENTS.md, <관련 docs>, <active plan>
- 현재 구현 근거: <파일/commit/issue>
- 입력/출력 계약: <topic/API/schema>

Constraints
- live_enabled=false, 실제 broker 주문 금지
- 독립 risk 승인 없는 command 금지
- Decimal/UTC/available_at/idempotency/fencing 규칙 준수
- 범위 밖 refactor와 dependency 추가 금지
- 기존 사용자 변경 보존

Done when
- <동작 acceptance criteria>
- <happy/failure/duplicate/restart test>
- <lint/type/unit/integration 명령>
- <docs/schema/migration/metric 갱신>
- 변경 파일과 미검증 사항을 최종 보고

구현 전 현재 코드를 읽고 active plan을 갱신하세요. 구현 후 자기 검토와 테스트를 수행하세요.
```

## 5. Milestone별 복사 프롬프트

### 5.1 M01 Foundation

```text
Goal
승인된 M00 migration ADR을 따라 Spearmint의 최소 foundation을 구현하세요. sample event 하나가 produce→consume→inbox dedupe→transactional outbox까지 local Compose에서 동작해야 합니다.

Context
- AGENTS.md, docs/02_TECH_STACK_AND_ADR.md, docs/03_DOMAIN_AND_DATA_MODEL.md, docs/04_API_AND_EVENT_CONTRACTS.md, plans/active/M01-foundation.md를 읽으세요.
- M00에서 확인한 기존 toolchain과 frontend를 보존하세요.

Constraints
- 지금은 KIS 주문, 전략, Kubernetes, Flink, ClickHouse를 구현하지 마세요.
- config default는 local/paper, live_enabled=false입니다.
- schema/event에 correlation, causation, four timestamps, producer/schema version, payload hash를 포함하세요.
- Decimal과 timezone-aware UTC type을 강제하세요.

Done when
- fresh bootstrap 명령 하나와 CI check 명령 하나가 문서화됨
- pinned dependencies와 dev Compose health가 검증됨
- duplicate sample event의 side effect가 정확히 1회라는 integration test
- schema compatibility, secret scan, lint/type/unit/integration 통과
- 결정이 ADR/README/active plan에 반영됨
```

### 5.2 M02 Market data slice

```text
Goal
KIS paper 시장데이터의 allowlist 소수 종목을 raw→normalized→1m bar→Timescale/Parquet→deterministic replay로 연결하세요.

Context
- docs/01_ARCHITECTURE.md, docs/03_DOMAIN_AND_DATA_MODEL.md, docs/04_API_AND_EVENT_CONTRACTS.md, docs/08_TEST_AND_QA_PLAN.md를 읽으세요.
- provider fixture/simulator를 먼저 구현하고 credential이 있을 때만 read-only paper contract test를 수행하세요.

Constraints
- provider payload를 domain 전체로 누출하지 마세요.
- provider_time/event_time/ingested_at/available_at을 보존하세요.
- gap/duplicate/out-of-order/stale를 숨기거나 임의 보간하지 마세요.
- broker order endpoint는 호출하지 마세요.

Done when
- recorded fixture replay checksum이 반복 실행에서 동일
- disconnect/resubscribe/gap/quarantine test 통과
- holiday/session/OHLC/tick/lot 품질 test 통과
- lag/freshness/gap metrics와 runbook link 존재
```

### 5.3 M03 OMS·Ledger

```text
Goal
broker simulator 기반으로 idempotent OMS, append-only ledger, reconciliation을 구현하세요. submit timeout 뒤 broker에 주문이 실제 존재하는 ambiguous scenario가 반드시 포함되어야 합니다.

Context
- docs/03_DOMAIN_AND_DATA_MODEL.md의 주문 상태기계
- docs/04_API_AND_EVENT_CONTRACTS.md의 adapter/idempotency
- docs/06_RISK_SECURITY_RUNBOOK.md의 fencing/reconciliation
- docs/08_TEST_AND_QA_PLAN.md의 simulator matrix

Constraints
- 현재 단계에서는 실제 broker write 금지
- timeout을 FAILED로 단정하거나 blind retry하지 않음
- float 금지, fill/ledger immutable, correction은 compensating entry
- 한 account active executor 하나와 monotonic fencing token

Done when
- duplicate/out-of-order/partial/late-fill/restart test 통과
- UNKNOWN→RECONCILING resolution과 manual-review path
- ledger replay checksum과 broker snapshot mismatch report
- split-brain fault test에서 stale writer side effect 0
```

### 5.4 M04 Risk Engine

```text
Goal
모든 order command 앞에서 R-001~R-012를 강제하는 독립 RiskGateway를 구현하세요.

Context
- docs/06_RISK_SECURITY_RUNBOOK.md와 config/risk-policy.example.yaml을 canonical 요구로 사용하세요.
- OMS simulator와 연결하되 strategy implementation은 필요하지 않습니다.

Constraints
- long/cash-only, no leverage/short/averaging-down
- AI multiplier는 0..1이며 final exposure를 늘릴 수 없음
- stale/missing/NaN/limit 미설정은 fail-closed
- policy는 immutable version+digest+approval; live_enabled=false

Done when
- table-driven unit test와 Hypothesis property test
- risk 승인 없는 command를 executor도 거절
- kill/reconciliation/UNKNOWN/fencing gates integration test
- decision snapshot/reasons/policy digest audit
```

### 5.5 M05 Strategy SDK

```text
Goal
live/replay 공용 deterministic Strategy SDK와 단순 trend baseline 하나를 구현하세요. 목표는 수익이 아니라 결정 경로의 재현성입니다.

Context
- docs/05_STRATEGY_RESEARCH_VALIDATION.md의 SDK/manifest
- docs/03_DOMAIN_AND_DATA_MODEL.md의 available_at
- 기존 feature/strategy code가 있으면 adapter로 보존 가능한지 먼저 평가

Constraints
- network/database/broker/wall-clock 직접 접근 금지
- output은 target exposure/order intent 초안, broker order가 아님
- 미래정보/latest corrected row 금지
- 입력 snapshot+version이 같으면 output digest 동일

Done when
- shifted available_at leakage test
- restart/state restore/golden replay test
- dependency boundary test
- manifest에 code/config/feature/universe digest
```

### 5.6 M06 Paper E2E

```text
Goal
KIS paper에서 market→decision→risk→order→fill→ledger→reconciliation→UI 한 종목/한 전략 vertical slice를 완성하세요.

Context
- docs/07_IMPLEMENTATION_ROADMAP.md M06
- docs/08_TEST_AND_QA_PLAN.md MVP acceptance scenario
- docs/09_DEPLOYMENT_AND_OPERATIONS.md와 docs/10_UI_UX_SPEC.md

Constraints
- paper account만; live URL/credential/topic 접근 금지
- AI는 mock 또는 검증된 축소 overlay이고 실패해도 hard risk 독립
- 202 명령과 UNKNOWN 주문을 UI에서 최종 성공처럼 표시하지 않음
- 구현 범위를 늘리기보다 한 경로의 fault/restart 관측을 완성

Done when
- full lineage UI와 structured trace
- timeout/partial fill/mismatch/feed stale/restart E2E
- duplicate broker side effect 0, ledger checksum 일치
- dashboards, alerts, runbook rehearsal와 결과 문서
```

### 5.7 M07 Research validation

```text
Goal
한 공개 가설을 paper metadata→hypothesis→vectorized screen→event replay→purged CV/CPCV→DSR/PBO/stress→immutable validation report로 재현하세요.

Context
- docs/05_STRATEGY_RESEARCH_VALIDATION.md 전체
- 승인된 데이터 license와 point-in-time dataset만 사용

Constraints
- LLM은 추출/설명만; metric 계산과 verdict를 맡기지 않음
- 모든 trial/search budget 보존
- 단일 Sharpe 또는 in-sample 결과로 통과 금지
- 결과가 나쁘더라도 삭제/재튜닝하지 말고 보고

Done when
- clean environment 재현과 digest lineage
- deliberate leakage tests 실패
- independent/reference 통계 fixture와 tolerance test
- PROPOSED gate별 pass/fail/insufficient evidence report
```

### 5.8 M08 Promotion

```text
Goal
동기화된 shadow challenger 비교, evidence gate, 사람 승인, safe-window assignment, rollback을 구현하세요.

Context
- docs/05_STRATEGY_RESEARCH_VALIDATION.md promotion policy
- docs/03_DOMAIN_AND_DATA_MODEL.md lifecycle state machine
- config/promotion-policy.example.yaml

Constraints
- challenger는 broker credential/order topic permission 없음
- MLflow alias만으로 capital routing 변경 금지
- 승인 없는 apply, digest mismatch, open-order unsafe transition 거절
- live activation은 이 작업 범위 밖; paper environment에서 workflow 검증

Done when
- request/evidence/approval/apply/verify/rollback audit
- champion 최대 1개 invariant와 race test
- failed apply fault injection 후 이전 champion 복귀
- 사람 승인 없는 promotion side effect 0
```

## 6. 세션 운영 loop

### 시작

1. `git status`와 active plan 확인
2. 관련 문서·nested `AGENTS.md` 읽기
3. 현재 코드/테스트/계약에서 사실 수집
4. 작은 plan과 질문/TBD 정리
5. scope가 명확하면 구현

### 구현 중

- 하나의 vertical slice를 red→green→refactor
- schema와 fixture를 먼저 또는 함께 변경
- 위험한 가정은 `docs/12_MIGRATION_AND_TBD.md`에 기록
- unrelated refactor 발견 시 이번 diff에 섞지 않고 후속 backlog
- dependency 추가 전 standard library/기존 dependency로 가능한지 확인

### 종료

1. diff 전체 review
2. 최소 관련 test 후 canonical check
3. secret/live default/future data/idempotency/float 검토
4. active plan에서 완료/미완료/결정 갱신
5. user-facing final: outcome, changed files, tests, unresolved blocker

## 7. Review 프롬프트

구현 세션과 별도로 다음 review를 요청한다.

```text
현재 branch의 변경을 구현자가 아닌 안전성 reviewer 관점에서 검토하세요.

우선순위:
1. 실제/중복 주문 가능성, risk 우회, stale executor
2. timeout/partial fill/reconciliation 오류
3. future-data leakage와 replay 비결정성
4. Decimal/시간대/idempotency/schema 호환성
5. secret, RBAC, live default, prompt injection
6. 테스트가 실제 failure mode를 증명하는지

AGENTS.md와 관련 docs를 기준으로 blocking/major/minor를 구분하세요. 파일과 정확한 근거를 제시하고, 근거 없는 스타일 취향은 제외하세요. 코드는 수정하지 말고 findings와 필요한 test만 보고하세요.
```

## 8. QA 프롬프트

```text
현재 milestone의 acceptance criteria를 독립적으로 검증하세요. 먼저 active plan과 docs/08_TEST_AND_QA_PLAN.md를 읽고, 구현 설명을 신뢰하지 말고 실제 명령과 fixture로 확인하세요.

- happy path뿐 아니라 duplicate, timeout, partial fill, restart, stale data, mismatch를 실행
- clean environment/bootstrap 확인
- live credential 없이 수행
- 실패를 숨기거나 snapshot을 자동 갱신하지 않음
- 결과를 command, exit code, 핵심 evidence와 함께 보고

검증 중 발견한 제품 변경은 구현하지 말고 재현 단계와 severity를 제시하세요.
```

## 9. Codex에게 주지 말아야 할 프롬프트

- “모든 마이크로서비스와 Kubernetes를 한 번에 완성해줘”
- “수익률이 가장 높은 전략을 찾아 바로 실거래해줘”
- “테스트가 깨지면 적당히 skip해줘”
- “timeout이면 주문을 다시 보내면 돼”
- “AI가 판단해서 risk를 유연하게 우회하게 해줘”
- “기존 코드를 전부 지우고 새로 만들어줘”

대신 한 가지 observable outcome, 관련 계약, 금지 경계, failure tests, 완료 조건을 명시한다.

## 10. 병렬 작업 규칙

사람이 명시적으로 여러 Codex 작업을 병렬화할 때만 적용한다.

- 독립 worktree/branch와 서로 겹치지 않는 file ownership
- shared schema 변경은 한 owner가 먼저 merge
- 예: M2 data-plane과 M3 simulator/ledger는 계약 고정 후 병렬 가능
- risk와 executor 경계는 통합 owner가 최종 review
- 각 branch는 merge 전 최신 contract/golden replay를 통과
- 여러 agent가 같은 migration/lockfile/AGENTS.md를 동시에 수정하지 않음

## 11. 문서 갱신 규칙

- 실제 repository 명령과 구조가 확인되면 README/AGENTS의 미검증 문구를 사실로 교체한다.
- 안전/아키텍처 결정은 ADR로 남긴다.
- implementation detail은 가장 가까운 subsystem 문서에 둔다.
- `PROPOSED` 값을 승인 없이 `CONFIRMED`로 바꾸지 않는다.
- 반복되는 Codex 실수만 가장 작은 durable rule로 AGENTS.md에 추가한다.
- 완료된 plan은 결과/결정/잔여 debt를 기록한 뒤 `plans/completed/`로 이동한다.
