flutter pub run pigeon \
  --input pigeon_generate/snapshot/snapshot_manager.dart \
  --dart_out pigeon_generate/snapshot/output/snapshot_manager.g.dart \
  --objc_header_out pigeon_generate/snapshot/output/snapshot_manager.g.h \
  --objc_source_out pigeon_generate/snapshot/output/snapshot_manager.g.m \
   --objc_prefix 'FLT' \
  --java_out pigeon_generate/snapshot/output/snapshot_manager.java