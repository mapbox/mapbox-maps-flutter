@JS('mapboxgl')
library;

import 'dart:js_interop';

import 'map_bindings.dart';

/// `mapboxgl.LngLatBounds` — a rectangular geographical area defined by its
/// south-west and north-east corners.
@JS('LngLatBounds')
extension type JSLngLatBounds._(JSObject _) implements JSObject {
  external JSLngLatBounds(JSLngLat sw, JSLngLat ne);
  external JSLngLat getSouthWest();
  external JSLngLat getNorthEast();
}

/// Options accepted by `JSMap.cameraForBounds`.
@JS()
@anonymous
extension type JSCameraForBoundsOptions._(JSObject _) implements JSObject {
  external factory JSCameraForBoundsOptions({
    JSPadding? padding,
    JSScreenPoint? offset,
    double? maxZoom,
    double? bearing,
    double? pitch,
  });

  external set padding(JSPadding value);
  external set offset(JSScreenPoint value);
  external set maxZoom(double value);
  external set bearing(double value);
  external set pitch(double value);
}

/// Camera-related JSMap externs.
extension MapCamera on JSMap {
  /// Projects a geographical coordinate to a pixel coordinate within the
  /// map's container.
  external JSScreenPoint project(JSLngLat lngLat);

  /// Unprojects a pixel coordinate (relative to the map's container) to a
  /// geographical coordinate.
  external JSLngLat unproject(JSScreenPoint point);

  /// Animates the camera by a screen-pixel offset.
  external void panBy(JSScreenPoint offset, JSCameraOptions? options);

  /// Animates the camera to the given [bearing] in degrees.
  external void rotateTo(double bearing, JSCameraOptions? options);

  /// Animates the camera to the given absolute [zoom] level.
  external void zoomTo(double zoom, JSCameraOptions? options);

  /// Returns the terrain elevation in meters at [lngLat], or null when no
  /// terrain is loaded under that point.
  external double? queryTerrainElevation(JSLngLat lngLat, JSObject? options);

  /// Returns camera options that fit [bounds] within the viewport, or null
  /// when GL JS cannot compute a valid camera (e.g. empty bounds).
  external JSCameraOptions? cameraForBounds(
    JSLngLatBounds bounds,
    JSCameraForBoundsOptions? options,
  );

  /// Constrains the camera center to the given bounds. Pass null to clear.
  external void setMaxBounds(JSLngLatBounds? bounds);

  /// Returns the bounds the camera center is constrained to, or null when
  /// no constraint is set.
  external JSLngLatBounds? getMaxBounds();

  external void setMinZoom(double? zoom);
  external double getMinZoom();
  external void setMaxZoom(double? zoom);
  external double getMaxZoom();
  external void setMinPitch(double? pitch);
  external double getMinPitch();
  external void setMaxPitch(double? pitch);
  external double getMaxPitch();
}
