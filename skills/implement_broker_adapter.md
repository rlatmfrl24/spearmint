# Skill: Implement Broker Adapter

Use this only for Phase 7+ broker work.

1. Read `docs/18_BROKER_AND_EXECUTION_SELECTION.md`, `docs/10_CAPABILITY_GATES.md`, and `docs/11_RISK_GOVERNANCE.md`.
2. Broker adapter target is IBKR Web API unless a decision record changes it.
3. Start with sandbox/paper mode only.
4. Never allow AI, Rulebook, or UI to call broker directly.
5. Required path: AI Judgment -> Capability Gate -> Risk Gate -> Order Intent -> Approval -> Broker Adapter -> Audit.
6. Add duplicate order prevention and kill switch tests.
7. Live trading remains disabled unless regulatory, broker, and risk gates pass.
