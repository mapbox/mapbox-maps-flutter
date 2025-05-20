import 'package:mapbox_maps_flutter_interface/mapbox_maps_flutter_interface.dart';
import 'package:mapbox_maps_flutter_web/src/bindings.dart';

extension PointToLngLat on Point {
  LngLat toLngLat() {
    return LngLat(coordinates.lng, coordinates.lat);
  }
}

extension LngLatToPoint on LngLat {
  Point toPoint() {
    return Point(coordinates: Position(lng, lat));
  }
}

extension PaddingOptionsToMbxEdgeInsets on PaddingOptions {
  MbxEdgeInsets toMbxEdgeInsets() {
    return MbxEdgeInsets(
      top: top.toDouble(),
      left: left.toDouble(),
      bottom: bottom.toDouble(),
      right: right.toDouble(),
    );
  }
}

extension MbxEdgeInsetsToPaddingOptions on MbxEdgeInsets {
  PaddingOptions toPaddingOptions() {
    return PaddingOptions(
      top: top,
      left: left,
      bottom: bottom,
      right: right,
    );
  }
}
