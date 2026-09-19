import 'package:mapbox_maps_flutter_platform_interface/mapbox_maps_flutter_platform_interface.dart'
    show CameraOptions, CameraState;

/// Conversions on [CameraState] used by callers that need to round-trip
/// the current camera back through APIs that take [CameraOptions]
/// (e.g. `Snapshotter.setCamera(...)`).
extension Conversion on CameraState {
  CameraOptions toCameraOptions() {
    return CameraOptions(
      center: center,
      padding: padding,
      zoom: zoom,
      bearing: bearing,
      pitch: pitch,
    );
  }
}
