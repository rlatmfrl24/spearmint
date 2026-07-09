# 15. Market Scope Decision

Last updated: 2026-07-08
Decision status: **Accepted**

## 1. Decision

The Phase 1 primary market is the **U.S. S&P 500 sector ETF universe**.

Benchmark:

```text
SPY
```

Primary sector ETF universe:

```text
XLC, XLY, XLP, XLE, XLF, XLV, XLI, XLB, XLRE, XLK, XLU
```

## 2. Rationale

This universe is the best first market because it aligns directly with the sector-first design.

- It gives a clean benchmark relationship against SPY.
- It supports relative strength, RS momentum, RRG quadrant, leadership transition, and false leadership analysis.
- It has a compact universe that is suitable for deterministic tests and early validation.
- It can later expand downward into holdings/constituents and upward into macro, factor, country, and global theme layers.
- It avoids the early complexity of individual stock recommendations, tax/personal suitability, and country-specific retail advice rules.

## 3. External Reference Basis

- S&P Sector and Industry Indices measure segments of the U.S. stock market using GICS.
- State Street's sector tracker monitors the 11 State Street Sector ETFs and their underlying holdings, but holdings/performance data must be used only in ways permitted by license/terms.
- The MVP should treat issuer/index pages as universe references, not as a guaranteed automated data source unless terms explicitly allow ingestion.

## 4. Universe Contract

`config/universe.yaml` is the source of truth for the active market. Codex must not add a sector, benchmark, or proxy directly in code.

```yaml
market:
  code: US_SP500_SECTOR_ETF
benchmark:
  code: SPY
sectors:
  - XLC
  - XLY
  - XLP
  - XLE
  - XLF
  - XLV
  - XLI
  - XLB
  - XLRE
  - XLK
  - XLU
```

## 5. Breadth Strategy

MVP breadth should start with proxy breadth and ETF-level confirmation.

Allowed in MVP:

- SPY vs RSP for equal-weight participation proxy.
- Sector ETF price/volume participation.
- Sector-level advancing/declining proxy if licensed/security-level data is available.

Blocked until license/data gate:

- Automated ETF holdings scraping.
- Constituent-level breadth using issuer holdings without terms review.
- Redistribution of holdings, weights, or index constituent data.

## 6. Expansion Plan

| Phase | Market | Entry condition |
|---|---|---|
| Phase 1 | U.S. S&P 500 sector ETFs | Active |
| Phase 2 | Korea KRX sector/industry and domestic ETFs | KRX/OpenDART/KIND source and local regulatory docs complete |
| Phase 3 | Global theme/country/style ETFs | Multi-currency, calendar, and benchmark models complete |
| Phase 5+ | Individual stocks | Stock candidate layer, valuation, and advice gates complete |

## 7. Do Not Do

- Do not mix Korean, U.S., and global ETF universes in the same RS ranking without an explicit benchmark and currency normalization model.
- Do not treat theme ETFs as equivalent to GICS sector ETFs.
- Do not expose holdings-level breadth unless the data source is licensed and mapped to `known_at`.
