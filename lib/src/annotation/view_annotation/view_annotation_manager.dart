part of mapbox_maps_flutter;

/// Callback invoked when a [ViewAnnotation] is tapped on the native side.
typedef OnViewAnnotationTap = void Function(ViewAnnotationTapEvent event);

/// Manages a collection of [ViewAnnotation]s (Flutter widgets anchored to
/// geographic coordinates) rendered natively above the map surface using the
/// platform's Mapbox view annotation APIs.
///
/// Usage:
/// ```dart
/// final manager = await mapboxMap.annotations.createViewAnnotationManager();
/// final annotation = await manager.create(ViewAnnotationOptions(
///   geometry: Point(coordinates: Position(2.35, 48.85)),
///   widget: const _PlaceMarker(),
///   anchor: ViewAnnotationAnchor.bottom,
/// ));
/// manager.tapEvents.listen((e) => print('tapped ${e.annotationId}'));
/// ```
///
/// ### Performance notes
/// * Widgets are rasterized off the main render tree via [_WidgetRasterizer]
///   and only re-rasterized on [create] / [update]. Camera movement does not
///   re-encode bitmaps — the native view annotation manager reprojects the
///   platform view for free.
/// * [update] diffs the incoming [ViewAnnotationOptions] against the last
///   committed ones and skips the rasterization step when only non-visual
///   fields (geometry, anchor, offset, visibility, overlap policy) changed.
/// * All platform calls go through a single [MethodChannel] scoped to the
///   manager id, so multiple managers on the same map do not fight for a
///   shared channel.
class ViewAnnotationManager extends BaseAnnotationManager {
  ViewAnnotationManager._({
    required super.id,
    required BinaryMessenger messenger,
    required String channelSuffix,
  })  : _channel = MethodChannel(
          'plugins.flutter.io.mapbox_maps.view_annotations.$channelSuffix.$id',
          const StandardMethodCodec(),
          messenger,
        ),
        super._(messenger: messenger) {
    _channel.setMethodCallHandler(_handleMethodCall);
  }

  final MethodChannel _channel;

  final Map<String, _InternalViewAnnotation> _annotations =
      <String, _InternalViewAnnotation>{};

  final StreamController<ViewAnnotationTapEvent> _tapController =
      StreamController<ViewAnnotationTapEvent>.broadcast();

  int _autoId = 0;
  bool _disposed = false;

  /// Stream of tap events for annotations in this manager.
  Stream<ViewAnnotationTapEvent> get tapEvents => _tapController.stream;

  /// Creates a new view annotation.
  ///
  /// Returns the created [ViewAnnotation]. The caller should store
  /// [ViewAnnotation.id] and pass it to [update] / [delete].
  Future<ViewAnnotation> create(ViewAnnotationOptions options) async {
    _ensureLive();
    final id = 'va_${_autoId++}';
    final payload = await _buildPayload(id, options);
    await _channel.invokeMethod<void>('create', payload.wireArgs);
    _annotations[id] = _InternalViewAnnotation(
      options: options,
      cachedRaster: payload.raster,
    );
    return ViewAnnotation._(id: id, options: options);
  }

  /// Updates an existing view annotation previously returned by [create].
  ///
  /// Throws [ArgumentError] when [id] is unknown.
  Future<ViewAnnotation> update(
      String id, ViewAnnotationOptions options) async {
    _ensureLive();
    final existing = _annotations[id];
    if (existing == null) {
      throw ArgumentError.value(id, 'id', 'Unknown view annotation.');
    }

    final needsRaster = _visualsChanged(existing.options, options);
    final _PreparedPayload payload = needsRaster
        ? await _buildPayload(id, options)
        : _buildPayloadFromRaster(id, options, existing.cachedRaster);

    await _channel.invokeMethod<void>('update', payload.wireArgs);
    _annotations[id] = _InternalViewAnnotation(
      options: options,
      cachedRaster: payload.raster,
    );
    return ViewAnnotation._(id: id, options: options);
  }

  /// Deletes a view annotation.
  Future<void> delete(String id) async {
    _ensureLive();
    if (_annotations.remove(id) == null) {
      return;
    }
    await _channel.invokeMethod<void>('delete', <String, Object?>{'id': id});
  }

  /// Deletes every view annotation managed by this manager.
  Future<void> deleteAll() async {
    _ensureLive();
    _annotations.clear();
    await _channel.invokeMethod<void>('deleteAll');
  }

  /// Returns an immutable snapshot of the currently tracked annotations.
  List<ViewAnnotation> getAnnotations() {
    return _annotations.entries
        .map((e) => ViewAnnotation._(id: e.key, options: e.value.options))
        .toList(growable: false);
  }

  /// Releases native resources held by the manager. The manager becomes
  /// unusable afterwards.
  Future<void> dispose() async {
    if (_disposed) {
      return;
    }
    _disposed = true;
    _channel.setMethodCallHandler(null);
    await _tapController.close();
    _annotations.clear();
    try {
      await _channel.invokeMethod<void>('dispose');
    } on PlatformException catch (_) {
      // Native side may already be torn down — ignore.
    }
  }

  /// Only the visual fields require re-rasterization.
  bool _visualsChanged(ViewAnnotationOptions a, ViewAnnotationOptions b) {
    if (identical(a.widget, b.widget) && a.image == b.image) {
      if (a.size == b.size && a.pixelRatio == b.pixelRatio) {
        return false;
      }
    }
    return true;
  }

  Future<_PreparedPayload> _buildPayload(
      String id, ViewAnnotationOptions options) async {
    _RasterizedWidget? raster;
    Uint8List bytes;
    ui.Size? renderedSize = options.size;

    if (options.widget != null) {
      final pixelRatio = options.pixelRatio ??
          PlatformDispatcher.instance.views.first.devicePixelRatio;
      raster = await _WidgetRasterizer.rasterize(
        widget: options.widget!,
        size: options.size,
        pixelRatio: pixelRatio,
      );
      bytes = raster.bytes;
      renderedSize = options.size ?? raster.logicalSize;
    } else {
      bytes = options.image!;
    }

    return _PreparedPayload(
      raster: raster,
      wireArgs: _encodeViewAnnotationPayload(
        id: id,
        options: options,
        imageBytes: bytes,
        renderedSize: renderedSize,
      ),
    );
  }

  _PreparedPayload _buildPayloadFromRaster(
    String id,
    ViewAnnotationOptions options,
    _RasterizedWidget? cachedRaster,
  ) {
    final bytes = cachedRaster?.bytes ?? options.image;
    if (bytes == null) {
      // Should be unreachable when options are constructed correctly.
      throw StateError(
          'ViewAnnotationManager.update: no bitmap available for $id.');
    }
    final ui.Size? renderedSize = options.size ?? cachedRaster?.logicalSize;
    return _PreparedPayload(
      raster: cachedRaster,
      wireArgs: _encodeViewAnnotationPayload(
        id: id,
        options: options,
        imageBytes: bytes,
        renderedSize: renderedSize,
      ),
    );
  }

  Future<dynamic> _handleMethodCall(MethodCall call) async {
    switch (call.method) {
      case 'onTap':
        final args = call.arguments as Map<Object?, Object?>?;
        final annotationId = args?['id'] as String?;
        if (annotationId != null && !_tapController.isClosed) {
          _tapController.add(
              ViewAnnotationTapEvent(annotationId: annotationId));
        }
        return null;
      default:
        return null;
    }
  }

  void _ensureLive() {
    if (_disposed) {
      throw StateError('ViewAnnotationManager has been disposed.');
    }
  }
}

class _InternalViewAnnotation {
  _InternalViewAnnotation({required this.options, required this.cachedRaster});
  ViewAnnotationOptions options;
  _RasterizedWidget? cachedRaster;
}

class _PreparedPayload {
  _PreparedPayload({required this.raster, required this.wireArgs});
  final _RasterizedWidget? raster;
  final Map<String, Object?> wireArgs;
}
