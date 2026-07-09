# Skill: Implement Provider License Gate

Use this when adding a provider adapter or source registry entry.

1. Read `docs/17_PROVIDER_AND_LICENSE_STRATEGY.md`.
2. Add source metadata to `config/source_registry.yaml`.
3. Add usage rules to `config/provider_policy.yaml` if needed.
4. Store `source_id`, `license_status`, `fetched_at`, `known_at`, and `quality_status`.
5. Archive raw payloads to R2 or fixture artifacts.
6. Block public display if license or redistribution rights are unknown.
7. Unit tests must use fixtures and never call the provider network.
