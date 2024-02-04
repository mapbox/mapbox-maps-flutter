part of mapbox_maps_flutter;

class SnapShotter {
  SnapShotter(this.id, this._messenger);

  final String id;
  final BinaryMessenger _messenger;

  late _SnapshotterMessager _snapshotterMessager =
      _SnapshotterMessager(binaryMessenger: _messenger);

  Future<void> cancel() => _snapshotterMessager.cancel(id);

  Future<void> destroy() => _snapshotterMessager.destroy(id);

  Future<void> setCamera(CameraOptions cameraOptions) =>
      _snapshotterMessager.setCamera(id, cameraOptions);

  Future<void> setStyleUri(String styleUri) => _snapshotterMessager.setStyleUri(id, styleUri);

  Future<void> setStyleJson(String styleJson) => _snapshotterMessager.setStyleJson(id, styleJson);

  Future<void> setSize(Size size) => _snapshotterMessager.setSize(id, size);

  Future<CameraOptions> cameraForCoordinates(List<Map<String?, Object?>?> coordinates,
          MbxEdgeInsets padding, double? bearing, double? pitch) =>
      _snapshotterMessager.cameraForCoordinates(id, coordinates, padding, bearing, pitch);

  Future<CoordinateBounds> coordinateBoundsForCamera(CameraOptions camera) =>
      _snapshotterMessager.coordinateBoundsForCamera(id, camera);

  Future<CameraState> getCameraState() => _snapshotterMessager.getCameraState(id);

  Future<Size> getSize() => _snapshotterMessager.getSize(id);

  Future<String> getStyleJson() => _snapshotterMessager.getStyleJson(id);

  Future<String> getStyleUri() => _snapshotterMessager.getStyleUri(id);

  Future<MbxImage?> start() => _snapshotterMessager.start(id);

  void setSnapshotStyleListener(OnSnapshotStyleListener listener) {
    OnSnapshotStyleListener.setup(listener, binaryMessenger: _messenger);
  }
}
