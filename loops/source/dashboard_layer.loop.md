# Loop: Dashboard Layer Implementation

## id
`dashboard_layer_implementation`

## trigger
Manual request to add or modify Layer 1~4 or future Layer 5~9 UI.

## class
`source_implementation`

## goal
Implement UI that renders API-provided evidence, risks, invalidation, freshness, and validation status without calculating financial metrics in components.

## scope
Allowed: `frontend/`, API types, UI docs, contract tests.

Forbidden: React-side metric calculations, fake values for missing data, ungated buy/sell or expected return copy.

## inputs
- `docs/07_UI_SPEC.md`
- `docs/06_API_CONTRACT.md`
- `docs/10_CAPABILITY_GATES.md`

## steps
1. Read UI and API specs.
2. Map UI fields to documented JSON payload.
3. Preserve current RS leader and momentum leader separation.
4. Render freshness and data quality in active layer scope.
5. Add component or snapshot tests.
6. Update docs if UI contract changes.

## verification
- verification_level: `L1_deterministic` + `L2_rule_or_policy`
- required_checks:
  - component/snapshot tests pass
  - UI uses API contract only
  - no forbidden investment copy appears outside allowed gates

## stopping_rule
Success only when UI tests and copy guardrails pass. Block if API contract is not available.

## memory
Write `loop_memory/active/<date>_dashboard_layer_implementation_<layer>.md`.
