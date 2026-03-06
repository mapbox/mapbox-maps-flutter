#!/bin/bash

set -e

# Function to display usage
usage() {
    echo "Usage: $0 <version>"
    echo ""
    echo "Examples:"
    echo "  $0 12.0.0                        # Set both to stable version"
    echo "  $0 12.0.0-beta.3                 # Set both to beta version"
    echo "  $0 11.19.0-rc.1                  # Set both to RC version"
    echo ""
    exit 1
}

compare_versions() {
    # Split on both . and - to get all parts: "12.0.0-beta.1" -> ["12","0","0","beta","1"]
    local new_version_normalized=$(echo "$1" | sed 's/-/./g')
    local current_version_normalized=$(echo "$2" | sed 's/-/./g')

    IFS='.' read -ra new_parts <<< "$new_version_normalized"
    IFS='.' read -ra current_parts <<< "$current_version_normalized"
    # Pad to at least 3 parts (major.minor.patch)
    while [ ${#new_parts[@]} -lt 3 ]; do new_parts+=(0); done
    while [ ${#current_parts[@]} -lt 3 ]; do current_parts+=(0); done

    # Compare major.minor.patch
    for i in {0..2}; do
        if [ "${new_parts[i]}" -lt "${current_parts[i]}" ]; then
            return 0  # downgrade
        elif [ "${new_parts[i]}" -gt "${current_parts[i]}" ]; then
            return 2  # upgrade
        fi
    done

    # Base versions equal, check pre-release
    local new_has_pre=$( [ ${#new_parts[@]} -gt 3 ] && echo "true" || echo "false" )
    local current_has_pre=$( [ ${#current_parts[@]} -gt 3 ] && echo "true" || echo "false" )

    if [[ "$new_has_pre" == "true" && "$current_has_pre" == "false" ]]; then
        return 0  # pre-release to release (downgrade)
    elif [[ "$new_has_pre" == "false" && "$current_has_pre" == "true" ]]; then
        return 2  # release to pre-release (upgrade)
    elif [[ "$new_has_pre" == "true" && "$current_has_pre" == "true" ]]; then
        # Both pre-release, check beta < rc
        if [[ "${new_parts[3]}" == "beta" && "${current_parts[3]}" == "rc" ]]; then
            return 0  # beta < rc (downgrade)
        elif [[ "${new_parts[3]}" == "rc" && "${current_parts[3]}" == "beta" ]]; then
            return 2  # rc > beta (upgrade)
        fi
    fi

    return 1  # versions equal
}

get_current_version() {
    local platform="$1"
    local current_version=""

    if [ "$platform" = "ios" ]; then
        current_version=$(grep "exact:" "$PACKAGE_SWIFT_FILE" | sed 's/.*exact: "\([^"]*\)".*/\1/')
    elif [ "$platform" = "android" ]; then
        current_version=$(grep "com\.mapbox\.maps:android-ndk27:" "$BUILD_GRADLE_FILE" | sed 's/.*android-ndk27:\([^"]*\).*/\1/')
    fi

    echo "$current_version"
}

# Function to update iOS dependency
update_ios_dependency() {
    local version="$1"

    if [ -f "$PACKAGE_SWIFT_FILE" ]; then
        echo "Updating iOS SPM dependency in $PACKAGE_SWIFT_FILE"
        # Update exact version in Package.swift
        sed -i '' "s/exact: \"[^\"]*\"/exact: \"$version\"/" "$PACKAGE_SWIFT_FILE"

        echo "Updated iOS SPM MapboxMaps dependency to $version"
    else
        echo "Error: Package.swift not found at $PACKAGE_SWIFT_FILE"
        exit 1
    fi

    if [ -f "$PODSPEC_FILE" ]; then
        echo "Updating iOS CocoaPods dependency in $PODSPEC_FILE"
        # Update MapboxMaps version
        sed -i '' "s/s\.dependency 'MapboxMaps', '[^']*'/s.dependency 'MapboxMaps', '$version'/" "$PODSPEC_FILE"

        echo "Updated iOS CocoaPods MapboxMaps dependency to $version"
    else
        echo "Error: Podspec not found at $PODSPEC_FILE"
    fi
}

# Function to update Android dependency
update_android_dependency() {
    local version="$1"

    if [ -f "$BUILD_GRADLE_FILE" ]; then
        echo "Updating Android dependency in $BUILD_GRADLE_FILE"

        # Update android-ndk27 version
        sed -i '' "s/implementation \"com\.mapbox\.maps:android-ndk27:[^\"]*\"/implementation \"com.mapbox.maps:android-ndk27:$version\"/" "$BUILD_GRADLE_FILE"

        echo "Updated Android android-ndk27 dependency to $version"
    else
        echo "Error: Android build.gradle file not found at $BUILD_GRADLE_FILE"
        exit 1
    fi
}

# Check if at least one argument is provided
if [ $# -eq 0 ]; then
    echo "Error: Version is required."
    usage
fi

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
PODSPEC_FILE="$SCRIPT_DIR/../ios/mapbox_maps_flutter.podspec"
PACKAGE_SWIFT_FILE="$SCRIPT_DIR/../ios/mapbox_maps_flutter/Package.swift"
BUILD_GRADLE_FILE="$SCRIPT_DIR/../android/build.gradle"

# Parse version argument
VERSION="$1"

# Validate version format
if ! [[ "$VERSION" =~ ^[0-9]+\.[0-9]+\.[0-9]+(-[a-zA-Z0-9]+(\.[0-9]+)*)?$ ]]; then
    echo "Error: Invalid version format '$VERSION'"
    echo "Expected: X.Y.Z or X.Y.Z-beta.N or X.Y.Z-rc.N"
    exit 1
fi

# Get current versions from project files
CURRENT_IOS=$(get_current_version "ios")
CURRENT_ANDROID=$(get_current_version "android")

echo "Current project versions:"
echo "  iOS (MapboxMaps): $CURRENT_IOS"
echo "  Android (android-ndk27): $CURRENT_ANDROID"
echo ""

# Check for version downgrades and warn
if [ -n "$CURRENT_IOS" ]; then
    compare_versions "$VERSION" "$CURRENT_IOS" || comparison_result=$?
    if [ ${comparison_result:-0} -eq 0 ]; then
        echo "WARNING: You are downgrading from $CURRENT_IOS to $VERSION"
        echo ""
    fi
fi

echo "Setting version: $VERSION"

# Update project files
update_ios_dependency "$VERSION"
update_android_dependency "$VERSION"

echo ""
echo "Cleaning Flutter build cache..."
flutter clean

echo ""
echo "Updating Package.resolved..."
cd "$(dirname "$PACKAGE_SWIFT_FILE")" && swift package update mapbox-maps-ios
echo "Updated Package.resolved using Swift Package Manager"
