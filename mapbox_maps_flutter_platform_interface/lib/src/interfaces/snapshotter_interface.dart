import 'dart:typed_data';

import 'package:turf/turf.dart';

import '../events.dart';
import '../pigeons/platform_interface_data_types.dart';

/// Abstract interface for capturing styled map snapshots.
///
/// Use a snapshotter to capture a static image of a map without a live [MapWidget].
/// Configure the result via [MapSnapshotOptions] at construction time, set the style,
/// adjust the camera, and then call [start] to capture the image.
abstract interface class SnapshotterPlatformInterface {
  /// Event listeners wired at construction time.
  OnStyleLoadedListener? get onStyleLoadedListener;
  OnMapLoadErrorListener? get onMapLoadErrorListener;
  OnStyleDataLoadedListener? get onStyleDataLoadedListener;
  OnStyleImageMissingListener? get onStyleImageMissingListener;

  /// Returns the current snapshotter camera state.
  Future<CameraState> getCameraState();

  /// Sets the camera to the given options.
  Future<void> setCamera(CameraOptions cameraOptions);

  /// Returns the current snapshot image size.
  Future<Size?> getSize();

  /// Sets the snapshot image size.
  Future<void> setSize(Size size);

  /// Captures a snapshot. If a pending request exists it is cancelled first.
  Future<Uint8List?> start();

  /// Cancels any pending snapshot request.
  Future<void> cancel();

  /// Returns the coordinate bounds corresponding to the given camera options.
  Future<CoordinateBounds> coordinateBounds(CameraOptions camera);

  /// Returns camera options that fit the given list of coordinates.
  Future<CameraOptions> camera({
    required List<Point> coordinates,
    MbxEdgeInsets? padding,
    double? bearing,
    double? pitch,
  });

  /// Returns tile identifiers covering the current snapshotter camera.
  Future<List<CanonicalTileID?>> tileCover(TileCoverOptions options);

  /// Clears temporary map data from the snapshotter's data path.
  Future<void> clearData();

  /// Releases resources held by this snapshotter instance.
  Future<void> dispose();
}
