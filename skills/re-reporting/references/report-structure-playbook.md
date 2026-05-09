# Report Structure Playbook

## Recommended spine
1. Title + metadata
2. Executive summary (plain-English first)
3. Decision snapshot (top risks, top actions, owners)
4. Scope / environment / assumptions
5. Background needed for this bug class
6. Architecture and trust boundaries
7. Attack surface and entry points
8. Data structures / protocol format (if needed)
9. Root cause analysis
10. Evidence blocks (claim -> evidence -> interpretation)
11. Impact and exploitability limits
12. Patch / mitigation analysis
13. Conclusion and lessons
14. Disclosure timeline + references
15. Technical appendix (full artifacts, traces, PoCs)

## Section goals
- **Summary:** what was found, why it matters, what remains uncertain.
- **Decision snapshot:** what leadership should approve now (priority + owner + timeline).
- **Scope:** tested devices/versions and what was not tested.
- **Root cause:** broken assumption, not just crash behavior.
- **Impact:** boundary crossed + required preconditions.
- **Mitigation:** what fix changes and residual risk.

## Paragraph rhythm
Claim -> context -> evidence -> meaning -> transition.

For reader-friendly reports, append one plain-language line per finding:
- **So what:** [business/user impact in one sentence]

## Safe language constraints
- Prefer: “on tested builds”, “under these assumptions”, “local privilege escalation”.
- Avoid: “universal root”, “full pwn”, “works everywhere”.
