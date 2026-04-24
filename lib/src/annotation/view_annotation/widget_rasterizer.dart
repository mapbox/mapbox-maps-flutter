part of mapbox_maps_flutter;

/// Rasterizes arbitrary Flutter widgets into PNG bytes suitable for handing
/// to the native view annotation managers.
///
/// The implementation mounts the widget inside a throwaway render pipeline
/// (no interaction with the host widget tree) and captures a
/// [RenderRepaintBoundary.toImage] frame. This keeps the pipeline on the UI
/// isolate but avoids any visible overlay, so we do not inherit build-phase
/// constraints of the enclosing [MapWidget].
///
/// The rasterizer is intentionally stateless — callers are expected to
/// manage their own caches keyed by a visual fingerprint (widget identity,
/// size, pixel ratio). See [ViewAnnotationManager] for the cache policy
/// applied when widgets are handed through that API.
abstract class _WidgetRasterizer {
  _WidgetRasterizer._();

  /// Rasterizes [widget] at the given logical [size].
  ///
  /// When [size] is null, the widget is measured with loose [BoxConstraints]
  /// and rendered at its intrinsic dry layout size, capped at
  /// [_maxUnboundedSide] logical pixels per side so runaway widgets do not
  /// blow past GPU texture limits. [pixelRatio] controls the DPR of the
  /// resulting bitmap and should usually match the screen's DPR or a
  /// caller-chosen cap for zoomed-in views.
  static Future<_RasterizedWidget> rasterize({
    required Widget widget,
    ui.Size? size,
    required double pixelRatio,
  }) async {
    final FlutterView flutterView = PlatformDispatcher.instance.views.first;
    final BoxConstraints logicalConstraints = size == null
        ? const BoxConstraints(
            minWidth: 0,
            maxWidth: _maxUnboundedSide,
            minHeight: 0,
            maxHeight: _maxUnboundedSide,
          )
        : BoxConstraints.tight(size);
    final ui.Size physicalCap = ui.Size(
      (size?.width ?? _maxUnboundedSide) * pixelRatio,
      (size?.height ?? _maxUnboundedSide) * pixelRatio,
    );

    final RenderRepaintBoundary repaintBoundary = RenderRepaintBoundary();

    final RenderView renderView = RenderView(
      view: flutterView,
      configuration: ViewConfiguration(
        physicalConstraints: BoxConstraints.loose(physicalCap),
        logicalConstraints: logicalConstraints,
        devicePixelRatio: pixelRatio,
      ),
      child: repaintBoundary,
    );

    final PipelineOwner pipelineOwner = PipelineOwner();
    final BuildOwner buildOwner = BuildOwner(focusManager: FocusManager());
    pipelineOwner.rootNode = renderView;
    renderView.prepareInitialFrame();

    final RenderObjectToWidgetElement<RenderBox> rootElement =
        RenderObjectToWidgetAdapter<RenderBox>(
      container: repaintBoundary,
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: MediaQuery(
          data: MediaQueryData.fromView(flutterView),
          child: widget,
        ),
      ),
    ).attachToRenderTree(buildOwner);

    buildOwner
      ..buildScope(rootElement)
      ..finalizeTree();

    pipelineOwner
      ..flushLayout()
      ..flushCompositingBits()
      ..flushPaint();

    final ui.Image image =
        await repaintBoundary.toImage(pixelRatio: pixelRatio);
    try {
      final ByteData? byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);
      if (byteData == null) {
        throw StateError('Failed to encode widget annotation to PNG.');
      }
      final ui.Size renderedLogicalSize = repaintBoundary.hasSize
          ? repaintBoundary.size
          : (size ?? ui.Size.zero);
      return _RasterizedWidget(
        bytes: byteData.buffer.asUint8List(),
        logicalSize: renderedLogicalSize,
        pixelRatio: pixelRatio,
      );
    } finally {
      image.dispose();
      // Detach the offscreen tree so any tickers / image streams held by the
      // widget are released. We leave the element tree unmounted implicitly —
      // elements without a parent become garbage after the build owner goes
      // out of scope, matching the behaviour of the `screenshot` package.
      pipelineOwner.rootNode = null;
    }
  }

  static const double _maxUnboundedSide = 2048;
}

/// Carrier returned by [_WidgetRasterizer.rasterize] with the PNG payload and
/// the logical size that the widget laid out to (needed to give the native
/// view annotation manager the correct view dimensions).
@immutable
class _RasterizedWidget {
  const _RasterizedWidget({
    required this.bytes,
    required this.logicalSize,
    required this.pixelRatio,
  });

  final Uint8List bytes;
  final ui.Size logicalSize;
  final double pixelRatio;
}
