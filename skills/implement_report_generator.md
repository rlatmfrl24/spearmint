# Skill: Implement Report Generator

Use this when generating research briefs.

## Steps

1. Read `docs/12_REPORTING_SPEC.md`.
2. Use structured snapshot payload only.
3. Generate sections from templates first; LLM editing may be added later behind guardrails.
4. Include executive summary, evidence, disagreement, risks, invalidation, freshness, validation caveat.
5. Block unsupported claims.
6. Add text consistency tests.

## Required Report Sections

```text
Executive Summary
Market Flow
Current RS Leader
Momentum Leader / Rotation Watch
Breadth and Participation
Risks
Invalidation
Data Freshness Appendix
Validation Caveat
```
