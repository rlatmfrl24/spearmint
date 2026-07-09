# Skill: Implement Metric Module

Use this when adding or changing a metric.

## Steps

1. Read `docs/04_METRICS_AND_STATES.md`.
2. Add or update pure calculation code under `src/metrics/`.
3. Do not call providers, DB, API, UI, or AI from metric code.
4. Use config thresholds only.
5. Return the standard module state contract.
6. Add deterministic synthetic tests.
7. Test missing data, flat price, zero volume if applicable, insufficient lookback, and threshold boundaries.
8. Update docs if the metric contract changes.

## Required Output

```json
{
  "state": "...",
  "transition": "...",
  "direction": "...",
  "strength": 0,
  "evidence": {},
  "warnings": []
}
```
