# 13. 요구사항 추적표

이 표는 “문서에는 있으나 구현·테스트·운영 증거가 없는 요구사항”을 막기 위한 index다. 실제 code path와 CI test 이름은 milestone 완료 시 채운다.

## 1. 데이터·판단

| Requirement | 설계 source | 구현 milestone | 필수 test/evidence | 상태 |
| --- | --- | --- | --- | --- |
| FR-DATA-001 WS 복구·gap | 01 §7, 04 §6 | M02 | disconnect/resubscribe/gap fixture | Planned |
| FR-DATA-002 immutable raw | 01 §11, 09 §5.3 | M02 | payload/object hash, replay | Planned |
| FR-DATA-003 canonical normalize | 03 §4, 04 §2–3 | M01–M02 | schema contract/golden | Planned |
| FR-DATA-004 four timestamps | 01 §7, 03 §4 | M01–M02 | time semantics fixture | Planned |
| FR-DATA-005 data quality | 03 §10 | M02 | duplicate/order/gap/quarantine | Planned |
| FR-DATA-006 point-in-time reference | 03 §8 | M02 | historical calendar/action replay | Planned |
| FR-DATA-007 external lineage/license | 05 §3, 09 §5.3 | M07 | source/version/license manifest | Planned |
| FR-DEC-001 deterministic output | 05 §4, 08 §5 | M05 | golden signal digest | Planned |
| FR-DEC-002 available_at | 03 §8 | M05 | future sentinel/shift test | Planned |
| FR-DEC-003 versioned snapshot | 03 §3.2 | M05 | decision trace lookup | Planned |
| FR-DEC-004 intent-only strategy | 05 §4 | M05 | forbidden dependency test | Planned |
| FR-DEC-005 AI fallback | 05 §9, 06 §10.5 | M05–M06 | invalid/stale/timeout property+E2E | Planned |

## 2. Risk·주문·원장

| Requirement | 설계 source | 구현 milestone | 필수 test/evidence | 상태 |
| --- | --- | --- | --- | --- |
| INV-001/002 long·cash only | 06 §2–3 | M04 | projected position/cash property | Planned |
| INV-003 no averaging down | 06 §3.1 | M04 | losing-long BUY matrix | Planned |
| INV-004 AI reduce-only | 05 §9, 06 R-002 | M04 | `final <= base` randomized test | Planned |
| INV-005 strategy isolation | 01 §4, 05 §4 | M01/M05 | import/ACL/credential test | Planned |
| INV-006 challenger isolation | 05 §8, 06 §7 | M08 | ACL and topic denial | Planned |
| FR-CTL-001 limits | 06 §2 | M04 | policy matrix/property | Planned |
| FR-CTL-002 failure gates | 06 §4, §10 | M04/M06 | stale/loss/mismatch/clock faults | Planned |
| FR-CTL-003 idempotency | 04 §1, §3 | M01/M03 | duplicate intent side effect 1 | Planned |
| FR-CTL-004 state machine | 03 §5 | M03 | valid/invalid transition property | Planned |
| FR-CTL-005 UNKNOWN reconcile | 01 §8, 06 §10.2 | M03 | timeout-then-fill scenario | Planned |
| FR-CTL-006 partial fill race | 03 §5 | M03 | partial/cancel/late-fill | Planned |
| FR-CTL-007 reconciliation | 06 §6 | M03/M06 | broker/internal checksum | Planned |
| FR-CTL-008 kill switch | 06 §4 | M04/M06 | scope/RBAC/audit E2E | Planned |
| R-008 single executor | 01 §9, 06 §5 | M03 | split-brain/fencing fault | Planned |
| Ledger immutability | 03 §3.4, 08 §3.3 | M03 | replay/conservation/correction | Planned |

## 3. 연구·승격

| Requirement | 설계 source | 구현 milestone | 필수 test/evidence | 상태 |
| --- | --- | --- | --- | --- |
| FR-RSCH-001 hypothesis record | 05 §3 | M07 | validated schema+human review | Planned |
| FR-RSCH-002 full lineage/trials | 05 §10 | M07 | clean reproduction, failed trials | Planned |
| FR-RSCH-003 two-stage backtest | 05 §5–6 | M07 | linked screen/replay run IDs | Planned |
| FR-RSCH-004 CV/DSR/PBO/stress | 05 §6 | M07 | statistical reference fixture | Planned |
| FR-RSCH-005 shadow only | 05 §8 | M08 | no credential/order permission | Planned |
| FR-RSCH-006 approval/rollback | 05 §7–8 | M08 | approval/digest/rollback E2E | Planned |
| FR-RSCH-007 transition ownership | 03 §7, 05 §8 | M08 | open-order safe-window race | Planned |
| INV-009 human gates | 04 §4.2, 06 §11 | M08/M10 | approval bypass negative tests | Planned |
| INV-010 no self modification | 05 §1, 06 §7 | M07–M08 | runtime ACL/admission test | Planned |

## 4. 운영·보안·UI

| Requirement | 설계 source | 구현 milestone | 필수 test/evidence | 상태 |
| --- | --- | --- | --- | --- |
| FR-OPS-001 freshness/lag/latency | 09 §6 | M06 | dashboard metric fixtures | Planned |
| FR-OPS-002 full correlation | 04 §3, 10 §3.4 | M06 | trace/lineage E2E | Planned |
| FR-OPS-003 UNKNOWN/mismatch alert | 06 §6, 10 §3.1 | M06 | alert routing test | Planned |
| FR-OPS-004 high-risk action UX | 04 §4.2, 10 §4 | M06/M08 | reason/RBAC/approval E2E | Planned |
| FR-OPS-005 daily report | 09 §9 | M06/M08 | deterministic report fixture | Planned |
| Environment isolation | 09 §1, §4 | M01/M09 | paper↔live negative test | Planned |
| Secret/supply chain | 06 §7, 09 §7 | M01/M09 | scans/SBOM/signature | Planned |
| Backup/restore | 09 §8 | M09 | restore+full reconciliation rehearsal | Planned |
| Accessible operations UI | 10 §7 | M06 | keyboard/screen reader/contrast QA | Planned |

## 5. Milestone exit gate

각 milestone 종료 시:

1. 해당 row의 상태를 `Implemented`로 바꾸기 전에 실제 code path와 test ID/CI artifact를 추가한다.
2. test가 skip이면 `Implemented`가 아니라 `Blocked` 또는 `Partial`이다.
3. 설계 변경은 source 문서와 이 표를 같은 change에서 갱신한다.
4. production incident regression은 가장 가까운 row에 evidence를 추가한다.
5. M10 전 모든 safety/risk/environment row가 `Verified in paper` 이상이어야 한다.

허용 상태: `Planned`, `In progress`, `Partial`, `Blocked`, `Implemented`, `Verified in paper`, `Verified in limited live`, `Retired`.
