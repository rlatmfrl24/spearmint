# 14. Testing Strategy

Last updated: 2026-07-08

## 1. Test Principles

- Unit tests must not call the network.
- Use deterministic synthetic and fixture data.
- Test edge cases before provider integration.
- API contracts must be pinned.
- UI tests must verify leader separation and freshness visibility.
- AI tests must verify guardrails and structured output.
- Execution tests must never hit a live broker.

## 2. Test Types

| Type | Purpose |
|---|---|
| Unit | Pure functions, metrics, rulebook, gates |
| Fixture integration | Store + metric + rulebook with local fixtures |
| Contract | API JSON schema snapshots |
| UI | Display behavior and copy guardrails |
| Validation | Replay label generation and reliability |
| AI guardrail | Forbidden wording and schema validation |
| Risk/execution | Future sandbox-only order intent tests |

## 3. Metric Edge Cases

Every metric module should test:

```text
normal trend
weak trend
missing data
flat price
zero volume
negative volume error
insufficient lookback
threshold boundary
```

## 4. Rulebook Tests

Each pattern:

```text
positive case
negative case
veto case
missing data case
narrative includes risk
narrative includes invalidation
schema conformity
```

## 5. API Tests

- `/api/sectors` includes required fields.
- `/api/data/status` handles stale sources.
- `/api/validation` hides probability when not ready.
- Future gated endpoints return capability error.

## 6. AI Tests

- AI output conforms to schema.
- AI output includes dissenting view.
- AI output includes risks and invalidation.
- AI output lists blocked capabilities.
- AI output does not contain forbidden copy for current level.

## 7. Execution Tests

Future-only, sandbox-only:

- Capability disabled blocks order.
- Kill switch blocks order.
- Duplicate order blocked.
- Risk limit blocks order.
- User approval required.
- Audit log written.


## Loop Verification Testing

Loop engineering adds another test layer: each non-trivial change must declare the highest actual verifier that passed.

| Verification level | Test expectation |
|---|---|
| L1 deterministic | Unit tests, schema tests, SQL dry-runs, golden JSON checks |
| L2 rule/policy | Linters, type checks, capability gates, provider-license gates, financial copy guardrails |
| L3 delayed field truth | CI, staging smoke tests, replay run, calibration run, scheduled refresh output |
| L4 model judge | Separate critic model with rubric; never self-approval |
| L5 human checkpoint | Explicit human/legal/broker/domain review note |

Loop-specific required tests:

- `metric_module_implementation`: synthetic deterministic metric edge cases.
- `rulebook_pattern_implementation`: pattern and veto tests.
- `api_endpoint_implementation`: JSON schema or snapshot contract tests.
- `dashboard_layer_implementation`: API-only UI and forbidden-copy tests.
- `provider_adapter_implementation`: fixture-backed ingestion and license gate tests.
- `validation_replay_implementation`: replay fixture and thin-sample guard tests.
- `ai_judgment_agent_implementation`: guardrail validator and capability-gate tests.
- `pr_self_review`: checklist completion and named terminal state.
