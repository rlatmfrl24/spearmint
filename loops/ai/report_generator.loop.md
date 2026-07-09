# Loop: Report Generator Implementation

## id
`report_generator_implementation`

## trigger
Manual request to add research brief export, executive summary, report section, or narrative template.

## class
`documentation_sync`

## goal
Generate reports from structured payloads without inventing numbers, omitting risks, or weakening validation caveats.

## scope
Allowed: `src/reporting/`, docs, templates, report contract tests.

Forbidden: unsupported claims, uncited facts, buy/sell advice outside gates, expected returns outside calibration gates.

## inputs
- `docs/12_REPORTING_SPEC.md`
- `docs/06_API_CONTRACT.md`
- `docs/10_CAPABILITY_GATES.md`

## steps
1. Define report input JSON.
2. Build deterministic template or constrained LLM prompt.
3. Require risks, invalidation, freshness, and validation caveat.
4. Add schema and copy guardrail tests.
5. Update docs and loop memory.

## verification
- verification_level: `L1_deterministic` + `L2_rule_or_policy`
- required_checks:
  - report schema test passes
  - forbidden copy guardrail passes
  - numbers originate from structured payload

## stopping_rule
Success only when report output is grounded and guarded. Block if source metrics are missing.

## memory
Write `loop_memory/active/<date>_report_generator_implementation.md`.
