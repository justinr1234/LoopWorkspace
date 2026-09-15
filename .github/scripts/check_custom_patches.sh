#!/usr/bin/env bash
# Verifies the custom patches in patches/ still land in a Loop build.
#
# For each build workflow, runs its "Customize Loop" step exactly as CI does,
# then checks that every patches/*.patch is actually applied. This catches both:
#   - a patch that no longer applies to the current Loop/LoopKit code, and
#   - a workflow that no longer applies patches/ (e.g. changed by an upstream
#     merge), which would otherwise build WITHOUT the customizations.
#
# Run from the root of a LoopWorkspace checkout with submodules.
# Usage: .github/scripts/check_custom_patches.sh [workflow.yml ...]
set -euo pipefail

workflows=("$@")
if [ ${#workflows[@]} -eq 0 ]; then
  workflows=(.github/workflows/build_loop.yml .github/workflows/build_loop_auto.yml)
fi

command -v yq > /dev/null || { echo "::error::yq is required"; exit 1; }

shopt -s nullglob
patches=(patches/*.patch)
if [ ${#patches[@]} -eq 0 ]; then
  echo "::error::No patches found in patches/"
  exit 1
fi

reset_submodules() {
  git submodule foreach --quiet --recursive 'git checkout --quiet -- . && git clean -fdq'
}
trap reset_submodules EXIT

failed=0
for wf in "${workflows[@]}"; do
  echo "::group::$wf"
  step=$(yq '.jobs.build.steps[] | select(.name == "Customize Loop") | .run' "$wf")
  if [ -z "$step" ]; then
    echo "::error file=$wf::No 'Customize Loop' step found"
    failed=1
  else
    reset_submodules
    if ! bash -e -c "$step"; then
      echo "::error file=$wf::'Customize Loop' step failed"
      failed=1
    else
      for p in "${patches[@]}"; do
        # The build applies with --whitespace=fix, so match the same way in reverse.
        if git apply --reverse --check --whitespace=fix "$p" 2> /dev/null; then
          echo "applied: $p"
        else
          echo "::error file=$wf::$p was not applied by the 'Customize Loop' step"
          failed=1
        fi
      done
    fi
  fi
  echo "::endgroup::"
done

exit $failed
