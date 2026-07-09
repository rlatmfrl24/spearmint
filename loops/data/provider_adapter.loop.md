# Loop: Provider Adapter Implementation

## id
`provider_adapter_implementation`

## trigger
Manual request to add or modify market, macro, filing, or vendor provider adapter.

## class
`data_pipeline`

## goal
Implement a provider adapter that respects source registry, provider policy, license gate, raw archiving, idempotent upsert, and network-free unit tests.

## scope
Allowed: provider adapter code, fixtures, source registry config, provider policy docs/tests.

Forbidden: live network in unit tests; redistributing provider data outside license; writing directly to derived metrics.

## inputs
- `docs/17_PROVIDER_AND_LICENSE_STRATEGY.md`
- `config/source_registry.yaml`
- `config/provider_policy.yaml`

## steps
1. Confirm provider class: official, licensed_vendor, manual, fixture, or experimental.
2. Define adapter interface and fixture payload.
3. Store raw payload and normalized series separately.
4. Add idempotent upsert tests.
5. Add freshness and quality status mapping.
6. Update registry and docs.

## verification
- verification_level: `L1_deterministic` + `L2_rule_or_policy`
- required_checks:
  - fixture tests pass
  - license gate documented
  - raw payload storage path defined
  - derived write path separated

## stopping_rule
Success only when fixture-backed ingestion works and license gate is explicit. Block if live credential or license scope is unknown.

## memory
Write `loop_memory/active/<date>_provider_adapter_implementation_<provider>.md`.
