import 'package:flutter/foundation.dart';
import 'package:mapbox_maps_flutter_platform_interface/mapbox_maps_flutter_platform_interface.dart';

@internal
T? styleOptionalCast<T>(dynamic value) {
  if (value is T) return value;
  if (value is num && T == double) return value.toDouble() as T;
  return null;
}

@internal
List<T>? styleOptionalCastList<T>(dynamic value) {
  if (value is List) {
    return value.where((v) => v is T).cast<T>().toList();
  }
  return null;
}

@internal
Future<String?> resolveFlutterAssetPath(String? flutterAssetUri) =>
    MapboxMapsFlutterPlatform.instance.mapboxMapsOptions.getFlutterAssetPath(
      flutterAssetUri,
    );
