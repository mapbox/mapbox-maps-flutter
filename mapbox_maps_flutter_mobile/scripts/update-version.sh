#!/bin/bash

# Check if argument is provided
if [ $# -eq 0 ]; then
    echo "Usage: $0 <input>"
    exit 1
fi

VERSION="$1"
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

# Validate the version format (e.g., 1.0.0 or 1.0.0-rc.1)
if ! [[ "$VERSION" =~ ^[0-9]+\.[0-9]+\.[0-9]+(-[a-zA-Z0-9]+(\.[0-9]+)*)?$ ]]; then
    echo "Error: Invalid version format. Use 'X.Y.Z' or 'X.Y.Z-rc.1'."
    exit 1
fi

echo "Updating MapboxMaps Flutter SDK version: $VERSION"

PUBSPEC_FILE="$SCRIPT_DIR/../pubspec.yaml"
sed -i '' "s/^version: .*/version: $VERSION/" "$PUBSPEC_FILE"

PODSPEC_FILE="$SCRIPT_DIR/../ios/mapbox_maps_flutter.podspec"
sed -i '' "s/\(s\.version *= *\)\'[^\']*\'/\1\'$VERSION\'/" "$PODSPEC_FILE"

PACKAGE_INFO_FILE="$SCRIPT_DIR/../lib/src/package_info.dart"
sed -i '' "s/^const String mapboxPluginVersion = .*/const String mapboxPluginVersion = '$VERSION';/" "$PACKAGE_INFO_FILE"
