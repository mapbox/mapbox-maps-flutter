import 'dart:js_interop';
import 'dart:math' as math;

import 'package:flutter/painting.dart';
import 'package:mapbox_maps_flutter_platform_interface/mapbox_maps_flutter_platform_interface.dart';
import 'package:turf/turf.dart' as turf;

import '../bindings/map_bindings.dart';
import 'default_transition_duration.dart';

/// Starts a camera animation (jumpTo / easeTo / flyTo) based on the
/// transition type.
///
/// [around] is the geographic point that stays at the same screen position
/// while the zoom and bearing change. An immediate transition with [around]
/// uses [jumpAround], because `jumpTo` ignores it. As on mobile, [center]
/// takes precedence over [around], and a [FlyViewportTransition] and a
/// [DefaultViewportTransition] ignore [around].
void animateCamera(
  JSMap map,
  JSLngLat? center,
  double? zoom,
  double? bearing,
  double? pitch,
  JSPadding? padding,
  ViewportTransition transition, {
  JSLngLat? around,
}) {
  if (center != null) around = null;
  final opts = JSCameraOptions()..essential = true;
  if (center != null) opts.center = center;
  if (zoom != null) opts.zoom = zoom;
  if (bearing != null) opts.bearing = bearing;
  if (pitch != null) opts.pitch = pitch;
  if (padding != null) opts.padding = padding;

  switch (transition) {
    case ImmediateViewportTransition():
      if (around == null) {
        map.jumpTo(opts);
      } else {
        jumpAround(map, opts, around);
      }
    case FlyViewportTransition(:final duration):
      if (duration != null) opts.duration = duration.inMilliseconds;
      map.flyTo(opts);
    case EasingViewportTransition(:final curve, :final duration):
      if (around != null) opts.around = around;
      map.easeTo(
        opts
          ..duration = duration.inMilliseconds
          ..easing = ((double t) => curve.transform(t)).toJS,
      );
    case DefaultViewportTransition(:final maxDuration):
      final duration = defaultTransitionDurationTo(
        map,
        center: center,
        zoom: zoom,
        hasBearing: bearing != null,
        hasPitch: pitch != null,
        hasPadding: padding != null,
        maxDuration: maxDuration,
      );
      map.easeTo(opts..duration = duration.inMilliseconds);
  }
}

/// Completes when the camera move that was just started ends.
///
/// Call it after the move. A jump, a move that GL JS skipped and the stop of
/// an earlier animation all fire `moveend` before the call returns, so only a
/// running animation is awaited.
Future<void> moveEnded(JSMap map) async {
  if (map.isEasing()) await map.onceAsync('moveend').toDart;
}

/// Applies [options] at once and keeps [around] at its screen position.
///
/// GL JS `jumpTo` ignores `around`, and a zero-duration `easeTo` applies it
/// in one step, which is not exact on the globe projection. This function
/// pans the map until the point is back at its screen position.
void jumpAround(JSMap map, JSCameraOptions options, JSLngLat around) {
  final target = map.project(around);
  map.jumpTo(options);
  for (var i = 0; i < 5; i++) {
    final current = map.project(around);
    final dx = current.x - target.x;
    final dy = current.y - target.y;
    if (dx.abs() < 0.01 && dy.abs() < 0.01) return;
    final center = map.project(map.getCenter());
    map.jumpTo(
      JSCameraOptions()
        ..center = map.unproject(JSScreenPoint(center.x + dx, center.y + dy)),
    );
  }
}

/// Returns the duration of a [DefaultViewportTransition] from the current
/// camera of [map] to a camera with [center] and [zoom].
Duration defaultTransitionDurationTo(
  JSMap map, {
  JSLngLat? center,
  double? zoom,
  required bool hasBearing,
  required bool hasPitch,
  required bool hasPadding,
  required Duration maxDuration,
}) => defaultTransitionDuration(
  centerDistance: center != null
      ? _pixelDistance(map, map.getCenter(), center)
      : null,
  currentZoom: map.getZoom(),
  targetZoom: zoom,
  hasBearing: hasBearing,
  hasPitch: hasPitch,
  hasPadding: hasPadding,
  maxDuration: maxDuration,
);

double _pixelDistance(JSMap map, JSLngLat from, JSLngLat to) {
  final a = map.project(from);
  // With world copies, GL JS moves along the shorter way around the world.
  // Measure the same way, as mobile does.
  var lng = to.lng;
  if (map.getRenderWorldCopies()) {
    lng -= ((lng - from.lng) / 360).round() * 360;
  }
  final b = map.project(JSLngLat(lng, to.lat));
  return math.sqrt(math.pow(b.x - a.x, 2) + math.pow(b.y - a.y, 2));
}

JSAny? geometryToBounds(turf.GeometryObject geometry) {
  final box = turf.bbox(geometry);
  final sw = <JSAny>[box[0]!.toDouble().toJS, box[1]!.toDouble().toJS].toJS;
  final ne = <JSAny>[box[2]!.toDouble().toJS, box[3]!.toDouble().toJS].toJS;
  return <JSAny>[sw, ne].toJS;
}

JSAny? pointToJSCenter(turf.Point? point) {
  if (point == null) return null;
  return <JSAny>[
    point.coordinates.lng.toDouble().toJS,
    point.coordinates.lat.toDouble().toJS,
  ].toJS;
}

JSPadding? edgeInsetsToJSPadding(EdgeInsets? insets) {
  if (insets == null) return null;
  return JSPadding(
    top: insets.top,
    bottom: insets.bottom,
    left: insets.left,
    right: insets.right,
  );
}
