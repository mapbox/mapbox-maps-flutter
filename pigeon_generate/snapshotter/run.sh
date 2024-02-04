# --swift_out pigeon_generate/snapshotter/output/snapshotter.g.swift
flutter pub run pigeon \
  --input pigeon_generate/snapshotter/snapshotter.dart \
  --dart_out pigeon_generate/snapshotter/output/snapshotter.g.dart \
  --objc_header_out pigeon_generate/snapshotter/output/snapshotter.g.h \
  --objc_source_out pigeon_generate/snapshotter/output/snapshotter.g.m \
  --objc_prefix 'FLT' \
  --java_out pigeon_generate/snapshotter/output/FLTSnapshot.java \
  --java_package "com.mapbox.maps.pigeons"