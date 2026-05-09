# Graph Tool Notes (from Context7 docs)

## Plotly (`/plotly/plotly.py`)
- Strong for interactive, publication-quality charts.
- Relevant trace types for this project:
  - bar/scatter combos,
  - annotated heatmaps,
  - timeline-like cartesian traces,
  - sankey-style flow visuals.
- Legend grouping (`legendgroup`) is useful for layered evidence views.

## Matplotlib (`/websites/matplotlib_stable`)
- Good for static report-ready figures with precise control.
- Use `Axes.annotate` / `Figure.legend` / `Figure.colorbar` for explanatory visuals.
- Export publication output with `savefig(..., dpi=..., bbox_inches='tight')`.

## Practical split for this skill
- If reader must interact/drill down -> Plotly.
- If final PDF/static report artifact -> Matplotlib/Seaborn.
