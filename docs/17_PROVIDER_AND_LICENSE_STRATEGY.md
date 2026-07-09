# 17. Provider and License Strategy

Last updated: 2026-07-08
Decision status: **Accepted with license gates**

## 1. Decision

Use a provider abstraction from day one.

MVP source profile:

| Data | Provider profile | Class | Gate |
|---|---|---|---|
| ETF OHLCV | `prices.massive_us_stocks` | vendor | license required |
| Macro/risk | `macro.fred` | official macro | API key/terms |
| SEC filings/XBRL | `filings.sec_edgar` | official filing | SEC access policy |
| Sector ETF universe references | `universe.ssga_sector_spdr` | issuer reference | terms review |
| Sector/GICS taxonomy reference | `indices.sp_global_sectors` | index reference | index license review |
| Test data | `prices.fixture` | fixture | tests only |

## 2. Principles

- Never hard-code provider URLs inside metrics or UI.
- Provider adapters fetch and normalize data; metrics consume normalized stores only.
- All provider records must include `source_id`, `fetched_at`, `known_at`, `license_status`, and `quality_status`.
- Public dashboard display must be blocked when redistribution/display rights are unknown.
- Unit tests must use fixtures and never call the network.

## 3. Price Data Decision

The primary price provider profile is `prices.massive_us_stocks`, because the API provides U.S. stock market reference data, OHLC aggregate bars, grouped daily market summaries, snapshots, trades, quotes, and related endpoints.

Production use requires a commercial/redistribution review. The code must support replacing this provider with another licensed provider without changing metrics, rulebook, API, or UI.

## 4. Official Supporting Data

SEC EDGAR:

- Use for filings metadata and XBRL financial facts.
- Prefer bulk ZIP for large backfills.
- Use `accepted_at`, `filed_at`, `published_at`, and `known_at` fields for point-in-time correctness.

FRED/ALFRED:

- Use for macro/risk series such as VIX, 10-year Treasury yield, high-yield spread.
- Use ALFRED vintage dates when historical macro values can be revised.

## 5. Issuer and Index References

State Street and S&P references are useful for universe/taxonomy. Do not assume automated holdings ingestion, index constituents, or redistribution is allowed.

Holdings-level breadth is disabled until:

1. terms allow ingestion,
2. redistribution/display rights are documented,
3. holdings have `asof_at` and `known_at`,
4. issuer/vendor source cadence is modeled,
5. rulebook output includes freshness and license scope.

## 6. Runtime License Gate

Provider gate output:

```json
{
  "source_id": "prices.massive_us_stocks",
  "license_status": "license_required",
  "public_display_allowed": false,
  "research_internal_allowed": true,
  "reason": "Commercial redistribution rights not recorded."
}
```

If a required source is blocked:

- return `license_blocked` for affected modules,
- do not fabricate fallback metrics,
- show data collection warning,
- lower or block Rulebook conviction.

## 7. Source Registry Files

- `config/source_registry.yaml`
- `config/provider_policy.yaml`
