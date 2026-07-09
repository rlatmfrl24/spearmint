# Loop: Documentation Synchronization

## id
`docs_sync`

## trigger
Manual or event-driven after source, API, config, schema, feature gate, or loop contract changes.

## class
`documentation_sync`

## goal
Keep project charter, README, AGENTS, docs, config, skills, loop specs, migrations, manifest, and self-evaluation aligned.

## scope
Allowed: all documentation, config examples, manifests, loop specs, skills.

Forbidden: changing product scope without recording the decision.

## inputs
- changed file list
- `PROJECT_SOURCE_MANIFEST.md`
- `docs/21_DECISION_RECORDS.md`
- `docs/99_SELF_EVALUATION.md`

## steps
1. Identify changed contracts and decisions.
2. Update direct spec docs.
3. Update README and AGENTS if workflow or scope changed.
4. Update manifest file count and package notes.
5. Add decision record if needed.
6. Update self-evaluation for package-level releases.
7. Write loop memory.

## verification
- verification_level: `L2_rule_or_policy`
- required_checks:
  - no stale file list
  - changed contracts reflected in docs
  - future scope remains separated from active scope

## stopping_rule
Success only when docs and manifest are consistent. Block if a scope decision is ambiguous.

## memory
Write `loop_memory/active/<date>_docs_sync.md`.
