import 'package:mapbox_maps_flutter_interface/mapbox_maps_flutter_interface.dart';

/// An abstract base class that defines the interface for interacting with a Mapbox map.
///
/// This interface provides methods for setting the camera options and retrieving the current camera state.
abstract base class MapboxMapInterface {
  /// Sets the camera options for the map.
  ///
  /// [cameraOptions] - The desired camera options to apply to the map.
  ///
  /// Returns a [Future] that completes when the camera options have been applied.
  Future<void> setCamera(CameraOptions cameraOptions);

  /// Retrieves the current state of the camera.
  ///
  /// Returns a [Future] that completes with the current [CameraState] of the map.
  Future<CameraState> getCameraState();
}
