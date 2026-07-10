import 'dart:convert' show jsonDecode;
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
/// GL JS's `queryRenderedFeatures`: a single [JSScreenPoint], a two-element
/// [JSArray] of [JSScreenPoint] (bounding box), or null for the full viewport.
extension RenderedQueryGeometryToJS on RenderedQueryGeometry {
  JSAny? toJS() {
    final decoded = jsonDecode(value) as Object;
    switch (type) {
      case Type.SCREEN_COORDINATE:
        final map = decoded as Map<String, dynamic>;
        return JSScreenPoint(
          (map['x'] as num).toDouble(),
          (map['y'] as num).toDouble(),
        );
      case Type.SCREEN_BOX:
        final map = decoded as Map<String, dynamic>;
        final min = map['min'] as Map<String, dynamic>;
        final max = map['max'] as Map<String, dynamic>;
        return <JSScreenPoint>[
          JSScreenPoint(
            (min['x'] as num).toDouble(),
            (min['y'] as num).toDouble(),
          ),
          JSScreenPoint(
            (max['x'] as num).toDouble(),
            (max['y'] as num).toDouble(),
          ),
        ].toJS;
      case Type.LIST:
        // GL JS only accepts a single point or a two-point bounding box.
        // Derive the axis-aligned bounding box of all points in the list.
        final list = decoded as List<dynamic>;
        if (list.isEmpty) return null;
        if (list.length == 1) {
          final p = list[0] as Map<String, dynamic>;
          return JSScreenPoint(
            (p['x'] as num).toDouble(),
            (p['y'] as num).toDouble(),
          );
        }
        double minX = double.infinity, minY = double.infinity;
        double maxX = double.negativeInfinity, maxY = double.negativeInfinity;
        for (final item in list) {
          final p = item as Map<String, dynamic>;
          final x = (p['x'] as num).toDouble();
          final y = (p['y'] as num).toDouble();
          if (x < minX) minX = x;
          if (y < minY) minY = y;
          if (x > maxX) maxX = x;
          if (y > maxY) maxY = y;
        }
        return <JSScreenPoint>[
          JSScreenPoint(minX, minY),
          JSScreenPoint(maxX, maxY),
        ].toJS;
    }
  }
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
