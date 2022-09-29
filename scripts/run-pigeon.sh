#!/bin/bash
set -euo pipefail

if ! command -v kotlinc &> /dev/null
then
    echo "kotlinc command line runner is not found, install it via brew or sdk-man or add to the PATH!"
    exit
fi

formatDartFile() {
  flutter format $1
  sed -i '' '1,8d' $1
  sed -i '' '1s/^/part of mapbox_maps;\n/' $1
}

# Generating MapboxMap from gl-native and common IDLs.
# TODO extract the whole pigeon call
flutter pub run pigeon \
  --input pigeons/mapbox_map.dart \
  --dart_out lib/src/pigeons/mapbox_map.dart.orig \
  --objc_header_out ios/Classes/mapbox_map.h \
  --objc_source_out ios/Classes/mapbox_map.m \
  --objc_prefix FLT \
  --java_out android/src/main/java/com/mapbox/maps/pigeons/FLTMapboxMap.java \
  --java_package "com.mapbox.maps.pigeons"
formatDartFile lib/src/pigeons/mapbox_map.dart.orig

# Generating Settings classes from serialization spec.
# Note - different objc prefix FLT_SETTINGS is used due to the the class ScreenCoordinate
# that is colliding with in mapbox_map and leads to conflict for ObjC
flutter pub run pigeon \
  --input pigeons/settings.dart \
  --dart_out lib/src/pigeons/settings.dart.orig \
  --objc_header_out ios/Classes/settings.h \
  --objc_source_out ios/Classes/settings.m \
  --objc_prefix FLT_SETTINGS \
  --java_out android/src/main/java/com/mapbox/maps/pigeons/FLTSettings.java \
  --java_package "com.mapbox.maps.pigeons"
formatDartFile lib/src/pigeons/settings.dart.orig
# Remove the duplicating ScreenCoordinate
sed -i '' '20,44d' lib/src/pigeons/settings.dart.orig

# Generating classes from AnnotationMessager.
for i in pigeons/*AnnotationMessager.dart; do
  filename="$(basename -s .dart $i)"
  flutter pub run pigeon \
    --input $i \
    --dart_out lib/src/pigeons/$filename.dart.orig \
    --objc_header_out ios/Classes/$filename.h \
    --objc_source_out ios/Classes/$filename.m \
    --objc_prefix FLT \
    --java_out android/src/main/java/com/mapbox/maps/pigeons/FLT$filename.java \
    --java_package "com.mapbox.maps.pigeons"
  formatDartFile lib/src/pigeons/$filename.dart.orig
done

# copy comments from the Pigeon Dart templates to the generated Dart files
kotlinc -script scripts/copy-comments.kts -- -p pigeons -g lib/src/pigeons
