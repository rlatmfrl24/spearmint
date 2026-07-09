# Loop: API Endpoint Implementation

## id
`api_endpoint_implementation`

## trigger
Manual request to add or modify an API endpoint.

## class
`source_implementation`

## goal
Implement an endpoint that serves documented JSON contracts without allowing UI-side metric calculation.

## scope
Allowed: API handlers, application snapshot builders, contract tests, `docs/06_API_CONTRACT.md`, frontend types if needed.

Forbidden: undocumented response fields used by UI, financial calculations in React components, unbounded analytical queries from Cloudflare Workers.

## inputs
- `docs/06_API_CONTRACT.md`
- `docs/16_CLOUDFLARE_POSTGRES_ARCHITECTURE.md`
- `config/features.yaml`

## steps
1. Read API contract and Cloudflare/Postgres constraints.
2. Implement bounded read path from snapshot/materialized view.
3. Add schema/contract tests.
4. Update frontend types if response changes.
5. Update docs and loop memory.

## verification
- verification_level: `L1_deterministic` + `L2_rule_or_policy`
- required_checks:
  - API contract tests pass
  - feature gates enforced
  - no heavy replay or model training in Workers

## stopping_rule
Success only when endpoint matches documented schema and gates. Block if the required snapshot table/view does not exist.

## memory
Write `loop_memory/active/<date>_api_endpoint_implementation_<endpoint>.md`.
