#!/bin/bash
set -eou pipefail

# Function to display usage information
usage() {
    echo "Usage: $0 --mode <validate|generate>"
    exit 1
}
mode="generate"

# Fetch the dependencies in JSON format
deps=$(flutter pub deps --json)

# Parse command-line arguments
if [[ $# -eq 0 ]]; then
  echo "Error: No arguments provided."
  usage
fi

while [[ $# -gt 0 ]]; do
  case "$1" in
    --mode)
      if [[ -n "$2" ]]; then
        mode="$2"
        shift 2
      else
        echo "Error: --mode requires a value."
        usage
      fi
      ;;
    *)
      usage
      ;;
  esac
done

# Get version and direct dependencies from mapbox_maps_flutter package specifically
mapbox_root=$(echo "$deps" | jq '.packages[] | select(.kind == "root" and .name == "mapbox_maps_flutter")')
sdk_version=$(echo "$mapbox_root" | jq -r '.version')
direct_deps=$(echo "$mapbox_root" | jq -r '.directDependencies[]')

# Filter packages to only include direct dependencies of mapbox_maps_flutter (excluding flutter SDK)
# Convert direct_deps list to jq array filter
deps_filter=$(echo "$direct_deps" | jq -R -s -c 'split("\n") | map(select(length > 0 and . != "flutter"))')
package_info=$(echo "$deps" | jq -r --argjson deps "$deps_filter" '.packages[] | select(.name as $name | $deps | index($name)) | "\(.name) \(.version)"')

deps_licenses=""
# Loop through each name/version pair
while read -r name version; do
  # Skip empty entries (can happen in workspace configurations)
  if [ -z "$name" ] || [ -z "$version" ]; then
    continue
  fi

  package_metadata=$(curl -s "https://pub.dev/api/packages/$name/versions/$version")
  archive_url=$(echo "$package_metadata" | jq -r '.archive_url')
  repository_url=$(echo "$package_metadata" | jq -r '.pubspec.repository // "No repository URL found"')

  # download the package archive
  curl -s -o "/tmp/${name}-${version}.tar.gz" "$archive_url"
  mkdir -p "/tmp/${name}-${version}"
  tar -xzf "/tmp/${name}-${version}.tar.gz" -C "/tmp/${name}-${version}"

  # Find the license file in the unzipped folder (case-insensitive search)
  license_file=$(find "/tmp/${name}-${version}" -type f -iname "license*")

  if [ -n "$license_file" ]; then
    license_entry="### $name, $repository_url"$'\n\n'"\`\`\`"$'\n'"$(cat "$license_file")"$'\n'"\`\`\`"$'\n\n'
    deps_licenses+="$license_entry"
  else
    dep_licenses+="No license file found for $name $version"
  fi
  # Add your logic here to handle each package
done <<< "$package_info"

# Resolve the script's directory to find the monorepo projects root
script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
projects_dir="$(cd "$script_dir/../../../.." && pwd)"

# Read iOS and Android SDK licenses from local monorepo paths
ios_license_path="$projects_dir/maps-ios/mapbox-maps-ios/LICENSE.md"
android_license_path="$projects_dir/maps-android/mapbox-maps-android/LICENSE.md"

if [ ! -f "$ios_license_path" ]; then
  echo "Error: iOS LICENSE.md not found at $ios_license_path"
  exit 1
fi

if [ ! -f "$android_license_path" ]; then
  echo "Error: Android LICENSE.md not found at $android_license_path"
  exit 1
fi

ios_license_content=$(cat "$ios_license_path")
android_license_content=$(cat "$android_license_path")

current_year=$(date +%Y)

license="## License

Mapbox Maps for Flutter version $sdk_version
Mapbox Maps Flutter SDK

Copyright &copy; 2022 - $current_year Mapbox, Inc. All rights reserved.

The software and files in this repository (collectively, “Software”) are licensed under the Mapbox TOS for use only with the relevant Mapbox product(s) listed at www.mapbox.com/pricing. This license allows developers with a current active Mapbox account to use and modify the authorized portions of the Software as needed for use only with the relevant Mapbox product(s) through their Mapbox account in accordance with the Mapbox TOS.  This license terminates automatically if a developer no longer has a Mapbox account in good standing or breaches the Mapbox TOS. For the license terms, please see the Mapbox TOS at https://www.mapbox.com/legal/tos/ which incorporates the Mapbox Product Terms at www.mapbox.com/legal/service-terms.  If this Software is a SDK, modifications that change or interfere with marked portions of the code related to billing, accounting, or data collection are not authorized and the SDK sends limited de-identified location and usage data which is used in accordance with the Mapbox TOS. [Updated 2023-01]

## Acknowledgements

This application makes use of the following third party libraries:

$deps_licenses---

$ios_license_content

$android_license_content"

if [ "$mode" == "validate" ]; then
    if [[ "$(cat LICENSE)" == "$license" ]]; then
        echo "License file is up-to-date."
        exit 0
    else
        echo "⚠️ License is not up-to-date. ⚠️"
        echo "$license" > /tmp/expected_license.txt
        cat LICENSE > /tmp/current_license.txt
        echo "Diff (expected vs current):"
        diff /tmp/expected_license.txt /tmp/current_license.txt || true
        exit 1
    fi
elif [ "$mode" == "generate" ]; then
    echo "$license" > LICENSE
    echo "License file has been updated." >&2
else
    usage
fi
