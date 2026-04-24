part of mapbox_maps_flutter;

/// Options used to create or update a [ViewAnnotation] via
/// [ViewAnnotationManager.create] or [ViewAnnotationManager.update].
///
/// A view annotation is a native Android/iOS view anchored to a geographic
/// coordinate. Unlike symbol-based [PointAnnotation]s, view annotations are
/// rendered as platform views above the map surface and therefore support
/// arbitrary Flutter widgets passed through [widget]. The widget is rasterized
/// once (or whenever its visual contents change) and handed to the platform
/// as PNG bytes.
///
/// The [anchor] value reuses the existing [ViewAnnotationAnchor] enum shared
/// with the pigeon-generated map surface, so a single anchor concept applies
/// to both style-layer annotations and view annotations.
///
/// If [widget] is omitted, [image] must be supplied with raw PNG/JPEG bytes.
@immutable
class ViewAnnotationOptions {
  /// Creates options backed by a Flutter [widget].
  ///
  /// The widget is rendered offscreen at [size] (or a measured intrinsic size
  /// if omitted) using [pixelRatio] for the platform's DPR, then uploaded to
  /// the native view annotation manager.
  const ViewAnnotationOptions({
    required this.geometry,
    this.widget,
    this.image,
    this.size,
    this.pixelRatio,
    this.anchor = ViewAnnotationAnchor.CENTER,
    this.offsetX = 0,
    this.offsetY = 0,
    this.allowOverlap = true,
    this.visible = true,
  }) : assert(widget != null || image != null,
            'Either widget or image must be provided.');

  /// Geographic position that the annotation is anchored to.
  final Point geometry;

  /// Flutter widget rendered as the annotation's content.
  ///
  /// Mutually optional with [image]. If both are provided, [widget] wins and
  /// [image] is ignored.
  final Widget? widget;

  /// Pre-rasterized bitmap bytes (PNG, JPEG, or any format decodable by the
  /// host platform). Use this when the caller already owns a bitmap and does
  /// not want the package to rasterize a widget.
  final Uint8List? image;

  /// Logical (DP on Android, points on iOS) size of the native view.
  ///
  /// When null and [widget] is provided, the widget's intrinsic size at
  /// [pixelRatio] is used.
  final ui.Size? size;

  /// Device pixel ratio used when rasterizing [widget].
  ///
  /// When null, defaults to the primary view's DPR at the time of creation.
  final double? pixelRatio;

  /// Anchor point of the annotation relative to [geometry].
  final ViewAnnotationAnchor anchor;

  /// Horizontal offset in logical pixels applied after anchoring.
  final double offsetX;

  /// Vertical offset in logical pixels applied after anchoring.
  final double offsetY;

  /// Whether the annotation is allowed to overlap other view annotations.
  final bool allowOverlap;

  /// Whether the annotation is currently visible.
  final bool visible;

  ViewAnnotationOptions copyWith({
    Point? geometry,
    Widget? widget,
    Uint8List? image,
    ui.Size? size,
    double? pixelRatio,
    ViewAnnotationAnchor? anchor,
    double? offsetX,
    double? offsetY,
    bool? allowOverlap,
    bool? visible,
  }) {
    return ViewAnnotationOptions(
      geometry: geometry ?? this.geometry,
      widget: widget ?? this.widget,
      image: image ?? this.image,
      size: size ?? this.size,
      pixelRatio: pixelRatio ?? this.pixelRatio,
      anchor: anchor ?? this.anchor,
      offsetX: offsetX ?? this.offsetX,
      offsetY: offsetY ?? this.offsetY,
      allowOverlap: allowOverlap ?? this.allowOverlap,
      visible: visible ?? this.visible,
    );
  }
}

/// Represents a live view annotation managed by a [ViewAnnotationManager].
@immutable
class ViewAnnotation {
  const ViewAnnotation._({
    required this.id,
    required this.options,
  });

  /// Stable identifier assigned by the manager at creation time.
  final String id;

  /// Options currently applied to the annotation.
  final ViewAnnotationOptions options;
}

/// Event delivered when a view annotation is tapped on the native side.
@immutable
class ViewAnnotationTapEvent {
  const ViewAnnotationTapEvent({required this.annotationId});

  /// Id of the tapped annotation (matches [ViewAnnotation.id]).
  final String annotationId;
}

/// Internal wire encoding helpers for view annotation payloads.
///
/// Keeping this close to the options lets us evolve the protocol without
/// leaking it into public API surface.
Map<String, Object?> _encodeViewAnnotationPayload({
  required String id,
  required ViewAnnotationOptions options,
  required Uint8List imageBytes,
  required ui.Size? renderedSize,
}) {
  final coords = options.geometry.coordinates;
  return <String, Object?>{
    'id': id,
    'coordinates': <double>[coords.lng.toDouble(), coords.lat.toDouble()],
    'image': imageBytes,
    if (renderedSize != null) 'width': renderedSize.width,
    if (renderedSize != null) 'height': renderedSize.height,
    'anchor': options.anchor.index,
    'offsetX': options.offsetX,
    'offsetY': options.offsetY,
    'allowOverlap': options.allowOverlap,
    'visible': options.visible,
  };
}
