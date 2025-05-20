#!/bin/bash
set -euo pipefail

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

# Run dart-apitool diff in the target directory
(
  cd "$TARGET_DIR"
  dart-apitool diff --old pub://mapbox_maps_flutter --new .
)
