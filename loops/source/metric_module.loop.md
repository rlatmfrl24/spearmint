# Loop: Metric Module Implementation

## id
`metric_module_implementation`

## trigger
Manual request to add or modify a metric such as relative strength, breadth, participation, market context, or rotation.

## class
`source_implementation`

## goal
Implement a deterministic metric module that returns the standard module state contract without violating financial guardrails.

## scope
Allowed: `src/metrics/`, `src/domain/`, `tests/unit/metrics/`, `docs/04_METRICS_AND_STATES.md`, `config/thresholds.example.yaml`.

Forbidden: UI metric calculation, provider network calls in metric logic, hard-coded thresholds.

## inputs
- `docs/04_METRICS_AND_STATES.md`
- `docs/03_DATA_MODEL.md`
- `config/thresholds.example.yaml`
- existing metric tests and fixtures

## steps
1. Read metric docs and thresholds.
2. Define exact input and output contract.
3. Implement pure calculation logic.
4. Add deterministic synthetic tests for normal and edge cases.
5. Add missing data, flat price, zero volume, and insufficient lookback tests.
6. Update docs/config if contract or thresholds changed.
7. Write loop memory.

## verification
- verification_level: `L1_deterministic` + `L2_rule_or_policy`
- required_checks:
  - unit metric tests pass
  - no network calls in tests
  - metric returns `state`, `transition`, `direction`, `strength`, `evidence`, `warnings`
  - thresholds are config-driven

## stopping_rule
Success only when tests and contract checks pass. Block if metric definition requires unavailable data or license approval.

## memory
Write `loop_memory/active/<date>_metric_module_implementation_<metric>.md`.
