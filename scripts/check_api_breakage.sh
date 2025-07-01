#!/bin/bash
set -euo pipefail

# Check if dart_apitool is activated globally
if ! dart pub global list | grep -q 'dart_apitool'; then
  echo "dart_apitool is not activated globally. Please run: dart pub global activate dart_apitool"
  exit 1
fi

TARGET_DIR="mapbox_maps_flutter"
TEMP_FILE="$TARGET_DIR/pubspec_overrides.yaml"

# Create the temp file with the required content
cat > "$TEMP_FILE" <<EOF
resolution:
dependency_overrides:
  mapbox_maps_flutter_mobile: 
    path: ../mapbox_maps_flutter_mobile
  mapbox_maps_flutter_interface:
    path: ../mapbox_maps_flutter_interface
  mapbox_maps_flutter_web:
    path: ../mapbox_maps_flutter_web
EOF

# Ensure the temp file is deleted on script exit
trap "rm -f '$TEMP_FILE'" EXIT

# Run dart pub get in the target directory
(
  cd "$TARGET_DIR"
  dart pub get
)

# Get the current stable version of mapbox_maps_flutter on pub.dev
PACKAGE_NAME="mapbox_maps_flutter"
PACKAGE_VERSION=$(curl -s "https://pub.dev/api/packages/$PACKAGE_NAME" | grep -o '"latest":{"version":"[^"]*' | grep -o '[0-9]\+\(\.[0-9]\+\)*')
echo "Current stable version of mapbox_maps_flutter: $PACKAGE_VERSION"

# Run dart-apitool diff in the target directory
(
  cd "$TARGET_DIR"
  dart-apitool diff \
    --old pub://$PACKAGE_NAME/$PACKAGE_VERSION \
    --new . \
    --version-check-mode=onlyBreakingChanges
)