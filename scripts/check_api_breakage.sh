#!/usr/bin/env bash
set -e

# Check if dart_apitool is activated globally
if ! dart pub global list | grep -q 'dart_apitool'; then
  echo "dart_apitool is not activated globally. Please run: dart pub global activate dart_apitool"
  exit 1
fi

# Get the current stable version of mapbox_maps_flutter on pub.dev
PACKAGE_NAME="mapbox_maps_flutter"
PACKAGE_VERSION=$(curl -s "https://pub.dev/api/packages/$PACKAGE_NAME" | grep -o '"latest":{"version":"[^"]*' | grep -o '[0-9]\+\(\.[0-9]\+\)*')
echo "Current stable version of mapbox_maps_flutter: $PACKAGE_VERSION"

# Get the path of local mapbox-maps-flutter
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LOCAL_PACKAGE_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

# Run dart_apitool to check for API breakage
dart-apitool diff \
  --old pub://$PACKAGE_NAME/$PACKAGE_VERSION \
  --new $LOCAL_PACKAGE_ROOT \
  --version-check-mode=onlyBreakingChanges