# Skill: Implement API Endpoint

Use this when adding or changing API endpoints.

## Steps

1. Read `docs/06_API_CONTRACT.md`.
2. Define schema before implementation.
3. API must return explicit freshness and validation status for user-facing judgments.
4. Do not expose gated capability unless `capability_gate.allowed = true`.
5. Add contract tests.
6. Update frontend types.
7. Update docs if response shape changes.

## Error Contract

Use standard error shape:

```json
{
  "error": {
    "code": "...",
    "message": "...",
    "details": {}
  }
}
```
