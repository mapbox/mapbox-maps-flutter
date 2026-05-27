import 'dart:ui' show Offset;

import 'package:flutter/painting.dart' show EdgeInsets;
import 'package:mapbox_maps_flutter_platform_interface/mapbox_maps_flutter_platform_interface.dart';
import 'package:turf/turf.dart';

import 'map_bindings.dart';

extension PointToJSLngLat on Point {
  JSLngLat toJSLngLat() =>
      JSLngLat(coordinates.lng.toDouble(), coordinates.lat.toDouble());
}

extension EdgeInsetsToJSPadding on EdgeInsets {
  JSPadding toJSPadding() =>
      JSPadding(top: top, bottom: bottom, left: left, right: right);
}

extension MbxEdgeInsetsToJSPadding on MbxEdgeInsets {
  JSPadding toJSPadding() =>
      JSPadding(top: top, bottom: bottom, left: left, right: right);
}

extension OffsetToJSScreenPoint on Offset {
  JSScreenPoint toJSScreenPoint() =>
      JSScreenPoint(dx.toDouble(), dy.toDouble());
}

extension ScreenCoordinateToJSScreenPoint on ScreenCoordinate {
  JSScreenPoint toJSScreenPoint() => JSScreenPoint(x.toDouble(), y.toDouble());
}

extension JSLngLatToPoint on JSLngLat {
  Point toPoint() => Point(coordinates: Position(lng, lat));
}

extension CoordinateBoundsToJSLngLatBounds on CoordinateBounds {
  JSLngLatBounds toJSLngLatBounds() =>
      JSLngLatBounds(southwest.toJSLngLat(), northeast.toJSLngLat());
}

extension BBoxToJSLngLatBounds on BBox {
  JSLngLatBounds toJSLngLatBounds() => JSLngLatBounds(
    JSLngLat(lng1.toDouble(), lat1.toDouble()),
    JSLngLat(lng2.toDouble(), lat2.toDouble()),
  );
}

extension PointListToJSLngLatBounds on List<Point> {
  /// Returns the axis-aligned bounding box of the points via turf.bbox.
  JSLngLatBounds toJSLngLatBounds() => bbox(
    MultiPoint(coordinates: map((p) => p.coordinates).toList()),
  ).toJSLngLatBounds();
}

extension JSCameraForBoundsOptionsMerge on JSCameraForBoundsOptions {
  void withPadding(JSPadding? padding) {
    if (padding != null) this.padding = padding;
  }

  void withOffset(JSScreenPoint? offset) {
    if (offset != null) this.offset = offset;
  }

  void withMaxZoom(double? maxZoom) {
    if (maxZoom != null) this.maxZoom = maxZoom;
  }

  void withBearing(double? bearing) {
    if (bearing != null) this.bearing = bearing;
  }

  void withPitch(double? pitch) {
    if (pitch != null) this.pitch = pitch;
  }
}

extension JSCameraOptionsMerge on JSCameraOptions {
  void withCenter(JSLngLat? center) {
    if (center != null) this.center = center;
  }

  void withZoom(double? zoom) {
    if (zoom != null) this.zoom = zoom;
  }

  void withBearing(double? bearing) {
    if (bearing != null) this.bearing = bearing;
  }

  void withPitch(double? pitch) {
    if (pitch != null) this.pitch = pitch;
  }

  void withPadding(JSPadding? padding) {
    if (padding != null) this.padding = padding;
  }

  void withDuration(Duration? duration) {
    if (duration != null) this.duration = duration.inMilliseconds;
  }

  void withDurationMs(int? durationMs) {
    if (durationMs != null) duration = durationMs;
  }

  void withAnchor(JSLngLat? anchor) {
    if (anchor != null) around = anchor;
  }
}
