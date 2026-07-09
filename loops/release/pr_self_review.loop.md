# Loop: PR Self Review

## id
`pr_self_review`

## trigger
Before handoff, PR creation, or package delivery.

## class
`documentation_sync`

## goal
Run a final review against architecture, financial guardrails, tests, docs, loop memory, and capability gates.

## scope
Allowed: review notes, small docs fixes, manifest/self-evaluation updates.

Forbidden: large new feature implementation during review loop unless a new source loop is started.

## inputs
- changed file list
- test output
- relevant loop memory
- docs and config

## steps
1. Check non-negotiable financial rules.
2. Check architecture dependency direction.
3. Check tests and network-free unit tests.
4. Check docs synchronization.
5. Check capability gates and feature flags.
6. Check loop memory and terminal state.
7. Produce handoff.

## verification
- verification_level: `L1_deterministic` + `L2_rule_or_policy` + optional `L4_model_judge`
- required_checks:
  - checklist complete
  - unresolved blockers named
  - failed checks are not hidden

## stopping_rule
Success only when review passes or blockers are explicitly recorded. Escalate for legal/broker/license uncertainty.

## memory
Write `loop_memory/active/<date>_pr_self_review.md`.
