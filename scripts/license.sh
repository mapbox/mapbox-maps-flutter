#!/bin/bash
set -eou pipefail

# Function to display usage information
usage() {
    echo "Usage: $0 <package_name> --mode <validate|generate>"
    exit 1
}
mode="generate"


# Check if exactly two arguments are provided
if [ "$#" -ne 2 ]; then
  echo "Usage: $0 <package-name> --mode=[generate|validate]"
  exit 1
fi

PACKAGE_NAME="$1"
MODE="$2"

# Extract the mode value
if [[ "$MODE" =~ --mode[=\ ]?(generate|validate) ]]; then
  MODE="${BASH_REMATCH[1]}"
else
  echo "Invalid mode. Use --mode generate or --mode validate"
  exit 1
fi

# Fetch the dependencies in JSON format
deps=$(flutter pub deps --json)

PACKAGE_INFO=$(echo "$deps" | jq --arg PACKAGE_NAME "$PACKAGE_NAME" '
  .packages
  | map(select(.name == $PACKAGE_NAME))
  | first
  | {version: .version, directDependencies: .directDependencies}
')

# Extract directDependencies array from PACKAGE_INFO
DIRECT_DEPS=$(echo "$PACKAGE_INFO" | jq '.directDependencies')

# Find all packages whose names are in directDependencies
MATCHING_PACKAGES=$(echo "$deps" | jq -s --argjson deps "$DIRECT_DEPS" '
  .[0].packages
  | map(select(.name as $n | $deps | index($n)))
  | map(select(.name != "flutter" and (.name | startswith("mapbox_maps_flutter") | not)))
  | map({name, version})
')

PACKAGE_VERSION=$(echo "$PACKAGE_INFO" | jq -r '.version')

deps_licenses=""
# Loop through each name/version pair
while read -r name version; do
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
    deps_licenses+="No license file found for $name $version"
  fi
  # Add your logic here to handle each package
done < <(echo "$MATCHING_PACKAGES" | jq -r '.[] | "\(.name) \(.version)"')

if [[ "$PACKAGE_NAME" == "mapbox_maps_flutter" ]]; then
  mobile_dir="mapbox_maps_flutter_mobile"
else
  mobile_dir="$PACKAGE_NAME"
fi

ios_sdk_version=$(grep -A 1 'mapbox-maps-ios' $mobile_dir/ios/mapbox_maps_flutter/Package.swift | grep 'exact' | sed -E 's/.*"([0-9]+\.[0-9]+\.[0-9]+(-[a-zA-Z0-9.]+)?)".*/\1/')
android_sdk_version=$(grep 'com.mapbox.maps:android' $mobile_dir/android/build.gradle | sed -E 's/.*"com\.mapbox\.maps:android:([0-9]+\.[0-9]+\.[0-9]+(-[a-zA-Z0-9.]+)?)".*/\1/')

# Fetch the license files for iOS and Android SDKs
ios_license_content=$(curl -s "https://raw.githubusercontent.com/mapbox/mapbox-maps-ios/v$ios_sdk_version/LICENSE.md")
android_license_content=$(curl -s "https://raw.githubusercontent.com/mapbox/mapbox-maps-android/v$android_sdk_version/LICENSE.md")

license_template="changequote("""","""")dnl # prevents m4 from being confused with backquotes by changing quotes to non-existent tokens
## License

Mapbox Maps for Flutter version __SDK_VERSION__
Mapbox Maps Flutter SDK

Copyright &copy; 2022 - __YEAR__ Mapbox, Inc. All rights reserved.

The software and files in this repository (collectively, “Software”) are licensed under the Mapbox TOS for use only with the relevant Mapbox product(s) listed at www.mapbox.com/pricing. This license allows developers with a current active Mapbox account to use and modify the authorized portions of the Software as needed for use only with the relevant Mapbox product(s) through their Mapbox account in accordance with the Mapbox TOS.  This license terminates automatically if a developer no longer has a Mapbox account in good standing or breaches the Mapbox TOS. For the license terms, please see the Mapbox TOS at https://www.mapbox.com/legal/tos/ which incorporates the Mapbox Product Terms at www.mapbox.com/legal/service-terms.  If this Software is a SDK, modifications that change or interfere with marked portions of the code related to billing, accounting, or data collection are not authorized and the SDK sends limited de-identified location and usage data which is used in accordance with the Mapbox TOS. [Updated 2023-01]

## Acknowledgements

This application makes use of the following third party libraries:

__DEPS_LICENSES__---

__IOS_LICENSES__

__ANDROID_LICENSES__
"
license=$(echo "$license_template" | m4 -D __SDK_VERSION__="$PACKAGE_VERSION" \
                                        -D __DEPS_LICENSES__="$deps_licenses" \
                                        -D __IOS_LICENSES__="$ios_license_content" \
                                        -D __ANDROID_LICENSES__="$android_license_content" \
                                        -D __YEAR__="$(date +%Y)")

if [ "$MODE" == "validate" ]; then
    if [[ "$(cat $mobile_dir/LICENSE)" == "$license" ]]; then
        echo "License file is up-to-date."
        exit 0
    else
        echo "⚠️ License is not up-to-date. ⚠️"
        exit 1
    fi
elif [ "$MODE" == "generate" ]; then
    echo "$license" > $mobile_dir/LICENSE
    echo "License file has been updated." >&2
else
    usage
fi
