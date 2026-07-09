# 05. Rulebook

Last updated: 2026-07-08

## 1. Purpose

The Rulebook converts module states into explainable sector judgments. It does not recalculate metrics.

## 2. Input Contract

```json
{
  "relative_strength": {},
  "momentum": {},
  "breadth": {},
  "participation": {},
  "rotation": {},
  "catalyst": {},
  "market_context": {},
  "data_quality": {}
}
```

## 3. Output Contract

```json
{
  "direction": "up",
  "strength": 3,
  "conviction_label": "rule_aligned",
  "lead_pattern": "Strong Leader",
  "narrative": "...",
  "risks": [],
  "invalidation": [],
  "source_metrics": {},
  "data_freshness": {},
  "validation_status": "not_validated"
}
```

`conviction_label` is not a probability. It describes rule alignment and evidence quality.

## 4. Pattern Definitions

### Strong Leader

Condition intent:

```text
relative_strength strong
momentum strengthening or stable-high
breadth healthy
participation confirmed
no major veto
```

Required output:

- Narrative says leadership is confirmed by multiple modules.
- Risks mention what would weaken confirmation.
- Invalidation includes RS momentum deterioration and participation failure.

### Emerging Leader

```text
relative_strength improving or near-strong
momentum strengthening
breadth improving
participation at least neutral or improving
```

### Borderline Leader

```text
RRG Leading
but breadth or participation not strong enough for high conviction
```

### Late Leader

```text
relative_strength still strong
momentum weakening
breadth narrowing or participation no longer expanding
```

### Mega-cap Dependence

```text
ETF or sector proxy strong
breadth narrow
concentration risk high or breadth unavailable with warning
```

### False Leadership

```text
price/RS strong
participation unconfirmed or breaking down
breadth weak or deteriorating
```

### Healthy Expansion

```text
breadth improving
participation confirmed
relative_strength stable or improving
```

### Weak Expansion

```text
breadth improving
participation not confirmed
relative_strength not yet strong
```

### Breakdown

```text
relative_strength weak
momentum weakening
participation breakdown
market context hostile or data confirms weakness
```

## 5. Veto Rules

| Veto | Effect |
|---|---|
| Momentum Collapse | Blocks Strong Up |
| Participation Breakdown | Blocks high conviction |
| Catalyst Reversal | Lowers strength |
| Broad Breadth Collapse | Adds risk flag |
| Data Insufficient | Blocks high conviction and user-facing strong wording |
| Stale Source | Blocks AI Level 3+ outputs |

## 6. Narrative Template

Use this structure:

```text
[Observed state].
[Evidence modules].
[Module disagreement, if any].
[Risk].
[Invalidation condition].
[Validation status caveat].
```

Example:

```text
Technology remains the current RS leader, but momentum is weakening and breadth is narrowing. Participation is still confirmed, so the sector is not yet a false leader. This view weakens if RS momentum falls for two consecutive observations or if participation turns unconfirmed. Historical validation is not yet sufficient for probability-like language.
```

## 7. Guardrails

Forbidden in MVP rulebook outputs:

```text
buy
sell
target price
expected return
high probability of rising
win rate
```

Allowed:

```text
research strength
rule alignment
leadership quality
transition watch
risk flag
invalidation condition
```

Future phases may allow stronger actionability only through capability gates.

## 8. Tests

Each pattern must have at least:

- Positive case
- Negative case
- Veto override case
- Missing data case
- Narrative contains risk and invalidation
- Contract schema test
