#!/usr/bin/env bash
#
# validate.sh — LOCAL regression check for the federated
# mapbox_maps_flutter plugin migration. This script is NOT wired into
# CI; it's a one-command gate each migration workstream runs before
# opening a PR. The CI set and this script's set intentionally differ.
#
# Stages:
#   1. static           — flutter pub get, dart analyze, dart format
#   2. codegen-drift    — make generate-all, fail if git is dirty
#   3. unit-tests       — flutter test in facade / platform_interface / web
#   4. api-breakage     — REGRESSION DETECTOR (see below), not absolute gate
#   5. android          — integration tests on an Android device
#   6. ios              — integration tests on an iOS simulator
#   7. chrome           — integration tests on Chrome
#   8. mobile-sanity    — flutter test + pub publish --dry-run in mobile pkg
#
# Each stage has a matching --skip-<stage> flag. --only <stage> runs a
# single stage. Device stages also skip automatically when the required
# environment variable is missing.
#
# Stage 4 (api-breakage) semantics:
#   The 3.0.0-beta federated facade intentionally diverges from the
#   pub.dev 2.22.0 reference. The expected count of unapproved
#   breaking changes drops organically as WS1 – WS5 rewrap APIs, and
#   WS6 zeroes it out via allow-list entries. So stage 4 is a
#   regression detector, not an absolute gate:
#     - baseline: packages/mapbox_maps_flutter/scripts/breakage_baseline.txt
#     - fail  if current unapproved count > baseline (new breakage)
#     - pass  if count == baseline (steady state)
#     - pass  if count <  baseline (progress!) and remind to decrement
#                                   the baseline file in the same commit.
#
# Environment variables:
#   MAPBOX_ACCESS_TOKEN   Mapbox public token for integration tests.
#                         Required for stages 5 / 6 / 7.
#   ANDROID_DEVICE        Android device id for -d in stage 5.
#                         Optional; falls back to flutter's default device.
#   IOS_DEVICE            iOS simulator id/name for -d in stage 6.
#                         Optional; falls back to flutter's default device.
#
# Dependencies:
#   - flutter, dart on PATH
#   - dart_apitool activated: dart pub global activate dart_apitool
#   - patrol_cli activated (stages 5/6/7): dart pub global activate patrol_cli
#   - jq, curl, git, make
#   - npm, node (for stage 2, transitively via make)
#
# Exit code is 0 on full success, 1 on any stage failure.

set -o pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
FACADE_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
PROJECT_ROOT="$(cd "$FACADE_DIR/../.." && pwd)"
PACKAGES_DIR="$PROJECT_ROOT/packages"

INTERFACE_DIR="$PACKAGES_DIR/mapbox_maps_flutter_platform_interface"
MOBILE_DIR="$PACKAGES_DIR/mapbox_maps_flutter_mobile"
WEB_DIR="$PACKAGES_DIR/mapbox_maps_flutter_web"

# Stages toggled on by default.
RUN_STATIC=1
RUN_CODEGEN_DRIFT=1
RUN_UNIT_TESTS=1
RUN_API_BREAKAGE=1
RUN_ANDROID=1
RUN_IOS=1
RUN_CHROME=1
RUN_MOBILE_SANITY=1

ONLY_STAGE=""

usage() {
  cat <<EOF
Usage: validate.sh [--only <stage>] [--skip-<stage> ...] [--help]

Stages: static | codegen-drift | unit-tests | api-breakage | android | ios | chrome | mobile-sanity

Examples:
  scripts/validate.sh                          # run everything
  scripts/validate.sh --skip-android --skip-ios --skip-chrome
  scripts/validate.sh --only api-breakage
EOF
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --skip-static)         RUN_STATIC=0 ;;
    --skip-codegen-drift)  RUN_CODEGEN_DRIFT=0 ;;
    --skip-unit-tests)     RUN_UNIT_TESTS=0 ;;
    --skip-api-breakage)   RUN_API_BREAKAGE=0 ;;
    --skip-android)        RUN_ANDROID=0 ;;
    --skip-ios)            RUN_IOS=0 ;;
    --skip-chrome)         RUN_CHROME=0 ;;
    --skip-mobile-sanity)  RUN_MOBILE_SANITY=0 ;;
    --only)
      shift
      [[ $# -gt 0 ]] || { echo "--only needs a stage name"; exit 2; }
      ONLY_STAGE="$1"
      ;;
    -h|--help) usage; exit 0 ;;
    *) echo "unknown flag: $1"; usage; exit 2 ;;
  esac
  shift
done

if [[ -n "$ONLY_STAGE" ]]; then
  RUN_STATIC=0; RUN_CODEGEN_DRIFT=0; RUN_UNIT_TESTS=0; RUN_API_BREAKAGE=0
  RUN_ANDROID=0; RUN_IOS=0; RUN_CHROME=0; RUN_MOBILE_SANITY=0
  case "$ONLY_STAGE" in
    static)          RUN_STATIC=1 ;;
    codegen-drift)   RUN_CODEGEN_DRIFT=1 ;;
    unit-tests)      RUN_UNIT_TESTS=1 ;;
    api-breakage)    RUN_API_BREAKAGE=1 ;;
    android)         RUN_ANDROID=1 ;;
    ios)             RUN_IOS=1 ;;
    chrome)          RUN_CHROME=1 ;;
    mobile-sanity)   RUN_MOBILE_SANITY=1 ;;
    *) echo "unknown stage: $ONLY_STAGE"; usage; exit 2 ;;
  esac
fi

# ───── helpers ──────────────────────────────────────────────────────────

FAILED_STAGES=()
SKIPPED_STAGES=()
PASSED_STAGES=()
SKIPPED_THIS_STAGE=0

banner() {
  echo ""
  echo "───── $1 ─────"
}

run_stage() {
  local name="$1"; shift
  SKIPPED_THIS_STAGE=0
  banner "$name"
  if "$@"; then
    if [[ "$SKIPPED_THIS_STAGE" == "1" ]]; then
      : # already recorded under SKIPPED_STAGES
    else
      PASSED_STAGES+=("$name")
    fi
  else
    FAILED_STAGES+=("$name")
  fi
}

skip_stage() {
  local name="$1"; shift
  local reason="$*"
  echo ""
  echo "─── skip $name — $reason"
  SKIPPED_STAGES+=("$name ($reason)")
  SKIPPED_THIS_STAGE=1
}

require_token() {
  [[ -n "${MAPBOX_ACCESS_TOKEN:-}" ]]
}

# ───── stage 1: static ──────────────────────────────────────────────────

stage_static() {
  echo "flutter pub get (workspace root)"
  (cd "$PROJECT_ROOT" && flutter pub get) || return 1

  local failed=0

  # Analyze each package. Mobile's example/ and test/ dirs were deleted
  # in WS6 (the migrated example app + integration tests live in the
  # facade package), so mobile is now lib-only and can be analyzed in
  # full like the other three packages.
  for d in "$FACADE_DIR" "$INTERFACE_DIR" "$WEB_DIR" "$MOBILE_DIR"; do
    echo ""
    echo "── $(basename "$d") analyze"
    (cd "$d" && dart analyze) || failed=1
  done

  # Format check mirrors `make format`'s target list exactly, so this
  # gate stays aligned with the canonical formatter invocation. Paths
  # outside this list (test/ directories especially) still carry
  # historical drift and are not gated here; expand this list in
  # lockstep with Makefile's `format` rule.
  echo ""
  echo "── dart format check (matches make format scope)"
  (
    cd "$PROJECT_ROOT" && \
    dart format \
      --set-exit-if-changed \
      --output=none \
      --language-version=3.10 \
      packages/mapbox_maps_flutter_mobile/lib \
      packages/mapbox_maps_flutter/lib \
      packages/mapbox_maps_flutter/example/integration_test \
      packages/mapbox_maps_flutter/example/patrol_test \
      packages/mapbox_maps_flutter_platform_interface/lib \
      packages/mapbox_maps_flutter_web/lib
  ) || failed=1

  return $failed
}

# ───── stage 2: codegen drift ───────────────────────────────────────────

stage_codegen_drift() {
  if [[ ! -d "$PROJECT_ROOT/codegen" ]]; then
    echo "no codegen dir; skipping"
    return 0
  fi

  # Only tracked-file modifications can be confused with codegen output;
  # ignore untracked files so a work-in-progress script in scripts/ or a
  # scratch note somewhere doesn't block the drift check.
  local dirty_before
  dirty_before=$(cd "$PROJECT_ROOT" && git diff --name-only -- packages codegen | wc -l | tr -d ' ')
  if [[ "$dirty_before" != "0" ]]; then
    echo "⚠️  packages/ or codegen/ has uncommitted tracked-file changes;"
    echo "    codegen drift cannot distinguish generator output from local"
    echo "    edits. Commit or stash, or re-run with --skip-codegen-drift."
    (cd "$PROJECT_ROOT" && git diff --name-only -- packages codegen)
    return 1
  fi

  echo "make generate-all"
  (cd "$PROJECT_ROOT" && make generate-all) || return 1

  local dirty_after
  dirty_after=$(cd "$PROJECT_ROOT" && git diff --name-only -- packages codegen | wc -l | tr -d ' ')
  if [[ "$dirty_after" != "0" ]]; then
    echo ""
    echo "❌ make generate-all produced a diff — generated files are out of sync"
    (cd "$PROJECT_ROOT" && git diff --name-only -- packages codegen)
    echo ""
    echo "  Run: cd $PROJECT_ROOT && make generate-all && git diff"
    return 1
  fi

  return 0
}

# ───── stage 3: unit tests ──────────────────────────────────────────────

stage_unit_tests() {
  local failed=0
  for d in "$FACADE_DIR" "$INTERFACE_DIR" "$WEB_DIR"; do
    if [[ -d "$d/test" ]]; then
      echo ""
      echo "── $(basename "$d") flutter test"
      (cd "$d" && flutter test) || failed=1
    fi
  done
  return $failed
}

# ───── stage 4: api breakage ────────────────────────────────────────────

stage_api_breakage() {
  # dart_apitool installs its binary into ~/.pub-cache/bin, which isn't
  # on PATH by default. Add it here so `dart pub global activate
  # dart_apitool` is all a contributor has to do.
  local pub_cache_bin="${PUB_CACHE:-$HOME/.pub-cache}/bin"
  local pushed_path=0
  if [[ -d "$pub_cache_bin" ]] && [[ ":$PATH:" != *":$pub_cache_bin:"* ]]; then
    PATH="$pub_cache_bin:$PATH"
    pushed_path=1
  fi

  local baseline_file="$SCRIPT_DIR/breakage_baseline.txt"
  local baseline
  if [[ -f "$baseline_file" ]]; then
    baseline=$(tr -d '[:space:]' < "$baseline_file")
  else
    echo "❌ missing $baseline_file — required for the regression check"
    echo "   Seed it with the current unapproved count: run"
    echo "     scripts/check_api_breakage.sh --count"
    echo "   and write its single-line stdout into scripts/breakage_baseline.txt"
    return 1
  fi
  if ! [[ "$baseline" =~ ^[0-9]+$ ]]; then
    echo "❌ $baseline_file does not contain a plain integer (got: '$baseline')"
    return 1
  fi

  # check_api_breakage.sh --count writes only the integer to stdout.
  # Informational logs and the dart-apitool noise go to stderr, which we
  # let pass through to the user.
  local current
  current=$("$SCRIPT_DIR/check_api_breakage.sh" --count)
  local inner_exit=$?

  # Restore PATH so subsequent stages see the env they started with.
  if [[ "$pushed_path" == "1" ]]; then
    PATH="${PATH#${pub_cache_bin}:}"
  fi

  if (( inner_exit != 0 )); then
    echo "❌ check_api_breakage.sh failed (exit $inner_exit) — see stderr above"
    return 1
  fi
  if ! [[ "$current" =~ ^[0-9]+$ ]]; then
    echo "❌ check_api_breakage.sh --count produced non-integer stdout: '$current'"
    return 1
  fi

  echo "baseline unapproved breakages: $baseline"
  echo "current  unapproved breakages: $current"
  echo ""

  if (( current > baseline )); then
    local delta=$(( current - baseline ))
    echo "❌ api-breakage regressed: +$delta new unapproved breaking change(s)"
    echo "   Run 'scripts/check_api_breakage.sh' (without --count) for the full diff."
    return 1
  fi

  if (( current < baseline )); then
    local delta=$(( baseline - current ))
    echo "✅ api-breakage improved: -$delta unapproved breaking change(s)"
    echo ""
    echo "   Remember to decrement the baseline in the same commit:"
    echo "     echo $current > $baseline_file"
    return 0
  fi

  echo "✅ api-breakage steady at baseline"
  return 0
}

# ───── stages 5/6/7: device integration tests ───────────────────────────

# Runs the facade example's Patrol integration suite on $device. Patrol
# discovers every `*_test.dart` under `patrol_test/` and bundles them
# automatically — each file sets the access token in its own `setUpAll`,
# so there is no hand-maintained aggregating entry point to keep in sync.
run_integration_on_device() {
  local device="$1"
  local label="$2"

  local example_dir="$FACADE_DIR/example"
  if [[ ! -d "$example_dir/patrol_test" ]]; then
    echo "no $example_dir/patrol_test — expected the Patrol test directory"
    return 1
  fi

  echo "running Patrol integration tests on $label ($device)"
  (
    cd "$example_dir" && \
    patrol test \
      --target patrol_test \
      --device "$device" \
      --dart-define=ACCESS_TOKEN="$MAPBOX_ACCESS_TOKEN"
  )
}

# Web runs through Patrol's Playwright runner (`patrol test -d chrome`),
# which drives the browser itself — no chromedriver, no flutter_driver
# entry point. Unlike CI we do NOT pass `--enable-unsafe-swiftshader`:
# software WebGL hangs on a real macOS GPU, and the local machine renders
# with its own GPU.
run_integration_on_web() {
  local example_dir="$FACADE_DIR/example"

  if [[ ! -d "$example_dir/patrol_test" ]]; then
    echo "no $example_dir/patrol_test — expected the Patrol test directory"
    return 1
  fi

  echo ""
  echo "  patrol test --target patrol_test -d chrome"
  (
    cd "$example_dir" && \
    patrol test \
      --target patrol_test \
      --device chrome \
      --dart-define=ACCESS_TOKEN="$MAPBOX_ACCESS_TOKEN"
  )
}

stage_android() {
  if ! require_token; then
    skip_stage "android" "MAPBOX_ACCESS_TOKEN not set"
    return 0
  fi
  local device="${ANDROID_DEVICE:-emulator-5554}"
  run_integration_on_device "$device" "android"
}

stage_ios() {
  if ! require_token; then
    skip_stage "ios" "MAPBOX_ACCESS_TOKEN not set"
    return 0
  fi
  # Default to iPhone 17 Pro. Older iOS runtimes (e.g. 15.5) have been
  # observed to fail the integration suite; iPhone 17 Pro / iOS 26.4 is
  # the known-good combo. Override via IOS_DEVICE.
  local device="${IOS_DEVICE:-iPhone 17 Pro}"
  run_integration_on_device "$device" "ios"
}

stage_chrome() {
  if ! require_token; then
    skip_stage "chrome" "MAPBOX_ACCESS_TOKEN not set"
    return 0
  fi

  run_integration_on_web
}

# ───── stage 8: mobile sanity ───────────────────────────────────────────

stage_mobile_sanity() {
  local failed=0
  if [[ -d "$MOBILE_DIR/test" ]]; then
    echo ""
    echo "── mapbox_maps_flutter_mobile flutter test"
    (cd "$MOBILE_DIR" && flutter test) || failed=1
  fi

  echo ""
  echo "── mapbox_maps_flutter_mobile pub publish --dry-run"
  local publish_output
  publish_output=$(cd "$MOBILE_DIR" && flutter pub publish --dry-run 2>&1)
  local publish_exit=$?
  echo "$publish_output"

  # Until WS6 pins the platform-interface dep, `pub publish --dry-run`
  # emits exactly one warning about `platform_interface: any`. That's
  # expected and tracked in the migration plan, so we filter it out
  # before deciding whether this stage passes. Any OTHER dry-run
  # warning/error is treated as a real failure.
  if [[ "$publish_exit" != "0" ]]; then
    local allowed_pattern='Your dependency on "mapbox_maps_flutter_platform_interface" should have a version constraint'
    local modified_pattern='checked-in files are modified in git'
    # pub publish prints "Package has N warnings." or "... 1 warning." —
    # if the filtered issue list is only the expected ones, pass.
    local unexpected
    unexpected=$(printf '%s\n' "$publish_output" \
      | grep -E '^\* ' \
      | grep -v -E "$allowed_pattern" \
      | grep -v -E "$modified_pattern")
    if [[ -z "$unexpected" ]]; then
      echo ""
      echo "ℹ  tolerating expected pre-WS6 warnings: platform_interface pin,"
      echo "   uncommitted local-edit noise. Real errors/warnings would fail."
    else
      echo ""
      echo "❌ unexpected pub publish issue(s):"
      printf '%s\n' "$unexpected" | sed 's/^/   /'
      failed=1
    fi
  fi

  return $failed
}

# ───── dispatch ─────────────────────────────────────────────────────────

dispatch_stage() {
  local flag="$1"
  local name="$2"
  local fn="$3"
  if [[ "$flag" == "1" ]]; then
    run_stage "$name" "$fn"
  else
    echo "─── skip $name — disabled by --skip-$name / --only"
    SKIPPED_STAGES+=("$name (skipped via flag)")
  fi
}

dispatch_stage "$RUN_STATIC"          "static"          stage_static
dispatch_stage "$RUN_CODEGEN_DRIFT"   "codegen-drift"   stage_codegen_drift
dispatch_stage "$RUN_UNIT_TESTS"      "unit-tests"      stage_unit_tests
dispatch_stage "$RUN_API_BREAKAGE"    "api-breakage"    stage_api_breakage
dispatch_stage "$RUN_ANDROID"         "android"         stage_android
dispatch_stage "$RUN_IOS"             "ios"             stage_ios
dispatch_stage "$RUN_CHROME"          "chrome"          stage_chrome
dispatch_stage "$RUN_MOBILE_SANITY"   "mobile-sanity"   stage_mobile_sanity

echo ""
echo "═════════════════════════════════════════════════════════"
echo " validate.sh summary"
echo "═════════════════════════════════════════════════════════"
for s in "${PASSED_STAGES[@]}";  do echo "  ✅ $s";  done
for s in "${SKIPPED_STAGES[@]}"; do echo "  ⏭  $s";  done
for s in "${FAILED_STAGES[@]}";  do echo "  ❌ $s";  done
echo ""

[[ ${#FAILED_STAGES[@]} -eq 0 ]]
