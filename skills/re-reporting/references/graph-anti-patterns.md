# Graph Anti-Patterns

## Fatal mistakes
1. **Chart without question**
   - Fix: state one explicit question before plotting.
2. **Decorative complexity** (3D, gradients, chartjunk)
   - Fix: flat encoding, minimal ink.
3. **Mismatched chart type**
   - Fix: use matrix in `graph-selection-matrix.md`.
4. **Truncated baselines for bars**
   - Fix: start bars at zero unless justified and disclosed.
5. **Unlabeled units/axes**
   - Fix: include units and data source in caption or axis labels.
6. **Color encodes too many dimensions**
   - Fix: max 1 semantic mapping per channel.
7. **No uncertainty when uncertainty exists**
   - Fix: show CI/error ranges or explicit caveat.
8. **Unreadable dense text in diagrams**
   - Fix: split diagrams by stage; keep labels short.
9. **Inconsistent color semantics across report**
   - Fix: reserve semantic palette globally.
10. **Evidence hidden in appendix only**
   - Fix: put critical supporting visuals near claims.

## Security-report specific failures
- Mixing confirmed vs hypothetical paths in same visual.
- Showing exploit recipe details when only impact communication is needed.
- Claiming universality from single-device data.
- Leading with evidence-claim matrices for executive readers.
- Showing confidence scoring charts without a direct decision/action takeaway.

## Pre-publish graph checks
- [ ] Question stated?
- [ ] Correct chart family?
- [ ] Caption explains argument role?
- [ ] Units + sample + scope shown?
- [ ] Limitations noted?
- [ ] Color semantics consistent?
- [ ] Can a non-specialist explain this figure in 20 seconds?
- [ ] If removed, would this reduce decision quality?
