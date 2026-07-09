# 12. Reporting Spec

Last updated: 2026-07-08

## 1. Purpose

The reporting layer turns structured facts into readable research briefs without inventing unsupported claims.

## 2. Report Types

| Report | Phase | Purpose |
|---|---|---|
| Daily Market Flow Brief | MVP | Market regime and sector leadership |
| Sector Leadership Brief | MVP | Current leader, momentum leader, risks |
| Validation Appendix | MVP | Replay readiness and diagnostics |
| AI Scenario Brief | Phase 2~3 | Base/bull/bear/rotation scenarios |
| Stock Candidate Brief | Future | Candidate list and evidence |
| Portfolio Advice Brief | Future | User-specific recommendations |
| Execution Review | Future | Orders, fills, risk checks, audit |

## 3. MVP Research Brief Sections

```text
1. Executive Summary
2. Market Flow
3. Current RS Leader
4. Momentum Leader / Rotation Watch
5. Sector Breadth and Participation
6. Market Context
7. Module Disagreement
8. Risks
9. Invalidation Conditions
10. Data Freshness Appendix
11. Validation Caveat
```

## 4. Required Input Payload

```json
{
  "as_of": "2026-07-08",
  "benchmark": "SPY",
  "layer_outputs": {},
  "rulebook_outputs": {},
  "ai_judgment": {},
  "source_freshness": {},
  "validation": {},
  "capability_gates": {}
}
```

## 5. Writing Rules

Use this sequence:

```text
Observation -> Evidence -> Interpretation -> Risk -> Invalidation -> Validation/Freshness Caveat
```

Forbidden:

```text
Unsupported prediction
Unvalidated probability
Buy/sell command
Target price
Expected return
Order instruction
```

Allowed:

```text
research stance
transition watch
rule alignment
risk flag
scenario if gated
sample-observed diagnostics if Layer 4 allows
```

## 6. Report Output Contract

```json
{
  "report_id": "...",
  "as_of": "2026-07-08",
  "sections": [
    {
      "section_id": "executive_summary",
      "title": "Executive Summary",
      "body": "...",
      "evidence_refs": [],
      "warnings": []
    }
  ],
  "blocked_claims": [],
  "data_freshness_appendix": {},
  "validation_caveat": "..."
}
```

## 7. Consistency Tests

- Numbers in text match payload.
- Report includes risks and invalidation.
- Report includes freshness appendix.
- Report does not contain blocked words for current capability level.
- AI scenario report includes dissenting view.
