import 'package:mapbox_maps_flutter_interface/src/types/edge_insets.dart';
import 'package:mapbox_maps_flutter_interface/src/types/screen_coordinate.dart';
import 'package:turf/turf.dart' show Point;

/// Represents the options for configuring the camera's position and view.
class CameraOptions {
  /// The geographical center point of the camera.
  Point? center;

  /// The padding around the camera view.
  MbxEdgeInsets? padding;

  /// Point of reference for `zoom` and `angle`, assuming an origin at the
  /// top-left corner of the view.
  ScreenCoordinate? anchor;

  /// Zero-based zoom level. Constrained to the minimum and maximum zoom
  /// levels.
  double? zoom;

  /// Bearing, measured in degrees from true north. Wrapped to [0, 360).
  double? bearing;

  /// Pitch toward the horizon measured in degrees.
  double? pitch;

  CameraOptions({
    this.center,
    this.padding,
    this.anchor,
    this.zoom,
    this.bearing,
    this.pitch,
  });
}
