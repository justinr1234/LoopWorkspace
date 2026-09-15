# Custom Patches for justinr1234/LoopWorkspace

Every `*.patch` file here is applied by LoopKit's stock "Customize Loop" step in
both build workflows (`build_loop.yml` and `build_loop_auto.yml`):

    git apply ./patches/* --allow-empty -v --whitespace=fix

That line ships with upstream, so the workflows in this fork stay identical to
LoopKit/LoopWorkspace and upstream syncs can't drop or break the patch step.
**Don't edit the build workflows to add patches.**

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

1. Make the change inside the submodule, then write the patch with paths relative
   to the LoopWorkspace root (`LoopKit/...`, `Loop/...`), e.g.:

       git -C LoopKit diff --src-prefix=a/LoopKit/ --dst-prefix=b/LoopKit/ > patches/04-my-change.patch

2. Use a numeric prefix; patches apply in filename order.
3. Keep only `*.patch` and `*.md` files here. A subdirectory makes the stock
   `git apply ./patches/*` fail.
4. Verify from the LoopWorkspace root (submodules checked out, `yq` installed):

       .github/scripts/check_custom_patches.sh

## Safety Net

`.github/workflows/check_custom_patches.yml` (fork-only) runs on every push to
`dev` and daily. It runs each build workflow's own "Customize Loop" step and
fails if any patch here isn't applied, both against this fork (the next build)
and against upstream's latest `dev` (the next sync). A failure means a patch
needs refreshing, or upstream changed how patches are applied, and it shows up
before the Sunday build.

## References

- [Loop & Learn Customization](https://www.loopandlearn.org/custom-code-browser-build/)
- [loopandlearn/customization repo](https://github.com/loopandlearn/customization)
- [LoopDocs: Customize Your Loop](https://loopkit.github.io/loopdocs/build/code-customization/)
