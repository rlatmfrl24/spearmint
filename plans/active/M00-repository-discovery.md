# M00 — Repository discovery·이관 감사

## Outcome

현재 Spearmint 저장소의 실제 기술·동작·배포·broker write 경계를 근거 파일과 명령으로 확인하고, 기능 삭제 없이 목표 architecture로 이동할 승인 가능한 M01 계획을 만든다.

## Context inspected

- [ ] `AGENTS.md`, `README.md`, `PLANS.md`
- [ ] `docs/00_PROJECT_SPEC.md`, `docs/01_ARCHITECTURE.md`
- [ ] `docs/07_IMPLEMENTATION_ROADMAP.md`, `docs/12_MIGRATION_AND_TBD.md`
- [ ] repository tree, git status/history/remotes
- [ ] package/lock/runtime, env examples, migration, tests, CI/deployment
- [ ] broker/data/notification integrations와 credential access

## Scope

### In

- 읽기 위주 source/config/test/deployment 감사
- secret 없는 기존 bootstrap/build/test 재현
- current-state, gap matrix, migration ADR, M01 plan 작성

### Out

- 제품 코드 refactor/기능 추가
- dependency/framework 전환
- broker write, live credential 사용
- legacy integration 삭제

## Safety impact

- live/paper 동작 변경 없음
- secret 값은 읽거나 출력하지 않고 참조 위치·관리 방식만 기록
- 외부 write와 destructive command 금지
- 사용자 uncommitted change 보존

## Implementation steps

- [ ] 저장소 상태와 지침, 실제 entrypoint/명령 inventory
- [ ] deployable/data store/external dependency topology 작성
- [ ] market→strategy→risk→order→broker→ledger flow 추적
- [ ] auth/secret/live default와 위험 finding 분류
- [ ] test/build/deploy 재현과 실패 원인 기록
- [ ] keep/adapt/replace/remove/unknown matrix 작성
- [ ] strangler 순서, parity test, rollback을 migration ADR에 작성
- [ ] 작은 M01 vertical slice와 acceptance test 계획

## Tests and evidence

- 실제 repository가 제공하는 명령만 실행해 기록
- live endpoint/order 호출 없음
- build/test 실패도 숨기지 않고 command/exit/error 요약
- 각 사실에 file path, config key, test 또는 commit 근거

## Rollback

이번 milestone은 문서 산출물 외 product code를 변경하지 않는다. 잘못된 문서 판단은 근거를 추가해 revision하고 기존 배포에 영향이 없다.

## Decisions and deviations

- 2026-08-13 / handoff package 단계에서는 repository current state 미확인 / M00가 source of truth를 확립

## Progress

- 2026-08-13 / 계획 template 생성 / repository root로 이관 후 Codex가 실행
