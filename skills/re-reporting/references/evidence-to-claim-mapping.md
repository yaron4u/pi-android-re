# Evidence-to-Claim Mapping

## Canonical mapping template

| Claim ID | Claim text | Evidence ID(s) | Evidence type | Strength | Gaps / caveats |
|---|---|---|---|---|---|
| C1 |  | E1 | code / log / diff / trace / diagram | high/med/low |  |

## Evidence quality tiers
- **High:** direct code path + reproducible artifact (trace/log/diff).
- **Medium:** indirect indicator, plausible but partially inferred.
- **Low:** anecdotal or single noisy observation.

## Rules
1. Every major claim must map to at least one High/Medium evidence item.
2. If all evidence is Low, claim must be downgraded to hypothesis.
3. Negative results are evidence too; record them.
4. Keep raw artifact path/hash for reproducibility.

## Minimal artifact ledger

| Evidence ID | Source | File/hash/link | Reproduction command | Notes |
|---|---|---|---|---|
| E1 | static RE |  |  |  |
