# Loop: Rulebook Pattern Implementation

## id
`rulebook_pattern_implementation`

## trigger
Manual request to add or modify a rulebook pattern, conviction gate, or veto.

## class
`source_implementation`

## goal
Implement a rulebook pattern that consumes module states and emits narrative, risks, invalidation, source metrics, freshness, and validation status.

## scope
Allowed: `src/rules/`, `src/domain/`, `tests/unit/rules/`, `docs/05_RULEBOOK.md`, `docs/06_API_CONTRACT.md` if output changes.

Forbidden: recalculating raw metrics inside the rulebook; converting module states into a single average score.

## inputs
- `docs/05_RULEBOOK.md`
- `docs/04_METRICS_AND_STATES.md`
- `docs/10_CAPABILITY_GATES.md`

## steps
1. Identify the pattern or veto.
2. Define required module state combinations.
3. Add narrative/risk/invalidation templates.
4. Add rulebook unit tests for positive, negative, veto, and insufficient-data cases.
5. Update API contract if output shape changed.
6. Write loop memory.

## verification
- verification_level: `L1_deterministic` + `L2_rule_or_policy`
- required_checks:
  - rulebook pattern tests pass
  - output contract includes required fields
  - veto rules cannot produce high conviction when blocked

## stopping_rule
Success only when pattern and veto tests pass. Block if the pattern depends on unimplemented metrics.

## memory
Write `loop_memory/active/<date>_rulebook_pattern_implementation_<pattern>.md`.
