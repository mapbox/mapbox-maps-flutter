#!/usr/bin/env bash
#
# Diff the local mapbox_maps_flutter package against the latest stable on
# pub.dev and report breaking changes that aren't in
# scripts/allowed_breaking_changes.json.
#
# Usage:
#   scripts/check_api_breakage.sh           # human-readable report on stdout
#   scripts/check_api_breakage.sh --count   # only the unapproved count on
#                                           # stdout; everything else (logs,
#                                           # banner, list) goes to stderr.
#                                           # Always exits 0 unless the
#                                           # tooling itself fails.
#
# validate.sh's api-breakage stage uses --count to feed the regression
# detector — keep stdout in --count mode to a single integer.

set -e

COUNT_ONLY=0
if [[ "${1:-}" == "--count" ]]; then
  COUNT_ONLY=1
fi

# In --count mode, re-route all informational output to stderr and keep
# the original stdout on file descriptor 3. The integer count is written
# to fd 3 at the end. This decouples the data channel from the human one
# without touching the existing echos.
if (( COUNT_ONLY )); then
  exec 3>&1 1>&2
fi

# Cleanup temp file on exit
TEMP_JSON=""
cleanup() {
  if [ -n "$TEMP_JSON" ] && [ -f "$TEMP_JSON" ]; then
    rm -f "$TEMP_JSON"
  fi
}
trap cleanup EXIT

if ! dart pub global list | grep -q 'dart_apitool'; then
  echo "dart_apitool is not activated globally. Please run: dart pub global activate dart_apitool"
  exit 1
fi

if ! command -v jq &> /dev/null; then
  echo "jq is required but not installed. Please install it: brew install jq"
  exit 1
fi

# Get the current stable version of mapbox_maps_flutter on pub.dev
PACKAGE_NAME="mapbox_maps_flutter"
PACKAGE_VERSION=$(curl -s "https://pub.dev/api/packages/$PACKAGE_NAME" | jq -r .latest.version)

if [ -z "$PACKAGE_VERSION" ] || [ "$PACKAGE_VERSION" = "null" ]; then
  echo "Failed to fetch current stable version from pub.dev"
  exit 1
fi

echo "Current stable version of mapbox_maps_flutter: $PACKAGE_VERSION"

# Get the path of local mapbox-maps-flutter
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LOCAL_PACKAGE_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
ALLOWED_CHANGES_FILE="$SCRIPT_DIR/allowed_breaking_changes.json"

if [ ! -f "$ALLOWED_CHANGES_FILE" ]; then
  echo "❌ Allow list file not found: $ALLOWED_CHANGES_FILE"
  exit 1
fi

# Run dart-apitool and save JSON report.
#
# `mktemp <prefix>XXXXXX.<ext>` works on GNU but BSD mktemp (macOS)
# treats the trailing `.json` literally and tries to create that
# fixed name, colliding on re-run. Prefer `mktemp -t` which both
# accept, then append `.json` ourselves so dart-apitool's JSON
# reporter is happy with the extension.
TEMP_JSON_BASE=$(mktemp -t mapbox_maps_flutter_apitool_report) || \
  TEMP_JSON_BASE=$(mktemp)
TEMP_JSON="${TEMP_JSON_BASE}.json"
mv "$TEMP_JSON_BASE" "$TEMP_JSON"
set +e
dart-apitool diff \
  --old pub://$PACKAGE_NAME/$PACKAGE_VERSION \
  --new $LOCAL_PACKAGE_ROOT \
  --version-check-mode=onlyBreakingChanges \
  --report-format json \
  --report-file-path "$TEMP_JSON" 2>&1
set -e

if [ ! -f "$TEMP_JSON" ] || ! jq -e '.report' "$TEMP_JSON" > /dev/null 2>&1; then
  echo ""
  echo "❌ dart-apitool did not produce a valid JSON report"
  echo "Make sure it's activated: dart pub global activate dart_apitool"
  exit 1
fi

UNAPPROVED=$(jq -r \
  --slurpfile allowList "$ALLOWED_CHANGES_FILE" '
  ($allowList[0] | map(.changeDescription)) as $allowed |

  [
    .report.breakingChanges.children[]? |
    if .children then
      (.label | split(" ") | .[1:] | join(" ")) as $className |
      .children[]? | select(. != null and .changeDescription != null) |
      "\($className): \(.changeDescription)"
    else
      select(. != null and .changeDescription != null) |
      .changeDescription
    end
  ] |

  .[] |
  select(. as $desc | $allowed | index($desc) | not)
' "$TEMP_JSON")

if [ -z "$UNAPPROVED" ]; then
  if (( COUNT_ONLY )); then
    echo 0 >&3
    exit 0
  fi
  echo ""
  echo "✅ No unapproved breaking changes"
  echo ""
  exit 0
fi

UNAPPROVED_COUNT=$(echo "$UNAPPROVED" | wc -l | tr -d ' ')

if (( COUNT_ONLY )); then
  echo "$UNAPPROVED_COUNT" >&3
  exit 0
fi

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "❌ Found $UNAPPROVED_COUNT breaking change(s) NOT in allow list:"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "$UNAPPROVED" | sed 's/^/  /'
echo ""
echo "To allow these changes, add them to: $ALLOWED_CHANGES_FILE"
echo ""
exit 1
