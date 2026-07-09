# Skill: Implement Provider Adapter

Use this when adding a data provider.

## Steps

1. Read `docs/03_DATA_MODEL.md`.
2. Define provider source id in `config/source_registry.yaml`.
3. Implement adapter under `src/infrastructure/providers/`.
4. Convert provider payload to canonical raw series or event rows.
5. Preserve `source`, `source_class`, `published_at`, `known_at`, `fetched_at`, and `run_id`.
6. Add fixture payloads.
7. Unit tests must use fixtures and not call the network.
8. Add integration test only with explicit provider test marker.

## Quality Checks

- Idempotent upsert.
- Schema drift handling.
- Freshness calculation.
- Error logged in `run_log`.
