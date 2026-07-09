# 19. Regulatory Scope

Last updated: 2026-07-08
Status: **Architecture policy, not legal advice**

## 1. Purpose

This document defines conservative product gates for jurisdiction-sensitive features. It does not replace legal counsel.

## 2. MVP Regulatory Posture

The MVP is a research dashboard.

Allowed:

- sector flow analysis
- non-personalized research commentary
- data freshness and validation readiness
- historical diagnostics clearly labeled as diagnostics
- AI scenarios within research-only wording

Blocked:

- personalized buy/sell/hold advice
- target prices
- expected returns
- user-specific portfolio weights
- broker-ready order suggestions
- automatic order submission
- claims of calibrated probability before validation gate

## 3. U.S. Gate

Before U.S. user-facing personalized advice, order proposals, or auto-trading:

- complete investment-adviser / broker-dealer / publisher-exclusion legal memo,
- determine registration, exemption, or broker-partner route,
- prepare disclosures and conflict policy,
- build user suitability/profile model,
- store advice and order audit trail,
- ensure broker approval for third-party or automated trading workflow,
- document supervision and compliance workflow.

## 4. Korea Gate

Before Korea user-facing personalized advice, order proposals, or auto-trading:

- complete local counsel review under Korean financial investment laws,
- determine whether investment advisory, discretionary investment, robo-advisor, or broker API restrictions apply,
- review domestic broker API terms,
- build suitability/investor-profile checks,
- store advice and order audit trail,
- prepare Korean-language disclosures and user consents.

## 5. Copy Gate

Research copy may say:

```text
리서치 관점에서 강세가 확인됩니다.
전환 관찰 구간입니다.
이 판단은 아래 조건에서 약화됩니다.
검증 상태는 제한적입니다.
```

Gated copy requires Level 5+ or higher:

```text
매수하세요.
매도하세요.
목표가는 ...입니다.
기대수익률은 ...입니다.
주문을 제안합니다.
자동으로 매수합니다.
```

## 6. Enforcement

Regulatory policy is enforced through:

- `config/regulatory_scope.yaml`
- `docs/10_CAPABILITY_GATES.md`
- `docs/11_RISK_GOVERNANCE.md`
- `docs/18_BROKER_AND_EXECUTION_SELECTION.md`
- AI guardrail validator
- report copy tests
- UI copy snapshot tests
