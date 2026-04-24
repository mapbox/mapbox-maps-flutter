#!/usr/bin/env bash
# NOTE: validate.sh (stage 4, api-breakage) parses the
# "Found N breaking change(s) NOT in allow list" line emitted below
# to feed its regression-detector. Keep that wording or update
# validate.sh:305 in the same commit.
set -e

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

# Run dart-apitool and save JSON report
TEMP_JSON=$(mktemp /tmp/mapbox_maps_flutter_apitool_report_XXXXXX.json)
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
  echo ""
  echo "✅ No unapproved breaking changes"
  echo ""
  exit 0
fi

UNAPPROVED_COUNT=$(echo "$UNAPPROVED" | wc -l | tr -d ' ')

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
