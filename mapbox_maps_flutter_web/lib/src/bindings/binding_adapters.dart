import 'dart:js_interop';
import 'dart:ui' show Offset;

import 'package:flutter/painting.dart' show EdgeInsets;
import 'package:mapbox_maps_flutter_platform_interface/mapbox_maps_flutter_platform_interface.dart';
import 'package:turf/turf.dart';

import 'json_helpers.dart';
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

extension JSMapCameraState on JSMap {
  CameraState getCameraState() => CameraState(
    center: getCenter().toPoint(),
    // GL JS manages viewport padding per camera command (jumpTo/easeTo) and
    // does not expose a "current padding" getter; zero matches how a
    // non-padded camera is modelled on the native side.
    padding: MbxEdgeInsets(top: 0, left: 0, bottom: 0, right: 0),
    zoom: getZoom(),
    bearing: getBearing(),
    pitch: getPitch(),
  );
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

/// Converts a [RenderedQueryGeometry] to the JS geometry argument accepted by
/// GL JS's `queryRenderedFeatures`: a single [JSScreenPoint], or a
/// two-element [JSArray] of [JSScreenPoint] (bounding box).
///
/// A [RenderedQueryGeometry.fromList] built from an empty point list has no
/// GL JS representation. GL JS treats a missing geometry as a request for
/// the whole viewport. An empty query area never means that. Callers must
/// special-case an empty point list before calling [toJS].
extension RenderedQueryGeometryToJS on RenderedQueryGeometry {
  JSAny toJS() => switch (this) {
    ScreenCoordinateRenderedQueryGeometry(:final point) =>
      point.toJSScreenPoint(),
    ScreenBoxRenderedQueryGeometry(:final box) => <JSScreenPoint>[
      box.min.toJSScreenPoint(),
      box.max.toJSScreenPoint(),
    ].toJS,
    ScreenCoordinateListRenderedQueryGeometry(:final points) => _boundingBoxFor(
      points,
    ),
  };
}

/// GL JS only accepts a single point or a two-point bounding box.
/// Derives the axis-aligned bounding box of all points in the list.
///
/// Throws [ArgumentError] if [points] is empty. See
/// [RenderedQueryGeometryToJS] for why.
JSAny _boundingBoxFor(List<ScreenCoordinate> points) {
  if (points.isEmpty) {
    throw ArgumentError.value(points, 'points', 'must not be empty');
  }
  if (points.length == 1) {
    return points[0].toJSScreenPoint();
  }
  double minX = double.infinity, minY = double.infinity;
  double maxX = double.negativeInfinity, maxY = double.negativeInfinity;
  for (final p in points) {
    if (p.x < minX) minX = p.x;
    if (p.y < minY) minY = p.y;
    if (p.x > maxX) maxX = p.x;
    if (p.y > maxY) maxY = p.y;
  }
  return <JSScreenPoint>[
    JSScreenPoint(minX, minY),
    JSScreenPoint(maxX, maxY),
  ].toJS;
}

extension JSMapFeatureToQueried on JSMapFeature {
  /// [source]/[sourceLayer] must be passed in rather than read off this
  /// object: GL JS only sets them on the `MapGeoJSONFeature`s returned by
  /// `queryRenderedFeatures`. The plain `GeoJSONFeature`s returned by
  /// `querySourceFeatures` lack both fields, so reading `this.source` there
  /// throws (non-nullable JS interop getter hitting `undefined`).
  QueriedFeature toQueriedFeature({
    required String source,
    required String? sourceLayer,
  }) {
    final featureMap = <String?, Object?>{
      'type': 'Feature',
      'geometry': geometry?.dartify(),
      'properties': properties.toDart(),
    };
    final rawId = id?.toDart();
    if (rawId != null) featureMap['id'] = rawId;

    return QueriedFeature(
      feature: featureMap,
      source: source,
      sourceLayer: sourceLayer,
      state: state != null ? jsonStringify(state!) : '{}',
    );
  }
}
