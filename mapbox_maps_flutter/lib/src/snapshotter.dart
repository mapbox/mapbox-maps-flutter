import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:mapbox_maps_flutter_platform_interface/mapbox_maps_flutter_platform_interface.dart';
import 'package:turf/turf.dart';

/// Captures styled map snapshots without a live [MapWidget].
class Snapshotter {
  final SnapshotterPlatformInterface _impl;

  @internal
  Snapshotter(this._impl);

  /// Event listener invoked when the style has been fully loaded.
  OnStyleLoadedListener? get onStyleLoadedListener =>
      _impl.onStyleLoadedListener;

  /// Event listener invoked when a map load error occurs.
  OnMapLoadErrorListener? get onMapLoadErrorListener =>
      _impl.onMapLoadErrorListener;

  /// Event listener invoked when style data has been loaded.
  OnStyleDataLoadedListener? get onStyleDataLoadedListener =>
      _impl.onStyleDataLoadedListener;

  /// Event listener invoked when the style has a missing image.
  OnStyleImageMissingListener? get onStyleImageMissingListener =>
      _impl.onStyleImageMissingListener;

  /// Returns the current snapshotter camera state.
  Future<CameraState> getCameraState() => _impl.getCameraState();

  /// Sets the camera to the given options.
  Future<void> setCamera(CameraOptions cameraOptions) =>
      _impl.setCamera(cameraOptions);

  /// Returns the current snapshot image size.
  Future<Size?> getSize() => _impl.getSize();

  /// Sets the snapshot image size.
  Future<void> setSize(Size size) => _impl.setSize(size);

  /// Captures a snapshot. If a pending request exists it is cancelled first.
  Future<Uint8List?> start() => _impl.start();

  /// Cancels any pending snapshot request.
  Future<void> cancel() => _impl.cancel();

  /// Returns the coordinate bounds corresponding to the given camera options.
  Future<CoordinateBounds> coordinateBounds(CameraOptions camera) =>
      _impl.coordinateBounds(camera);

  /// Returns camera options that fit the given list of coordinates.
  Future<CameraOptions> camera({
    required List<Point> coordinates,
    MbxEdgeInsets? padding,
    double? bearing,
    double? pitch,
  }) =>
      _impl.camera(
        coordinates: coordinates,
        padding: padding,
        bearing: bearing,
        pitch: pitch,
      );

  /// Returns tile identifiers covering the current snapshotter camera.
  Future<List<CanonicalTileID?>> tileCover(TileCoverOptions options) =>
      _impl.tileCover(options);

  /// Clears temporary map data from the snapshotter's data path.
  Future<void> clearData() => _impl.clearData();

  /// Releases resources held by this snapshotter instance.
  Future<void> dispose() => _impl.dispose();
}
