import 'package:flutter/foundation.dart';
import 'package:mapbox_maps_flutter_interface/src/types/edge_insets.dart';
import 'package:turf/turf.dart' show Point;

/// Represents the state of the camera in the map.
@immutable
class CameraState {
  /// Creates a [CameraState] instance.
  const CameraState({
    required this.center,
    required this.padding,
    required this.zoom,
    required this.pitch,
    required this.bearing,
  });

  /// The geographical center point of the camera's position.
  final Point center;

  /// The padding around the camera's viewport in pixels.
  /// This is typically used to adjust the visible region of the map.
  final MbxEdgeInsets padding;

  /// The zoom level of the camera.
  /// A higher zoom level means a closer view of the map.
  final double zoom;

  /// The pitch (tilt) of the camera in degrees.
  /// A higher pitch value tilts the camera view.
  final double pitch;

  /// The bearing (rotation) of the camera in degrees.
  /// A bearing of 0 means the map is oriented north.
  final double bearing;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CameraState &&
          runtimeType == other.runtimeType &&
          center == other.center &&
          padding == other.padding &&
          zoom == other.zoom &&
          pitch == other.pitch &&
          bearing == other.bearing;

  @override
  int get hashCode =>
      center.hashCode ^
      padding.hashCode ^
      zoom.hashCode ^
      pitch.hashCode ^
      bearing.hashCode;

  @override
  String toString() {
    return 'CameraState(center: $center, padding: $padding, zoom: $zoom, pitch: $pitch, bearing: $bearing)';
  }
}
