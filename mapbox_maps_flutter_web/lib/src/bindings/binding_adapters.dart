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
