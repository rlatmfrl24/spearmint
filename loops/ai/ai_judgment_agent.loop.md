# Loop: AI Judgment Agent Implementation

## id
`ai_judgment_agent_implementation`

## trigger
Manual request to add Layer 5 AI judgment, scenario generation, critic review, or guardrail behavior.

## class
`ai_judgment`

## goal
Add AI judgment behavior that uses structured facts, respects capability gates, logs decisions, includes dissent and invalidation, and never bypasses validation or risk policy.

## scope
Allowed: `src/ai/`, AI docs, guardrail tests, decision logs, reporting payloads.

Forbidden: AI directly fetching market data, modifying thresholds, replacing Rulebook output, issuing ungated buy/sell advice, or self-approving model-judged output.

## inputs
- `docs/09_AI_DECISION_ARCHITECTURE.md`
- `docs/10_CAPABILITY_GATES.md`
- `docs/11_RISK_GOVERNANCE.md`
- `docs/12_REPORTING_SPEC.md`

## steps
1. Define facts-only input schema.
2. Define output schema with base/bull/bear/dissent views.
3. Add guardrail validator.
4. Add separate critic rubric if model judgment is used.
5. Log AI decision and blocked capabilities.
6. Update docs and loop memory.

## verification
- verification_level: `L2_rule_or_policy` + `L4_model_judge`
- required_checks:
  - schema validation passes
  - guardrail validator blocks forbidden outputs
  - same model/agent does not approve its own L4 judgment
  - capability gate determines exposure

## stopping_rule
Success only when guardrails and logs exist. Block if requested output requires a higher capability level.

## memory
Write `loop_memory/active/<date>_ai_judgment_agent_implementation_<feature>.md`.
