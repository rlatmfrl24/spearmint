# 09. AI Decision Architecture

Last updated: 2026-07-08

## 1. Purpose

AI starts as an interpretation assistant but is designed to become an active judgment layer. The AI may reason about market regime, sector rotation, risks, scenarios, dissenting views, and eventually stock candidates or portfolio advice, but only within capability gates.

## 2. AI Roles

| Agent | Role |
|---|---|
| Market Flow AI | Interprets Layer 1 market regime |
| Sector Rotation AI | Interprets leadership and transition |
| Catalyst AI | Interprets manual and future news catalysts |
| Skeptic AI | Generates dissenting view and invalidation |
| Risk AI | Reviews data quality, validation, risk flags |
| Portfolio AI | Future: maps ideas to user portfolio context |
| Report Editor AI | Writes structured research brief |
| Guardrail AI | Blocks forbidden wording and unsupported claims |

## 3. AI Input Rules

AI input must be structured facts, not raw unbounded context.

```json
{
  "as_of": "2026-07-08",
  "layer_outputs": {},
  "rulebook_outputs": {},
  "validation": {},
  "data_freshness": {},
  "capability_gates": {},
  "feature_flags": {}
}
```

AI must not silently invent market data, external news, probabilities, target prices, or order instructions.

## 4. AI Output Contract

```json
{
  "stance": "selective_rotation_watch",
  "confidence": "medium",
  "base_case": "...",
  "bull_case": "...",
  "bear_case": "...",
  "rotation_case": "...",
  "dissenting_view": "...",
  "risks": [],
  "invalidation": [],
  "evidence_refs": [],
  "blocked_claims": [],
  "actionability_level": "research_only"
}
```

## 5. AI Committee Flow

```text
Layer 0~4 facts
  -> Market Flow AI
  -> Sector Rotation AI
  -> Catalyst AI
  -> Skeptic AI
  -> Risk AI
  -> Guardrail AI
  -> Final AI Judgment
  -> Report Editor AI
  -> API response
```

## 6. Capability Levels

AI must read allowed capability level from `docs/10_CAPABILITY_GATES.md` and runtime gate output.

At Level 2, AI may generate scenario and rotation watch. It may not produce buy/sell recommendations, target prices, expected returns, or order intents.

## 7. Prompt Design Rules

- Use JSON input.
- Request JSON output.
- Include forbidden claims list.
- Include validation stage.
- Include data freshness warnings.
- Ask for dissenting view and invalidation.
- Ask for blocked capabilities to be listed.

## 8. Audit Logging

Every AI user-facing output requires:

```text
decision_id
model_name
model_version
input_hash
output_hash
guardrail_result
capability_level
created_at
```

## 9. Future AI Expansion

AI can expand to stock candidates, portfolio advice, and execution only after:

- Source data is point-in-time safe.
- Validation stage allows the output type.
- Capability gate allows the output type.
- Risk governance exists.
- Audit logging is complete.
- User suitability exists where personalized advice is involved.
