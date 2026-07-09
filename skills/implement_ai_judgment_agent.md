# Skill: Implement AI Judgment Agent

Use this when adding AI scenario or judgment behavior.

## Steps

1. Read `docs/09_AI_DECISION_ARCHITECTURE.md` and `docs/10_CAPABILITY_GATES.md`.
2. Use structured facts only.
3. Include validation stage and blocked capabilities in prompt input.
4. Request structured JSON output.
5. Include base, bull, bear, rotation, dissenting view.
6. Run guardrail validation before user-facing output.
7. Log `ai_decision_log`.
8. Add tests for forbidden claims.

## Forbidden Without Gate

- Buy/sell advice
- Target price
- Expected return
- Stock recommendation
- Order intent
- Auto trading
