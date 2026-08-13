# Spearmint Quant Evolution — Codex 구현 이관 패키지

> 문서 기준일: 2026-08-13  
> 상태: 구현 착수용 기준선(Baseline)  
> 우선 환경: 한국투자증권 모의투자, 국내 유동성 ETF·대형주, 15분~5일 보유

이 디렉터리는 Spearmint를 Codex로 이어서 구현하기 위한 저장소 투입용 문서 패키지다. 목표는 “AI가 알아서 수익을 내는 봇”이 아니라, 시장 데이터를 재생할 수 있고 주문 실패를 안전하게 처리하며, 연구 전략을 검증한 뒤 제한적으로 교체할 수 있는 저빈도 단기 퀀트 플랫폼을 만드는 것이다.

## 1. 가장 먼저 읽을 문서

Codex와 사람 모두 다음 순서로 읽는다.

1. `AGENTS.md` — 매 작업에 적용되는 안전 규칙과 완료 정의
2. `docs/00_PROJECT_SPEC.md` — 제품 목표, 범위, 요구사항
3. `docs/01_ARCHITECTURE.md` — 목표 아키텍처와 데이터 흐름
4. `docs/07_IMPLEMENTATION_ROADMAP.md` — 실제 구현 순서와 완료 조건
5. 현재 작업에 해당하는 세부 문서

Codex 첫 세션에는 `docs/11_CODEX_VIBE_CODING_PLAYBOOK.md`의 “첫 번째 프롬프트”를 사용한다.

## 2. 확정된 제품 경계

- 거래 대상: 국내 유동성 ETF와 대형주
- 보유 기간: 대략 15분~5영업일
- 포지션: long/cash만 허용
- 1차 브로커: 한국투자증권(KIS) 모의투자
- 2차 브로커: 토스증권 REST 어댑터 후보
- 전략군: 추세, 평균회귀, 이벤트 기반
- AI 역할: 공시·뉴스의 이벤트 분류와 위험 축소 오버레이(0~1)
- AI 금지: 주문 생성, hard risk 우회, 포지션 확대, 전략 자기수정
- 금지: 레버리지, 손실 포지션 물타기, 무승인 실거래, 자동 자본 승격
- 전략 교체: purged walk-forward/CPCV, DSR/PBO, 비용 스트레스, 모의·shadow 검증, 사람 승인 후 진행

첨부된 ISA·IRP·연금저축 자료는 장기 자산배분 정책에 관한 별도 자료다. 이 시스템의 단기 자동매매 자금·전략에 직접 결합하지 않는다. 추후 필요하면 별도 “capital policy” 모듈에서 읽기 전용 참고정보로 다룬다.

## 3. MVP의 물리적 배포 단위

논리 컴포넌트는 세밀하게 분리하되 초기에는 다음 4개 backend 배포 단위와 1개 web UI로 시작한다.

| 배포 단위 | 책임 |
| --- | --- |
| Data plane | KIS/Web 데이터 수집, raw event 보존, 정규화, 품질검사 |
| Decision plane | feature·시장상태, champion·shadow challenger, AI overlay |
| Control plane | 독립 risk, OMS, 브로커 실행, ledger, reconciliation |
| Research plane | replay, backtest, 논문 파이프라인, 실험·승격 관리 |
| Web | 상태 관찰, 승인, kill switch, 조사·실험 결과 확인 |

초기부터 10~20개 네트워크 마이크로서비스로 쪼개지 않는다. 패키지 경계와 이벤트 계약을 먼저 만들고, 처리량·장애격리 요구가 측정됐을 때만 독립 배포한다.

## 4. 목표 저장소 구조

M00 저장소 조사 후 현재 코드에 맞게 조정한다. 기존 React/Vite·Cloudflare 또는 Alpaca 연동이 존재한다는 과거 정보는 **미검증 레거시 가정**이며, 확인 전 삭제하거나 교체하지 않는다.

```text
.
├── AGENTS.md
├── PLANS.md
├── README.md
├── apps/
│   ├── data-plane/
│   ├── decision-plane/
│   ├── control-plane/
│   ├── research-plane/
│   └── web/
├── packages/
│   ├── contracts/
│   ├── domain/
│   ├── broker-kis/
│   ├── broker-toss/
│   ├── strategy-sdk/
│   ├── risk-policy/
│   ├── observability/
│   └── testkit/
├── config/
├── db/
│   ├── migrations/
│   └── seeds/
├── infra/
│   ├── compose/
│   ├── monitoring/
│   └── k8s/                  # 도입 조건 충족 전 비활성
├── docs/
├── plans/
│   ├── active/
│   └── completed/
└── tests/
    ├── contract/
    ├── integration/
    ├── replay/
    └── fault_injection/
```

## 5. 문서 지도

| 문서 | 사용 시점 |
| --- | --- |
| `docs/00_PROJECT_SPEC.md` | 범위·요구사항·비목표 확인 |
| `docs/01_ARCHITECTURE.md` | 서비스 경계·흐름·장애 의미론 결정 |
| `docs/02_TECH_STACK_AND_ADR.md` | 기술 선택 또는 의존성 변경 |
| `docs/03_DOMAIN_AND_DATA_MODEL.md` | DB·상태기계·시점 모델 구현 |
| `docs/04_API_AND_EVENT_CONTRACTS.md` | REST/gRPC/topic/schema 구현 |
| `docs/05_STRATEGY_RESEARCH_VALIDATION.md` | 전략 SDK·논문·백테스트·승격 구현 |
| `docs/06_RISK_SECURITY_RUNBOOK.md` | risk·권한·kill switch·사고대응 구현 |
| `docs/07_IMPLEMENTATION_ROADMAP.md` | 마일스톤과 작업 순서 |
| `docs/08_TEST_AND_QA_PLAN.md` | 테스트·재생·장애주입·CI |
| `docs/09_DEPLOYMENT_AND_OPERATIONS.md` | 환경·관측·백업·Kubernetes 전환 |
| `docs/10_UI_UX_SPEC.md` | 운영 UI와 승인 UX |
| `docs/11_CODEX_VIBE_CODING_PLAYBOOK.md` | Codex 세션 운영과 복사 가능한 프롬프트 |
| `docs/12_MIGRATION_AND_TBD.md` | 기존 코드 이관, 확정/제안/TBD 구분 |
| `docs/13_REQUIREMENTS_TRACEABILITY.md` | 요구사항→설계→마일스톤→테스트 증거 추적 |

## 6. 시작과 완료의 기준

첫 코딩 작업은 전략 작성이 아니라 **M00 저장소 조사**다. 현재 구조, 빌드·테스트 명령, 비밀정보, 배포, broker adapter, 데이터 모델을 확인한 뒤 문서와 실제 코드의 차이를 기록한다.

Paper MVP는 다음이 모두 성립해야 완료다.

- KIS 시세를 raw log에 저장하고 동일 입력을 결정적으로 replay할 수 있다.
- 정규화→feature→signal→risk→order intent→paper order→fill→ledger→reconciliation이 한 경로로 동작한다.
- WebSocket gap, duplicate event, REST timeout, partial fill, position mismatch가 fail-safe로 처리된다.
- 실거래 credential 없이 전체 E2E와 장애주입 테스트가 통과한다.
- AI를 끄거나 실패시켜도 가격 기반 시스템과 hard risk가 안전하게 동작한다.
- 모든 변경은 관련 테스트, 문서, migration, 관측 지표를 포함한다.

## 7. 문서 우선순위

충돌 시 다음 순서를 따른다.

1. `AGENTS.md`의 안전 불변조건
2. 승인된 ADR 및 `docs/12_MIGRATION_AND_TBD.md`의 확정 결정
3. `docs/00_PROJECT_SPEC.md`
4. 세부 설계 문서
5. 예시 YAML과 복사 가능한 프롬프트

코드가 문서와 다르면 조용히 한쪽을 맞추지 않는다. 차이를 기록하고, 안전·범위에 영향을 주면 사용자에게 결정을 요청한다.

## 8. 주요 공식 근거

- [Codex AGENTS.md 공식 가이드](https://learn.chatgpt.com/docs/agent-configuration/agents-md)
- [Codex 작업 모범 사례](https://learn.chatgpt.com/guides/best-practices)
- [한국투자증권 Open Trading API](https://github.com/koreainvestment/open-trading-api)
- [토스증권 OpenAPI](https://openapi.tossinvest.com/openapi-docs/latest/openapi.json)
- [Apache Kafka](https://kafka.apache.org/documentation/)
- [Apache Flink fault tolerance](https://nightlies.apache.org/flink/flink-docs-stable/docs/learn-flink/fault_tolerance/)
- [MLflow Model Registry](https://mlflow.org/docs/latest/ml/model-registry/)
- [QuantConnect LEAN](https://www.quantconnect.com/docs/v2/lean-engine/getting-started)
