import 'dart:js_interop';

import 'package:flutter/painting.dart';
import 'package:mapbox_maps_flutter_platform_interface/mapbox_maps_flutter_platform_interface.dart';
import 'package:turf/turf.dart' as turf;

import '../bindings/map_bindings.dart';

/// Starts a camera animation (easeTo or flyTo) based on the transition type.
void animate(
  JSMap map,
  JSAny? center,
  double? zoom,
  double? bearing,
  double? pitch,
  JSPadding? padding,
  ViewportTransition transition,
) {
  final opts = JSCameraOptions(
    center: center,
    zoom: zoom,
    bearing: bearing,
    pitch: pitch,
    padding: padding,
    duration: transitionDurationMs(transition),
    essential: true,
  );

  switch (transition) {
    case FlyViewportTransition():
      map.flyTo(opts);
    case EasingViewportTransition():
    case DefaultViewportTransition():
      map.easeTo(opts);
  }
}

JSAny? geometryToBounds(turf.GeometryObject geometry) {
  final box = turf.bbox(geometry);
  final sw = <JSAny>[box[0]!.toDouble().toJS, box[1]!.toDouble().toJS].toJS;
  final ne = <JSAny>[box[2]!.toDouble().toJS, box[3]!.toDouble().toJS].toJS;
  return <JSAny>[sw, ne].toJS;
}

int? transitionDurationMs(ViewportTransition? transition) {
  return switch (transition) {
    FlyViewportTransition(:final duration) => duration?.inMilliseconds,
    EasingViewportTransition(:final duration) => duration.inMilliseconds,
    DefaultViewportTransition(:final maxDuration) =>
      maxDuration.inMilliseconds,
    null => null,
  };
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
