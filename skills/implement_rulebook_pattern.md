# Skill: Implement Rulebook Pattern

Use this when adding or changing a Rulebook pattern.

## Steps

1. Read `docs/05_RULEBOOK.md`.
2. Add pattern logic under `src/rules/`.
3. Do not recalculate metrics in the rulebook.
4. Consume module states only.
5. Include narrative, risks, invalidation, source metrics, freshness, validation status.
6. Add positive, negative, veto, missing-data tests.
7. Update API contract if output shape changes.
8. Update UI model if new pattern name is surfaced.

## Guardrail

Do not output buy/sell, target price, expected return, or unvalidated probability unless capability gates explicitly allow it.
