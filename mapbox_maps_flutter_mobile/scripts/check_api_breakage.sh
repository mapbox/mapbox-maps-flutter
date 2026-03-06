#!/usr/bin/env bash
set -e

# Cleanup temp file on exit
TEMP_OUTPUT=""
cleanup() {
  if [ -n "$TEMP_OUTPUT" ] && [ -f "$TEMP_OUTPUT" ]; then
    rm -f "$TEMP_OUTPUT"
  fi
}
trap cleanup EXIT

# Check if dart_apitool is activated globally
if ! dart pub global list | grep -q 'dart_apitool'; then
  echo "dart_apitool is not activated globally. Please run: dart pub global activate dart_apitool"
  exit 1
fi

# Check if jq is installed
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
ALLOWED_CHANGES_FILE="$SCRIPT_DIR/allowed_breaking_changes.txt"

# Run dart-apitool and capture output
TEMP_OUTPUT=$(mktemp)
set +e
dart-apitool diff \
  --old pub://$PACKAGE_NAME/$PACKAGE_VERSION \
  --new $LOCAL_PACKAGE_ROOT \
  --version-check-mode=onlyBreakingChanges 2>&1 | tee "$TEMP_OUTPUT"
set -e

# Check if dart-apitool ran successfully
if ! grep -q "Generating report" "$TEMP_OUTPUT"; then
  echo ""
  echo "❌ dart-apitool did not run successfully"
  echo "Make sure it's activated: dart pub global activate dart_apitool"
  exit 1
fi

# Check if breaking changes were detected (i.e., "New Version is too low!" message)
if ! grep -q "New Version is too low!" "$TEMP_OUTPUT"; then
  echo ""
  echo "✅ No breaking changes detected"
  exit 0
fi

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "⚠️  Breaking changes detected"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

# Load allow list (ignore comments and empty lines)
ALLOWED_PATTERNS=""
if [ -f "$ALLOWED_CHANGES_FILE" ]; then
  ALLOWED_PATTERNS=$(grep -v "^#" "$ALLOWED_CHANGES_FILE" | grep -v "^$" || true)
fi

# Check if we have valid patterns
if [ -z "$ALLOWED_PATTERNS" ]; then
  echo ""
  echo "❌ No allow list found or allow list is empty"
  echo ""
  echo "To allow breaking changes:"
  echo "  1. Review the changes above carefully"
  echo "  2. Create $ALLOWED_CHANGES_FILE (or add entries if it exists)"
  echo "  3. Add patterns from the BREAKING CHANGES section"
  echo ""
  echo "Example entries:"
  echo '  Method "setLineCutoutWidth" removed'
  echo '  Field "lineCutoutWidth" removed'
  echo ""
  exit 1
fi

# Strip ANSI color codes from output for reliable parsing
CLEAN_OUTPUT=$(sed 's/\x1b\[[0-9;]*m//g' "$TEMP_OUTPUT")

# Extract the breaking changes section
BREAKING_SECTION=$(echo "$CLEAN_OUTPUT" | sed -n '/^BREAKING CHANGES$/,/^Non-Breaking changes$/p' | sed '$d' || true)

if [ -z "$BREAKING_SECTION" ]; then
  echo ""
  echo "❌ Could not find BREAKING CHANGES section in output"
  exit 1
fi

# Check each line in breaking section against allow list
UNAPPROVED_LINES=""
while IFS= read -r line; do
  # Skip empty lines, section headers, and tree drawing characters
  [ -z "$line" ] && continue
  echo "$line" | grep -qE "^(BREAKING CHANGES|Class|Interface)" && continue
  echo "$line" | grep -qE "^[[:space:]]*[├└│─┬┼]" && continue

  # Check if this is an actual breaking change line (contains removed, changed, added to incompatible, etc.)
  if echo "$line" | grep -qE 'removed|changed|added.*incompatible|decreased|increased'; then
    # Check if this line matches any allowed pattern
    MATCHED=false
    while IFS= read -r pattern; do
      [ -z "$pattern" ] && continue
      if echo "$line" | grep -qF "$pattern"; then
        MATCHED=true
        break
      fi
    done <<< "$ALLOWED_PATTERNS"

    if [ "$MATCHED" = false ]; then
      UNAPPROVED_LINES="${UNAPPROVED_LINES}${line}"$'\n'
    fi
  fi
done <<< "$BREAKING_SECTION"

if [ -n "$UNAPPROVED_LINES" ]; then
  echo ""
  echo "❌ Found breaking changes NOT in allow list:"
  echo ""
  echo "$UNAPPROVED_LINES"
  echo ""
  echo "To allow these changes, add them to: $ALLOWED_CHANGES_FILE"
  echo ""
  echo "Tip: Copy the text in quotes (e.g., 'Method \"foo\" removed')"
  echo ""
  exit 1
fi

echo ""
echo "✅ All breaking changes are in the allow list"
echo ""
exit 0
