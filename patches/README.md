# Loop Custom Patches

Custom patches for Justin's Loop build. These are automatically applied during the GitHub Actions CI/CD pipeline (build_loop.yml) before each build.

## Patch Organization

```
patches/
├── workspace/          # Workspace-level patches (top-level files like xcconfig, etc.)
│   └── .gitkeep
├── 01-now-line.patch   # Submodule patch: LoopKit (applied with --directory=LoopKit)
└── README.md           # This file
```

### How Patches Are Applied

1. **Workspace-level patches** (`patches/workspace/*`): Applied with `git apply ./patches/workspace/*` — for changes to top-level LoopWorkspace files.
2. **Submodule patches** (`patches/NN-name.patch`): Applied individually with `git apply --directory=SubmoduleName` — specified in the build_loop.yml "Customize Loop" step.

### Adding New Patches

**For workspace-level changes:**
```bash
cd ~/p/LoopWorkspace
# Make changes to top-level files
git diff > patches/workspace/my-change.patch
```

**For submodule changes:**
```bash
cd ~/p/LoopWorkspace/<SubmoduleName>
# Make changes
git diff > ../patches/NN-description.patch
# Then add an apply line in build_loop.yml's "Customize Loop" step:
#   git apply ./patches/NN-description.patch --directory=<SubmoduleName> -v --whitespace=fix
```

**Naming convention:** Use numeric prefixes (`01-`, `02-`, etc.) for ordering.

---

## Active Patches

### 01-now-line.patch
**Target:** LoopKit submodule  
**What:** Adds a vertical "now line" to all Loop charts (Glucose, IOB, COB, Dose)  
**Why:** Makes it much easier to visually identify "right now" on the scrollable charts. Very popular community customization from Loop & Learn.  
**Files modified:**
- `LoopKitUI/Charts/COBChart.swift` — Carbs on Board chart (line color: carbTint)
- `LoopKitUI/Charts/IOBChart.swift` — Insulin on Board chart (line color: insulinTint)
- `LoopKitUI/Charts/DoseChart.swift` — Insulin Dose chart (line color: insulinTint)
- `LoopKitUI/Charts/PredictedGlucoseChart.swift` — Glucose chart (line color: glucoseTint)

**How it works:** Each chart gets a `currentTimeLayer` — a `ChartGuideLinesForValuesLayer` with a single X-axis value at `Date()`, rendered as a 1pt colored vertical line using the chart's tint color.

**Risk level:** Low — purely visual, no algorithm or data changes. Based on the well-tested Loop & Learn `now_line` customization.

---

## Patch Maintenance

- **Upstream sync conflicts:** If upstream LoopKit changes the chart files, the patch may fail to apply. The build will fail in CI, alerting us to regenerate the patch.
- **Regenerating a patch:** Check out the current upstream, make the same change, `git diff > patches/NN-name.patch`.
- **90-day TestFlight rule:** Builds expire after 90 days. The weekly auto-build handles renewal, but broken patches block the cycle.
