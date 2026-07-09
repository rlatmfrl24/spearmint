# Skill: Implement Postgres Migration

Use this when adding or changing database tables.

1. Read `docs/03_DATA_MODEL.md` and `config/database.postgres.yaml`.
2. Add migration SQL under `database/migrations/`.
3. Preserve raw/derived/validation/ai/ops/execution schema separation.
4. Include PIT fields when storing market, macro, filing, or derived facts.
5. Add idempotent constraints or upsert keys.
6. Add migration tests or schema smoke tests.
7. Update docs if table contracts changed.
8. Do not use D1 as canonical analytical storage.
