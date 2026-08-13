# PLANS.md — Codex 실행계획 규약

복수 파일, 데이터 마이그레이션, 외부 연동, 상태기계, 30분 이상 예상 작업은 코딩 전에 `plans/active/YYYY-MM-DD-<slug>.md` 실행계획을 만든다. 한 세션에서 하나의 명확한 결과만 다룬다.

## 실행계획 필수 구조

```markdown
# <작업명>

## Outcome
사용자가 확인할 수 있는 최종 결과 한 문단.

## Context inspected
- 읽은 파일과 현재 동작
- 재현한 문제 또는 기준선
- 관련 요구사항/ADR/이벤트 계약

## Scope
### In
- 이번 작업에서 바꾸는 것

### Out
- 의도적으로 미루는 것

## Safety impact
- live/paper 영향
- 주문·자금·개인정보·secret 영향
- 실패 시 안전 동작

## Implementation steps
- [ ] 단계 1 — 산출물과 검증
- [ ] 단계 2 — 산출물과 검증

## Tests and evidence
- 실행할 명령
- contract/replay/fault-injection 항목
- 사용자 확인 항목

## Rollback
- 코드·schema·deployment 되돌리기
- 진행 중 주문/포지션 영향

## Decisions and deviations
- 날짜 / 결정 / 근거

## Progress
- 날짜 / 완료 내용 / 다음 단계
```

## 계획 운영 규칙

- 계획은 살아 있는 문서다. 구현 중 새 사실이 나오면 먼저 갱신한다.
- 저장소 실제 상태가 문서 가정과 다르면 작업을 확대하지 말고 차이를 기록한다.
- 각 단계는 코드 목록이 아니라 관찰 가능한 산출물과 검증을 가진다.
- 한 번에 여러 마일스톤을 구현하지 않는다.
- 승인되지 않은 실거래, credential 변경, 데이터 삭제, 광범위한 구조 변경은 계획만으로 권한이 생기지 않는다.
- 완료 후 `plans/completed/`로 이동하고 남은 TODO는 새 계획으로 분리한다.

## ADR 템플릿

아키텍처, 데이터 계약, 핵심 의존성, 안전 정책을 바꿀 때 `docs/adr/NNNN-<slug>.md`를 만든다.

```markdown
# ADR-NNNN: <결정>

- Status: Proposed | Accepted | Superseded | Rejected
- Date: YYYY-MM-DD
- Owners: <role>

## Context
해결하려는 문제와 제약.

## Decision
선택한 방향과 적용 범위.

## Alternatives
검토했지만 선택하지 않은 방향과 이유.

## Consequences
장점, 비용, 운영 영향, migration/rollback.

## Verification
결정이 올바르게 구현됐음을 확인하는 테스트·지표.
```

## 작업 카드 프롬프트 구조

Codex 요청은 가능한 한 다음 네 요소를 포함한다.

- **Goal:** 무엇을 만들거나 고칠지
- **Context:** 읽어야 할 파일과 현재 증거
- **Constraints:** 안전·아키텍처·범위 제약
- **Done when:** 테스트와 관찰 가능한 완료조건

복사 가능한 마일스톤 프롬프트는 `docs/11_CODEX_VIBE_CODING_PLAYBOOK.md`에 있다.

