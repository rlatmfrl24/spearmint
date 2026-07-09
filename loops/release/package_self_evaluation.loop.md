# Loop: Package Self Evaluation

## id
`package_self_evaluation`

## trigger
Before delivering a generated source-document package.

## class
`documentation_sync`

## goal
Evaluate whether the package is complete, internally consistent, safe by default, and ready to be added to a Codex project.

## scope
Allowed: docs, manifest, README, AGENTS, config, loop specs, self-evaluation.

Forbidden: overclaiming operational readiness when external approvals, data licenses, legal review, broker approval, or live calibration have not occurred.

## inputs
- package directory
- manifest
- self-evaluation rubric
- changed file list

## steps
1. Count files.
2. Verify required docs exist.
3. Verify loop engineering files exist.
4. Verify active vs deferred scope separation.
5. Verify safety defaults and feature flags.
6. Verify missing external approvals are named.
7. Update `docs/99_SELF_EVALUATION.md`.
8. Create checksum.

## verification
- verification_level: `L2_rule_or_policy`
- required_checks:
  - required files exist
  - package zip opens successfully
  - checksums generated
  - self-evaluation names both strengths and remaining external dependencies

## stopping_rule
Success only when package is coherent and verified. Exhausted if zip or file checks cannot be completed.

## memory
Write `loop_memory/active/<date>_package_self_evaluation.md`.
