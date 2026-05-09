# Graph Selection Matrix (Question -> Chart)

| Question to answer | Best graph | Why it works | Data shape | Preferred libs |
|---|---|---|---|---|
| Where is the vulnerable component in system architecture? | Layered architecture diagram | Shows trust boundaries/privilege rings | Components + edges + trust levels | graphviz, mermaid |
| How does input reach the bug? | Flowchart / dataflow | Clarifies path and choke points | Ordered steps + branch conditions | graphviz, mermaid |
| What changed between vulnerable and patched states? | Side-by-side diff panel + mini table | Makes fix semantics explicit | before/after flags, checks | matplotlib (table), markdown diff |
| Which steps are time-sensitive (race/UAF)? | Swimlane timeline | Captures interleaving | actor, timestamp/order, state | mermaid sequence, plotly timeline |
| What fields in a struct/command matter? | Bitfield / layout diagram | Reduces parsing burden | offset, width, semantic meaning | mermaid, graphviz |
| Which primitives were achieved (R/W/exec) and at what privilege? | Capability ladder chart | Communicates escalation logic | stage, primitive, boundary crossed | matplotlib, altair |
| Which devices/versions are affected? | Heatmap matrix | Fast coverage reading | device x version x status | seaborn, plotly |
| How frequent are crash signatures / outcomes? | Ranked horizontal bar chart | Best for comparison | category + count | matplotlib, seaborn |
| How do root causes distribute by class? | Pareto chart | Prioritizes remediation focus | class + count + cumulative% | matplotlib |
| How uncertain is measurement/probability? | Errorbar/CI plot | Makes confidence explicit | metric + CI bounds | seaborn, matplotlib |
| How does command grammar map to hardware effects? | State diagram | Captures transitions and invalid edges | states + transitions + guards | graphviz, mermaid |
| How does evidence support each claim? | Evidence-claim adjacency matrix (appendix-first) | Auditability for reviewers | claim x evidence links | seaborn heatmap |
| Which checks lead to which user-visible outcomes? | Check-to-impact matrix | Connects technical controls to user/business effect | check x outcome link | seaborn heatmap, matplotlib table |
| What should we fix first? | Priority-ranked action bar chart | Converts findings into execution order | action + priority score | matplotlib, altair |

## Decision shortcuts
- Sequential and deterministic -> flowchart.
- Interleaving actors/threads -> swimlane timeline.
- Coverage/comparison grids -> heatmap.
- Rank comparisons -> horizontal bars.
- Uncertainty/statistics -> CI/error bars.
- Trust boundaries -> architecture diagram.
- Non-technical audience default -> flowchart + impact matrix + priority chart.
- Evidence adjacency matrix -> appendix unless audience is audit/peer-review.

## Mandatory caption format
**Figure N — [object]. [argument role / what to notice].**
