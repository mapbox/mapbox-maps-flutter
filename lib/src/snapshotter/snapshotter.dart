part of mapbox_maps_flutter;

final _SnapshotterInstanceManager _snapshotterInstanceManager =
    _SnapshotterInstanceManager();

/// A utility class for capturing styled map snapshots.
///
/// Use a [Snapshotter] when you need to capture a static snapshot of a map without using the actual [MapWidget].
/// You can configure the final result via [MapSnapshotOptions] upon construction time and then start the snapshot.
final class Snapshotter {
  /// A `style` object that can be manipulated to set different styles for a snapshot.
  late StyleManager style;

  /// Invoked when the requested style has been fully loaded, including the style, specified sprite and sources' metadata.
  final OnStyleLoadedListener? onStyleLoadedListener;

  /// Invoked whenever the map load errors out.
  final OnMapLoadErrorListener? onMapLoadErrorListener;

  /// Invoked when the requested style data has been loaded.
  final OnStyleDataLoadedListener? onStyleDataLoadedListener;

  /// Invoked whenever a style has a missing image. This event is emitted when the Map renders visible tiles and
  /// one of the required images is missing in the sprite sheet. Subscriber has to provide the missing image
  /// by calling StyleManager#addStyleImage method.
  final OnStyleImageMissingListener? onStyleImageMissingListener;

  late _SnapshotterMessenger _snapshotterMessenger;
  late _MapEvents _mapEvents;
  final int _suffix = _suffixesRegistry.getSuffix();
  static final Finalizer<int> _finalizer = Finalizer((suffix) {
    try {
      _snapshotterInstanceManager
          .tearDownSnapshotterForSuffix(suffix.toString());
      _suffixesRegistry.releaseSuffix(suffix);
    } catch (e) {
      print("Error: Failed to dispose snapshotter, error: $e");
    }
  });

  Snapshotter._({
    required MapSnapshotOptions options,
    this.onStyleLoadedListener,
    this.onMapLoadErrorListener,
    this.onStyleDataLoadedListener,
    this.onStyleImageMissingListener,
  }) {
    _snapshotterMessenger =
        _SnapshotterMessenger(messageChannelSuffix: _suffix.toString());
    style = StyleManager(messageChannelSuffix: _suffix.toString());
    _mapEvents = _MapEvents(channelSuffix: _suffix.toString());
  }

  /// Creates a new [Snapshotter] instance.
  /// The style can be set using [style.setStyleURI] or [style.setStyleJSON].
  static Future<Snapshotter> create({
    required MapSnapshotOptions options,
    OnStyleLoadedListener? onStyleLoadedListener,
    OnMapLoadErrorListener? onMapLoadErrorListener,
    OnStyleDataLoadedListener? onStyleDataLoadedListener,
    OnStyleImageMissingListener? onStyleImageMissingListener,
  }) async {
    final snapshotter = Snapshotter._(
        options: options,
        onStyleLoadedListener: onStyleLoadedListener,
        onMapLoadErrorListener: onMapLoadErrorListener,
        onStyleDataLoadedListener: onStyleDataLoadedListener,
        onStyleImageMissingListener: onStyleImageMissingListener);

    snapshotter._mapEvents._onStyleLoadedListener = onStyleLoadedListener;
    snapshotter._mapEvents._onMapLoadErrorListener = onMapLoadErrorListener;
    snapshotter._mapEvents._onStyleDataLoadedListener =
        onStyleDataLoadedListener;
    snapshotter._mapEvents._onStyleImageMissingListener =
        onStyleImageMissingListener;

    await _snapshotterInstanceManager.setupSnapshotterForSuffix(
        snapshotter._suffix.toString(),
        snapshotter._mapEvents.eventTypes.map((e) => e.index).toList(),
        options);

    Snapshotter._finalizer
        .attach(snapshotter, snapshotter._suffix, detach: snapshotter);
    return snapshotter;
  }

  /// Disposes the snapshotter instance.
  /// The instance should not be used after calling this method.
  Future<void> dispose() async {
    _finalizer.detach(this);
    await _snapshotterInstanceManager
        .tearDownSnapshotterForSuffix(_suffix.toString());
    _suffixesRegistry.releaseSuffix(_suffix);
  }

  /// The current state of the snapshotter camera.
  Future<CameraState> getCameraState() =>
      _snapshotterMessenger.getCameraState();

  /// Set the current state of the snapshotter camera.
  Future<void> setCamera(CameraOptions cameraOptions) =>
      _snapshotterMessenger.setCamera(cameraOptions);

  /// The size of the snapshot image.
  Future<Size?> getSize() async => _snapshotterMessenger.getSize();

  /// Set the size of the snapshot image.
  Future<void> setSize(Size size) => _snapshotterMessenger.setSize(size);

  /// Request a new snapshot. If there is a pending snapshot request, it is cancelled automatically.
  /// Throws an error if the snapshot is cancelled.
  Future<Uint8List?> start() async => _snapshotterMessenger.start();

  /// Cancel the current snapshot operation, if any. The callback passed to the start method
  /// is called with error parameter set.
  Future<void> cancel() async => _snapshotterMessenger.cancel();

  /// Returns the coordinate bounds corresponding to a given `CameraOptions`
  Future<CoordinateBounds> coordinateBounds(CameraOptions camera) =>
      _snapshotterMessenger.coordinateBounds(camera);

  /// Calculates a `CameraOptions` to fit a list of coordinates.
  Future<CameraOptions> camera(
          {required List<Point> coordinates,
          MbxEdgeInsets? padding,
          double? bearing,
          double? pitch}) =>
      _snapshotterMessenger.camera(
          coordinates: coordinates,
          padding: padding,
          bearing: bearing,
          pitch: pitch);

  /// Returns array of tile identifiers that cover current map camera.
  Future<List<CanonicalTileID?>> tileCover(TileCoverOptions options) =>
      _snapshotterMessenger.tileCover(options);

  /// Clears temporary map data.
  ///
  /// Clears temporary map data from the data path defined in the given resource
  /// options. Useful to reduce the disk usage or in case the disk cache contains
  /// invalid data.
  ///
  /// Note: Calling this API will affect all maps that use the same data path
  ///       and does not affect persistent map data like offline style packages.
  Future<void> clearData() async => _snapshotterMessenger.clearData();
}
