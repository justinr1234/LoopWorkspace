# Custom Patches for justinr1234/LoopWorkspace

These patches are automatically applied during the GitHub Actions browser build
(see `.github/workflows/build_loop.yml` → "Customize Loop" step).

## Active Patches

| Patch | Submodule | Description |
|-------|-----------|-------------|
| `01-now-line.patch` | LoopKit | Adds a vertical "now" line to all charts (glucose, IOB, COB, dose) showing current time |
| `02-override-sensitivity.patch` | LoopKit | Override insulin sensitivity range: 50%–200% in 5% steps (default is 10%–200% in 10% steps) |
| `03-future-carbs-4h.patch` | Loop | Extends future carb entry window from 1 hour to 4 hours for advance meal planning |

## Patch Details

### 01-now-line.patch (LoopKit)
- **Source:** Loop & Learn community (`now_line`)
- **Files:** `COBChart.swift`, `DoseChart.swift`, `IOBChart.swift`, `PredictedGlucoseChart.swift`
- **Effect:** Draws a colored vertical line at the current time on every chart, making it easy to see "now" relative to predictions and history

### 02-override-sensitivity.patch (LoopKit)
- **Source:** Loop & Learn community (`override_sens`)
- **File:** `InsulinSensitivityScalingTableViewCell.swift`
- **Effect:** Changes override insulin sensitivity picker from 10–200% (10% steps) to 50–200% (5% steps). Allows finer-grained control during exercise, illness, stress, etc.

### 03-future-carbs-4h.patch (Loop)
- **Source:** Loop & Learn community (`future_carbs_4h`)
- **File:** `LoopConstants.swift`
- **Effect:** Extends `maxCarbEntryFutureTime` from 1 hour to 4 hours. Useful for pre-logging carbs when you know you'll eat later (e.g., dinner reservation in 2 hours). Loop will start adjusting insulin delivery based on the planned carbs.

## Adding New Patches

1. Create a `.patch` file in this directory with numeric prefix (e.g., `04-my-change.patch`)
2. Add a corresponding `git apply` line in `build_loop.yml` specifying the correct `--directory=SubmoduleName`
3. Workspace-level patches go in `patches/workspace/` and are auto-applied
4. Test that the patch applies cleanly: `git apply --check patches/NN-name.patch --directory=SubmoduleName`

## References

- [Loop & Learn Customization](https://www.loopandlearn.org/custom-code-browser-build/)
- [loopandlearn/customization repo](https://github.com/loopandlearn/customization)
- [LoopDocs: Customize Your Loop](https://loopkit.github.io/loopdocs/build/code-customization/)
