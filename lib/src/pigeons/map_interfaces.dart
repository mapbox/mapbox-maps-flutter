part of mapbox_maps_flutter;

/// Describes glyphs rasterization modes.
enum GlyphsRasterizationMode {
  /// No glyphs are rasterized locally. All glyphs are loaded from the server.
  NO_GLYPHS_RASTERIZED_LOCALLY,

  /// Ideographs are rasterized locally, and they are not loaded from the server.
  IDEOGRAPHS_RASTERIZED_LOCALLY,

  /// All glyphs are rasterized locally. No glyphs are loaded from the server.
  ALL_GLYPHS_RASTERIZED_LOCALLY,
}

/// Describes the map context mode.
/// We can make some optimizations if we know that the drawing context is not shared with other code.
enum ContextMode {
  /// Unique context mode: in OpenGL, the GL context is not shared, thus we can retain knowledge about the GL state
  /// from a previous render pass. It also enables clearing the screen using glClear for the bottommost background
  /// layer when no pattern is applied to that layer.
  UNIQUE,

  /// Shared context mode: in OpenGL, the GL context is shared with other renderers, thus we cannot rely on the GL
  /// state set from a previous render pass.
  SHARED,
}

/// Describes whether to constrain the map in both axes or only vertically e.g. while panning.
enum ConstrainMode {
  /// No constrains.
  NONE,

  /// Constrain to height only
  HEIGHT_ONLY,

  /// Constrain both width and height axes.
  WIDTH_AND_HEIGHT,
}

/// Satisfies embedding platforms that requires the viewport coordinate systems to be set according to its standards.
enum ViewportMode {
  /// Default viewport
  DEFAULT,

  /// Viewport flipped on the y-axis.
  FLIPPED_Y,
}

/// Describes the map orientation.
enum NorthOrientation {
  /// Default, map oriented upwards
  UPWARDS,

  /// Map oriented righwards
  RIGHTWARDS,

  /// Map oriented downwards
  DOWNWARDS,

  /// Map oriented leftwards
  LEFTWARDS,
}

/// Options for enabling debugging features in a map.
enum MapDebugOptionsData {
  /// Edges of tile boundaries are shown as thick, red lines to help diagnose
  /// tile clipping issues.
  TILE_BORDERS,

  /// Each tile shows its tile coordinate (x/y/z) in the upper-left corner.
  PARSE_STATUS,

  /// Each tile shows a timestamp indicating when it was loaded.
  TIMESTAMPS,

  /// Edges of glyphs and symbols are shown as faint, green lines to help
  /// diagnose collision and label placement issues.
  COLLISION,

  /// Each drawing operation is replaced by a translucent fill. Overlapping
  /// drawing operations appear more prominent to help diagnose overdrawing.
  OVERDRAW,

  /// The stencil buffer is shown instead of the color buffer.
  STENCIL_CLIP,

  /// The depth buffer is shown instead of the color buffer.
  DEPTH_BUFFER,

  /// Visualize residency of tiles in the render cache. Tile boundaries of cached tiles
  /// are rendered with green, tiles waiting for an update with yellow and tiles not in the cache
  /// with red.
  RENDER_CACHE,

  /// Show 3D model bounding boxes. */
  MODEL_BOUNDS,
  TERRAIN_WIREFRAME,
}

/// Enum describing how to place view annotation relatively to geometry.
enum ViewAnnotationAnchor {
  /// The top of the view annotation is placed closest to the geometry.
  TOP,

  /// The left side of the view annotation is placed closest to the geometry. */
  LEFT,

  /// The bottom of the view annotation is placed closest to the geometry. */
  BOTTOM,

  /// The right side of the view annotation is placed closest to the geometry. */
  RIGHT,

  /// The top-left corner of the view annotation is placed closest to the geometry. */
  TOP_LEFT,

  /// The bottom-right corner of the view annotation is placed closest to the geometry. */
  BOTTOM_RIGHT,

  /// The top-right corner of the view annotation is placed closest to the geometry. */
  TOP_RIGHT,

  /// The bottom-left corner of the view annotation is placed closest to the geometry. */
  BOTTOM_LEFT,
  CENTER,
}

enum Type {
  SCREEN_BOX,
  SCREEN_COORDINATE,
  LIST,
}

/// Describes the reason for a style package download request failure.
enum StylePackErrorType {
  /// The operation was canceled.
  CANCELED,

  /// The style package does not exist.
  DOES_NOT_EXIST,

  /// There is no available space to store the resources.
  DISK_FULL,

  /// Other reason.
  OTHER,
}

/// Describes the reason for an offline request response error.
enum ResponseErrorReason {
  /// The resource is not found.
  NOT_FOUND,

  /// The server error. */
  SERVER,

  /// The connection error. */
  CONNECTION,

  /// The error happened because of a rate limit. */
  RATE_LIMIT,
  OTHER,
}

/// Describes the download state of a region.
enum OfflineRegionDownloadState {
  /// Indicates downloading is inactive.
  INACTIVE,
  ACTIVE,
}

/// Describes tile store usage modes.
enum TileStoreUsageMode {
  /// Tile store usage is disabled.
  ///
  /// The implementation skips checking tile store when requesting a tile.
  DISABLED,

  /// Tile store enabled for accessing loaded tile packs.
  ///
  /// The implementation first checks tile store when requesting a tile.
  /// If a tile pack is already loaded, the tile will be extracted and returned. Otherwise, the implementation
  /// falls back to requesting the individual tile and storing it in the disk cache.
  READ_ONLY,

  /// Tile store enabled for accessing local tile packs and for loading new tile packs from server.
  ///
  /// All tile requests are converted to tile pack requests, i.e.
  /// the tile pack that includes the request tile will be loaded, and the tile extracted
  /// from it. In this mode, no individual tile requests will be made.
  ///
  /// This mode can be useful if the map trajectory is predefined and the user cannot pan
  /// freely (e.g. navigation use cases), so that there is a good chance tile packs are already loaded
  /// in the vicinity of the user.
  ///
  /// If users can pan freely, this mode is not recommended. Otherwise, panning
  /// will download tile packs instead of using individual tiles. Note that this means that we could first
  /// download an individual tile, and then a tile pack that also includes this tile. The individual tile in
  /// the disk cache won’t be used as long as the up-to-date tile pack exists in the cache.
  READ_AND_UPDATE,
}

/// Describes the kind of a style property value.
enum StylePropertyValueKind {
  /// The property value is not defined.
  UNDEFINED,

  /// The property value is a constant. */
  CONSTANT,

  /// The property value is a style [expression](https://docs.mapbox.com/mapbox-gl-js/style-spec/#expressions). */
  EXPRESSION,
  TRANSITION,
}

/// HTTP defines a set of request methods to indicate the desired action to be performed for a given resource.
enum HttpMethod {
  /// The GET method requests a representation of the specified resource. Requests using GET should only retrieve data.
  GET,

  /// The HEAD method asks for a response identical to that of a GET request, but without the response body.
  HEAD,

  /// The POST method sends data (stored in the request body) to a server to create or update a given resource.
  POST,
}

/// Classify network types based on cost.
enum NetworkRestriction {
  /// Allow access to all network types.
  NONE,

  /// Forbid network access to expensive networks, such as cellular.
  DISALLOW_EXPENSIVE,

  /// Forbid access to all network types.
  DISALLOW_ALL,
}

/// Enum which describes possible error types which could happen during HTTP request/download calls.
enum HttpRequestErrorType {
  /// Establishing connection related error.
  CONNECTION_ERROR,

  /// SSL related error.
  SSLERROR,

  /// Request was cancelled by the user.
  REQUEST_CANCELLED,

  /// Timeout error.
  REQUEST_TIMED_OUT,

  /// Range request failed.
  RANGE_ERROR,

  /// Other than above error.
  OTHER_ERROR,
}

/// Enum which represents different error cases which could happen during download session.
enum DownloadErrorCode {
  /// General filesystem related error code. For cases like: write error, no such file or directory, not enough space and etc.
  FILE_SYSTEM_ERROR,

  /// General network related error. Should be probably representation of HttpRequestError.
  NETWORK_ERROR,
}

/// Enum representing state of download session.
enum DownloadState {
  /// Download session initiated but not started yet.
  PENDING,

  /// Download session is in progress.
  DOWNLOADING,

  /// Download session failed.
  FAILED,

  /// Download session successfully finished.
  FINISHED,
}

/// Describes the tiles data domain.
enum TileDataDomain {
  /// Data for Maps.
  MAPS,

  /// Data for Navigation.
  NAVIGATION,

  /// Data for Search.
  SEARCH,

  /// Data for ADAS
  ADAS,
}

/// Describes the reason for a tile region download request failure.
enum TileRegionErrorType {
  /// The operation was canceled.
  CANCELED,

  /// tile region does not exist.
  DOES_NOT_EXIST,

  /// Tileset descriptors resolving failed.
  TILESET_DESCRIPTOR,

  /// There is no available space to store the resources
  DISK_FULL,

  /// Other reason.
  OTHER,

  /// The region contains more tiles than allowed.
  TILE_COUNT_EXCEEDED,
}

/// The distance on each side between rectangles, when one is contained into other.
///
/// All fields' values are in pixels units.
class MbxEdgeInsets {
  MbxEdgeInsets({
    required this.top,
    required this.left,
    required this.bottom,
    required this.right,
  });

  /// Padding from the top.
  double top;

  /// Padding from the left.
  double left;

  /// Padding from the bottom.
  double bottom;

  /// Padding from the right.
  double right;

  Object encode() {
    final Map<Object?, Object?> pigeonMap = <Object?, Object?>{};
    pigeonMap['top'] = top;
    pigeonMap['left'] = left;
    pigeonMap['bottom'] = bottom;
    pigeonMap['right'] = right;
    return pigeonMap;
  }

  static MbxEdgeInsets decode(Object message) {
    final Map<Object?, Object?> pigeonMap = message as Map<Object?, Object?>;
    return MbxEdgeInsets(
      top: pigeonMap['top']! as double,
      left: pigeonMap['left']! as double,
      bottom: pigeonMap['bottom']! as double,
      right: pigeonMap['right']! as double,
    );
  }
}

/// Various options for describing the viewpoint of a camera. All fields are
/// optional.
///
/// Anchor and center points are mutually exclusive, with preference for the
/// center point when both are set.
class CameraOptions {
  CameraOptions({
    this.center,
    this.padding,
    this.anchor,
    this.zoom,
    this.bearing,
    this.pitch,
  });

  /// Coordinate at the center of the camera.
  Map<String?, Object?>? center;

  /// Padding around the interior of the view that affects the frame of
  /// reference for `center`.
  MbxEdgeInsets? padding;

  /// Point of reference for `zoom` and `angle`, assuming an origin at the
  /// top-left corner of the view.
  ScreenCoordinate? anchor;

  /// Zero-based zoom level. Constrained to the minimum and maximum zoom
  /// levels.
  double? zoom;

  /// Bearing, measured in degrees from true north. Wrapped to [0, 360).
  double? bearing;

  /// Pitch toward the horizon measured in degrees.
  double? pitch;

  Object encode() {
    final Map<Object?, Object?> pigeonMap = <Object?, Object?>{};
    pigeonMap['center'] = center;
    pigeonMap['padding'] = padding?.encode();
    pigeonMap['anchor'] = anchor?.encode();
    pigeonMap['zoom'] = zoom;
    pigeonMap['bearing'] = bearing;
    pigeonMap['pitch'] = pitch;
    return pigeonMap;
  }

  static CameraOptions decode(Object message) {
    final Map<Object?, Object?> pigeonMap = message as Map<Object?, Object?>;
    return CameraOptions(
      center: (pigeonMap['center'] as Map<Object?, Object?>?)
          ?.cast<String?, Object?>(),
      padding: pigeonMap['padding'] != null
          ? MbxEdgeInsets.decode(pigeonMap['padding']!)
          : null,
      anchor: pigeonMap['anchor'] != null
          ? ScreenCoordinate.decode(pigeonMap['anchor']!)
          : null,
      zoom: pigeonMap['zoom'] as double?,
      bearing: pigeonMap['bearing'] as double?,
      pitch: pigeonMap['pitch'] as double?,
    );
  }
}

/// Describes the viewpoint of a camera.
class CameraState {
  CameraState({
    required this.center,
    required this.padding,
    required this.zoom,
    required this.bearing,
    required this.pitch,
  });

  /// Coordinate at the center of the camera.
  Map<String?, Object?> center;

  /// Padding around the interior of the view that affects the frame of
  /// reference for `center`.
  MbxEdgeInsets padding;

  /// Zero-based zoom level. Constrained to the minimum and maximum zoom
  /// levels.
  double zoom;

  /// Bearing, measured in degrees from true north. Wrapped to [0, 360).
  double bearing;

  /// Pitch toward the horizon measured in degrees.
  double pitch;

  Object encode() {
    final Map<Object?, Object?> pigeonMap = <Object?, Object?>{};
    pigeonMap['center'] = center;
    pigeonMap['padding'] = padding.encode();
    pigeonMap['zoom'] = zoom;
    pigeonMap['bearing'] = bearing;
    pigeonMap['pitch'] = pitch;
    return pigeonMap;
  }

  static CameraState decode(Object message) {
    final Map<Object?, Object?> pigeonMap = message as Map<Object?, Object?>;
    return CameraState(
      center: (pigeonMap['center'] as Map<Object?, Object?>?)!
          .cast<String?, Object?>(),
      padding: MbxEdgeInsets.decode(pigeonMap['padding']!),
      zoom: pigeonMap['zoom']! as double,
      bearing: pigeonMap['bearing']! as double,
      pitch: pigeonMap['pitch']! as double,
    );
  }
}

/// Holds options to be used for setting `camera bounds`.
class CameraBoundsOptions {
  CameraBoundsOptions({
    this.bounds,
    this.maxZoom,
    this.minZoom,
    this.maxPitch,
    this.minPitch,
  });

  /// The latitude and longitude bounds to which the camera center are constrained.
  CoordinateBounds? bounds;

  /// The maximum zoom level, in Mapbox zoom levels 0-25.5. At low zoom levels, a small set of map tiles covers a large geographical area. At higher zoom levels, a larger number of tiles cover a smaller geographical area.
  double? maxZoom;

  /// The minimum zoom level, in Mapbox zoom levels 0-25.5.
  double? minZoom;

  /// The maximum allowed pitch value in degrees.
  double? maxPitch;

  /// The minimum allowed pitch value in degrees.
  double? minPitch;

  Object encode() {
    final Map<Object?, Object?> pigeonMap = <Object?, Object?>{};
    pigeonMap['bounds'] = bounds?.encode();
    pigeonMap['maxZoom'] = maxZoom;
    pigeonMap['minZoom'] = minZoom;
    pigeonMap['maxPitch'] = maxPitch;
    pigeonMap['minPitch'] = minPitch;
    return pigeonMap;
  }

  static CameraBoundsOptions decode(Object message) {
    final Map<Object?, Object?> pigeonMap = message as Map<Object?, Object?>;
    return CameraBoundsOptions(
      bounds: pigeonMap['bounds'] != null
          ? CoordinateBounds.decode(pigeonMap['bounds']!)
          : null,
      maxZoom: pigeonMap['maxZoom'] as double?,
      minZoom: pigeonMap['minZoom'] as double?,
      maxPitch: pigeonMap['maxPitch'] as double?,
      minPitch: pigeonMap['minPitch'] as double?,
    );
  }
}

/// Holds information about `camera bounds`.
class CameraBounds {
  CameraBounds({
    required this.bounds,
    required this.maxZoom,
    required this.minZoom,
    required this.maxPitch,
    required this.minPitch,
  });

  /// The latitude and longitude bounds to which the camera center are constrained.
  CoordinateBounds bounds;

  /// The maximum zoom level, in Mapbox zoom levels 0-25.5. At low zoom levels, a small set of map tiles covers a large geographical area. At higher zoom levels, a larger number of tiles cover a smaller geographical area.
  double maxZoom;

  /// The minimum zoom level, in Mapbox zoom levels 0-25.5.
  double minZoom;

  /// The maximum allowed pitch value in degrees.
  double maxPitch;

  /// The minimum allowed pitch value in degrees.
  double minPitch;

  Object encode() {
    final Map<Object?, Object?> pigeonMap = <Object?, Object?>{};
    pigeonMap['bounds'] = bounds.encode();
    pigeonMap['maxZoom'] = maxZoom;
    pigeonMap['minZoom'] = minZoom;
    pigeonMap['maxPitch'] = maxPitch;
    pigeonMap['minPitch'] = minPitch;
    return pigeonMap;
  }

  static CameraBounds decode(Object message) {
    final Map<Object?, Object?> pigeonMap = message as Map<Object?, Object?>;
    return CameraBounds(
      bounds: CoordinateBounds.decode(pigeonMap['bounds']!),
      maxZoom: pigeonMap['maxZoom']! as double,
      minZoom: pigeonMap['minZoom']! as double,
      maxPitch: pigeonMap['maxPitch']! as double,
      minPitch: pigeonMap['minPitch']! as double,
    );
  }
}

class MapAnimationOptions {
  MapAnimationOptions({
    this.duration,
    this.startDelay,
  });

  /// The duration of the animation in milliseconds.
  /// If not set explicitly default duration will be taken 300ms
  int? duration;

  /// The amount of time, in milliseconds, to delay starting the animation after animation start.
  /// If not set explicitly default startDelay will be taken 0ms. This only works for Android.
  int? startDelay;

  Object encode() {
    final Map<Object?, Object?> pigeonMap = <Object?, Object?>{};
    pigeonMap['duration'] = duration;
    pigeonMap['startDelay'] = startDelay;
    return pigeonMap;
  }

  static MapAnimationOptions decode(Object message) {
    final Map<Object?, Object?> pigeonMap = message as Map<Object?, Object?>;
    return MapAnimationOptions(
      duration: pigeonMap['duration'] as int?,
      startDelay: pigeonMap['startDelay'] as int?,
    );
  }
}

/// A rectangular area as measured on a two-dimensional map projection.
class CoordinateBounds {
  CoordinateBounds({
    required this.southwest,
    required this.northeast,
    required this.infiniteBounds,
  });

  /// Coordinate at the southwest corner.
  /// Note: setting this field with invalid values (infinite, NaN) will crash the application.
  Map<String?, Object?> southwest;

  /// Coordinate at the northeast corner.
  /// Note: setting this field with invalid values (infinite, NaN) will crash the application.
  Map<String?, Object?> northeast;

  /// If set to `true`, an infinite (unconstrained) bounds covering the world coordinates would be used.
  /// Coordinates provided in `southwest` and `northeast` fields would be omitted and have no effect.
  bool infiniteBounds;

  Object encode() {
    final Map<Object?, Object?> pigeonMap = <Object?, Object?>{};
    pigeonMap['southwest'] = southwest;
    pigeonMap['northeast'] = northeast;
    pigeonMap['infiniteBounds'] = infiniteBounds;
    return pigeonMap;
  }

  static CoordinateBounds decode(Object message) {
    final Map<Object?, Object?> pigeonMap = message as Map<Object?, Object?>;
    return CoordinateBounds(
      southwest: (pigeonMap['southwest'] as Map<Object?, Object?>?)!
          .cast<String?, Object?>(),
      northeast: (pigeonMap['northeast'] as Map<Object?, Object?>?)!
          .cast<String?, Object?>(),
      infiniteBounds: pigeonMap['infiniteBounds']! as bool,
    );
  }
}

/// Options for enabling debugging features in a map.
class MapDebugOptions {
  MapDebugOptions({
    required this.data,
  });

  MapDebugOptionsData data;

  Object encode() {
    final Map<Object?, Object?> pigeonMap = <Object?, Object?>{};
    pigeonMap['data'] = data.index;
    return pigeonMap;
  }

  static MapDebugOptions decode(Object message) {
    final Map<Object?, Object?> pigeonMap = message as Map<Object?, Object?>;
    return MapDebugOptions(
      data: MapDebugOptionsData.values[pigeonMap['data']! as int],
    );
  }
}

/// Describes the glyphs rasterization option values.
class GlyphsRasterizationOptions {
  GlyphsRasterizationOptions({
    required this.rasterizationMode,
    this.fontFamily,
  });

  /// Glyphs rasterization mode for client-side text rendering.
  GlyphsRasterizationMode rasterizationMode;

  /// Font family to use as font fallback for client-side text renderings.
  ///
  /// Note: `GlyphsRasterizationMode` has precedence over font family. If `AllGlyphsRasterizedLocally`
  /// or `IdeographsRasterizedLocally` is set, local glyphs will be generated based on the provided font family. If no
  /// font family is provided, the map will fall back to use the system default font. The mechanisms of choosing the
  /// default font are varied in platforms:
  /// - For darwin(iOS/macOS) platform, the default font family is created from the <a href="https://developer.apple.com/documentation/uikit/uifont/1619027-systemfontofsize?language=objc">systemFont</a>.
  ///   If provided fonts are not supported on darwin platform, the map will fall back to use the first available font from the global fallback list.
  /// - For Android platform: the default font <a href="https://developer.android.com/reference/android/graphics/Typeface#DEFAULT">Typeface.DEFAULT</a> will be used.
  ///
  /// Besides, the font family will be discarded if it is provided along with `NoGlyphsRasterizedLocally` mode.
  ///
  String? fontFamily;

  Object encode() {
    final Map<Object?, Object?> pigeonMap = <Object?, Object?>{};
    pigeonMap['rasterizationMode'] = rasterizationMode.index;
    pigeonMap['fontFamily'] = fontFamily;
    return pigeonMap;
  }

  static GlyphsRasterizationOptions decode(Object message) {
    final Map<Object?, Object?> pigeonMap = message as Map<Object?, Object?>;
    return GlyphsRasterizationOptions(
      rasterizationMode: GlyphsRasterizationMode
          .values[pigeonMap['rasterizationMode']! as int],
      fontFamily: pigeonMap['fontFamily'] as String?,
    );
  }
}

/// Map memory budget in megabytes.
class MapMemoryBudgetInMegabytes {
  MapMemoryBudgetInMegabytes({
    required this.size,
  });

  int size;

  Object encode() {
    final Map<Object?, Object?> pigeonMap = <Object?, Object?>{};
    pigeonMap['size'] = size;
    return pigeonMap;
  }

  static MapMemoryBudgetInMegabytes decode(Object message) {
    final Map<Object?, Object?> pigeonMap = message as Map<Object?, Object?>;
    return MapMemoryBudgetInMegabytes(
      size: pigeonMap['size']! as int,
    );
  }
}

/// Map memory budget in tiles.
class MapMemoryBudgetInTiles {
  MapMemoryBudgetInTiles({
    required this.size,
  });

  int size;

  Object encode() {
    final Map<Object?, Object?> pigeonMap = <Object?, Object?>{};
    pigeonMap['size'] = size;
    return pigeonMap;
  }

  static MapMemoryBudgetInTiles decode(Object message) {
    final Map<Object?, Object?> pigeonMap = message as Map<Object?, Object?>;
    return MapMemoryBudgetInTiles(
      size: pigeonMap['size']! as int,
    );
  }
}

/// Describes the map option values.
class MapOptions {
  MapOptions({
    this.contextMode,
    this.constrainMode,
    this.viewportMode,
    this.orientation,
    this.crossSourceCollisions,
    this.optimizeForTerrain,
    this.size,
    required this.pixelRatio,
    this.glyphsRasterizationOptions,
  });

  /// The map context mode. This can be used to optimizations
  /// if we know that the drawing context is not shared with other code.
  ContextMode? contextMode;

  /// The map constrain mode. This can be used to limit the map
  /// to wrap around the globe horizontally. By default, it is set to
  /// `HeightOnly`.
  ConstrainMode? constrainMode;

  /// The viewport mode. This can be used to flip the vertical
  /// orientation of the map as some devices may use inverted orientation.
  ViewportMode? viewportMode;

  /// The orientation of the Map. By default, it is set to
  /// `Upwards`.
  NorthOrientation? orientation;

  /// Specify whether to enable cross-source symbol collision detection
  /// or not. By default, it is set to `true`.
  bool? crossSourceCollisions;

  /// With terrain on, if `true`, the map will render for performance
  /// priority, which may lead to layer reordering allowing to maximize
  /// performance (layers that are draped over terrain will be drawn first,
  /// including fill, line, background, hillshade and raster). Any layers that
  /// are positioned after symbols are draped last, over symbols. Otherwise, if
  /// set to `false`, the map will always be drawn for layer order priority.
  /// By default, it is set to `true`.
  bool? optimizeForTerrain;

  /// The size to resize the map object and renderer backend.
  /// The size is given in `platform pixel` units. macOS and iOS platforms use
  /// device-independent pixel units, while other platforms, such as Android,
  /// use screen pixel units.
  Size? size;

  /// The custom pixel ratio. By default, it is set to 1.0
  double pixelRatio;

  /// Glyphs rasterization options to use for client-side text rendering.
  GlyphsRasterizationOptions? glyphsRasterizationOptions;

  Object encode() {
    final Map<Object?, Object?> pigeonMap = <Object?, Object?>{};
    pigeonMap['contextMode'] = contextMode?.index;
    pigeonMap['constrainMode'] = constrainMode?.index;
    pigeonMap['viewportMode'] = viewportMode?.index;
    pigeonMap['orientation'] = orientation?.index;
    pigeonMap['crossSourceCollisions'] = crossSourceCollisions;
    pigeonMap['optimizeForTerrain'] = optimizeForTerrain;
    pigeonMap['size'] = size?.encode();
    pigeonMap['pixelRatio'] = pixelRatio;
    pigeonMap['glyphsRasterizationOptions'] =
        glyphsRasterizationOptions?.encode();
    return pigeonMap;
  }

  static MapOptions decode(Object message) {
    final Map<Object?, Object?> pigeonMap = message as Map<Object?, Object?>;
    return MapOptions(
      contextMode: pigeonMap['contextMode'] != null
          ? ContextMode.values[pigeonMap['contextMode']! as int]
          : null,
      constrainMode: pigeonMap['constrainMode'] != null
          ? ConstrainMode.values[pigeonMap['constrainMode']! as int]
          : null,
      viewportMode: pigeonMap['viewportMode'] != null
          ? ViewportMode.values[pigeonMap['viewportMode']! as int]
          : null,
      orientation: pigeonMap['orientation'] != null
          ? NorthOrientation.values[pigeonMap['orientation']! as int]
          : null,
      crossSourceCollisions: pigeonMap['crossSourceCollisions'] as bool?,
      optimizeForTerrain: pigeonMap['optimizeForTerrain'] as bool?,
      size: pigeonMap['size'] != null ? Size.decode(pigeonMap['size']!) : null,
      pixelRatio: pigeonMap['pixelRatio']! as double,
      glyphsRasterizationOptions:
          pigeonMap['glyphsRasterizationOptions'] != null
              ? GlyphsRasterizationOptions.decode(
                  pigeonMap['glyphsRasterizationOptions']!)
              : null,
    );
  }
}

/// Describes the coordinate on the screen, measured from top to bottom and from left to right.
/// Note: the `map` uses screen coordinate units measured in `platform pixels`.
class ScreenCoordinate {
  ScreenCoordinate({
    required this.x,
    required this.y,
  });

  /// A value representing the x position of this coordinate.
  double x;

  /// A value representing the y position of this coordinate.
  double y;

  Object encode() {
    final Map<Object?, Object?> pigeonMap = <Object?, Object?>{};
    pigeonMap['x'] = x;
    pigeonMap['y'] = y;
    return pigeonMap;
  }

  static ScreenCoordinate decode(Object message) {
    final Map<Object?, Object?> pigeonMap = message as Map<Object?, Object?>;
    return ScreenCoordinate(
      x: pigeonMap['x']! as double,
      y: pigeonMap['y']! as double,
    );
  }
}

/// Describes the coordinate box on the screen, measured in `platform pixels`
/// from top to bottom and from left to right.
class ScreenBox {
  ScreenBox({
    required this.min,
    required this.max,
  });

  /// The screen coordinate close to the top left corner of the screen.
  ScreenCoordinate min;

  /// The screen coordinate close to the bottom right corner of the screen.
  ScreenCoordinate max;

  Object encode() {
    final Map<Object?, Object?> pigeonMap = <Object?, Object?>{};
    pigeonMap['min'] = min.encode();
    pigeonMap['max'] = max.encode();
    return pigeonMap;
  }

  static ScreenBox decode(Object message) {
    final Map<Object?, Object?> pigeonMap = message as Map<Object?, Object?>;
    return ScreenBox(
      min: ScreenCoordinate.decode(pigeonMap['min']!),
      max: ScreenCoordinate.decode(pigeonMap['max']!),
    );
  }
}

/// A coordinate bounds and zoom.
class CoordinateBoundsZoom {
  CoordinateBoundsZoom({
    required this.bounds,
    required this.zoom,
  });

  /// The latitude and longitude bounds.
  CoordinateBounds bounds;

  /// Zoom.
  double zoom;

  Object encode() {
    final Map<Object?, Object?> pigeonMap = <Object?, Object?>{};
    pigeonMap['bounds'] = bounds.encode();
    pigeonMap['zoom'] = zoom;
    return pigeonMap;
  }

  static CoordinateBoundsZoom decode(Object message) {
    final Map<Object?, Object?> pigeonMap = message as Map<Object?, Object?>;
    return CoordinateBoundsZoom(
      bounds: CoordinateBounds.decode(pigeonMap['bounds']!),
      zoom: pigeonMap['zoom']! as double,
    );
  }
}

/// Size type.
class Size {
  Size({
    required this.width,
    required this.height,
  });

  /// Width of the size.
  double width;

  /// Height of the size.
  double height;

  Object encode() {
    final Map<Object?, Object?> pigeonMap = <Object?, Object?>{};
    pigeonMap['width'] = width;
    pigeonMap['height'] = height;
    return pigeonMap;
  }

  static Size decode(Object message) {
    final Map<Object?, Object?> pigeonMap = message as Map<Object?, Object?>;
    return Size(
      width: pigeonMap['width']! as double,
      height: pigeonMap['height']! as double,
    );
  }
}

/// Options for querying rendered features.
class RenderedQueryOptions {
  RenderedQueryOptions({
    this.layerIds,
    this.filter,
  });

  /// Layer IDs to include in the query.
  List<String?>? layerIds;

  /// Filters the returned features with an expression
  String? filter;

  Object encode() {
    final Map<Object?, Object?> pigeonMap = <Object?, Object?>{};
    pigeonMap['layerIds'] = layerIds;
    pigeonMap['filter'] = filter;
    return pigeonMap;
  }

  static RenderedQueryOptions decode(Object message) {
    final Map<Object?, Object?> pigeonMap = message as Map<Object?, Object?>;
    return RenderedQueryOptions(
      layerIds: (pigeonMap['layerIds'] as List<Object?>?)?.cast<String?>(),
      filter: pigeonMap['filter'] as String?,
    );
  }
}

/// Options for querying source features.
class SourceQueryOptions {
  SourceQueryOptions({
    this.sourceLayerIds,
    required this.filter,
  });

  /// Source layer IDs to include in the query.
  List<String?>? sourceLayerIds;

  /// Filters the returned features with an expression
  String filter;

  Object encode() {
    final Map<Object?, Object?> pigeonMap = <Object?, Object?>{};
    pigeonMap['sourceLayerIds'] = sourceLayerIds;
    pigeonMap['filter'] = filter;
    return pigeonMap;
  }

  static SourceQueryOptions decode(Object message) {
    final Map<Object?, Object?> pigeonMap = message as Map<Object?, Object?>;
    return SourceQueryOptions(
      sourceLayerIds:
          (pigeonMap['sourceLayerIds'] as List<Object?>?)?.cast<String?>(),
      filter: pigeonMap['filter']! as String,
    );
  }
}

/// A value or a collection of a feature extension.
class FeatureExtensionValue {
  FeatureExtensionValue({
    this.value,
    this.featureCollection,
  });

  /// An optional value of a feature extension
  String? value;

  /// An optional array of features from a feature extension.
  List<Map<String?, Object?>?>? featureCollection;

  Object encode() {
    final Map<Object?, Object?> pigeonMap = <Object?, Object?>{};
    pigeonMap['value'] = value;
    pigeonMap['featureCollection'] = featureCollection;
    return pigeonMap;
  }

  static FeatureExtensionValue decode(Object message) {
    final Map<Object?, Object?> pigeonMap = message as Map<Object?, Object?>;
    return FeatureExtensionValue(
      value: pigeonMap['value'] as String?,
      featureCollection: (pigeonMap['featureCollection'] as List<Object?>?)
          ?.cast<Map<String?, Object?>?>(),
    );
  }
}

/// Specifies position of a layer that is added via addStyleLayer method.
class LayerPosition {
  LayerPosition({
    this.above,
    this.below,
    this.at,
  });

  /// Layer should be positioned above specified layer id.
  String? above;

  /// Layer should be positioned below specified layer id.
  String? below;

  /// Layer should be positioned at specified index in a layers stack.
  int? at;

  Object encode() {
    final Map<Object?, Object?> pigeonMap = <Object?, Object?>{};
    pigeonMap['above'] = above;
    pigeonMap['below'] = below;
    pigeonMap['at'] = at;
    return pigeonMap;
  }

  static LayerPosition decode(Object message) {
    final Map<Object?, Object?> pigeonMap = message as Map<Object?, Object?>;
    return LayerPosition(
      above: pigeonMap['above'] as String?,
      below: pigeonMap['below'] as String?,
      at: pigeonMap['at'] as int?,
    );
  }
}

/// Represents query result that is returned in QueryFeaturesCallback.
/// @see `queryRenderedFeatures` or `querySourceFeatures`
class QueriedFeature {
  QueriedFeature({
    required this.feature,
    required this.source,
    this.sourceLayer,
    required this.state,
  });

  /// Feature returned by the query.
  Map<String?, Object?> feature;

  /// Source id for a queried feature.
  String source;

  /// Source layer id for a queried feature. May be null if source does not support layers, e.g., 'geojson' source,
  /// or when data provided by the source is not layered.
  String? sourceLayer;

  /// Feature state for a queried feature. Type of the value is an Object.
  /// @see `setFeatureState` and `getFeatureState`
  String state;

  Object encode() {
    final Map<Object?, Object?> pigeonMap = <Object?, Object?>{};
    pigeonMap['feature'] = feature;
    pigeonMap['source'] = source;
    pigeonMap['sourceLayer'] = sourceLayer;
    pigeonMap['state'] = state;
    return pigeonMap;
  }

  static QueriedFeature decode(Object message) {
    final Map<Object?, Object?> pigeonMap = message as Map<Object?, Object?>;
    return QueriedFeature(
      feature: (pigeonMap['feature'] as Map<Object?, Object?>?)!
          .cast<String?, Object?>(),
      source: pigeonMap['source']! as String,
      sourceLayer: pigeonMap['sourceLayer'] as String?,
      state: pigeonMap['state']! as String,
    );
  }
}

/// Geometry for querying rendered features. */
class RenderedQueryGeometry {
  RenderedQueryGeometry({
    required this.value,
    required this.type,
  });

  /// ScreenCoordinate/List<ScreenCoordinate>/ScreenBox in Json mode.
  String value;
  Type type;

  Object encode() {
    final Map<Object?, Object?> pigeonMap = <Object?, Object?>{};
    pigeonMap['value'] = value;
    pigeonMap['type'] = type.index;
    return pigeonMap;
  }

  static RenderedQueryGeometry decode(Object message) {
    final Map<Object?, Object?> pigeonMap = message as Map<Object?, Object?>;
    return RenderedQueryGeometry(
      value: pigeonMap['value']! as String,
      type: Type.values[pigeonMap['type']! as int],
    );
  }
}

/// An offline region definition is a geographic region defined by a style URL,
/// a geometry, zoom range, and device pixel ratio. Both `minZoom` and `maxZoom` must be ≥ 0,
/// and `maxZoom` must be ≥ `minZoom`. The `maxZoom` may be ∞, in which case for each tile source,
/// the region will include tiles from `minZoom` up to the maximum zoom level provided by that source.
/// The `pixelRatio` must be ≥ 0 and should typically be 1.0 or 2.0.
class OfflineRegionGeometryDefinition {
  OfflineRegionGeometryDefinition({
    required this.styleURL,
    required this.geometry,
    required this.minZoom,
    required this.maxZoom,
    required this.pixelRatio,
    required this.glyphsRasterizationMode,
  });

  /// The style associated with the offline region
  String styleURL;

  /// The geometry that defines the boundary of the offline region
  Map<String?, Object?> geometry;

  /// Minimum zoom level for the offline region
  double minZoom;

  /// Maximum zoom level for the offline region
  double maxZoom;

  /// Pixel ratio to be accounted for when downloading assets
  double pixelRatio;

  /// Specifies glyphs rasterization mode. It defines which glyphs will be loaded from the server
  GlyphsRasterizationMode glyphsRasterizationMode;

  Object encode() {
    final Map<Object?, Object?> pigeonMap = <Object?, Object?>{};
    pigeonMap['styleURL'] = styleURL;
    pigeonMap['geometry'] = geometry;
    pigeonMap['minZoom'] = minZoom;
    pigeonMap['maxZoom'] = maxZoom;
    pigeonMap['pixelRatio'] = pixelRatio;
    pigeonMap['glyphsRasterizationMode'] = glyphsRasterizationMode.index;
    return pigeonMap;
  }

  static OfflineRegionGeometryDefinition decode(Object message) {
    final Map<Object?, Object?> pigeonMap = message as Map<Object?, Object?>;
    return OfflineRegionGeometryDefinition(
      styleURL: pigeonMap['styleURL']! as String,
      geometry: (pigeonMap['geometry'] as Map<Object?, Object?>?)!
          .cast<String?, Object?>(),
      minZoom: pigeonMap['minZoom']! as double,
      maxZoom: pigeonMap['maxZoom']! as double,
      pixelRatio: pigeonMap['pixelRatio']! as double,
      glyphsRasterizationMode: GlyphsRasterizationMode
          .values[pigeonMap['glyphsRasterizationMode']! as int],
    );
  }
}

/// An offline region definition is a geographic region defined by a style URL,
/// geographic bounding box, zoom range, and device pixel ratio. Both `minZoom` and `maxZoom` must be ≥ 0,
/// and `maxZoom` must be ≥ `minZoom`. The `maxZoom` may be ∞, in which case for each tile source,
/// the region will include tiles from `minZoom` up to the maximum zoom level provided by that source.
/// The `pixelRatio` must be ≥ 0 and should typically be 1.0 or 2.0.
class OfflineRegionTilePyramidDefinition {
  OfflineRegionTilePyramidDefinition({
    required this.styleURL,
    required this.bounds,
    required this.minZoom,
    required this.maxZoom,
    required this.pixelRatio,
    required this.glyphsRasterizationMode,
  });

  /// The style associated with the offline region.
  String styleURL;

  /// The bounds covering the region.
  CoordinateBounds bounds;

  /// Minimum zoom level for the offline region.
  double minZoom;

  /// Maximum zoom level for the offline region.
  double maxZoom;

  /// Pixel ratio to be accounted for when downloading assets.
  double pixelRatio;

  /// Specifies glyphs download mode.
  GlyphsRasterizationMode glyphsRasterizationMode;

  Object encode() {
    final Map<Object?, Object?> pigeonMap = <Object?, Object?>{};
    pigeonMap['styleURL'] = styleURL;
    pigeonMap['bounds'] = bounds.encode();
    pigeonMap['minZoom'] = minZoom;
    pigeonMap['maxZoom'] = maxZoom;
    pigeonMap['pixelRatio'] = pixelRatio;
    pigeonMap['glyphsRasterizationMode'] = glyphsRasterizationMode.index;
    return pigeonMap;
  }

  static OfflineRegionTilePyramidDefinition decode(Object message) {
    final Map<Object?, Object?> pigeonMap = message as Map<Object?, Object?>;
    return OfflineRegionTilePyramidDefinition(
      styleURL: pigeonMap['styleURL']! as String,
      bounds: CoordinateBounds.decode(pigeonMap['bounds']!),
      minZoom: pigeonMap['minZoom']! as double,
      maxZoom: pigeonMap['maxZoom']! as double,
      pixelRatio: pigeonMap['pixelRatio']! as double,
      glyphsRasterizationMode: GlyphsRasterizationMode
          .values[pigeonMap['glyphsRasterizationMode']! as int],
    );
  }
}

/// ProjectedMeters is a coordinate in a specific
/// [Spherical Mercator](http://docs.openlayers.org/library/spherical_mercator.html) projection.
///
/// This specific Spherical Mercator projection assumes the Earth is a sphere with a radius
/// of 6,378,137 meters. Coordinates are determined as distances, in meters, on the surface
/// of that sphere.
class ProjectedMeters {
  ProjectedMeters({
    required this.northing,
    required this.easting,
  });

  /// Projected meters in north direction.
  double northing;

  /// Projected meters in east direction.
  double easting;

  Object encode() {
    final Map<Object?, Object?> pigeonMap = <Object?, Object?>{};
    pigeonMap['northing'] = northing;
    pigeonMap['easting'] = easting;
    return pigeonMap;
  }

  static ProjectedMeters decode(Object message) {
    final Map<Object?, Object?> pigeonMap = message as Map<Object?, Object?>;
    return ProjectedMeters(
      northing: pigeonMap['northing']! as double,
      easting: pigeonMap['easting']! as double,
    );
  }
}

/// Describes a point on the map in Mercator projection.
class MercatorCoordinate {
  MercatorCoordinate({
    required this.x,
    required this.y,
  });

  /// A value representing the x position of this coordinate.
  double x;

  /// A value representing the y position of this coordinate.
  double y;

  Object encode() {
    final Map<Object?, Object?> pigeonMap = <Object?, Object?>{};
    pigeonMap['x'] = x;
    pigeonMap['y'] = y;
    return pigeonMap;
  }

  static MercatorCoordinate decode(Object message) {
    final Map<Object?, Object?> pigeonMap = message as Map<Object?, Object?>;
    return MercatorCoordinate(
      x: pigeonMap['x']! as double,
      y: pigeonMap['y']! as double,
    );
  }
}

/// Options to configure a resource
class ResourceOptions {
  ResourceOptions({
    required this.accessToken,
    this.baseURL,
    this.dataPath,
    this.assetPath,
    this.tileStoreUsageMode,
  });

  /// The access token that is used to access resources provided by Mapbox services.
  String accessToken;

  /// The base URL that would be used to make HTTP requests. By default it is `https://api.mapbox.com`.
  String? baseURL;

  /// The path to the map data folder.
  ///
  /// The implementation will use this folder for storing offline style packages and temporary data.
  ///
  /// The application must have sufficient permissions to create files within the provided directory.
  /// If a dataPath is not provided, the default location will be used (the application data path defined
  /// in the `Mapbox Common SystemInformation API`).
  String? dataPath;

  /// The path to the folder where application assets are located. Resources whose protocol is `asset://`
  /// will be fetched from an asset folder or asset management system provided by respective platform.
  /// This option is ignored for Android platform. An iOS application may provide path to an application bundle's path.
  String? assetPath;

  /// The tile store usage mode.
  TileStoreUsageMode? tileStoreUsageMode;

  Object encode() {
    final Map<Object?, Object?> pigeonMap = <Object?, Object?>{};
    pigeonMap['accessToken'] = accessToken;
    pigeonMap['baseURL'] = baseURL;
    pigeonMap['dataPath'] = dataPath;
    pigeonMap['assetPath'] = assetPath;
    pigeonMap['tileStoreUsageMode'] = tileStoreUsageMode?.index;
    return pigeonMap;
  }

  static ResourceOptions decode(Object message) {
    final Map<Object?, Object?> pigeonMap = message as Map<Object?, Object?>;
    return ResourceOptions(
      accessToken: pigeonMap['accessToken']! as String,
      baseURL: pigeonMap['baseURL'] as String?,
      dataPath: pigeonMap['dataPath'] as String?,
      assetPath: pigeonMap['assetPath'] as String?,
      tileStoreUsageMode: pigeonMap['tileStoreUsageMode'] != null
          ? TileStoreUsageMode.values[pigeonMap['tileStoreUsageMode']! as int]
          : null,
    );
  }
}

/// The information about style object (source or layer).
class StyleObjectInfo {
  StyleObjectInfo({
    required this.id,
    required this.type,
  });

  /// The object's identifier.
  String id;

  /// The object's type.
  String type;

  Object encode() {
    final Map<Object?, Object?> pigeonMap = <Object?, Object?>{};
    pigeonMap['id'] = id;
    pigeonMap['type'] = type;
    return pigeonMap;
  }

  static StyleObjectInfo decode(Object message) {
    final Map<Object?, Object?> pigeonMap = message as Map<Object?, Object?>;
    return StyleObjectInfo(
      id: pigeonMap['id']! as String,
      type: pigeonMap['type']! as String,
    );
  }
}

/// Image type.
class MbxImage {
  MbxImage({
    required this.width,
    required this.height,
    required this.data,
  });

  /// The width of the image, in screen pixels.
  int width;

  /// The height of the image, in screen pixels.
  int height;

  /// 32-bit premultiplied RGBA image data.
  ///
  /// An uncompressed image data encoded in 32-bit RGBA format with premultiplied
  /// alpha channel. This field should contain exactly `4 * width * height` bytes. It
  /// should consist of a sequence of scanlines.
  Uint8List data;

  Object encode() {
    final Map<Object?, Object?> pigeonMap = <Object?, Object?>{};
    pigeonMap['width'] = width;
    pigeonMap['height'] = height;
    pigeonMap['data'] = data;
    return pigeonMap;
  }

  static MbxImage decode(Object message) {
    final Map<Object?, Object?> pigeonMap = message as Map<Object?, Object?>;
    return MbxImage(
      width: pigeonMap['width']! as int,
      height: pigeonMap['height']! as int,
      data: pigeonMap['data']! as Uint8List,
    );
  }
}

/// Describes the image stretch areas.
class ImageStretches {
  ImageStretches({
    required this.first,
    required this.second,
  });

  /// The first stretchable part in screen pixel units.
  double first;

  /// The second stretchable part in screen pixel units.
  double second;

  Object encode() {
    final Map<Object?, Object?> pigeonMap = <Object?, Object?>{};
    pigeonMap['first'] = first;
    pigeonMap['second'] = second;
    return pigeonMap;
  }

  static ImageStretches decode(Object message) {
    final Map<Object?, Object?> pigeonMap = message as Map<Object?, Object?>;
    return ImageStretches(
      first: pigeonMap['first']! as double,
      second: pigeonMap['second']! as double,
    );
  }
}

/// Describes the image content, e.g. where text can be fit into an image.
///
/// When sizing icons with `icon-text-fit`, the icon size will be adjusted so that the this content box fits exactly around the text.
class ImageContent {
  ImageContent({
    required this.left,
    required this.top,
    required this.right,
    required this.bottom,
  });

  /// Distance to the left, in screen pixels.
  double left;

  /// Distance to the top, in screen pixels.
  double top;

  /// Distance to the right, in screen pixels.
  double right;

  /// Distance to the bottom, in screen pixels.
  double bottom;

  Object encode() {
    final Map<Object?, Object?> pigeonMap = <Object?, Object?>{};
    pigeonMap['left'] = left;
    pigeonMap['top'] = top;
    pigeonMap['right'] = right;
    pigeonMap['bottom'] = bottom;
    return pigeonMap;
  }

  static ImageContent decode(Object message) {
    final Map<Object?, Object?> pigeonMap = message as Map<Object?, Object?>;
    return ImageContent(
      left: pigeonMap['left']! as double,
      top: pigeonMap['top']! as double,
      right: pigeonMap['right']! as double,
      bottom: pigeonMap['bottom']! as double,
    );
  }
}

/// The `transition options` controls timing for the interpolation between a transitionable style
/// property's previous value and new value. These can be used to define the style default property
/// transition behavior. Also, any transitionable style property may also have its own `-transition`
/// property that defines specific transition timing for that specific layer property, overriding
/// the global transition values.
class TransitionOptions {
  TransitionOptions({
    this.duration,
    this.delay,
    this.enablePlacementTransitions,
  });

  /// Time allotted for transitions to complete. Units in milliseconds. Defaults to `300.0`.
  int? duration;

  /// Length of time before a transition begins. Units in milliseconds. Defaults to `0.0`.
  int? delay;

  /// Whether the fade in/out symbol placement transition is enabled. Defaults to `true`.
  bool? enablePlacementTransitions;

  Object encode() {
    final Map<Object?, Object?> pigeonMap = <Object?, Object?>{};
    pigeonMap['duration'] = duration;
    pigeonMap['delay'] = delay;
    pigeonMap['enablePlacementTransitions'] = enablePlacementTransitions;
    return pigeonMap;
  }

  static TransitionOptions decode(Object message) {
    final Map<Object?, Object?> pigeonMap = message as Map<Object?, Object?>;
    return TransitionOptions(
      duration: pigeonMap['duration'] as int?,
      delay: pigeonMap['delay'] as int?,
      enablePlacementTransitions:
          pigeonMap['enablePlacementTransitions'] as bool?,
    );
  }
}

/// Represents a tile coordinate.
class CanonicalTileID {
  CanonicalTileID({
    required this.z,
    required this.x,
    required this.y,
  });

  /// The z value of the coordinate (zoom-level).
  int z;

  /// The x value of the coordinate.
  int x;

  /// The y value of the coordinate.
  int y;

  Object encode() {
    final Map<Object?, Object?> pigeonMap = <Object?, Object?>{};
    pigeonMap['z'] = z;
    pigeonMap['x'] = x;
    pigeonMap['y'] = y;
    return pigeonMap;
  }

  static CanonicalTileID decode(Object message) {
    final Map<Object?, Object?> pigeonMap = message as Map<Object?, Object?>;
    return CanonicalTileID(
      z: pigeonMap['z']! as int,
      x: pigeonMap['x']! as int,
      y: pigeonMap['y']! as int,
    );
  }
}

/// Holds a style property value with meta data.
class StylePropertyValue {
  StylePropertyValue({
    required this.value,
    required this.kind,
  });

  /// The property value.
  String value;

  /// The kind of the property value.
  StylePropertyValueKind kind;

  Object encode() {
    final Map<Object?, Object?> pigeonMap = <Object?, Object?>{};
    pigeonMap['value'] = value;
    pigeonMap['kind'] = kind.index;
    return pigeonMap;
  }

  static StylePropertyValue decode(Object message) {
    final Map<Object?, Object?> pigeonMap = message as Map<Object?, Object?>;
    return StylePropertyValue(
      value: pigeonMap['value']! as String,
      kind: StylePropertyValueKind.values[pigeonMap['kind']! as int],
    );
  }
}

class __AnimationManagerCodec extends StandardMessageCodec {
  const __AnimationManagerCodec();
  @override
  void writeValue(WriteBuffer buffer, Object? value) {
    if (value is CameraOptions) {
      buffer.putUint8(128);
      writeValue(buffer, value.encode());
    } else if (value is MapAnimationOptions) {
      buffer.putUint8(129);
      writeValue(buffer, value.encode());
    } else if (value is MbxEdgeInsets) {
      buffer.putUint8(130);
      writeValue(buffer, value.encode());
    } else if (value is ScreenCoordinate) {
      buffer.putUint8(131);
      writeValue(buffer, value.encode());
    } else if (value is ScreenCoordinate) {
      buffer.putUint8(132);
      writeValue(buffer, value.encode());
    } else {
      super.writeValue(buffer, value);
    }
  }

  @override
  Object? readValueOfType(int type, ReadBuffer buffer) {
    switch (type) {
      case 128:
        return CameraOptions.decode(readValue(buffer)!);

      case 129:
        return MapAnimationOptions.decode(readValue(buffer)!);

      case 130:
        return MbxEdgeInsets.decode(readValue(buffer)!);

      case 131:
        return ScreenCoordinate.decode(readValue(buffer)!);

      case 132:
        return ScreenCoordinate.decode(readValue(buffer)!);

      default:
        return super.readValueOfType(type, buffer);
    }
  }
}

class _AnimationManager {
  /// Constructor for [_AnimationManager].  The [binaryMessenger] named argument is
  /// available for dependency injection.  If it is left null, the default
  /// BinaryMessenger will be used which routes to the host platform.
  _AnimationManager({BinaryMessenger? binaryMessenger})
      : _binaryMessenger = binaryMessenger;

  final BinaryMessenger? _binaryMessenger;

  static const MessageCodec<Object?> codec = __AnimationManagerCodec();

  Future<void> easeTo(CameraOptions arg_cameraOptions,
      MapAnimationOptions? arg_mapAnimationOptions) async {
    final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
        'dev.flutter.pigeon._AnimationManager.easeTo', codec,
        binaryMessenger: _binaryMessenger);
    final Map<Object?, Object?>? replyMap = await channel
            .send(<Object?>[arg_cameraOptions, arg_mapAnimationOptions])
        as Map<Object?, Object?>?;
    if (replyMap == null) {
      throw PlatformException(
        code: 'channel-error',
        message: 'Unable to establish connection on channel.',
      );
    } else if (replyMap['error'] != null) {
      final Map<Object?, Object?> error =
          (replyMap['error'] as Map<Object?, Object?>?)!;
      throw PlatformException(
        code: (error['code'] as String?)!,
        message: error['message'] as String?,
        details: error['details'],
      );
    } else {
      return;
    }
  }

  Future<void> flyTo(CameraOptions arg_cameraOptions,
      MapAnimationOptions? arg_mapAnimationOptions) async {
    final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
        'dev.flutter.pigeon._AnimationManager.flyTo', codec,
        binaryMessenger: _binaryMessenger);
    final Map<Object?, Object?>? replyMap = await channel
            .send(<Object?>[arg_cameraOptions, arg_mapAnimationOptions])
        as Map<Object?, Object?>?;
    if (replyMap == null) {
      throw PlatformException(
        code: 'channel-error',
        message: 'Unable to establish connection on channel.',
      );
    } else if (replyMap['error'] != null) {
      final Map<Object?, Object?> error =
          (replyMap['error'] as Map<Object?, Object?>?)!;
      throw PlatformException(
        code: (error['code'] as String?)!,
        message: error['message'] as String?,
        details: error['details'],
      );
    } else {
      return;
    }
  }

  Future<void> pitchBy(
      double arg_pitch, MapAnimationOptions? arg_mapAnimationOptions) async {
    final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
        'dev.flutter.pigeon._AnimationManager.pitchBy', codec,
        binaryMessenger: _binaryMessenger);
    final Map<Object?, Object?>? replyMap =
        await channel.send(<Object?>[arg_pitch, arg_mapAnimationOptions])
            as Map<Object?, Object?>?;
    if (replyMap == null) {
      throw PlatformException(
        code: 'channel-error',
        message: 'Unable to establish connection on channel.',
      );
    } else if (replyMap['error'] != null) {
      final Map<Object?, Object?> error =
          (replyMap['error'] as Map<Object?, Object?>?)!;
      throw PlatformException(
        code: (error['code'] as String?)!,
        message: error['message'] as String?,
        details: error['details'],
      );
    } else {
      return;
    }
  }

  Future<void> scaleBy(
      double arg_amount,
      ScreenCoordinate? arg_screenCoordinate,
      MapAnimationOptions? arg_mapAnimationOptions) async {
    final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
        'dev.flutter.pigeon._AnimationManager.scaleBy', codec,
        binaryMessenger: _binaryMessenger);
    final Map<Object?, Object?>? replyMap = await channel.send(<Object?>[
      arg_amount,
      arg_screenCoordinate,
      arg_mapAnimationOptions
    ]) as Map<Object?, Object?>?;
    if (replyMap == null) {
      throw PlatformException(
        code: 'channel-error',
        message: 'Unable to establish connection on channel.',
      );
    } else if (replyMap['error'] != null) {
      final Map<Object?, Object?> error =
          (replyMap['error'] as Map<Object?, Object?>?)!;
      throw PlatformException(
        code: (error['code'] as String?)!,
        message: error['message'] as String?,
        details: error['details'],
      );
    } else {
      return;
    }
  }

  Future<void> moveBy(ScreenCoordinate arg_screenCoordinate,
      MapAnimationOptions? arg_mapAnimationOptions) async {
    final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
        'dev.flutter.pigeon._AnimationManager.moveBy', codec,
        binaryMessenger: _binaryMessenger);
    final Map<Object?, Object?>? replyMap = await channel
            .send(<Object?>[arg_screenCoordinate, arg_mapAnimationOptions])
        as Map<Object?, Object?>?;
    if (replyMap == null) {
      throw PlatformException(
        code: 'channel-error',
        message: 'Unable to establish connection on channel.',
      );
    } else if (replyMap['error'] != null) {
      final Map<Object?, Object?> error =
          (replyMap['error'] as Map<Object?, Object?>?)!;
      throw PlatformException(
        code: (error['code'] as String?)!,
        message: error['message'] as String?,
        details: error['details'],
      );
    } else {
      return;
    }
  }

  Future<void> rotateBy(ScreenCoordinate arg_first, ScreenCoordinate arg_second,
      MapAnimationOptions? arg_mapAnimationOptions) async {
    final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
        'dev.flutter.pigeon._AnimationManager.rotateBy', codec,
        binaryMessenger: _binaryMessenger);
    final Map<Object?, Object?>? replyMap = await channel
            .send(<Object?>[arg_first, arg_second, arg_mapAnimationOptions])
        as Map<Object?, Object?>?;
    if (replyMap == null) {
      throw PlatformException(
        code: 'channel-error',
        message: 'Unable to establish connection on channel.',
      );
    } else if (replyMap['error'] != null) {
      final Map<Object?, Object?> error =
          (replyMap['error'] as Map<Object?, Object?>?)!;
      throw PlatformException(
        code: (error['code'] as String?)!,
        message: error['message'] as String?,
        details: error['details'],
      );
    } else {
      return;
    }
  }

  Future<void> cancelCameraAnimation() async {
    final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
        'dev.flutter.pigeon._AnimationManager.cancelCameraAnimation', codec,
        binaryMessenger: _binaryMessenger);
    final Map<Object?, Object?>? replyMap =
        await channel.send(null) as Map<Object?, Object?>?;
    if (replyMap == null) {
      throw PlatformException(
        code: 'channel-error',
        message: 'Unable to establish connection on channel.',
      );
    } else if (replyMap['error'] != null) {
      final Map<Object?, Object?> error =
          (replyMap['error'] as Map<Object?, Object?>?)!;
      throw PlatformException(
        code: (error['code'] as String?)!,
        message: error['message'] as String?,
        details: error['details'],
      );
    } else {
      return;
    }
  }
}

class __CameraManagerCodec extends StandardMessageCodec {
  const __CameraManagerCodec();
  @override
  void writeValue(WriteBuffer buffer, Object? value) {
    if (value is CameraBounds) {
      buffer.putUint8(128);
      writeValue(buffer, value.encode());
    } else if (value is CameraBoundsOptions) {
      buffer.putUint8(129);
      writeValue(buffer, value.encode());
    } else if (value is CameraOptions) {
      buffer.putUint8(130);
      writeValue(buffer, value.encode());
    } else if (value is CameraState) {
      buffer.putUint8(131);
      writeValue(buffer, value.encode());
    } else if (value is CanonicalTileID) {
      buffer.putUint8(132);
      writeValue(buffer, value.encode());
    } else if (value is CoordinateBounds) {
      buffer.putUint8(133);
      writeValue(buffer, value.encode());
    } else if (value is CoordinateBoundsZoom) {
      buffer.putUint8(134);
      writeValue(buffer, value.encode());
    } else if (value is FeatureExtensionValue) {
      buffer.putUint8(135);
      writeValue(buffer, value.encode());
    } else if (value is GlyphsRasterizationOptions) {
      buffer.putUint8(136);
      writeValue(buffer, value.encode());
    } else if (value is ImageContent) {
      buffer.putUint8(137);
      writeValue(buffer, value.encode());
    } else if (value is ImageStretches) {
      buffer.putUint8(138);
      writeValue(buffer, value.encode());
    } else if (value is LayerPosition) {
      buffer.putUint8(139);
      writeValue(buffer, value.encode());
    } else if (value is MapAnimationOptions) {
      buffer.putUint8(140);
      writeValue(buffer, value.encode());
    } else if (value is MapDebugOptions) {
      buffer.putUint8(141);
      writeValue(buffer, value.encode());
    } else if (value is MapMemoryBudgetInMegabytes) {
      buffer.putUint8(142);
      writeValue(buffer, value.encode());
    } else if (value is MapMemoryBudgetInTiles) {
      buffer.putUint8(143);
      writeValue(buffer, value.encode());
    } else if (value is MapOptions) {
      buffer.putUint8(144);
      writeValue(buffer, value.encode());
    } else if (value is MbxEdgeInsets) {
      buffer.putUint8(145);
      writeValue(buffer, value.encode());
    } else if (value is MbxImage) {
      buffer.putUint8(146);
      writeValue(buffer, value.encode());
    } else if (value is MercatorCoordinate) {
      buffer.putUint8(147);
      writeValue(buffer, value.encode());
    } else if (value is OfflineRegionGeometryDefinition) {
      buffer.putUint8(148);
      writeValue(buffer, value.encode());
    } else if (value is OfflineRegionTilePyramidDefinition) {
      buffer.putUint8(149);
      writeValue(buffer, value.encode());
    } else if (value is ProjectedMeters) {
      buffer.putUint8(150);
      writeValue(buffer, value.encode());
    } else if (value is QueriedFeature) {
      buffer.putUint8(151);
      writeValue(buffer, value.encode());
    } else if (value is RenderedQueryGeometry) {
      buffer.putUint8(152);
      writeValue(buffer, value.encode());
    } else if (value is RenderedQueryOptions) {
      buffer.putUint8(153);
      writeValue(buffer, value.encode());
    } else if (value is ResourceOptions) {
      buffer.putUint8(154);
      writeValue(buffer, value.encode());
    } else if (value is ScreenBox) {
      buffer.putUint8(155);
      writeValue(buffer, value.encode());
    } else if (value is ScreenCoordinate) {
      buffer.putUint8(156);
      writeValue(buffer, value.encode());
    } else if (value is Size) {
      buffer.putUint8(157);
      writeValue(buffer, value.encode());
    } else if (value is SourceQueryOptions) {
      buffer.putUint8(158);
      writeValue(buffer, value.encode());
    } else if (value is StyleObjectInfo) {
      buffer.putUint8(159);
      writeValue(buffer, value.encode());
    } else if (value is StylePropertyValue) {
      buffer.putUint8(160);
      writeValue(buffer, value.encode());
    } else if (value is TransitionOptions) {
      buffer.putUint8(161);
      writeValue(buffer, value.encode());
    } else {
      super.writeValue(buffer, value);
    }
  }

  @override
  Object? readValueOfType(int type, ReadBuffer buffer) {
    switch (type) {
      case 128:
        return CameraBounds.decode(readValue(buffer)!);

      case 129:
        return CameraBoundsOptions.decode(readValue(buffer)!);

      case 130:
        return CameraOptions.decode(readValue(buffer)!);

      case 131:
        return CameraState.decode(readValue(buffer)!);

      case 132:
        return CanonicalTileID.decode(readValue(buffer)!);

      case 133:
        return CoordinateBounds.decode(readValue(buffer)!);

      case 134:
        return CoordinateBoundsZoom.decode(readValue(buffer)!);

      case 135:
        return FeatureExtensionValue.decode(readValue(buffer)!);

      case 136:
        return GlyphsRasterizationOptions.decode(readValue(buffer)!);

      case 137:
        return ImageContent.decode(readValue(buffer)!);

      case 138:
        return ImageStretches.decode(readValue(buffer)!);

      case 139:
        return LayerPosition.decode(readValue(buffer)!);

      case 140:
        return MapAnimationOptions.decode(readValue(buffer)!);

      case 141:
        return MapDebugOptions.decode(readValue(buffer)!);

      case 142:
        return MapMemoryBudgetInMegabytes.decode(readValue(buffer)!);

      case 143:
        return MapMemoryBudgetInTiles.decode(readValue(buffer)!);

      case 144:
        return MapOptions.decode(readValue(buffer)!);

      case 145:
        return MbxEdgeInsets.decode(readValue(buffer)!);

      case 146:
        return MbxImage.decode(readValue(buffer)!);

      case 147:
        return MercatorCoordinate.decode(readValue(buffer)!);

      case 148:
        return OfflineRegionGeometryDefinition.decode(readValue(buffer)!);

      case 149:
        return OfflineRegionTilePyramidDefinition.decode(readValue(buffer)!);

      case 150:
        return ProjectedMeters.decode(readValue(buffer)!);

      case 151:
        return QueriedFeature.decode(readValue(buffer)!);

      case 152:
        return RenderedQueryGeometry.decode(readValue(buffer)!);

      case 153:
        return RenderedQueryOptions.decode(readValue(buffer)!);

      case 154:
        return ResourceOptions.decode(readValue(buffer)!);

      case 155:
        return ScreenBox.decode(readValue(buffer)!);

      case 156:
        return ScreenCoordinate.decode(readValue(buffer)!);

      case 157:
        return Size.decode(readValue(buffer)!);

      case 158:
        return SourceQueryOptions.decode(readValue(buffer)!);

      case 159:
        return StyleObjectInfo.decode(readValue(buffer)!);

      case 160:
        return StylePropertyValue.decode(readValue(buffer)!);

      case 161:
        return TransitionOptions.decode(readValue(buffer)!);

      default:
        return super.readValueOfType(type, buffer);
    }
  }
}

class _CameraManager {
  /// Constructor for [_CameraManager].  The [binaryMessenger] named argument is
  /// available for dependency injection.  If it is left null, the default
  /// BinaryMessenger will be used which routes to the host platform.
  _CameraManager({BinaryMessenger? binaryMessenger})
      : _binaryMessenger = binaryMessenger;

  final BinaryMessenger? _binaryMessenger;

  static const MessageCodec<Object?> codec = __CameraManagerCodec();

  Future<CameraOptions> cameraForCoordinateBounds(CoordinateBounds arg_bounds,
      MbxEdgeInsets arg_padding, double? arg_bearing, double? arg_pitch) async {
    final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
        'dev.flutter.pigeon._CameraManager.cameraForCoordinateBounds', codec,
        binaryMessenger: _binaryMessenger);
    final Map<Object?, Object?>? replyMap = await channel
            .send(<Object?>[arg_bounds, arg_padding, arg_bearing, arg_pitch])
        as Map<Object?, Object?>?;
    if (replyMap == null) {
      throw PlatformException(
        code: 'channel-error',
        message: 'Unable to establish connection on channel.',
      );
    } else if (replyMap['error'] != null) {
      final Map<Object?, Object?> error =
          (replyMap['error'] as Map<Object?, Object?>?)!;
      throw PlatformException(
        code: (error['code'] as String?)!,
        message: error['message'] as String?,
        details: error['details'],
      );
    } else if (replyMap['result'] == null) {
      throw PlatformException(
        code: 'null-error',
        message: 'Host platform returned null value for non-null return value.',
      );
    } else {
      return (replyMap['result'] as CameraOptions?)!;
    }
  }

  Future<CameraOptions> cameraForCoordinates(
      List<Map<String?, Object?>?> arg_coordinates,
      MbxEdgeInsets arg_padding,
      double? arg_bearing,
      double? arg_pitch) async {
    final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
        'dev.flutter.pigeon._CameraManager.cameraForCoordinates', codec,
        binaryMessenger: _binaryMessenger);
    final Map<Object?, Object?>? replyMap = await channel.send(
            <Object?>[arg_coordinates, arg_padding, arg_bearing, arg_pitch])
        as Map<Object?, Object?>?;
    if (replyMap == null) {
      throw PlatformException(
        code: 'channel-error',
        message: 'Unable to establish connection on channel.',
      );
    } else if (replyMap['error'] != null) {
      final Map<Object?, Object?> error =
          (replyMap['error'] as Map<Object?, Object?>?)!;
      throw PlatformException(
        code: (error['code'] as String?)!,
        message: error['message'] as String?,
        details: error['details'],
      );
    } else if (replyMap['result'] == null) {
      throw PlatformException(
        code: 'null-error',
        message: 'Host platform returned null value for non-null return value.',
      );
    } else {
      return (replyMap['result'] as CameraOptions?)!;
    }
  }

  Future<CameraOptions> cameraForCoordinatesCameraOptions(
      List<Map<String?, Object?>?> arg_coordinates,
      CameraOptions arg_camera,
      ScreenBox arg_box) async {
    final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
        'dev.flutter.pigeon._CameraManager.cameraForCoordinatesCameraOptions',
        codec,
        binaryMessenger: _binaryMessenger);
    final Map<Object?, Object?>? replyMap =
        await channel.send(<Object?>[arg_coordinates, arg_camera, arg_box])
            as Map<Object?, Object?>?;
    if (replyMap == null) {
      throw PlatformException(
        code: 'channel-error',
        message: 'Unable to establish connection on channel.',
      );
    } else if (replyMap['error'] != null) {
      final Map<Object?, Object?> error =
          (replyMap['error'] as Map<Object?, Object?>?)!;
      throw PlatformException(
        code: (error['code'] as String?)!,
        message: error['message'] as String?,
        details: error['details'],
      );
    } else if (replyMap['result'] == null) {
      throw PlatformException(
        code: 'null-error',
        message: 'Host platform returned null value for non-null return value.',
      );
    } else {
      return (replyMap['result'] as CameraOptions?)!;
    }
  }

  Future<CameraOptions> cameraForGeometry(Map<String?, Object?> arg_geometry,
      MbxEdgeInsets arg_padding, double? arg_bearing, double? arg_pitch) async {
    final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
        'dev.flutter.pigeon._CameraManager.cameraForGeometry', codec,
        binaryMessenger: _binaryMessenger);
    final Map<Object?, Object?>? replyMap = await channel
            .send(<Object?>[arg_geometry, arg_padding, arg_bearing, arg_pitch])
        as Map<Object?, Object?>?;
    if (replyMap == null) {
      throw PlatformException(
        code: 'channel-error',
        message: 'Unable to establish connection on channel.',
      );
    } else if (replyMap['error'] != null) {
      final Map<Object?, Object?> error =
          (replyMap['error'] as Map<Object?, Object?>?)!;
      throw PlatformException(
        code: (error['code'] as String?)!,
        message: error['message'] as String?,
        details: error['details'],
      );
    } else if (replyMap['result'] == null) {
      throw PlatformException(
        code: 'null-error',
        message: 'Host platform returned null value for non-null return value.',
      );
    } else {
      return (replyMap['result'] as CameraOptions?)!;
    }
  }

  Future<CoordinateBounds> coordinateBoundsForCamera(
      CameraOptions arg_camera) async {
    final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
        'dev.flutter.pigeon._CameraManager.coordinateBoundsForCamera', codec,
        binaryMessenger: _binaryMessenger);
    final Map<Object?, Object?>? replyMap =
        await channel.send(<Object?>[arg_camera]) as Map<Object?, Object?>?;
    if (replyMap == null) {
      throw PlatformException(
        code: 'channel-error',
        message: 'Unable to establish connection on channel.',
      );
    } else if (replyMap['error'] != null) {
      final Map<Object?, Object?> error =
          (replyMap['error'] as Map<Object?, Object?>?)!;
      throw PlatformException(
        code: (error['code'] as String?)!,
        message: error['message'] as String?,
        details: error['details'],
      );
    } else if (replyMap['result'] == null) {
      throw PlatformException(
        code: 'null-error',
        message: 'Host platform returned null value for non-null return value.',
      );
    } else {
      return (replyMap['result'] as CoordinateBounds?)!;
    }
  }

  Future<CoordinateBounds> coordinateBoundsForCameraUnwrapped(
      CameraOptions arg_camera) async {
    final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
        'dev.flutter.pigeon._CameraManager.coordinateBoundsForCameraUnwrapped',
        codec,
        binaryMessenger: _binaryMessenger);
    final Map<Object?, Object?>? replyMap =
        await channel.send(<Object?>[arg_camera]) as Map<Object?, Object?>?;
    if (replyMap == null) {
      throw PlatformException(
        code: 'channel-error',
        message: 'Unable to establish connection on channel.',
      );
    } else if (replyMap['error'] != null) {
      final Map<Object?, Object?> error =
          (replyMap['error'] as Map<Object?, Object?>?)!;
      throw PlatformException(
        code: (error['code'] as String?)!,
        message: error['message'] as String?,
        details: error['details'],
      );
    } else if (replyMap['result'] == null) {
      throw PlatformException(
        code: 'null-error',
        message: 'Host platform returned null value for non-null return value.',
      );
    } else {
      return (replyMap['result'] as CoordinateBounds?)!;
    }
  }

  Future<CoordinateBoundsZoom> coordinateBoundsZoomForCamera(
      CameraOptions arg_camera) async {
    final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
        'dev.flutter.pigeon._CameraManager.coordinateBoundsZoomForCamera',
        codec,
        binaryMessenger: _binaryMessenger);
    final Map<Object?, Object?>? replyMap =
        await channel.send(<Object?>[arg_camera]) as Map<Object?, Object?>?;
    if (replyMap == null) {
      throw PlatformException(
        code: 'channel-error',
        message: 'Unable to establish connection on channel.',
      );
    } else if (replyMap['error'] != null) {
      final Map<Object?, Object?> error =
          (replyMap['error'] as Map<Object?, Object?>?)!;
      throw PlatformException(
        code: (error['code'] as String?)!,
        message: error['message'] as String?,
        details: error['details'],
      );
    } else if (replyMap['result'] == null) {
      throw PlatformException(
        code: 'null-error',
        message: 'Host platform returned null value for non-null return value.',
      );
    } else {
      return (replyMap['result'] as CoordinateBoundsZoom?)!;
    }
  }

  Future<CoordinateBoundsZoom> coordinateBoundsZoomForCameraUnwrapped(
      CameraOptions arg_camera) async {
    final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
        'dev.flutter.pigeon._CameraManager.coordinateBoundsZoomForCameraUnwrapped',
        codec,
        binaryMessenger: _binaryMessenger);
    final Map<Object?, Object?>? replyMap =
        await channel.send(<Object?>[arg_camera]) as Map<Object?, Object?>?;
    if (replyMap == null) {
      throw PlatformException(
        code: 'channel-error',
        message: 'Unable to establish connection on channel.',
      );
    } else if (replyMap['error'] != null) {
      final Map<Object?, Object?> error =
          (replyMap['error'] as Map<Object?, Object?>?)!;
      throw PlatformException(
        code: (error['code'] as String?)!,
        message: error['message'] as String?,
        details: error['details'],
      );
    } else if (replyMap['result'] == null) {
      throw PlatformException(
        code: 'null-error',
        message: 'Host platform returned null value for non-null return value.',
      );
    } else {
      return (replyMap['result'] as CoordinateBoundsZoom?)!;
    }
  }

  Future<ScreenCoordinate> pixelForCoordinate(
      Map<String?, Object?> arg_coordinate) async {
    final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
        'dev.flutter.pigeon._CameraManager.pixelForCoordinate', codec,
        binaryMessenger: _binaryMessenger);
    final Map<Object?, Object?>? replyMap =
        await channel.send(<Object?>[arg_coordinate]) as Map<Object?, Object?>?;
    if (replyMap == null) {
      throw PlatformException(
        code: 'channel-error',
        message: 'Unable to establish connection on channel.',
      );
    } else if (replyMap['error'] != null) {
      final Map<Object?, Object?> error =
          (replyMap['error'] as Map<Object?, Object?>?)!;
      throw PlatformException(
        code: (error['code'] as String?)!,
        message: error['message'] as String?,
        details: error['details'],
      );
    } else if (replyMap['result'] == null) {
      throw PlatformException(
        code: 'null-error',
        message: 'Host platform returned null value for non-null return value.',
      );
    } else {
      return (replyMap['result'] as ScreenCoordinate?)!;
    }
  }

  Future<Map<String?, Object?>> coordinateForPixel(
      ScreenCoordinate arg_pixel) async {
    final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
        'dev.flutter.pigeon._CameraManager.coordinateForPixel', codec,
        binaryMessenger: _binaryMessenger);
    final Map<Object?, Object?>? replyMap =
        await channel.send(<Object?>[arg_pixel]) as Map<Object?, Object?>?;
    if (replyMap == null) {
      throw PlatformException(
        code: 'channel-error',
        message: 'Unable to establish connection on channel.',
      );
    } else if (replyMap['error'] != null) {
      final Map<Object?, Object?> error =
          (replyMap['error'] as Map<Object?, Object?>?)!;
      throw PlatformException(
        code: (error['code'] as String?)!,
        message: error['message'] as String?,
        details: error['details'],
      );
    } else if (replyMap['result'] == null) {
      throw PlatformException(
        code: 'null-error',
        message: 'Host platform returned null value for non-null return value.',
      );
    } else {
      return (replyMap['result'] as Map<Object?, Object?>?)!
          .cast<String?, Object?>();
    }
  }

  Future<List<ScreenCoordinate?>> pixelsForCoordinates(
      List<Map<String?, Object?>?> arg_coordinates) async {
    final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
        'dev.flutter.pigeon._CameraManager.pixelsForCoordinates', codec,
        binaryMessenger: _binaryMessenger);
    final Map<Object?, Object?>? replyMap = await channel
        .send(<Object?>[arg_coordinates]) as Map<Object?, Object?>?;
    if (replyMap == null) {
      throw PlatformException(
        code: 'channel-error',
        message: 'Unable to establish connection on channel.',
      );
    } else if (replyMap['error'] != null) {
      final Map<Object?, Object?> error =
          (replyMap['error'] as Map<Object?, Object?>?)!;
      throw PlatformException(
        code: (error['code'] as String?)!,
        message: error['message'] as String?,
        details: error['details'],
      );
    } else if (replyMap['result'] == null) {
      throw PlatformException(
        code: 'null-error',
        message: 'Host platform returned null value for non-null return value.',
      );
    } else {
      return (replyMap['result'] as List<Object?>?)!.cast<ScreenCoordinate?>();
    }
  }

  Future<List<Map<String?, Object?>?>> coordinatesForPixels(
      List<ScreenCoordinate?> arg_pixels) async {
    final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
        'dev.flutter.pigeon._CameraManager.coordinatesForPixels', codec,
        binaryMessenger: _binaryMessenger);
    final Map<Object?, Object?>? replyMap =
        await channel.send(<Object?>[arg_pixels]) as Map<Object?, Object?>?;
    if (replyMap == null) {
      throw PlatformException(
        code: 'channel-error',
        message: 'Unable to establish connection on channel.',
      );
    } else if (replyMap['error'] != null) {
      final Map<Object?, Object?> error =
          (replyMap['error'] as Map<Object?, Object?>?)!;
      throw PlatformException(
        code: (error['code'] as String?)!,
        message: error['message'] as String?,
        details: error['details'],
      );
    } else if (replyMap['result'] == null) {
      throw PlatformException(
        code: 'null-error',
        message: 'Host platform returned null value for non-null return value.',
      );
    } else {
      // FIXME manually patched - for some reason Pigeon generates incorrect mapping that leads to
      // Exception: "Unhandled Exception: type '_InternalLinkedHashMap<Object?, Object?>' is not a subtype of type 'Map<String?, Object?>?' in type cast"
      return (replyMap['result'] as List<Object?>?)!
          .map((e) => Map<String?, Object?>.from(e as Map<dynamic, dynamic>))
          .toList();
      // return (replyMap['result'] as List<Object?>?)!
      //    .cast<Map<String?, Object?>?>();
    }
  }

  Future<void> setCamera(CameraOptions arg_cameraOptions) async {
    final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
        'dev.flutter.pigeon._CameraManager.setCamera', codec,
        binaryMessenger: _binaryMessenger);
    final Map<Object?, Object?>? replyMap = await channel
        .send(<Object?>[arg_cameraOptions]) as Map<Object?, Object?>?;
    if (replyMap == null) {
      throw PlatformException(
        code: 'channel-error',
        message: 'Unable to establish connection on channel.',
      );
    } else if (replyMap['error'] != null) {
      final Map<Object?, Object?> error =
          (replyMap['error'] as Map<Object?, Object?>?)!;
      throw PlatformException(
        code: (error['code'] as String?)!,
        message: error['message'] as String?,
        details: error['details'],
      );
    } else {
      return;
    }
  }

  Future<CameraState> getCameraState() async {
    final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
        'dev.flutter.pigeon._CameraManager.getCameraState', codec,
        binaryMessenger: _binaryMessenger);
    final Map<Object?, Object?>? replyMap =
        await channel.send(null) as Map<Object?, Object?>?;
    if (replyMap == null) {
      throw PlatformException(
        code: 'channel-error',
        message: 'Unable to establish connection on channel.',
      );
    } else if (replyMap['error'] != null) {
      final Map<Object?, Object?> error =
          (replyMap['error'] as Map<Object?, Object?>?)!;
      throw PlatformException(
        code: (error['code'] as String?)!,
        message: error['message'] as String?,
        details: error['details'],
      );
    } else if (replyMap['result'] == null) {
      throw PlatformException(
        code: 'null-error',
        message: 'Host platform returned null value for non-null return value.',
      );
    } else {
      return (replyMap['result'] as CameraState?)!;
    }
  }

  Future<void> setBounds(CameraBoundsOptions arg_options) async {
    final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
        'dev.flutter.pigeon._CameraManager.setBounds', codec,
        binaryMessenger: _binaryMessenger);
    final Map<Object?, Object?>? replyMap =
        await channel.send(<Object?>[arg_options]) as Map<Object?, Object?>?;
    if (replyMap == null) {
      throw PlatformException(
        code: 'channel-error',
        message: 'Unable to establish connection on channel.',
      );
    } else if (replyMap['error'] != null) {
      final Map<Object?, Object?> error =
          (replyMap['error'] as Map<Object?, Object?>?)!;
      throw PlatformException(
        code: (error['code'] as String?)!,
        message: error['message'] as String?,
        details: error['details'],
      );
    } else {
      return;
    }
  }

  Future<CameraBounds> getBounds() async {
    final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
        'dev.flutter.pigeon._CameraManager.getBounds', codec,
        binaryMessenger: _binaryMessenger);
    final Map<Object?, Object?>? replyMap =
        await channel.send(null) as Map<Object?, Object?>?;
    if (replyMap == null) {
      throw PlatformException(
        code: 'channel-error',
        message: 'Unable to establish connection on channel.',
      );
    } else if (replyMap['error'] != null) {
      final Map<Object?, Object?> error =
          (replyMap['error'] as Map<Object?, Object?>?)!;
      throw PlatformException(
        code: (error['code'] as String?)!,
        message: error['message'] as String?,
        details: error['details'],
      );
    } else if (replyMap['result'] == null) {
      throw PlatformException(
        code: 'null-error',
        message: 'Host platform returned null value for non-null return value.',
      );
    } else {
      return (replyMap['result'] as CameraBounds?)!;
    }
  }

  Future<void> dragStart(ScreenCoordinate arg_point) async {
    final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
        'dev.flutter.pigeon._CameraManager.dragStart', codec,
        binaryMessenger: _binaryMessenger);
    final Map<Object?, Object?>? replyMap =
        await channel.send(<Object?>[arg_point]) as Map<Object?, Object?>?;
    if (replyMap == null) {
      throw PlatformException(
        code: 'channel-error',
        message: 'Unable to establish connection on channel.',
      );
    } else if (replyMap['error'] != null) {
      final Map<Object?, Object?> error =
          (replyMap['error'] as Map<Object?, Object?>?)!;
      throw PlatformException(
        code: (error['code'] as String?)!,
        message: error['message'] as String?,
        details: error['details'],
      );
    } else {
      return;
    }
  }

  Future<CameraOptions> getDragCameraOptions(
      ScreenCoordinate arg_fromPoint, ScreenCoordinate arg_toPoint) async {
    final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
        'dev.flutter.pigeon._CameraManager.getDragCameraOptions', codec,
        binaryMessenger: _binaryMessenger);
    final Map<Object?, Object?>? replyMap = await channel
        .send(<Object?>[arg_fromPoint, arg_toPoint]) as Map<Object?, Object?>?;
    if (replyMap == null) {
      throw PlatformException(
        code: 'channel-error',
        message: 'Unable to establish connection on channel.',
      );
    } else if (replyMap['error'] != null) {
      final Map<Object?, Object?> error =
          (replyMap['error'] as Map<Object?, Object?>?)!;
      throw PlatformException(
        code: (error['code'] as String?)!,
        message: error['message'] as String?,
        details: error['details'],
      );
    } else if (replyMap['result'] == null) {
      throw PlatformException(
        code: 'null-error',
        message: 'Host platform returned null value for non-null return value.',
      );
    } else {
      return (replyMap['result'] as CameraOptions?)!;
    }
  }

  Future<void> dragEnd() async {
    final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
        'dev.flutter.pigeon._CameraManager.dragEnd', codec,
        binaryMessenger: _binaryMessenger);
    final Map<Object?, Object?>? replyMap =
        await channel.send(null) as Map<Object?, Object?>?;
    if (replyMap == null) {
      throw PlatformException(
        code: 'channel-error',
        message: 'Unable to establish connection on channel.',
      );
    } else if (replyMap['error'] != null) {
      final Map<Object?, Object?> error =
          (replyMap['error'] as Map<Object?, Object?>?)!;
      throw PlatformException(
        code: (error['code'] as String?)!,
        message: error['message'] as String?,
        details: error['details'],
      );
    } else {
      return;
    }
  }
}

class __MapInterfaceCodec extends StandardMessageCodec {
  const __MapInterfaceCodec();
  @override
  void writeValue(WriteBuffer buffer, Object? value) {
    if (value is CameraBounds) {
      buffer.putUint8(128);
      writeValue(buffer, value.encode());
    } else if (value is CameraBoundsOptions) {
      buffer.putUint8(129);
      writeValue(buffer, value.encode());
    } else if (value is CameraOptions) {
      buffer.putUint8(130);
      writeValue(buffer, value.encode());
    } else if (value is CameraState) {
      buffer.putUint8(131);
      writeValue(buffer, value.encode());
    } else if (value is CanonicalTileID) {
      buffer.putUint8(132);
      writeValue(buffer, value.encode());
    } else if (value is CoordinateBounds) {
      buffer.putUint8(133);
      writeValue(buffer, value.encode());
    } else if (value is CoordinateBoundsZoom) {
      buffer.putUint8(134);
      writeValue(buffer, value.encode());
    } else if (value is FeatureExtensionValue) {
      buffer.putUint8(135);
      writeValue(buffer, value.encode());
    } else if (value is GlyphsRasterizationOptions) {
      buffer.putUint8(136);
      writeValue(buffer, value.encode());
    } else if (value is ImageContent) {
      buffer.putUint8(137);
      writeValue(buffer, value.encode());
    } else if (value is ImageStretches) {
      buffer.putUint8(138);
      writeValue(buffer, value.encode());
    } else if (value is LayerPosition) {
      buffer.putUint8(139);
      writeValue(buffer, value.encode());
    } else if (value is MapAnimationOptions) {
      buffer.putUint8(140);
      writeValue(buffer, value.encode());
    } else if (value is MapDebugOptions) {
      buffer.putUint8(141);
      writeValue(buffer, value.encode());
    } else if (value is MapMemoryBudgetInMegabytes) {
      buffer.putUint8(142);
      writeValue(buffer, value.encode());
    } else if (value is MapMemoryBudgetInTiles) {
      buffer.putUint8(143);
      writeValue(buffer, value.encode());
    } else if (value is MapOptions) {
      buffer.putUint8(144);
      writeValue(buffer, value.encode());
    } else if (value is MbxEdgeInsets) {
      buffer.putUint8(145);
      writeValue(buffer, value.encode());
    } else if (value is MbxImage) {
      buffer.putUint8(146);
      writeValue(buffer, value.encode());
    } else if (value is MercatorCoordinate) {
      buffer.putUint8(147);
      writeValue(buffer, value.encode());
    } else if (value is OfflineRegionGeometryDefinition) {
      buffer.putUint8(148);
      writeValue(buffer, value.encode());
    } else if (value is OfflineRegionTilePyramidDefinition) {
      buffer.putUint8(149);
      writeValue(buffer, value.encode());
    } else if (value is ProjectedMeters) {
      buffer.putUint8(150);
      writeValue(buffer, value.encode());
    } else if (value is QueriedFeature) {
      buffer.putUint8(151);
      writeValue(buffer, value.encode());
    } else if (value is RenderedQueryGeometry) {
      buffer.putUint8(152);
      writeValue(buffer, value.encode());
    } else if (value is RenderedQueryOptions) {
      buffer.putUint8(153);
      writeValue(buffer, value.encode());
    } else if (value is ResourceOptions) {
      buffer.putUint8(154);
      writeValue(buffer, value.encode());
    } else if (value is ScreenBox) {
      buffer.putUint8(155);
      writeValue(buffer, value.encode());
    } else if (value is ScreenCoordinate) {
      buffer.putUint8(156);
      writeValue(buffer, value.encode());
    } else if (value is Size) {
      buffer.putUint8(157);
      writeValue(buffer, value.encode());
    } else if (value is SourceQueryOptions) {
      buffer.putUint8(158);
      writeValue(buffer, value.encode());
    } else if (value is StyleObjectInfo) {
      buffer.putUint8(159);
      writeValue(buffer, value.encode());
    } else if (value is StylePropertyValue) {
      buffer.putUint8(160);
      writeValue(buffer, value.encode());
    } else if (value is TransitionOptions) {
      buffer.putUint8(161);
      writeValue(buffer, value.encode());
    } else {
      super.writeValue(buffer, value);
    }
  }

  @override
  Object? readValueOfType(int type, ReadBuffer buffer) {
    switch (type) {
      case 128:
        return CameraBounds.decode(readValue(buffer)!);

      case 129:
        return CameraBoundsOptions.decode(readValue(buffer)!);

      case 130:
        return CameraOptions.decode(readValue(buffer)!);

      case 131:
        return CameraState.decode(readValue(buffer)!);

      case 132:
        return CanonicalTileID.decode(readValue(buffer)!);

      case 133:
        return CoordinateBounds.decode(readValue(buffer)!);

      case 134:
        return CoordinateBoundsZoom.decode(readValue(buffer)!);

      case 135:
        return FeatureExtensionValue.decode(readValue(buffer)!);

      case 136:
        return GlyphsRasterizationOptions.decode(readValue(buffer)!);

      case 137:
        return ImageContent.decode(readValue(buffer)!);

      case 138:
        return ImageStretches.decode(readValue(buffer)!);

      case 139:
        return LayerPosition.decode(readValue(buffer)!);

      case 140:
        return MapAnimationOptions.decode(readValue(buffer)!);

      case 141:
        return MapDebugOptions.decode(readValue(buffer)!);

      case 142:
        return MapMemoryBudgetInMegabytes.decode(readValue(buffer)!);

      case 143:
        return MapMemoryBudgetInTiles.decode(readValue(buffer)!);

      case 144:
        return MapOptions.decode(readValue(buffer)!);

      case 145:
        return MbxEdgeInsets.decode(readValue(buffer)!);

      case 146:
        return MbxImage.decode(readValue(buffer)!);

      case 147:
        return MercatorCoordinate.decode(readValue(buffer)!);

      case 148:
        return OfflineRegionGeometryDefinition.decode(readValue(buffer)!);

      case 149:
        return OfflineRegionTilePyramidDefinition.decode(readValue(buffer)!);

      case 150:
        return ProjectedMeters.decode(readValue(buffer)!);

      case 151:
        return QueriedFeature.decode(readValue(buffer)!);

      case 152:
        return RenderedQueryGeometry.decode(readValue(buffer)!);

      case 153:
        return RenderedQueryOptions.decode(readValue(buffer)!);

      case 154:
        return ResourceOptions.decode(readValue(buffer)!);

      case 155:
        return ScreenBox.decode(readValue(buffer)!);

      case 156:
        return ScreenCoordinate.decode(readValue(buffer)!);

      case 157:
        return Size.decode(readValue(buffer)!);

      case 158:
        return SourceQueryOptions.decode(readValue(buffer)!);

      case 159:
        return StyleObjectInfo.decode(readValue(buffer)!);

      case 160:
        return StylePropertyValue.decode(readValue(buffer)!);

      case 161:
        return TransitionOptions.decode(readValue(buffer)!);

      default:
        return super.readValueOfType(type, buffer);
    }
  }
}

class _MapInterface {
  /// Constructor for [_MapInterface].  The [binaryMessenger] named argument is
  /// available for dependency injection.  If it is left null, the default
  /// BinaryMessenger will be used which routes to the host platform.
  _MapInterface({BinaryMessenger? binaryMessenger})
      : _binaryMessenger = binaryMessenger;

  final BinaryMessenger? _binaryMessenger;

  static const MessageCodec<Object?> codec = __MapInterfaceCodec();

  Future<void> loadStyleURI(String arg_styleURI) async {
    final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
        'dev.flutter.pigeon._MapInterface.loadStyleURI', codec,
        binaryMessenger: _binaryMessenger);
    final Map<Object?, Object?>? replyMap =
        await channel.send(<Object?>[arg_styleURI]) as Map<Object?, Object?>?;
    if (replyMap == null) {
      throw PlatformException(
        code: 'channel-error',
        message: 'Unable to establish connection on channel.',
      );
    } else if (replyMap['error'] != null) {
      final Map<Object?, Object?> error =
          (replyMap['error'] as Map<Object?, Object?>?)!;
      throw PlatformException(
        code: (error['code'] as String?)!,
        message: error['message'] as String?,
        details: error['details'],
      );
    } else {
      return;
    }
  }

  Future<void> loadStyleJson(String arg_styleJson) async {
    final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
        'dev.flutter.pigeon._MapInterface.loadStyleJson', codec,
        binaryMessenger: _binaryMessenger);
    final Map<Object?, Object?>? replyMap =
        await channel.send(<Object?>[arg_styleJson]) as Map<Object?, Object?>?;
    if (replyMap == null) {
      throw PlatformException(
        code: 'channel-error',
        message: 'Unable to establish connection on channel.',
      );
    } else if (replyMap['error'] != null) {
      final Map<Object?, Object?> error =
          (replyMap['error'] as Map<Object?, Object?>?)!;
      throw PlatformException(
        code: (error['code'] as String?)!,
        message: error['message'] as String?,
        details: error['details'],
      );
    } else {
      return;
    }
  }

  Future<void> clearData() async {
    final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
        'dev.flutter.pigeon._MapInterface.clearData', codec,
        binaryMessenger: _binaryMessenger);
    final Map<Object?, Object?>? replyMap =
        await channel.send(null) as Map<Object?, Object?>?;
    if (replyMap == null) {
      throw PlatformException(
        code: 'channel-error',
        message: 'Unable to establish connection on channel.',
      );
    } else if (replyMap['error'] != null) {
      final Map<Object?, Object?> error =
          (replyMap['error'] as Map<Object?, Object?>?)!;
      throw PlatformException(
        code: (error['code'] as String?)!,
        message: error['message'] as String?,
        details: error['details'],
      );
    } else {
      return;
    }
  }

  Future<void> setMemoryBudget(
      MapMemoryBudgetInMegabytes? arg_mapMemoryBudgetInMegabytes,
      MapMemoryBudgetInTiles? arg_mapMemoryBudgetInTiles) async {
    final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
        'dev.flutter.pigeon._MapInterface.setMemoryBudget', codec,
        binaryMessenger: _binaryMessenger);
    final Map<Object?, Object?>? replyMap = await channel.send(<Object?>[
      arg_mapMemoryBudgetInMegabytes,
      arg_mapMemoryBudgetInTiles
    ]) as Map<Object?, Object?>?;
    if (replyMap == null) {
      throw PlatformException(
        code: 'channel-error',
        message: 'Unable to establish connection on channel.',
      );
    } else if (replyMap['error'] != null) {
      final Map<Object?, Object?> error =
          (replyMap['error'] as Map<Object?, Object?>?)!;
      throw PlatformException(
        code: (error['code'] as String?)!,
        message: error['message'] as String?,
        details: error['details'],
      );
    } else {
      return;
    }
  }

  Future<Size> getSize() async {
    final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
        'dev.flutter.pigeon._MapInterface.getSize', codec,
        binaryMessenger: _binaryMessenger);
    final Map<Object?, Object?>? replyMap =
        await channel.send(null) as Map<Object?, Object?>?;
    if (replyMap == null) {
      throw PlatformException(
        code: 'channel-error',
        message: 'Unable to establish connection on channel.',
      );
    } else if (replyMap['error'] != null) {
      final Map<Object?, Object?> error =
          (replyMap['error'] as Map<Object?, Object?>?)!;
      throw PlatformException(
        code: (error['code'] as String?)!,
        message: error['message'] as String?,
        details: error['details'],
      );
    } else if (replyMap['result'] == null) {
      throw PlatformException(
        code: 'null-error',
        message: 'Host platform returned null value for non-null return value.',
      );
    } else {
      return (replyMap['result'] as Size?)!;
    }
  }

  Future<void> triggerRepaint() async {
    final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
        'dev.flutter.pigeon._MapInterface.triggerRepaint', codec,
        binaryMessenger: _binaryMessenger);
    final Map<Object?, Object?>? replyMap =
        await channel.send(null) as Map<Object?, Object?>?;
    if (replyMap == null) {
      throw PlatformException(
        code: 'channel-error',
        message: 'Unable to establish connection on channel.',
      );
    } else if (replyMap['error'] != null) {
      final Map<Object?, Object?> error =
          (replyMap['error'] as Map<Object?, Object?>?)!;
      throw PlatformException(
        code: (error['code'] as String?)!,
        message: error['message'] as String?,
        details: error['details'],
      );
    } else {
      return;
    }
  }

  Future<void> setGestureInProgress(bool arg_inProgress) async {
    final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
        'dev.flutter.pigeon._MapInterface.setGestureInProgress', codec,
        binaryMessenger: _binaryMessenger);
    final Map<Object?, Object?>? replyMap =
        await channel.send(<Object?>[arg_inProgress]) as Map<Object?, Object?>?;
    if (replyMap == null) {
      throw PlatformException(
        code: 'channel-error',
        message: 'Unable to establish connection on channel.',
      );
    } else if (replyMap['error'] != null) {
      final Map<Object?, Object?> error =
          (replyMap['error'] as Map<Object?, Object?>?)!;
      throw PlatformException(
        code: (error['code'] as String?)!,
        message: error['message'] as String?,
        details: error['details'],
      );
    } else {
      return;
    }
  }

  Future<bool> isGestureInProgress() async {
    final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
        'dev.flutter.pigeon._MapInterface.isGestureInProgress', codec,
        binaryMessenger: _binaryMessenger);
    final Map<Object?, Object?>? replyMap =
        await channel.send(null) as Map<Object?, Object?>?;
    if (replyMap == null) {
      throw PlatformException(
        code: 'channel-error',
        message: 'Unable to establish connection on channel.',
      );
    } else if (replyMap['error'] != null) {
      final Map<Object?, Object?> error =
          (replyMap['error'] as Map<Object?, Object?>?)!;
      throw PlatformException(
        code: (error['code'] as String?)!,
        message: error['message'] as String?,
        details: error['details'],
      );
    } else if (replyMap['result'] == null) {
      throw PlatformException(
        code: 'null-error',
        message: 'Host platform returned null value for non-null return value.',
      );
    } else {
      return (replyMap['result'] as bool?)!;
    }
  }

  Future<void> setUserAnimationInProgress(bool arg_inProgress) async {
    final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
        'dev.flutter.pigeon._MapInterface.setUserAnimationInProgress', codec,
        binaryMessenger: _binaryMessenger);
    final Map<Object?, Object?>? replyMap =
        await channel.send(<Object?>[arg_inProgress]) as Map<Object?, Object?>?;
    if (replyMap == null) {
      throw PlatformException(
        code: 'channel-error',
        message: 'Unable to establish connection on channel.',
      );
    } else if (replyMap['error'] != null) {
      final Map<Object?, Object?> error =
          (replyMap['error'] as Map<Object?, Object?>?)!;
      throw PlatformException(
        code: (error['code'] as String?)!,
        message: error['message'] as String?,
        details: error['details'],
      );
    } else {
      return;
    }
  }

  Future<bool> isUserAnimationInProgress() async {
    final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
        'dev.flutter.pigeon._MapInterface.isUserAnimationInProgress', codec,
        binaryMessenger: _binaryMessenger);
    final Map<Object?, Object?>? replyMap =
        await channel.send(null) as Map<Object?, Object?>?;
    if (replyMap == null) {
      throw PlatformException(
        code: 'channel-error',
        message: 'Unable to establish connection on channel.',
      );
    } else if (replyMap['error'] != null) {
      final Map<Object?, Object?> error =
          (replyMap['error'] as Map<Object?, Object?>?)!;
      throw PlatformException(
        code: (error['code'] as String?)!,
        message: error['message'] as String?,
        details: error['details'],
      );
    } else if (replyMap['result'] == null) {
      throw PlatformException(
        code: 'null-error',
        message: 'Host platform returned null value for non-null return value.',
      );
    } else {
      return (replyMap['result'] as bool?)!;
    }
  }

  Future<void> setPrefetchZoomDelta(int arg_delta) async {
    final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
        'dev.flutter.pigeon._MapInterface.setPrefetchZoomDelta', codec,
        binaryMessenger: _binaryMessenger);
    final Map<Object?, Object?>? replyMap =
        await channel.send(<Object?>[arg_delta]) as Map<Object?, Object?>?;
    if (replyMap == null) {
      throw PlatformException(
        code: 'channel-error',
        message: 'Unable to establish connection on channel.',
      );
    } else if (replyMap['error'] != null) {
      final Map<Object?, Object?> error =
          (replyMap['error'] as Map<Object?, Object?>?)!;
      throw PlatformException(
        code: (error['code'] as String?)!,
        message: error['message'] as String?,
        details: error['details'],
      );
    } else {
      return;
    }
  }

  Future<int> getPrefetchZoomDelta() async {
    final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
        'dev.flutter.pigeon._MapInterface.getPrefetchZoomDelta', codec,
        binaryMessenger: _binaryMessenger);
    final Map<Object?, Object?>? replyMap =
        await channel.send(null) as Map<Object?, Object?>?;
    if (replyMap == null) {
      throw PlatformException(
        code: 'channel-error',
        message: 'Unable to establish connection on channel.',
      );
    } else if (replyMap['error'] != null) {
      final Map<Object?, Object?> error =
          (replyMap['error'] as Map<Object?, Object?>?)!;
      throw PlatformException(
        code: (error['code'] as String?)!,
        message: error['message'] as String?,
        details: error['details'],
      );
    } else if (replyMap['result'] == null) {
      throw PlatformException(
        code: 'null-error',
        message: 'Host platform returned null value for non-null return value.',
      );
    } else {
      return (replyMap['result'] as int?)!;
    }
  }

  Future<void> setNorthOrientation(NorthOrientation arg_orientation) async {
    final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
        'dev.flutter.pigeon._MapInterface.setNorthOrientation', codec,
        binaryMessenger: _binaryMessenger);
    final Map<Object?, Object?>? replyMap = await channel
        .send(<Object?>[arg_orientation.index]) as Map<Object?, Object?>?;
    if (replyMap == null) {
      throw PlatformException(
        code: 'channel-error',
        message: 'Unable to establish connection on channel.',
      );
    } else if (replyMap['error'] != null) {
      final Map<Object?, Object?> error =
          (replyMap['error'] as Map<Object?, Object?>?)!;
      throw PlatformException(
        code: (error['code'] as String?)!,
        message: error['message'] as String?,
        details: error['details'],
      );
    } else {
      return;
    }
  }

  Future<void> setConstrainMode(ConstrainMode arg_mode) async {
    final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
        'dev.flutter.pigeon._MapInterface.setConstrainMode', codec,
        binaryMessenger: _binaryMessenger);
    final Map<Object?, Object?>? replyMap =
        await channel.send(<Object?>[arg_mode.index]) as Map<Object?, Object?>?;
    if (replyMap == null) {
      throw PlatformException(
        code: 'channel-error',
        message: 'Unable to establish connection on channel.',
      );
    } else if (replyMap['error'] != null) {
      final Map<Object?, Object?> error =
          (replyMap['error'] as Map<Object?, Object?>?)!;
      throw PlatformException(
        code: (error['code'] as String?)!,
        message: error['message'] as String?,
        details: error['details'],
      );
    } else {
      return;
    }
  }

  Future<void> setViewportMode(ViewportMode arg_mode) async {
    final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
        'dev.flutter.pigeon._MapInterface.setViewportMode', codec,
        binaryMessenger: _binaryMessenger);
    final Map<Object?, Object?>? replyMap =
        await channel.send(<Object?>[arg_mode.index]) as Map<Object?, Object?>?;
    if (replyMap == null) {
      throw PlatformException(
        code: 'channel-error',
        message: 'Unable to establish connection on channel.',
      );
    } else if (replyMap['error'] != null) {
      final Map<Object?, Object?> error =
          (replyMap['error'] as Map<Object?, Object?>?)!;
      throw PlatformException(
        code: (error['code'] as String?)!,
        message: error['message'] as String?,
        details: error['details'],
      );
    } else {
      return;
    }
  }

  Future<MapOptions> getMapOptions() async {
    final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
        'dev.flutter.pigeon._MapInterface.getMapOptions', codec,
        binaryMessenger: _binaryMessenger);
    final Map<Object?, Object?>? replyMap =
        await channel.send(null) as Map<Object?, Object?>?;
    if (replyMap == null) {
      throw PlatformException(
        code: 'channel-error',
        message: 'Unable to establish connection on channel.',
      );
    } else if (replyMap['error'] != null) {
      final Map<Object?, Object?> error =
          (replyMap['error'] as Map<Object?, Object?>?)!;
      throw PlatformException(
        code: (error['code'] as String?)!,
        message: error['message'] as String?,
        details: error['details'],
      );
    } else if (replyMap['result'] == null) {
      throw PlatformException(
        code: 'null-error',
        message: 'Host platform returned null value for non-null return value.',
      );
    } else {
      return (replyMap['result'] as MapOptions?)!;
    }
  }

  Future<List<MapDebugOptions?>> getDebug() async {
    final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
        'dev.flutter.pigeon._MapInterface.getDebug', codec,
        binaryMessenger: _binaryMessenger);
    final Map<Object?, Object?>? replyMap =
        await channel.send(null) as Map<Object?, Object?>?;
    if (replyMap == null) {
      throw PlatformException(
        code: 'channel-error',
        message: 'Unable to establish connection on channel.',
      );
    } else if (replyMap['error'] != null) {
      final Map<Object?, Object?> error =
          (replyMap['error'] as Map<Object?, Object?>?)!;
      throw PlatformException(
        code: (error['code'] as String?)!,
        message: error['message'] as String?,
        details: error['details'],
      );
    } else if (replyMap['result'] == null) {
      throw PlatformException(
        code: 'null-error',
        message: 'Host platform returned null value for non-null return value.',
      );
    } else {
      return (replyMap['result'] as List<Object?>?)!.cast<MapDebugOptions?>();
    }
  }

  Future<void> setDebug(
      List<MapDebugOptions?> arg_debugOptions, bool arg_value) async {
    final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
        'dev.flutter.pigeon._MapInterface.setDebug', codec,
        binaryMessenger: _binaryMessenger);
    final Map<Object?, Object?>? replyMap = await channel
        .send(<Object?>[arg_debugOptions, arg_value]) as Map<Object?, Object?>?;
    if (replyMap == null) {
      throw PlatformException(
        code: 'channel-error',
        message: 'Unable to establish connection on channel.',
      );
    } else if (replyMap['error'] != null) {
      final Map<Object?, Object?> error =
          (replyMap['error'] as Map<Object?, Object?>?)!;
      throw PlatformException(
        code: (error['code'] as String?)!,
        message: error['message'] as String?,
        details: error['details'],
      );
    } else {
      return;
    }
  }

  Future<List<QueriedFeature?>> queryRenderedFeatures(
      RenderedQueryGeometry arg_geometry,
      RenderedQueryOptions arg_options) async {
    final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
        'dev.flutter.pigeon._MapInterface.queryRenderedFeatures', codec,
        binaryMessenger: _binaryMessenger);
    final Map<Object?, Object?>? replyMap = await channel
        .send(<Object?>[arg_geometry, arg_options]) as Map<Object?, Object?>?;
    if (replyMap == null) {
      throw PlatformException(
        code: 'channel-error',
        message: 'Unable to establish connection on channel.',
      );
    } else if (replyMap['error'] != null) {
      final Map<Object?, Object?> error =
          (replyMap['error'] as Map<Object?, Object?>?)!;
      throw PlatformException(
        code: (error['code'] as String?)!,
        message: error['message'] as String?,
        details: error['details'],
      );
    } else if (replyMap['result'] == null) {
      throw PlatformException(
        code: 'null-error',
        message: 'Host platform returned null value for non-null return value.',
      );
    } else {
      return (replyMap['result'] as List<Object?>?)!.cast<QueriedFeature?>();
    }
  }

  Future<List<QueriedFeature?>> querySourceFeatures(
      String arg_sourceId, SourceQueryOptions arg_options) async {
    final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
        'dev.flutter.pigeon._MapInterface.querySourceFeatures', codec,
        binaryMessenger: _binaryMessenger);
    final Map<Object?, Object?>? replyMap = await channel
        .send(<Object?>[arg_sourceId, arg_options]) as Map<Object?, Object?>?;
    if (replyMap == null) {
      throw PlatformException(
        code: 'channel-error',
        message: 'Unable to establish connection on channel.',
      );
    } else if (replyMap['error'] != null) {
      final Map<Object?, Object?> error =
          (replyMap['error'] as Map<Object?, Object?>?)!;
      throw PlatformException(
        code: (error['code'] as String?)!,
        message: error['message'] as String?,
        details: error['details'],
      );
    } else if (replyMap['result'] == null) {
      throw PlatformException(
        code: 'null-error',
        message: 'Host platform returned null value for non-null return value.',
      );
    } else {
      return (replyMap['result'] as List<Object?>?)!.cast<QueriedFeature?>();
    }
  }

  Future<FeatureExtensionValue> getGeoJsonClusterLeaves(
      String arg_sourceIdentifier,
      Map<String?, Object?> arg_cluster,
      int? arg_limit,
      int? arg_offset) async {
    final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
        'dev.flutter.pigeon._MapInterface.getGeoJsonClusterLeaves', codec,
        binaryMessenger: _binaryMessenger);
    final Map<Object?, Object?>? replyMap = await channel.send(
            <Object?>[arg_sourceIdentifier, arg_cluster, arg_limit, arg_offset])
        as Map<Object?, Object?>?;
    if (replyMap == null) {
      throw PlatformException(
        code: 'channel-error',
        message: 'Unable to establish connection on channel.',
      );
    } else if (replyMap['error'] != null) {
      final Map<Object?, Object?> error =
          (replyMap['error'] as Map<Object?, Object?>?)!;
      throw PlatformException(
        code: (error['code'] as String?)!,
        message: error['message'] as String?,
        details: error['details'],
      );
    } else if (replyMap['result'] == null) {
      throw PlatformException(
        code: 'null-error',
        message: 'Host platform returned null value for non-null return value.',
      );
    } else {
      return (replyMap['result'] as FeatureExtensionValue?)!;
    }
  }

  Future<FeatureExtensionValue> getGeoJsonClusterChildren(
      String arg_sourceIdentifier, Map<String?, Object?> arg_cluster) async {
    final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
        'dev.flutter.pigeon._MapInterface.getGeoJsonClusterChildren', codec,
        binaryMessenger: _binaryMessenger);
    final Map<Object?, Object?>? replyMap =
        await channel.send(<Object?>[arg_sourceIdentifier, arg_cluster])
            as Map<Object?, Object?>?;
    if (replyMap == null) {
      throw PlatformException(
        code: 'channel-error',
        message: 'Unable to establish connection on channel.',
      );
    } else if (replyMap['error'] != null) {
      final Map<Object?, Object?> error =
          (replyMap['error'] as Map<Object?, Object?>?)!;
      throw PlatformException(
        code: (error['code'] as String?)!,
        message: error['message'] as String?,
        details: error['details'],
      );
    } else if (replyMap['result'] == null) {
      throw PlatformException(
        code: 'null-error',
        message: 'Host platform returned null value for non-null return value.',
      );
    } else {
      return (replyMap['result'] as FeatureExtensionValue?)!;
    }
  }

  Future<FeatureExtensionValue> getGeoJsonClusterExpansionZoom(
      String arg_sourceIdentifier, Map<String?, Object?> arg_cluster) async {
    final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
        'dev.flutter.pigeon._MapInterface.getGeoJsonClusterExpansionZoom',
        codec,
        binaryMessenger: _binaryMessenger);
    final Map<Object?, Object?>? replyMap =
        await channel.send(<Object?>[arg_sourceIdentifier, arg_cluster])
            as Map<Object?, Object?>?;
    if (replyMap == null) {
      throw PlatformException(
        code: 'channel-error',
        message: 'Unable to establish connection on channel.',
      );
    } else if (replyMap['error'] != null) {
      final Map<Object?, Object?> error =
          (replyMap['error'] as Map<Object?, Object?>?)!;
      throw PlatformException(
        code: (error['code'] as String?)!,
        message: error['message'] as String?,
        details: error['details'],
      );
    } else if (replyMap['result'] == null) {
      throw PlatformException(
        code: 'null-error',
        message: 'Host platform returned null value for non-null return value.',
      );
    } else {
      return (replyMap['result'] as FeatureExtensionValue?)!;
    }
  }

  Future<void> setFeatureState(String arg_sourceId, String? arg_sourceLayerId,
      String arg_featureId, String arg_state) async {
    final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
        'dev.flutter.pigeon._MapInterface.setFeatureState', codec,
        binaryMessenger: _binaryMessenger);
    final Map<Object?, Object?>? replyMap = await channel.send(<Object?>[
      arg_sourceId,
      arg_sourceLayerId,
      arg_featureId,
      arg_state
    ]) as Map<Object?, Object?>?;
    if (replyMap == null) {
      throw PlatformException(
        code: 'channel-error',
        message: 'Unable to establish connection on channel.',
      );
    } else if (replyMap['error'] != null) {
      final Map<Object?, Object?> error =
          (replyMap['error'] as Map<Object?, Object?>?)!;
      throw PlatformException(
        code: (error['code'] as String?)!,
        message: error['message'] as String?,
        details: error['details'],
      );
    } else {
      return;
    }
  }

  Future<String> getFeatureState(String arg_sourceId, String? arg_sourceLayerId,
      String arg_featureId) async {
    final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
        'dev.flutter.pigeon._MapInterface.getFeatureState', codec,
        binaryMessenger: _binaryMessenger);
    final Map<Object?, Object?>? replyMap = await channel
            .send(<Object?>[arg_sourceId, arg_sourceLayerId, arg_featureId])
        as Map<Object?, Object?>?;
    if (replyMap == null) {
      throw PlatformException(
        code: 'channel-error',
        message: 'Unable to establish connection on channel.',
      );
    } else if (replyMap['error'] != null) {
      final Map<Object?, Object?> error =
          (replyMap['error'] as Map<Object?, Object?>?)!;
      throw PlatformException(
        code: (error['code'] as String?)!,
        message: error['message'] as String?,
        details: error['details'],
      );
    } else if (replyMap['result'] == null) {
      throw PlatformException(
        code: 'null-error',
        message: 'Host platform returned null value for non-null return value.',
      );
    } else {
      return (replyMap['result'] as String?)!;
    }
  }

  Future<void> removeFeatureState(
      String arg_sourceId,
      String? arg_sourceLayerId,
      String arg_featureId,
      String? arg_stateKey) async {
    final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
        'dev.flutter.pigeon._MapInterface.removeFeatureState', codec,
        binaryMessenger: _binaryMessenger);
    final Map<Object?, Object?>? replyMap = await channel.send(<Object?>[
      arg_sourceId,
      arg_sourceLayerId,
      arg_featureId,
      arg_stateKey
    ]) as Map<Object?, Object?>?;
    if (replyMap == null) {
      throw PlatformException(
        code: 'channel-error',
        message: 'Unable to establish connection on channel.',
      );
    } else if (replyMap['error'] != null) {
      final Map<Object?, Object?> error =
          (replyMap['error'] as Map<Object?, Object?>?)!;
      throw PlatformException(
        code: (error['code'] as String?)!,
        message: error['message'] as String?,
        details: error['details'],
      );
    } else {
      return;
    }
  }

  Future<void> reduceMemoryUse() async {
    final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
        'dev.flutter.pigeon._MapInterface.reduceMemoryUse', codec,
        binaryMessenger: _binaryMessenger);
    final Map<Object?, Object?>? replyMap =
        await channel.send(null) as Map<Object?, Object?>?;
    if (replyMap == null) {
      throw PlatformException(
        code: 'channel-error',
        message: 'Unable to establish connection on channel.',
      );
    } else if (replyMap['error'] != null) {
      final Map<Object?, Object?> error =
          (replyMap['error'] as Map<Object?, Object?>?)!;
      throw PlatformException(
        code: (error['code'] as String?)!,
        message: error['message'] as String?,
        details: error['details'],
      );
    } else {
      return;
    }
  }

  Future<ResourceOptions> getResourceOptions() async {
    final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
        'dev.flutter.pigeon._MapInterface.getResourceOptions', codec,
        binaryMessenger: _binaryMessenger);
    final Map<Object?, Object?>? replyMap =
        await channel.send(null) as Map<Object?, Object?>?;
    if (replyMap == null) {
      throw PlatformException(
        code: 'channel-error',
        message: 'Unable to establish connection on channel.',
      );
    } else if (replyMap['error'] != null) {
      final Map<Object?, Object?> error =
          (replyMap['error'] as Map<Object?, Object?>?)!;
      throw PlatformException(
        code: (error['code'] as String?)!,
        message: error['message'] as String?,
        details: error['details'],
      );
    } else if (replyMap['result'] == null) {
      throw PlatformException(
        code: 'null-error',
        message: 'Host platform returned null value for non-null return value.',
      );
    } else {
      return (replyMap['result'] as ResourceOptions?)!;
    }
  }

  Future<double?> getElevation(Map<String?, Object?> arg_coordinate) async {
    final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
        'dev.flutter.pigeon._MapInterface.getElevation', codec,
        binaryMessenger: _binaryMessenger);
    final Map<Object?, Object?>? replyMap =
        await channel.send(<Object?>[arg_coordinate]) as Map<Object?, Object?>?;
    if (replyMap == null) {
      throw PlatformException(
        code: 'channel-error',
        message: 'Unable to establish connection on channel.',
      );
    } else if (replyMap['error'] != null) {
      final Map<Object?, Object?> error =
          (replyMap['error'] as Map<Object?, Object?>?)!;
      throw PlatformException(
        code: (error['code'] as String?)!,
        message: error['message'] as String?,
        details: error['details'],
      );
    } else {
      return (replyMap['result'] as double?);
    }
  }
}

class _OfflineRegionCodec extends StandardMessageCodec {
  const _OfflineRegionCodec();
  @override
  void writeValue(WriteBuffer buffer, Object? value) {
    if (value is CoordinateBounds) {
      buffer.putUint8(128);
      writeValue(buffer, value.encode());
    } else if (value is OfflineRegionGeometryDefinition) {
      buffer.putUint8(129);
      writeValue(buffer, value.encode());
    } else if (value is OfflineRegionTilePyramidDefinition) {
      buffer.putUint8(130);
      writeValue(buffer, value.encode());
    } else {
      super.writeValue(buffer, value);
    }
  }

  @override
  Object? readValueOfType(int type, ReadBuffer buffer) {
    switch (type) {
      case 128:
        return CoordinateBounds.decode(readValue(buffer)!);

      case 129:
        return OfflineRegionGeometryDefinition.decode(readValue(buffer)!);

      case 130:
        return OfflineRegionTilePyramidDefinition.decode(readValue(buffer)!);

      default:
        return super.readValueOfType(type, buffer);
    }
  }
}

class OfflineRegion {
  /// Constructor for [OfflineRegion].  The [binaryMessenger] named argument is
  /// available for dependency injection.  If it is left null, the default
  /// BinaryMessenger will be used which routes to the host platform.
  OfflineRegion({BinaryMessenger? binaryMessenger})
      : _binaryMessenger = binaryMessenger;

  final BinaryMessenger? _binaryMessenger;

  static const MessageCodec<Object?> codec = _OfflineRegionCodec();

  Future<int> getIdentifier() async {
    final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
        'dev.flutter.pigeon.OfflineRegion.getIdentifier', codec,
        binaryMessenger: _binaryMessenger);
    final Map<Object?, Object?>? replyMap =
        await channel.send(null) as Map<Object?, Object?>?;
    if (replyMap == null) {
      throw PlatformException(
        code: 'channel-error',
        message: 'Unable to establish connection on channel.',
      );
    } else if (replyMap['error'] != null) {
      final Map<Object?, Object?> error =
          (replyMap['error'] as Map<Object?, Object?>?)!;
      throw PlatformException(
        code: (error['code'] as String?)!,
        message: error['message'] as String?,
        details: error['details'],
      );
    } else if (replyMap['result'] == null) {
      throw PlatformException(
        code: 'null-error',
        message: 'Host platform returned null value for non-null return value.',
      );
    } else {
      return (replyMap['result'] as int?)!;
    }
  }

  Future<OfflineRegionTilePyramidDefinition?> getTilePyramidDefinition() async {
    final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
        'dev.flutter.pigeon.OfflineRegion.getTilePyramidDefinition', codec,
        binaryMessenger: _binaryMessenger);
    final Map<Object?, Object?>? replyMap =
        await channel.send(null) as Map<Object?, Object?>?;
    if (replyMap == null) {
      throw PlatformException(
        code: 'channel-error',
        message: 'Unable to establish connection on channel.',
      );
    } else if (replyMap['error'] != null) {
      final Map<Object?, Object?> error =
          (replyMap['error'] as Map<Object?, Object?>?)!;
      throw PlatformException(
        code: (error['code'] as String?)!,
        message: error['message'] as String?,
        details: error['details'],
      );
    } else {
      return (replyMap['result'] as OfflineRegionTilePyramidDefinition?);
    }
  }

  Future<OfflineRegionGeometryDefinition?> getGeometryDefinition() async {
    final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
        'dev.flutter.pigeon.OfflineRegion.getGeometryDefinition', codec,
        binaryMessenger: _binaryMessenger);
    final Map<Object?, Object?>? replyMap =
        await channel.send(null) as Map<Object?, Object?>?;
    if (replyMap == null) {
      throw PlatformException(
        code: 'channel-error',
        message: 'Unable to establish connection on channel.',
      );
    } else if (replyMap['error'] != null) {
      final Map<Object?, Object?> error =
          (replyMap['error'] as Map<Object?, Object?>?)!;
      throw PlatformException(
        code: (error['code'] as String?)!,
        message: error['message'] as String?,
        details: error['details'],
      );
    } else {
      return (replyMap['result'] as OfflineRegionGeometryDefinition?);
    }
  }

  Future<Uint8List> getMetadata() async {
    final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
        'dev.flutter.pigeon.OfflineRegion.getMetadata', codec,
        binaryMessenger: _binaryMessenger);
    final Map<Object?, Object?>? replyMap =
        await channel.send(null) as Map<Object?, Object?>?;
    if (replyMap == null) {
      throw PlatformException(
        code: 'channel-error',
        message: 'Unable to establish connection on channel.',
      );
    } else if (replyMap['error'] != null) {
      final Map<Object?, Object?> error =
          (replyMap['error'] as Map<Object?, Object?>?)!;
      throw PlatformException(
        code: (error['code'] as String?)!,
        message: error['message'] as String?,
        details: error['details'],
      );
    } else if (replyMap['result'] == null) {
      throw PlatformException(
        code: 'null-error',
        message: 'Host platform returned null value for non-null return value.',
      );
    } else {
      return (replyMap['result'] as Uint8List?)!;
    }
  }

  Future<void> setMetadata(Uint8List arg_metadata) async {
    final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
        'dev.flutter.pigeon.OfflineRegion.setMetadata', codec,
        binaryMessenger: _binaryMessenger);
    final Map<Object?, Object?>? replyMap =
        await channel.send(<Object?>[arg_metadata]) as Map<Object?, Object?>?;
    if (replyMap == null) {
      throw PlatformException(
        code: 'channel-error',
        message: 'Unable to establish connection on channel.',
      );
    } else if (replyMap['error'] != null) {
      final Map<Object?, Object?> error =
          (replyMap['error'] as Map<Object?, Object?>?)!;
      throw PlatformException(
        code: (error['code'] as String?)!,
        message: error['message'] as String?,
        details: error['details'],
      );
    } else {
      return;
    }
  }

  Future<void> setOfflineRegionDownloadState(
      OfflineRegionDownloadState arg_state) async {
    final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
        'dev.flutter.pigeon.OfflineRegion.setOfflineRegionDownloadState', codec,
        binaryMessenger: _binaryMessenger);
    final Map<Object?, Object?>? replyMap = await channel
        .send(<Object?>[arg_state.index]) as Map<Object?, Object?>?;
    if (replyMap == null) {
      throw PlatformException(
        code: 'channel-error',
        message: 'Unable to establish connection on channel.',
      );
    } else if (replyMap['error'] != null) {
      final Map<Object?, Object?> error =
          (replyMap['error'] as Map<Object?, Object?>?)!;
      throw PlatformException(
        code: (error['code'] as String?)!,
        message: error['message'] as String?,
        details: error['details'],
      );
    } else {
      return;
    }
  }

  Future<void> invalidate() async {
    final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
        'dev.flutter.pigeon.OfflineRegion.invalidate', codec,
        binaryMessenger: _binaryMessenger);
    final Map<Object?, Object?>? replyMap =
        await channel.send(null) as Map<Object?, Object?>?;
    if (replyMap == null) {
      throw PlatformException(
        code: 'channel-error',
        message: 'Unable to establish connection on channel.',
      );
    } else if (replyMap['error'] != null) {
      final Map<Object?, Object?> error =
          (replyMap['error'] as Map<Object?, Object?>?)!;
      throw PlatformException(
        code: (error['code'] as String?)!,
        message: error['message'] as String?,
        details: error['details'],
      );
    } else {
      return;
    }
  }

  Future<void> purge() async {
    final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
        'dev.flutter.pigeon.OfflineRegion.purge', codec,
        binaryMessenger: _binaryMessenger);
    final Map<Object?, Object?>? replyMap =
        await channel.send(null) as Map<Object?, Object?>?;
    if (replyMap == null) {
      throw PlatformException(
        code: 'channel-error',
        message: 'Unable to establish connection on channel.',
      );
    } else if (replyMap['error'] != null) {
      final Map<Object?, Object?> error =
          (replyMap['error'] as Map<Object?, Object?>?)!;
      throw PlatformException(
        code: (error['code'] as String?)!,
        message: error['message'] as String?,
        details: error['details'],
      );
    } else {
      return;
    }
  }
}

class _OfflineRegionManagerCodec extends StandardMessageCodec {
  const _OfflineRegionManagerCodec();
}

class OfflineRegionManager {
  /// Constructor for [OfflineRegionManager].  The [binaryMessenger] named argument is
  /// available for dependency injection.  If it is left null, the default
  /// BinaryMessenger will be used which routes to the host platform.
  OfflineRegionManager({BinaryMessenger? binaryMessenger})
      : _binaryMessenger = binaryMessenger;

  final BinaryMessenger? _binaryMessenger;

  static const MessageCodec<Object?> codec = _OfflineRegionManagerCodec();

  Future<void> setOfflineMapboxTileCountLimit(int arg_limit) async {
    final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
        'dev.flutter.pigeon.OfflineRegionManager.setOfflineMapboxTileCountLimit',
        codec,
        binaryMessenger: _binaryMessenger);
    final Map<Object?, Object?>? replyMap =
        await channel.send(<Object?>[arg_limit]) as Map<Object?, Object?>?;
    if (replyMap == null) {
      throw PlatformException(
        code: 'channel-error',
        message: 'Unable to establish connection on channel.',
      );
    } else if (replyMap['error'] != null) {
      final Map<Object?, Object?> error =
          (replyMap['error'] as Map<Object?, Object?>?)!;
      throw PlatformException(
        code: (error['code'] as String?)!,
        message: error['message'] as String?,
        details: error['details'],
      );
    } else {
      return;
    }
  }
}

class _ProjectionCodec extends StandardMessageCodec {
  const _ProjectionCodec();
  @override
  void writeValue(WriteBuffer buffer, Object? value) {
    if (value is CameraBounds) {
      buffer.putUint8(128);
      writeValue(buffer, value.encode());
    } else if (value is CameraBoundsOptions) {
      buffer.putUint8(129);
      writeValue(buffer, value.encode());
    } else if (value is CameraOptions) {
      buffer.putUint8(130);
      writeValue(buffer, value.encode());
    } else if (value is CameraState) {
      buffer.putUint8(131);
      writeValue(buffer, value.encode());
    } else if (value is CanonicalTileID) {
      buffer.putUint8(132);
      writeValue(buffer, value.encode());
    } else if (value is CoordinateBounds) {
      buffer.putUint8(133);
      writeValue(buffer, value.encode());
    } else if (value is CoordinateBoundsZoom) {
      buffer.putUint8(134);
      writeValue(buffer, value.encode());
    } else if (value is FeatureExtensionValue) {
      buffer.putUint8(135);
      writeValue(buffer, value.encode());
    } else if (value is GlyphsRasterizationOptions) {
      buffer.putUint8(136);
      writeValue(buffer, value.encode());
    } else if (value is ImageContent) {
      buffer.putUint8(137);
      writeValue(buffer, value.encode());
    } else if (value is ImageStretches) {
      buffer.putUint8(138);
      writeValue(buffer, value.encode());
    } else if (value is LayerPosition) {
      buffer.putUint8(139);
      writeValue(buffer, value.encode());
    } else if (value is MapAnimationOptions) {
      buffer.putUint8(140);
      writeValue(buffer, value.encode());
    } else if (value is MapDebugOptions) {
      buffer.putUint8(141);
      writeValue(buffer, value.encode());
    } else if (value is MapMemoryBudgetInMegabytes) {
      buffer.putUint8(142);
      writeValue(buffer, value.encode());
    } else if (value is MapMemoryBudgetInTiles) {
      buffer.putUint8(143);
      writeValue(buffer, value.encode());
    } else if (value is MapOptions) {
      buffer.putUint8(144);
      writeValue(buffer, value.encode());
    } else if (value is MbxEdgeInsets) {
      buffer.putUint8(145);
      writeValue(buffer, value.encode());
    } else if (value is MbxImage) {
      buffer.putUint8(146);
      writeValue(buffer, value.encode());
    } else if (value is MercatorCoordinate) {
      buffer.putUint8(147);
      writeValue(buffer, value.encode());
    } else if (value is OfflineRegionGeometryDefinition) {
      buffer.putUint8(148);
      writeValue(buffer, value.encode());
    } else if (value is OfflineRegionTilePyramidDefinition) {
      buffer.putUint8(149);
      writeValue(buffer, value.encode());
    } else if (value is ProjectedMeters) {
      buffer.putUint8(150);
      writeValue(buffer, value.encode());
    } else if (value is QueriedFeature) {
      buffer.putUint8(151);
      writeValue(buffer, value.encode());
    } else if (value is RenderedQueryGeometry) {
      buffer.putUint8(152);
      writeValue(buffer, value.encode());
    } else if (value is RenderedQueryOptions) {
      buffer.putUint8(153);
      writeValue(buffer, value.encode());
    } else if (value is ResourceOptions) {
      buffer.putUint8(154);
      writeValue(buffer, value.encode());
    } else if (value is ScreenBox) {
      buffer.putUint8(155);
      writeValue(buffer, value.encode());
    } else if (value is ScreenCoordinate) {
      buffer.putUint8(156);
      writeValue(buffer, value.encode());
    } else if (value is Size) {
      buffer.putUint8(157);
      writeValue(buffer, value.encode());
    } else if (value is SourceQueryOptions) {
      buffer.putUint8(158);
      writeValue(buffer, value.encode());
    } else if (value is StyleObjectInfo) {
      buffer.putUint8(159);
      writeValue(buffer, value.encode());
    } else if (value is StylePropertyValue) {
      buffer.putUint8(160);
      writeValue(buffer, value.encode());
    } else if (value is TransitionOptions) {
      buffer.putUint8(161);
      writeValue(buffer, value.encode());
    } else {
      super.writeValue(buffer, value);
    }
  }

  @override
  Object? readValueOfType(int type, ReadBuffer buffer) {
    switch (type) {
      case 128:
        return CameraBounds.decode(readValue(buffer)!);

      case 129:
        return CameraBoundsOptions.decode(readValue(buffer)!);

      case 130:
        return CameraOptions.decode(readValue(buffer)!);

      case 131:
        return CameraState.decode(readValue(buffer)!);

      case 132:
        return CanonicalTileID.decode(readValue(buffer)!);

      case 133:
        return CoordinateBounds.decode(readValue(buffer)!);

      case 134:
        return CoordinateBoundsZoom.decode(readValue(buffer)!);

      case 135:
        return FeatureExtensionValue.decode(readValue(buffer)!);

      case 136:
        return GlyphsRasterizationOptions.decode(readValue(buffer)!);

      case 137:
        return ImageContent.decode(readValue(buffer)!);

      case 138:
        return ImageStretches.decode(readValue(buffer)!);

      case 139:
        return LayerPosition.decode(readValue(buffer)!);

      case 140:
        return MapAnimationOptions.decode(readValue(buffer)!);

      case 141:
        return MapDebugOptions.decode(readValue(buffer)!);

      case 142:
        return MapMemoryBudgetInMegabytes.decode(readValue(buffer)!);

      case 143:
        return MapMemoryBudgetInTiles.decode(readValue(buffer)!);

      case 144:
        return MapOptions.decode(readValue(buffer)!);

      case 145:
        return MbxEdgeInsets.decode(readValue(buffer)!);

      case 146:
        return MbxImage.decode(readValue(buffer)!);

      case 147:
        return MercatorCoordinate.decode(readValue(buffer)!);

      case 148:
        return OfflineRegionGeometryDefinition.decode(readValue(buffer)!);

      case 149:
        return OfflineRegionTilePyramidDefinition.decode(readValue(buffer)!);

      case 150:
        return ProjectedMeters.decode(readValue(buffer)!);

      case 151:
        return QueriedFeature.decode(readValue(buffer)!);

      case 152:
        return RenderedQueryGeometry.decode(readValue(buffer)!);

      case 153:
        return RenderedQueryOptions.decode(readValue(buffer)!);

      case 154:
        return ResourceOptions.decode(readValue(buffer)!);

      case 155:
        return ScreenBox.decode(readValue(buffer)!);

      case 156:
        return ScreenCoordinate.decode(readValue(buffer)!);

      case 157:
        return Size.decode(readValue(buffer)!);

      case 158:
        return SourceQueryOptions.decode(readValue(buffer)!);

      case 159:
        return StyleObjectInfo.decode(readValue(buffer)!);

      case 160:
        return StylePropertyValue.decode(readValue(buffer)!);

      case 161:
        return TransitionOptions.decode(readValue(buffer)!);

      default:
        return super.readValueOfType(type, buffer);
    }
  }
}

class Projection {
  /// Constructor for [Projection].  The [binaryMessenger] named argument is
  /// available for dependency injection.  If it is left null, the default
  /// BinaryMessenger will be used which routes to the host platform.
  Projection({BinaryMessenger? binaryMessenger})
      : _binaryMessenger = binaryMessenger;

  final BinaryMessenger? _binaryMessenger;

  static const MessageCodec<Object?> codec = _ProjectionCodec();

  Future<double> getMetersPerPixelAtLatitude(
      double arg_latitude, double arg_zoom) async {
    final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
        'dev.flutter.pigeon.Projection.getMetersPerPixelAtLatitude', codec,
        binaryMessenger: _binaryMessenger);
    final Map<Object?, Object?>? replyMap = await channel
        .send(<Object?>[arg_latitude, arg_zoom]) as Map<Object?, Object?>?;
    if (replyMap == null) {
      throw PlatformException(
        code: 'channel-error',
        message: 'Unable to establish connection on channel.',
      );
    } else if (replyMap['error'] != null) {
      final Map<Object?, Object?> error =
          (replyMap['error'] as Map<Object?, Object?>?)!;
      throw PlatformException(
        code: (error['code'] as String?)!,
        message: error['message'] as String?,
        details: error['details'],
      );
    } else if (replyMap['result'] == null) {
      throw PlatformException(
        code: 'null-error',
        message: 'Host platform returned null value for non-null return value.',
      );
    } else {
      return (replyMap['result'] as double?)!;
    }
  }

  Future<ProjectedMeters> projectedMetersForCoordinate(
      Map<String?, Object?> arg_coordinate) async {
    final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
        'dev.flutter.pigeon.Projection.projectedMetersForCoordinate', codec,
        binaryMessenger: _binaryMessenger);
    final Map<Object?, Object?>? replyMap =
        await channel.send(<Object?>[arg_coordinate]) as Map<Object?, Object?>?;
    if (replyMap == null) {
      throw PlatformException(
        code: 'channel-error',
        message: 'Unable to establish connection on channel.',
      );
    } else if (replyMap['error'] != null) {
      final Map<Object?, Object?> error =
          (replyMap['error'] as Map<Object?, Object?>?)!;
      throw PlatformException(
        code: (error['code'] as String?)!,
        message: error['message'] as String?,
        details: error['details'],
      );
    } else if (replyMap['result'] == null) {
      throw PlatformException(
        code: 'null-error',
        message: 'Host platform returned null value for non-null return value.',
      );
    } else {
      return (replyMap['result'] as ProjectedMeters?)!;
    }
  }

  Future<Map<String?, Object?>> coordinateForProjectedMeters(
      ProjectedMeters arg_projectedMeters) async {
    final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
        'dev.flutter.pigeon.Projection.coordinateForProjectedMeters', codec,
        binaryMessenger: _binaryMessenger);
    final Map<Object?, Object?>? replyMap = await channel
        .send(<Object?>[arg_projectedMeters]) as Map<Object?, Object?>?;
    if (replyMap == null) {
      throw PlatformException(
        code: 'channel-error',
        message: 'Unable to establish connection on channel.',
      );
    } else if (replyMap['error'] != null) {
      final Map<Object?, Object?> error =
          (replyMap['error'] as Map<Object?, Object?>?)!;
      throw PlatformException(
        code: (error['code'] as String?)!,
        message: error['message'] as String?,
        details: error['details'],
      );
    } else if (replyMap['result'] == null) {
      throw PlatformException(
        code: 'null-error',
        message: 'Host platform returned null value for non-null return value.',
      );
    } else {
      return (replyMap['result'] as Map<Object?, Object?>?)!
          .cast<String?, Object?>();
    }
  }

  Future<MercatorCoordinate> project(
      Map<String?, Object?> arg_coordinate, double arg_zoomScale) async {
    final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
        'dev.flutter.pigeon.Projection.project', codec,
        binaryMessenger: _binaryMessenger);
    final Map<Object?, Object?>? replyMap =
        await channel.send(<Object?>[arg_coordinate, arg_zoomScale])
            as Map<Object?, Object?>?;
    if (replyMap == null) {
      throw PlatformException(
        code: 'channel-error',
        message: 'Unable to establish connection on channel.',
      );
    } else if (replyMap['error'] != null) {
      final Map<Object?, Object?> error =
          (replyMap['error'] as Map<Object?, Object?>?)!;
      throw PlatformException(
        code: (error['code'] as String?)!,
        message: error['message'] as String?,
        details: error['details'],
      );
    } else if (replyMap['result'] == null) {
      throw PlatformException(
        code: 'null-error',
        message: 'Host platform returned null value for non-null return value.',
      );
    } else {
      return (replyMap['result'] as MercatorCoordinate?)!;
    }
  }

  Future<Map<String?, Object?>> unproject(
      MercatorCoordinate arg_coordinate, double arg_zoomScale) async {
    final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
        'dev.flutter.pigeon.Projection.unproject', codec,
        binaryMessenger: _binaryMessenger);
    final Map<Object?, Object?>? replyMap =
        await channel.send(<Object?>[arg_coordinate, arg_zoomScale])
            as Map<Object?, Object?>?;
    if (replyMap == null) {
      throw PlatformException(
        code: 'channel-error',
        message: 'Unable to establish connection on channel.',
      );
    } else if (replyMap['error'] != null) {
      final Map<Object?, Object?> error =
          (replyMap['error'] as Map<Object?, Object?>?)!;
      throw PlatformException(
        code: (error['code'] as String?)!,
        message: error['message'] as String?,
        details: error['details'],
      );
    } else if (replyMap['result'] == null) {
      throw PlatformException(
        code: 'null-error',
        message: 'Host platform returned null value for non-null return value.',
      );
    } else {
      return (replyMap['result'] as Map<Object?, Object?>?)!
          .cast<String?, Object?>();
    }
  }
}

class _SettingsCodec extends StandardMessageCodec {
  const _SettingsCodec();
}

class Settings {
  /// Constructor for [Settings].  The [binaryMessenger] named argument is
  /// available for dependency injection.  If it is left null, the default
  /// BinaryMessenger will be used which routes to the host platform.
  Settings({BinaryMessenger? binaryMessenger})
      : _binaryMessenger = binaryMessenger;

  final BinaryMessenger? _binaryMessenger;

  static const MessageCodec<Object?> codec = _SettingsCodec();

  Future<void> set(String arg_key, String arg_value) async {
    final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
        'dev.flutter.pigeon.Settings.set', codec,
        binaryMessenger: _binaryMessenger);
    final Map<Object?, Object?>? replyMap = await channel
        .send(<Object?>[arg_key, arg_value]) as Map<Object?, Object?>?;
    if (replyMap == null) {
      throw PlatformException(
        code: 'channel-error',
        message: 'Unable to establish connection on channel.',
      );
    } else if (replyMap['error'] != null) {
      final Map<Object?, Object?> error =
          (replyMap['error'] as Map<Object?, Object?>?)!;
      throw PlatformException(
        code: (error['code'] as String?)!,
        message: error['message'] as String?,
        details: error['details'],
      );
    } else {
      return;
    }
  }

  Future<String> get(String arg_key) async {
    final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
        'dev.flutter.pigeon.Settings.get', codec,
        binaryMessenger: _binaryMessenger);
    final Map<Object?, Object?>? replyMap =
        await channel.send(<Object?>[arg_key]) as Map<Object?, Object?>?;
    if (replyMap == null) {
      throw PlatformException(
        code: 'channel-error',
        message: 'Unable to establish connection on channel.',
      );
    } else if (replyMap['error'] != null) {
      final Map<Object?, Object?> error =
          (replyMap['error'] as Map<Object?, Object?>?)!;
      throw PlatformException(
        code: (error['code'] as String?)!,
        message: error['message'] as String?,
        details: error['details'],
      );
    } else if (replyMap['result'] == null) {
      throw PlatformException(
        code: 'null-error',
        message: 'Host platform returned null value for non-null return value.',
      );
    } else {
      return (replyMap['result'] as String?)!;
    }
  }
}

class _MapSnapshotCodec extends StandardMessageCodec {
  const _MapSnapshotCodec();
  @override
  void writeValue(WriteBuffer buffer, Object? value) {
    if (value is CameraBounds) {
      buffer.putUint8(128);
      writeValue(buffer, value.encode());
    } else if (value is CameraBoundsOptions) {
      buffer.putUint8(129);
      writeValue(buffer, value.encode());
    } else if (value is CameraOptions) {
      buffer.putUint8(130);
      writeValue(buffer, value.encode());
    } else if (value is CameraState) {
      buffer.putUint8(131);
      writeValue(buffer, value.encode());
    } else if (value is CanonicalTileID) {
      buffer.putUint8(132);
      writeValue(buffer, value.encode());
    } else if (value is CoordinateBounds) {
      buffer.putUint8(133);
      writeValue(buffer, value.encode());
    } else if (value is CoordinateBoundsZoom) {
      buffer.putUint8(134);
      writeValue(buffer, value.encode());
    } else if (value is FeatureExtensionValue) {
      buffer.putUint8(135);
      writeValue(buffer, value.encode());
    } else if (value is GlyphsRasterizationOptions) {
      buffer.putUint8(136);
      writeValue(buffer, value.encode());
    } else if (value is ImageContent) {
      buffer.putUint8(137);
      writeValue(buffer, value.encode());
    } else if (value is ImageStretches) {
      buffer.putUint8(138);
      writeValue(buffer, value.encode());
    } else if (value is LayerPosition) {
      buffer.putUint8(139);
      writeValue(buffer, value.encode());
    } else if (value is MapAnimationOptions) {
      buffer.putUint8(140);
      writeValue(buffer, value.encode());
    } else if (value is MapDebugOptions) {
      buffer.putUint8(141);
      writeValue(buffer, value.encode());
    } else if (value is MapMemoryBudgetInMegabytes) {
      buffer.putUint8(142);
      writeValue(buffer, value.encode());
    } else if (value is MapMemoryBudgetInTiles) {
      buffer.putUint8(143);
      writeValue(buffer, value.encode());
    } else if (value is MapOptions) {
      buffer.putUint8(144);
      writeValue(buffer, value.encode());
    } else if (value is MbxEdgeInsets) {
      buffer.putUint8(145);
      writeValue(buffer, value.encode());
    } else if (value is MbxImage) {
      buffer.putUint8(146);
      writeValue(buffer, value.encode());
    } else if (value is MercatorCoordinate) {
      buffer.putUint8(147);
      writeValue(buffer, value.encode());
    } else if (value is OfflineRegionGeometryDefinition) {
      buffer.putUint8(148);
      writeValue(buffer, value.encode());
    } else if (value is OfflineRegionTilePyramidDefinition) {
      buffer.putUint8(149);
      writeValue(buffer, value.encode());
    } else if (value is ProjectedMeters) {
      buffer.putUint8(150);
      writeValue(buffer, value.encode());
    } else if (value is QueriedFeature) {
      buffer.putUint8(151);
      writeValue(buffer, value.encode());
    } else if (value is RenderedQueryGeometry) {
      buffer.putUint8(152);
      writeValue(buffer, value.encode());
    } else if (value is RenderedQueryOptions) {
      buffer.putUint8(153);
      writeValue(buffer, value.encode());
    } else if (value is ResourceOptions) {
      buffer.putUint8(154);
      writeValue(buffer, value.encode());
    } else if (value is ScreenBox) {
      buffer.putUint8(155);
      writeValue(buffer, value.encode());
    } else if (value is ScreenCoordinate) {
      buffer.putUint8(156);
      writeValue(buffer, value.encode());
    } else if (value is Size) {
      buffer.putUint8(157);
      writeValue(buffer, value.encode());
    } else if (value is SourceQueryOptions) {
      buffer.putUint8(158);
      writeValue(buffer, value.encode());
    } else if (value is StyleObjectInfo) {
      buffer.putUint8(159);
      writeValue(buffer, value.encode());
    } else if (value is StylePropertyValue) {
      buffer.putUint8(160);
      writeValue(buffer, value.encode());
    } else if (value is TransitionOptions) {
      buffer.putUint8(161);
      writeValue(buffer, value.encode());
    } else {
      super.writeValue(buffer, value);
    }
  }

  @override
  Object? readValueOfType(int type, ReadBuffer buffer) {
    switch (type) {
      case 128:
        return CameraBounds.decode(readValue(buffer)!);

      case 129:
        return CameraBoundsOptions.decode(readValue(buffer)!);

      case 130:
        return CameraOptions.decode(readValue(buffer)!);

      case 131:
        return CameraState.decode(readValue(buffer)!);

      case 132:
        return CanonicalTileID.decode(readValue(buffer)!);

      case 133:
        return CoordinateBounds.decode(readValue(buffer)!);

      case 134:
        return CoordinateBoundsZoom.decode(readValue(buffer)!);

      case 135:
        return FeatureExtensionValue.decode(readValue(buffer)!);

      case 136:
        return GlyphsRasterizationOptions.decode(readValue(buffer)!);

      case 137:
        return ImageContent.decode(readValue(buffer)!);

      case 138:
        return ImageStretches.decode(readValue(buffer)!);

      case 139:
        return LayerPosition.decode(readValue(buffer)!);

      case 140:
        return MapAnimationOptions.decode(readValue(buffer)!);

      case 141:
        return MapDebugOptions.decode(readValue(buffer)!);

      case 142:
        return MapMemoryBudgetInMegabytes.decode(readValue(buffer)!);

      case 143:
        return MapMemoryBudgetInTiles.decode(readValue(buffer)!);

      case 144:
        return MapOptions.decode(readValue(buffer)!);

      case 145:
        return MbxEdgeInsets.decode(readValue(buffer)!);

      case 146:
        return MbxImage.decode(readValue(buffer)!);

      case 147:
        return MercatorCoordinate.decode(readValue(buffer)!);

      case 148:
        return OfflineRegionGeometryDefinition.decode(readValue(buffer)!);

      case 149:
        return OfflineRegionTilePyramidDefinition.decode(readValue(buffer)!);

      case 150:
        return ProjectedMeters.decode(readValue(buffer)!);

      case 151:
        return QueriedFeature.decode(readValue(buffer)!);

      case 152:
        return RenderedQueryGeometry.decode(readValue(buffer)!);

      case 153:
        return RenderedQueryOptions.decode(readValue(buffer)!);

      case 154:
        return ResourceOptions.decode(readValue(buffer)!);

      case 155:
        return ScreenBox.decode(readValue(buffer)!);

      case 156:
        return ScreenCoordinate.decode(readValue(buffer)!);

      case 157:
        return Size.decode(readValue(buffer)!);

      case 158:
        return SourceQueryOptions.decode(readValue(buffer)!);

      case 159:
        return StyleObjectInfo.decode(readValue(buffer)!);

      case 160:
        return StylePropertyValue.decode(readValue(buffer)!);

      case 161:
        return TransitionOptions.decode(readValue(buffer)!);

      default:
        return super.readValueOfType(type, buffer);
    }
  }
}

class MapSnapshot {
  /// Constructor for [MapSnapshot].  The [binaryMessenger] named argument is
  /// available for dependency injection.  If it is left null, the default
  /// BinaryMessenger will be used which routes to the host platform.
  MapSnapshot({BinaryMessenger? binaryMessenger})
      : _binaryMessenger = binaryMessenger;

  final BinaryMessenger? _binaryMessenger;

  static const MessageCodec<Object?> codec = _MapSnapshotCodec();

  Future<ScreenCoordinate> screenCoordinate(
      Map<String?, Object?> arg_coordinate) async {
    final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
        'dev.flutter.pigeon.MapSnapshot.screenCoordinate', codec,
        binaryMessenger: _binaryMessenger);
    final Map<Object?, Object?>? replyMap =
        await channel.send(<Object?>[arg_coordinate]) as Map<Object?, Object?>?;
    if (replyMap == null) {
      throw PlatformException(
        code: 'channel-error',
        message: 'Unable to establish connection on channel.',
      );
    } else if (replyMap['error'] != null) {
      final Map<Object?, Object?> error =
          (replyMap['error'] as Map<Object?, Object?>?)!;
      throw PlatformException(
        code: (error['code'] as String?)!,
        message: error['message'] as String?,
        details: error['details'],
      );
    } else if (replyMap['result'] == null) {
      throw PlatformException(
        code: 'null-error',
        message: 'Host platform returned null value for non-null return value.',
      );
    } else {
      return (replyMap['result'] as ScreenCoordinate?)!;
    }
  }

  Future<Map<String?, Object?>> coordinate(
      ScreenCoordinate arg_screenCoordinate) async {
    final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
        'dev.flutter.pigeon.MapSnapshot.coordinate', codec,
        binaryMessenger: _binaryMessenger);
    final Map<Object?, Object?>? replyMap = await channel
        .send(<Object?>[arg_screenCoordinate]) as Map<Object?, Object?>?;
    if (replyMap == null) {
      throw PlatformException(
        code: 'channel-error',
        message: 'Unable to establish connection on channel.',
      );
    } else if (replyMap['error'] != null) {
      final Map<Object?, Object?> error =
          (replyMap['error'] as Map<Object?, Object?>?)!;
      throw PlatformException(
        code: (error['code'] as String?)!,
        message: error['message'] as String?,
        details: error['details'],
      );
    } else if (replyMap['result'] == null) {
      throw PlatformException(
        code: 'null-error',
        message: 'Host platform returned null value for non-null return value.',
      );
    } else {
      return (replyMap['result'] as Map<Object?, Object?>?)!
          .cast<String?, Object?>();
    }
  }

  Future<List<String?>> attributions() async {
    final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
        'dev.flutter.pigeon.MapSnapshot.attributions', codec,
        binaryMessenger: _binaryMessenger);
    final Map<Object?, Object?>? replyMap =
        await channel.send(null) as Map<Object?, Object?>?;
    if (replyMap == null) {
      throw PlatformException(
        code: 'channel-error',
        message: 'Unable to establish connection on channel.',
      );
    } else if (replyMap['error'] != null) {
      final Map<Object?, Object?> error =
          (replyMap['error'] as Map<Object?, Object?>?)!;
      throw PlatformException(
        code: (error['code'] as String?)!,
        message: error['message'] as String?,
        details: error['details'],
      );
    } else if (replyMap['result'] == null) {
      throw PlatformException(
        code: 'null-error',
        message: 'Host platform returned null value for non-null return value.',
      );
    } else {
      return (replyMap['result'] as List<Object?>?)!.cast<String?>();
    }
  }

  Future<MbxImage> image() async {
    final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
        'dev.flutter.pigeon.MapSnapshot.image', codec,
        binaryMessenger: _binaryMessenger);
    final Map<Object?, Object?>? replyMap =
        await channel.send(null) as Map<Object?, Object?>?;
    if (replyMap == null) {
      throw PlatformException(
        code: 'channel-error',
        message: 'Unable to establish connection on channel.',
      );
    } else if (replyMap['error'] != null) {
      final Map<Object?, Object?> error =
          (replyMap['error'] as Map<Object?, Object?>?)!;
      throw PlatformException(
        code: (error['code'] as String?)!,
        message: error['message'] as String?,
        details: error['details'],
      );
    } else if (replyMap['result'] == null) {
      throw PlatformException(
        code: 'null-error',
        message: 'Host platform returned null value for non-null return value.',
      );
    } else {
      return (replyMap['result'] as MbxImage?)!;
    }
  }
}

class _MapSnapshotterCodec extends StandardMessageCodec {
  const _MapSnapshotterCodec();
  @override
  void writeValue(WriteBuffer buffer, Object? value) {
    if (value is CameraBounds) {
      buffer.putUint8(128);
      writeValue(buffer, value.encode());
    } else if (value is CameraBoundsOptions) {
      buffer.putUint8(129);
      writeValue(buffer, value.encode());
    } else if (value is CameraOptions) {
      buffer.putUint8(130);
      writeValue(buffer, value.encode());
    } else if (value is CameraState) {
      buffer.putUint8(131);
      writeValue(buffer, value.encode());
    } else if (value is CanonicalTileID) {
      buffer.putUint8(132);
      writeValue(buffer, value.encode());
    } else if (value is CoordinateBounds) {
      buffer.putUint8(133);
      writeValue(buffer, value.encode());
    } else if (value is CoordinateBoundsZoom) {
      buffer.putUint8(134);
      writeValue(buffer, value.encode());
    } else if (value is FeatureExtensionValue) {
      buffer.putUint8(135);
      writeValue(buffer, value.encode());
    } else if (value is GlyphsRasterizationOptions) {
      buffer.putUint8(136);
      writeValue(buffer, value.encode());
    } else if (value is ImageContent) {
      buffer.putUint8(137);
      writeValue(buffer, value.encode());
    } else if (value is ImageStretches) {
      buffer.putUint8(138);
      writeValue(buffer, value.encode());
    } else if (value is LayerPosition) {
      buffer.putUint8(139);
      writeValue(buffer, value.encode());
    } else if (value is MapAnimationOptions) {
      buffer.putUint8(140);
      writeValue(buffer, value.encode());
    } else if (value is MapDebugOptions) {
      buffer.putUint8(141);
      writeValue(buffer, value.encode());
    } else if (value is MapMemoryBudgetInMegabytes) {
      buffer.putUint8(142);
      writeValue(buffer, value.encode());
    } else if (value is MapMemoryBudgetInTiles) {
      buffer.putUint8(143);
      writeValue(buffer, value.encode());
    } else if (value is MapOptions) {
      buffer.putUint8(144);
      writeValue(buffer, value.encode());
    } else if (value is MbxEdgeInsets) {
      buffer.putUint8(145);
      writeValue(buffer, value.encode());
    } else if (value is MbxImage) {
      buffer.putUint8(146);
      writeValue(buffer, value.encode());
    } else if (value is MercatorCoordinate) {
      buffer.putUint8(147);
      writeValue(buffer, value.encode());
    } else if (value is OfflineRegionGeometryDefinition) {
      buffer.putUint8(148);
      writeValue(buffer, value.encode());
    } else if (value is OfflineRegionTilePyramidDefinition) {
      buffer.putUint8(149);
      writeValue(buffer, value.encode());
    } else if (value is ProjectedMeters) {
      buffer.putUint8(150);
      writeValue(buffer, value.encode());
    } else if (value is QueriedFeature) {
      buffer.putUint8(151);
      writeValue(buffer, value.encode());
    } else if (value is RenderedQueryGeometry) {
      buffer.putUint8(152);
      writeValue(buffer, value.encode());
    } else if (value is RenderedQueryOptions) {
      buffer.putUint8(153);
      writeValue(buffer, value.encode());
    } else if (value is ResourceOptions) {
      buffer.putUint8(154);
      writeValue(buffer, value.encode());
    } else if (value is ScreenBox) {
      buffer.putUint8(155);
      writeValue(buffer, value.encode());
    } else if (value is ScreenCoordinate) {
      buffer.putUint8(156);
      writeValue(buffer, value.encode());
    } else if (value is Size) {
      buffer.putUint8(157);
      writeValue(buffer, value.encode());
    } else if (value is SourceQueryOptions) {
      buffer.putUint8(158);
      writeValue(buffer, value.encode());
    } else if (value is StyleObjectInfo) {
      buffer.putUint8(159);
      writeValue(buffer, value.encode());
    } else if (value is StylePropertyValue) {
      buffer.putUint8(160);
      writeValue(buffer, value.encode());
    } else if (value is TransitionOptions) {
      buffer.putUint8(161);
      writeValue(buffer, value.encode());
    } else {
      super.writeValue(buffer, value);
    }
  }

  @override
  Object? readValueOfType(int type, ReadBuffer buffer) {
    switch (type) {
      case 128:
        return CameraBounds.decode(readValue(buffer)!);

      case 129:
        return CameraBoundsOptions.decode(readValue(buffer)!);

      case 130:
        return CameraOptions.decode(readValue(buffer)!);

      case 131:
        return CameraState.decode(readValue(buffer)!);

      case 132:
        return CanonicalTileID.decode(readValue(buffer)!);

      case 133:
        return CoordinateBounds.decode(readValue(buffer)!);

      case 134:
        return CoordinateBoundsZoom.decode(readValue(buffer)!);

      case 135:
        return FeatureExtensionValue.decode(readValue(buffer)!);

      case 136:
        return GlyphsRasterizationOptions.decode(readValue(buffer)!);

      case 137:
        return ImageContent.decode(readValue(buffer)!);

      case 138:
        return ImageStretches.decode(readValue(buffer)!);

      case 139:
        return LayerPosition.decode(readValue(buffer)!);

      case 140:
        return MapAnimationOptions.decode(readValue(buffer)!);

      case 141:
        return MapDebugOptions.decode(readValue(buffer)!);

      case 142:
        return MapMemoryBudgetInMegabytes.decode(readValue(buffer)!);

      case 143:
        return MapMemoryBudgetInTiles.decode(readValue(buffer)!);

      case 144:
        return MapOptions.decode(readValue(buffer)!);

      case 145:
        return MbxEdgeInsets.decode(readValue(buffer)!);

      case 146:
        return MbxImage.decode(readValue(buffer)!);

      case 147:
        return MercatorCoordinate.decode(readValue(buffer)!);

      case 148:
        return OfflineRegionGeometryDefinition.decode(readValue(buffer)!);

      case 149:
        return OfflineRegionTilePyramidDefinition.decode(readValue(buffer)!);

      case 150:
        return ProjectedMeters.decode(readValue(buffer)!);

      case 151:
        return QueriedFeature.decode(readValue(buffer)!);

      case 152:
        return RenderedQueryGeometry.decode(readValue(buffer)!);

      case 153:
        return RenderedQueryOptions.decode(readValue(buffer)!);

      case 154:
        return ResourceOptions.decode(readValue(buffer)!);

      case 155:
        return ScreenBox.decode(readValue(buffer)!);

      case 156:
        return ScreenCoordinate.decode(readValue(buffer)!);

      case 157:
        return Size.decode(readValue(buffer)!);

      case 158:
        return SourceQueryOptions.decode(readValue(buffer)!);

      case 159:
        return StyleObjectInfo.decode(readValue(buffer)!);

      case 160:
        return StylePropertyValue.decode(readValue(buffer)!);

      case 161:
        return TransitionOptions.decode(readValue(buffer)!);

      default:
        return super.readValueOfType(type, buffer);
    }
  }
}

class MapSnapshotter {
  /// Constructor for [MapSnapshotter].  The [binaryMessenger] named argument is
  /// available for dependency injection.  If it is left null, the default
  /// BinaryMessenger will be used which routes to the host platform.
  MapSnapshotter({BinaryMessenger? binaryMessenger})
      : _binaryMessenger = binaryMessenger;

  final BinaryMessenger? _binaryMessenger;

  static const MessageCodec<Object?> codec = _MapSnapshotterCodec();

  Future<void> setSize(Size arg_size) async {
    final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
        'dev.flutter.pigeon.MapSnapshotter.setSize', codec,
        binaryMessenger: _binaryMessenger);
    final Map<Object?, Object?>? replyMap =
        await channel.send(<Object?>[arg_size]) as Map<Object?, Object?>?;
    if (replyMap == null) {
      throw PlatformException(
        code: 'channel-error',
        message: 'Unable to establish connection on channel.',
      );
    } else if (replyMap['error'] != null) {
      final Map<Object?, Object?> error =
          (replyMap['error'] as Map<Object?, Object?>?)!;
      throw PlatformException(
        code: (error['code'] as String?)!,
        message: error['message'] as String?,
        details: error['details'],
      );
    } else {
      return;
    }
  }

  Future<Size> getSize() async {
    final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
        'dev.flutter.pigeon.MapSnapshotter.getSize', codec,
        binaryMessenger: _binaryMessenger);
    final Map<Object?, Object?>? replyMap =
        await channel.send(null) as Map<Object?, Object?>?;
    if (replyMap == null) {
      throw PlatformException(
        code: 'channel-error',
        message: 'Unable to establish connection on channel.',
      );
    } else if (replyMap['error'] != null) {
      final Map<Object?, Object?> error =
          (replyMap['error'] as Map<Object?, Object?>?)!;
      throw PlatformException(
        code: (error['code'] as String?)!,
        message: error['message'] as String?,
        details: error['details'],
      );
    } else if (replyMap['result'] == null) {
      throw PlatformException(
        code: 'null-error',
        message: 'Host platform returned null value for non-null return value.',
      );
    } else {
      return (replyMap['result'] as Size?)!;
    }
  }

  Future<bool> isInTileMode() async {
    final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
        'dev.flutter.pigeon.MapSnapshotter.isInTileMode', codec,
        binaryMessenger: _binaryMessenger);
    final Map<Object?, Object?>? replyMap =
        await channel.send(null) as Map<Object?, Object?>?;
    if (replyMap == null) {
      throw PlatformException(
        code: 'channel-error',
        message: 'Unable to establish connection on channel.',
      );
    } else if (replyMap['error'] != null) {
      final Map<Object?, Object?> error =
          (replyMap['error'] as Map<Object?, Object?>?)!;
      throw PlatformException(
        code: (error['code'] as String?)!,
        message: error['message'] as String?,
        details: error['details'],
      );
    } else if (replyMap['result'] == null) {
      throw PlatformException(
        code: 'null-error',
        message: 'Host platform returned null value for non-null return value.',
      );
    } else {
      return (replyMap['result'] as bool?)!;
    }
  }

  Future<void> setTileMode(bool arg_set) async {
    final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
        'dev.flutter.pigeon.MapSnapshotter.setTileMode', codec,
        binaryMessenger: _binaryMessenger);
    final Map<Object?, Object?>? replyMap =
        await channel.send(<Object?>[arg_set]) as Map<Object?, Object?>?;
    if (replyMap == null) {
      throw PlatformException(
        code: 'channel-error',
        message: 'Unable to establish connection on channel.',
      );
    } else if (replyMap['error'] != null) {
      final Map<Object?, Object?> error =
          (replyMap['error'] as Map<Object?, Object?>?)!;
      throw PlatformException(
        code: (error['code'] as String?)!,
        message: error['message'] as String?,
        details: error['details'],
      );
    } else {
      return;
    }
  }

  Future<void> cancel() async {
    final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
        'dev.flutter.pigeon.MapSnapshotter.cancel', codec,
        binaryMessenger: _binaryMessenger);
    final Map<Object?, Object?>? replyMap =
        await channel.send(null) as Map<Object?, Object?>?;
    if (replyMap == null) {
      throw PlatformException(
        code: 'channel-error',
        message: 'Unable to establish connection on channel.',
      );
    } else if (replyMap['error'] != null) {
      final Map<Object?, Object?> error =
          (replyMap['error'] as Map<Object?, Object?>?)!;
      throw PlatformException(
        code: (error['code'] as String?)!,
        message: error['message'] as String?,
        details: error['details'],
      );
    } else {
      return;
    }
  }

  Future<double?> getElevation(Map<String?, Object?> arg_coordinate) async {
    final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
        'dev.flutter.pigeon.MapSnapshotter.getElevation', codec,
        binaryMessenger: _binaryMessenger);
    final Map<Object?, Object?>? replyMap =
        await channel.send(<Object?>[arg_coordinate]) as Map<Object?, Object?>?;
    if (replyMap == null) {
      throw PlatformException(
        code: 'channel-error',
        message: 'Unable to establish connection on channel.',
      );
    } else if (replyMap['error'] != null) {
      final Map<Object?, Object?> error =
          (replyMap['error'] as Map<Object?, Object?>?)!;
      throw PlatformException(
        code: (error['code'] as String?)!,
        message: error['message'] as String?,
        details: error['details'],
      );
    } else {
      return (replyMap['result'] as double?);
    }
  }
}

class _StyleManagerCodec extends StandardMessageCodec {
  const _StyleManagerCodec();
  @override
  void writeValue(WriteBuffer buffer, Object? value) {
    if (value is CameraBounds) {
      buffer.putUint8(128);
      writeValue(buffer, value.encode());
    } else if (value is CameraBoundsOptions) {
      buffer.putUint8(129);
      writeValue(buffer, value.encode());
    } else if (value is CameraOptions) {
      buffer.putUint8(130);
      writeValue(buffer, value.encode());
    } else if (value is CameraState) {
      buffer.putUint8(131);
      writeValue(buffer, value.encode());
    } else if (value is CanonicalTileID) {
      buffer.putUint8(132);
      writeValue(buffer, value.encode());
    } else if (value is CoordinateBounds) {
      buffer.putUint8(133);
      writeValue(buffer, value.encode());
    } else if (value is CoordinateBoundsZoom) {
      buffer.putUint8(134);
      writeValue(buffer, value.encode());
    } else if (value is FeatureExtensionValue) {
      buffer.putUint8(135);
      writeValue(buffer, value.encode());
    } else if (value is GlyphsRasterizationOptions) {
      buffer.putUint8(136);
      writeValue(buffer, value.encode());
    } else if (value is ImageContent) {
      buffer.putUint8(137);
      writeValue(buffer, value.encode());
    } else if (value is ImageStretches) {
      buffer.putUint8(138);
      writeValue(buffer, value.encode());
    } else if (value is LayerPosition) {
      buffer.putUint8(139);
      writeValue(buffer, value.encode());
    } else if (value is MapAnimationOptions) {
      buffer.putUint8(140);
      writeValue(buffer, value.encode());
    } else if (value is MapDebugOptions) {
      buffer.putUint8(141);
      writeValue(buffer, value.encode());
    } else if (value is MapMemoryBudgetInMegabytes) {
      buffer.putUint8(142);
      writeValue(buffer, value.encode());
    } else if (value is MapMemoryBudgetInTiles) {
      buffer.putUint8(143);
      writeValue(buffer, value.encode());
    } else if (value is MapOptions) {
      buffer.putUint8(144);
      writeValue(buffer, value.encode());
    } else if (value is MbxEdgeInsets) {
      buffer.putUint8(145);
      writeValue(buffer, value.encode());
    } else if (value is MbxImage) {
      buffer.putUint8(146);
      writeValue(buffer, value.encode());
    } else if (value is MercatorCoordinate) {
      buffer.putUint8(147);
      writeValue(buffer, value.encode());
    } else if (value is OfflineRegionGeometryDefinition) {
      buffer.putUint8(148);
      writeValue(buffer, value.encode());
    } else if (value is OfflineRegionTilePyramidDefinition) {
      buffer.putUint8(149);
      writeValue(buffer, value.encode());
    } else if (value is ProjectedMeters) {
      buffer.putUint8(150);
      writeValue(buffer, value.encode());
    } else if (value is QueriedFeature) {
      buffer.putUint8(151);
      writeValue(buffer, value.encode());
    } else if (value is RenderedQueryGeometry) {
      buffer.putUint8(152);
      writeValue(buffer, value.encode());
    } else if (value is RenderedQueryOptions) {
      buffer.putUint8(153);
      writeValue(buffer, value.encode());
    } else if (value is ResourceOptions) {
      buffer.putUint8(154);
      writeValue(buffer, value.encode());
    } else if (value is ScreenBox) {
      buffer.putUint8(155);
      writeValue(buffer, value.encode());
    } else if (value is ScreenCoordinate) {
      buffer.putUint8(156);
      writeValue(buffer, value.encode());
    } else if (value is Size) {
      buffer.putUint8(157);
      writeValue(buffer, value.encode());
    } else if (value is SourceQueryOptions) {
      buffer.putUint8(158);
      writeValue(buffer, value.encode());
    } else if (value is StyleObjectInfo) {
      buffer.putUint8(159);
      writeValue(buffer, value.encode());
    } else if (value is StylePropertyValue) {
      buffer.putUint8(160);
      writeValue(buffer, value.encode());
    } else if (value is TransitionOptions) {
      buffer.putUint8(161);
      writeValue(buffer, value.encode());
    } else {
      super.writeValue(buffer, value);
    }
  }

  @override
  Object? readValueOfType(int type, ReadBuffer buffer) {
    switch (type) {
      case 128:
        return CameraBounds.decode(readValue(buffer)!);

      case 129:
        return CameraBoundsOptions.decode(readValue(buffer)!);

      case 130:
        return CameraOptions.decode(readValue(buffer)!);

      case 131:
        return CameraState.decode(readValue(buffer)!);

      case 132:
        return CanonicalTileID.decode(readValue(buffer)!);

      case 133:
        return CoordinateBounds.decode(readValue(buffer)!);

      case 134:
        return CoordinateBoundsZoom.decode(readValue(buffer)!);

      case 135:
        return FeatureExtensionValue.decode(readValue(buffer)!);

      case 136:
        return GlyphsRasterizationOptions.decode(readValue(buffer)!);

      case 137:
        return ImageContent.decode(readValue(buffer)!);

      case 138:
        return ImageStretches.decode(readValue(buffer)!);

      case 139:
        return LayerPosition.decode(readValue(buffer)!);

      case 140:
        return MapAnimationOptions.decode(readValue(buffer)!);

      case 141:
        return MapDebugOptions.decode(readValue(buffer)!);

      case 142:
        return MapMemoryBudgetInMegabytes.decode(readValue(buffer)!);

      case 143:
        return MapMemoryBudgetInTiles.decode(readValue(buffer)!);

      case 144:
        return MapOptions.decode(readValue(buffer)!);

      case 145:
        return MbxEdgeInsets.decode(readValue(buffer)!);

      case 146:
        return MbxImage.decode(readValue(buffer)!);

      case 147:
        return MercatorCoordinate.decode(readValue(buffer)!);

      case 148:
        return OfflineRegionGeometryDefinition.decode(readValue(buffer)!);

      case 149:
        return OfflineRegionTilePyramidDefinition.decode(readValue(buffer)!);

      case 150:
        return ProjectedMeters.decode(readValue(buffer)!);

      case 151:
        return QueriedFeature.decode(readValue(buffer)!);

      case 152:
        return RenderedQueryGeometry.decode(readValue(buffer)!);

      case 153:
        return RenderedQueryOptions.decode(readValue(buffer)!);

      case 154:
        return ResourceOptions.decode(readValue(buffer)!);

      case 155:
        return ScreenBox.decode(readValue(buffer)!);

      case 156:
        return ScreenCoordinate.decode(readValue(buffer)!);

      case 157:
        return Size.decode(readValue(buffer)!);

      case 158:
        return SourceQueryOptions.decode(readValue(buffer)!);

      case 159:
        return StyleObjectInfo.decode(readValue(buffer)!);

      case 160:
        return StylePropertyValue.decode(readValue(buffer)!);

      case 161:
        return TransitionOptions.decode(readValue(buffer)!);

      default:
        return super.readValueOfType(type, buffer);
    }
  }
}

class StyleManager {
  /// Constructor for [StyleManager].  The [binaryMessenger] named argument is
  /// available for dependency injection.  If it is left null, the default
  /// BinaryMessenger will be used which routes to the host platform.
  StyleManager({BinaryMessenger? binaryMessenger})
      : _binaryMessenger = binaryMessenger;

  final BinaryMessenger? _binaryMessenger;

  static const MessageCodec<Object?> codec = _StyleManagerCodec();

  Future<String> getStyleURI() async {
    final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
        'dev.flutter.pigeon.StyleManager.getStyleURI', codec,
        binaryMessenger: _binaryMessenger);
    final Map<Object?, Object?>? replyMap =
        await channel.send(null) as Map<Object?, Object?>?;
    if (replyMap == null) {
      throw PlatformException(
        code: 'channel-error',
        message: 'Unable to establish connection on channel.',
      );
    } else if (replyMap['error'] != null) {
      final Map<Object?, Object?> error =
          (replyMap['error'] as Map<Object?, Object?>?)!;
      throw PlatformException(
        code: (error['code'] as String?)!,
        message: error['message'] as String?,
        details: error['details'],
      );
    } else if (replyMap['result'] == null) {
      throw PlatformException(
        code: 'null-error',
        message: 'Host platform returned null value for non-null return value.',
      );
    } else {
      return (replyMap['result'] as String?)!;
    }
  }

  Future<void> setStyleURI(String arg_uri) async {
    final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
        'dev.flutter.pigeon.StyleManager.setStyleURI', codec,
        binaryMessenger: _binaryMessenger);
    final Map<Object?, Object?>? replyMap =
        await channel.send(<Object?>[arg_uri]) as Map<Object?, Object?>?;
    if (replyMap == null) {
      throw PlatformException(
        code: 'channel-error',
        message: 'Unable to establish connection on channel.',
      );
    } else if (replyMap['error'] != null) {
      final Map<Object?, Object?> error =
          (replyMap['error'] as Map<Object?, Object?>?)!;
      throw PlatformException(
        code: (error['code'] as String?)!,
        message: error['message'] as String?,
        details: error['details'],
      );
    } else {
      return;
    }
  }

  Future<String> getStyleJSON() async {
    final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
        'dev.flutter.pigeon.StyleManager.getStyleJSON', codec,
        binaryMessenger: _binaryMessenger);
    final Map<Object?, Object?>? replyMap =
        await channel.send(null) as Map<Object?, Object?>?;
    if (replyMap == null) {
      throw PlatformException(
        code: 'channel-error',
        message: 'Unable to establish connection on channel.',
      );
    } else if (replyMap['error'] != null) {
      final Map<Object?, Object?> error =
          (replyMap['error'] as Map<Object?, Object?>?)!;
      throw PlatformException(
        code: (error['code'] as String?)!,
        message: error['message'] as String?,
        details: error['details'],
      );
    } else if (replyMap['result'] == null) {
      throw PlatformException(
        code: 'null-error',
        message: 'Host platform returned null value for non-null return value.',
      );
    } else {
      return (replyMap['result'] as String?)!;
    }
  }

  Future<void> setStyleJSON(String arg_json) async {
    final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
        'dev.flutter.pigeon.StyleManager.setStyleJSON', codec,
        binaryMessenger: _binaryMessenger);
    final Map<Object?, Object?>? replyMap =
        await channel.send(<Object?>[arg_json]) as Map<Object?, Object?>?;
    if (replyMap == null) {
      throw PlatformException(
        code: 'channel-error',
        message: 'Unable to establish connection on channel.',
      );
    } else if (replyMap['error'] != null) {
      final Map<Object?, Object?> error =
          (replyMap['error'] as Map<Object?, Object?>?)!;
      throw PlatformException(
        code: (error['code'] as String?)!,
        message: error['message'] as String?,
        details: error['details'],
      );
    } else {
      return;
    }
  }

  Future<CameraOptions> getStyleDefaultCamera() async {
    final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
        'dev.flutter.pigeon.StyleManager.getStyleDefaultCamera', codec,
        binaryMessenger: _binaryMessenger);
    final Map<Object?, Object?>? replyMap =
        await channel.send(null) as Map<Object?, Object?>?;
    if (replyMap == null) {
      throw PlatformException(
        code: 'channel-error',
        message: 'Unable to establish connection on channel.',
      );
    } else if (replyMap['error'] != null) {
      final Map<Object?, Object?> error =
          (replyMap['error'] as Map<Object?, Object?>?)!;
      throw PlatformException(
        code: (error['code'] as String?)!,
        message: error['message'] as String?,
        details: error['details'],
      );
    } else if (replyMap['result'] == null) {
      throw PlatformException(
        code: 'null-error',
        message: 'Host platform returned null value for non-null return value.',
      );
    } else {
      return (replyMap['result'] as CameraOptions?)!;
    }
  }

  Future<TransitionOptions> getStyleTransition() async {
    final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
        'dev.flutter.pigeon.StyleManager.getStyleTransition', codec,
        binaryMessenger: _binaryMessenger);
    final Map<Object?, Object?>? replyMap =
        await channel.send(null) as Map<Object?, Object?>?;
    if (replyMap == null) {
      throw PlatformException(
        code: 'channel-error',
        message: 'Unable to establish connection on channel.',
      );
    } else if (replyMap['error'] != null) {
      final Map<Object?, Object?> error =
          (replyMap['error'] as Map<Object?, Object?>?)!;
      throw PlatformException(
        code: (error['code'] as String?)!,
        message: error['message'] as String?,
        details: error['details'],
      );
    } else if (replyMap['result'] == null) {
      throw PlatformException(
        code: 'null-error',
        message: 'Host platform returned null value for non-null return value.',
      );
    } else {
      return (replyMap['result'] as TransitionOptions?)!;
    }
  }

  Future<void> setStyleTransition(
      TransitionOptions arg_transitionOptions) async {
    final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
        'dev.flutter.pigeon.StyleManager.setStyleTransition', codec,
        binaryMessenger: _binaryMessenger);
    final Map<Object?, Object?>? replyMap = await channel
        .send(<Object?>[arg_transitionOptions]) as Map<Object?, Object?>?;
    if (replyMap == null) {
      throw PlatformException(
        code: 'channel-error',
        message: 'Unable to establish connection on channel.',
      );
    } else if (replyMap['error'] != null) {
      final Map<Object?, Object?> error =
          (replyMap['error'] as Map<Object?, Object?>?)!;
      throw PlatformException(
        code: (error['code'] as String?)!,
        message: error['message'] as String?,
        details: error['details'],
      );
    } else {
      return;
    }
  }

  Future<void> addStyleLayer(
      String arg_properties, LayerPosition? arg_layerPosition) async {
    final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
        'dev.flutter.pigeon.StyleManager.addStyleLayer', codec,
        binaryMessenger: _binaryMessenger);
    final Map<Object?, Object?>? replyMap =
        await channel.send(<Object?>[arg_properties, arg_layerPosition])
            as Map<Object?, Object?>?;
    if (replyMap == null) {
      throw PlatformException(
        code: 'channel-error',
        message: 'Unable to establish connection on channel.',
      );
    } else if (replyMap['error'] != null) {
      final Map<Object?, Object?> error =
          (replyMap['error'] as Map<Object?, Object?>?)!;
      throw PlatformException(
        code: (error['code'] as String?)!,
        message: error['message'] as String?,
        details: error['details'],
      );
    } else {
      return;
    }
  }

  Future<void> addPersistentStyleLayer(
      String arg_properties, LayerPosition? arg_layerPosition) async {
    final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
        'dev.flutter.pigeon.StyleManager.addPersistentStyleLayer', codec,
        binaryMessenger: _binaryMessenger);
    final Map<Object?, Object?>? replyMap =
        await channel.send(<Object?>[arg_properties, arg_layerPosition])
            as Map<Object?, Object?>?;
    if (replyMap == null) {
      throw PlatformException(
        code: 'channel-error',
        message: 'Unable to establish connection on channel.',
      );
    } else if (replyMap['error'] != null) {
      final Map<Object?, Object?> error =
          (replyMap['error'] as Map<Object?, Object?>?)!;
      throw PlatformException(
        code: (error['code'] as String?)!,
        message: error['message'] as String?,
        details: error['details'],
      );
    } else {
      return;
    }
  }

  Future<bool> isStyleLayerPersistent(String arg_layerId) async {
    final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
        'dev.flutter.pigeon.StyleManager.isStyleLayerPersistent', codec,
        binaryMessenger: _binaryMessenger);
    final Map<Object?, Object?>? replyMap =
        await channel.send(<Object?>[arg_layerId]) as Map<Object?, Object?>?;
    if (replyMap == null) {
      throw PlatformException(
        code: 'channel-error',
        message: 'Unable to establish connection on channel.',
      );
    } else if (replyMap['error'] != null) {
      final Map<Object?, Object?> error =
          (replyMap['error'] as Map<Object?, Object?>?)!;
      throw PlatformException(
        code: (error['code'] as String?)!,
        message: error['message'] as String?,
        details: error['details'],
      );
    } else if (replyMap['result'] == null) {
      throw PlatformException(
        code: 'null-error',
        message: 'Host platform returned null value for non-null return value.',
      );
    } else {
      return (replyMap['result'] as bool?)!;
    }
  }

  Future<void> removeStyleLayer(String arg_layerId) async {
    final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
        'dev.flutter.pigeon.StyleManager.removeStyleLayer', codec,
        binaryMessenger: _binaryMessenger);
    final Map<Object?, Object?>? replyMap =
        await channel.send(<Object?>[arg_layerId]) as Map<Object?, Object?>?;
    if (replyMap == null) {
      throw PlatformException(
        code: 'channel-error',
        message: 'Unable to establish connection on channel.',
      );
    } else if (replyMap['error'] != null) {
      final Map<Object?, Object?> error =
          (replyMap['error'] as Map<Object?, Object?>?)!;
      throw PlatformException(
        code: (error['code'] as String?)!,
        message: error['message'] as String?,
        details: error['details'],
      );
    } else {
      return;
    }
  }

  Future<void> moveStyleLayer(
      String arg_layerId, LayerPosition? arg_layerPosition) async {
    final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
        'dev.flutter.pigeon.StyleManager.moveStyleLayer', codec,
        binaryMessenger: _binaryMessenger);
    final Map<Object?, Object?>? replyMap =
        await channel.send(<Object?>[arg_layerId, arg_layerPosition])
            as Map<Object?, Object?>?;
    if (replyMap == null) {
      throw PlatformException(
        code: 'channel-error',
        message: 'Unable to establish connection on channel.',
      );
    } else if (replyMap['error'] != null) {
      final Map<Object?, Object?> error =
          (replyMap['error'] as Map<Object?, Object?>?)!;
      throw PlatformException(
        code: (error['code'] as String?)!,
        message: error['message'] as String?,
        details: error['details'],
      );
    } else {
      return;
    }
  }

  Future<bool> styleLayerExists(String arg_layerId) async {
    final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
        'dev.flutter.pigeon.StyleManager.styleLayerExists', codec,
        binaryMessenger: _binaryMessenger);
    final Map<Object?, Object?>? replyMap =
        await channel.send(<Object?>[arg_layerId]) as Map<Object?, Object?>?;
    if (replyMap == null) {
      throw PlatformException(
        code: 'channel-error',
        message: 'Unable to establish connection on channel.',
      );
    } else if (replyMap['error'] != null) {
      final Map<Object?, Object?> error =
          (replyMap['error'] as Map<Object?, Object?>?)!;
      throw PlatformException(
        code: (error['code'] as String?)!,
        message: error['message'] as String?,
        details: error['details'],
      );
    } else if (replyMap['result'] == null) {
      throw PlatformException(
        code: 'null-error',
        message: 'Host platform returned null value for non-null return value.',
      );
    } else {
      return (replyMap['result'] as bool?)!;
    }
  }

  Future<List<StyleObjectInfo?>> getStyleLayers() async {
    final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
        'dev.flutter.pigeon.StyleManager.getStyleLayers', codec,
        binaryMessenger: _binaryMessenger);
    final Map<Object?, Object?>? replyMap =
        await channel.send(null) as Map<Object?, Object?>?;
    if (replyMap == null) {
      throw PlatformException(
        code: 'channel-error',
        message: 'Unable to establish connection on channel.',
      );
    } else if (replyMap['error'] != null) {
      final Map<Object?, Object?> error =
          (replyMap['error'] as Map<Object?, Object?>?)!;
      throw PlatformException(
        code: (error['code'] as String?)!,
        message: error['message'] as String?,
        details: error['details'],
      );
    } else if (replyMap['result'] == null) {
      throw PlatformException(
        code: 'null-error',
        message: 'Host platform returned null value for non-null return value.',
      );
    } else {
      return (replyMap['result'] as List<Object?>?)!.cast<StyleObjectInfo?>();
    }
  }

  Future<StylePropertyValue> getStyleLayerProperty(
      String arg_layerId, String arg_property) async {
    final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
        'dev.flutter.pigeon.StyleManager.getStyleLayerProperty', codec,
        binaryMessenger: _binaryMessenger);
    final Map<Object?, Object?>? replyMap = await channel
        .send(<Object?>[arg_layerId, arg_property]) as Map<Object?, Object?>?;
    if (replyMap == null) {
      throw PlatformException(
        code: 'channel-error',
        message: 'Unable to establish connection on channel.',
      );
    } else if (replyMap['error'] != null) {
      final Map<Object?, Object?> error =
          (replyMap['error'] as Map<Object?, Object?>?)!;
      throw PlatformException(
        code: (error['code'] as String?)!,
        message: error['message'] as String?,
        details: error['details'],
      );
    } else if (replyMap['result'] == null) {
      throw PlatformException(
        code: 'null-error',
        message: 'Host platform returned null value for non-null return value.',
      );
    } else {
      return (replyMap['result'] as StylePropertyValue?)!;
    }
  }

  Future<void> setStyleLayerProperty(
      String arg_layerId, String arg_property, Object arg_value) async {
    final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
        'dev.flutter.pigeon.StyleManager.setStyleLayerProperty', codec,
        binaryMessenger: _binaryMessenger);
    final Map<Object?, Object?>? replyMap =
        await channel.send(<Object?>[arg_layerId, arg_property, arg_value])
            as Map<Object?, Object?>?;
    if (replyMap == null) {
      throw PlatformException(
        code: 'channel-error',
        message: 'Unable to establish connection on channel.',
      );
    } else if (replyMap['error'] != null) {
      final Map<Object?, Object?> error =
          (replyMap['error'] as Map<Object?, Object?>?)!;
      throw PlatformException(
        code: (error['code'] as String?)!,
        message: error['message'] as String?,
        details: error['details'],
      );
    } else {
      return;
    }
  }

  Future<String> getStyleLayerProperties(String arg_layerId) async {
    final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
        'dev.flutter.pigeon.StyleManager.getStyleLayerProperties', codec,
        binaryMessenger: _binaryMessenger);
    final Map<Object?, Object?>? replyMap =
        await channel.send(<Object?>[arg_layerId]) as Map<Object?, Object?>?;
    if (replyMap == null) {
      throw PlatformException(
        code: 'channel-error',
        message: 'Unable to establish connection on channel.',
      );
    } else if (replyMap['error'] != null) {
      final Map<Object?, Object?> error =
          (replyMap['error'] as Map<Object?, Object?>?)!;
      throw PlatformException(
        code: (error['code'] as String?)!,
        message: error['message'] as String?,
        details: error['details'],
      );
    } else if (replyMap['result'] == null) {
      throw PlatformException(
        code: 'null-error',
        message: 'Host platform returned null value for non-null return value.',
      );
    } else {
      return (replyMap['result'] as String?)!;
    }
  }

  Future<void> setStyleLayerProperties(
      String arg_layerId, String arg_properties) async {
    final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
        'dev.flutter.pigeon.StyleManager.setStyleLayerProperties', codec,
        binaryMessenger: _binaryMessenger);
    final Map<Object?, Object?>? replyMap = await channel
        .send(<Object?>[arg_layerId, arg_properties]) as Map<Object?, Object?>?;
    if (replyMap == null) {
      throw PlatformException(
        code: 'channel-error',
        message: 'Unable to establish connection on channel.',
      );
    } else if (replyMap['error'] != null) {
      final Map<Object?, Object?> error =
          (replyMap['error'] as Map<Object?, Object?>?)!;
      throw PlatformException(
        code: (error['code'] as String?)!,
        message: error['message'] as String?,
        details: error['details'],
      );
    } else {
      return;
    }
  }

  Future<void> addStyleSource(
      String arg_sourceId, String arg_properties) async {
    final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
        'dev.flutter.pigeon.StyleManager.addStyleSource', codec,
        binaryMessenger: _binaryMessenger);
    final Map<Object?, Object?>? replyMap =
        await channel.send(<Object?>[arg_sourceId, arg_properties])
            as Map<Object?, Object?>?;
    if (replyMap == null) {
      throw PlatformException(
        code: 'channel-error',
        message: 'Unable to establish connection on channel.',
      );
    } else if (replyMap['error'] != null) {
      final Map<Object?, Object?> error =
          (replyMap['error'] as Map<Object?, Object?>?)!;
      throw PlatformException(
        code: (error['code'] as String?)!,
        message: error['message'] as String?,
        details: error['details'],
      );
    } else {
      return;
    }
  }

  Future<StylePropertyValue> getStyleSourceProperty(
      String arg_sourceId, String arg_property) async {
    final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
        'dev.flutter.pigeon.StyleManager.getStyleSourceProperty', codec,
        binaryMessenger: _binaryMessenger);
    final Map<Object?, Object?>? replyMap = await channel
        .send(<Object?>[arg_sourceId, arg_property]) as Map<Object?, Object?>?;
    if (replyMap == null) {
      throw PlatformException(
        code: 'channel-error',
        message: 'Unable to establish connection on channel.',
      );
    } else if (replyMap['error'] != null) {
      final Map<Object?, Object?> error =
          (replyMap['error'] as Map<Object?, Object?>?)!;
      throw PlatformException(
        code: (error['code'] as String?)!,
        message: error['message'] as String?,
        details: error['details'],
      );
    } else if (replyMap['result'] == null) {
      throw PlatformException(
        code: 'null-error',
        message: 'Host platform returned null value for non-null return value.',
      );
    } else {
      return (replyMap['result'] as StylePropertyValue?)!;
    }
  }

  Future<void> setStyleSourceProperty(
      String arg_sourceId, String arg_property, Object arg_value) async {
    final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
        'dev.flutter.pigeon.StyleManager.setStyleSourceProperty', codec,
        binaryMessenger: _binaryMessenger);
    final Map<Object?, Object?>? replyMap =
        await channel.send(<Object?>[arg_sourceId, arg_property, arg_value])
            as Map<Object?, Object?>?;
    if (replyMap == null) {
      throw PlatformException(
        code: 'channel-error',
        message: 'Unable to establish connection on channel.',
      );
    } else if (replyMap['error'] != null) {
      final Map<Object?, Object?> error =
          (replyMap['error'] as Map<Object?, Object?>?)!;
      throw PlatformException(
        code: (error['code'] as String?)!,
        message: error['message'] as String?,
        details: error['details'],
      );
    } else {
      return;
    }
  }

  Future<String> getStyleSourceProperties(String arg_sourceId) async {
    final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
        'dev.flutter.pigeon.StyleManager.getStyleSourceProperties', codec,
        binaryMessenger: _binaryMessenger);
    final Map<Object?, Object?>? replyMap =
        await channel.send(<Object?>[arg_sourceId]) as Map<Object?, Object?>?;
    if (replyMap == null) {
      throw PlatformException(
        code: 'channel-error',
        message: 'Unable to establish connection on channel.',
      );
    } else if (replyMap['error'] != null) {
      final Map<Object?, Object?> error =
          (replyMap['error'] as Map<Object?, Object?>?)!;
      throw PlatformException(
        code: (error['code'] as String?)!,
        message: error['message'] as String?,
        details: error['details'],
      );
    } else if (replyMap['result'] == null) {
      throw PlatformException(
        code: 'null-error',
        message: 'Host platform returned null value for non-null return value.',
      );
    } else {
      return (replyMap['result'] as String?)!;
    }
  }

  Future<void> setStyleSourceProperties(
      String arg_sourceId, String arg_properties) async {
    final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
        'dev.flutter.pigeon.StyleManager.setStyleSourceProperties', codec,
        binaryMessenger: _binaryMessenger);
    final Map<Object?, Object?>? replyMap =
        await channel.send(<Object?>[arg_sourceId, arg_properties])
            as Map<Object?, Object?>?;
    if (replyMap == null) {
      throw PlatformException(
        code: 'channel-error',
        message: 'Unable to establish connection on channel.',
      );
    } else if (replyMap['error'] != null) {
      final Map<Object?, Object?> error =
          (replyMap['error'] as Map<Object?, Object?>?)!;
      throw PlatformException(
        code: (error['code'] as String?)!,
        message: error['message'] as String?,
        details: error['details'],
      );
    } else {
      return;
    }
  }

  Future<void> updateStyleImageSourceImage(
      String arg_sourceId, MbxImage arg_image) async {
    final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
        'dev.flutter.pigeon.StyleManager.updateStyleImageSourceImage', codec,
        binaryMessenger: _binaryMessenger);
    final Map<Object?, Object?>? replyMap = await channel
        .send(<Object?>[arg_sourceId, arg_image]) as Map<Object?, Object?>?;
    if (replyMap == null) {
      throw PlatformException(
        code: 'channel-error',
        message: 'Unable to establish connection on channel.',
      );
    } else if (replyMap['error'] != null) {
      final Map<Object?, Object?> error =
          (replyMap['error'] as Map<Object?, Object?>?)!;
      throw PlatformException(
        code: (error['code'] as String?)!,
        message: error['message'] as String?,
        details: error['details'],
      );
    } else {
      return;
    }
  }

  Future<void> removeStyleSource(String arg_sourceId) async {
    final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
        'dev.flutter.pigeon.StyleManager.removeStyleSource', codec,
        binaryMessenger: _binaryMessenger);
    final Map<Object?, Object?>? replyMap =
        await channel.send(<Object?>[arg_sourceId]) as Map<Object?, Object?>?;
    if (replyMap == null) {
      throw PlatformException(
        code: 'channel-error',
        message: 'Unable to establish connection on channel.',
      );
    } else if (replyMap['error'] != null) {
      final Map<Object?, Object?> error =
          (replyMap['error'] as Map<Object?, Object?>?)!;
      throw PlatformException(
        code: (error['code'] as String?)!,
        message: error['message'] as String?,
        details: error['details'],
      );
    } else {
      return;
    }
  }

  Future<bool> styleSourceExists(String arg_sourceId) async {
    final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
        'dev.flutter.pigeon.StyleManager.styleSourceExists', codec,
        binaryMessenger: _binaryMessenger);
    final Map<Object?, Object?>? replyMap =
        await channel.send(<Object?>[arg_sourceId]) as Map<Object?, Object?>?;
    if (replyMap == null) {
      throw PlatformException(
        code: 'channel-error',
        message: 'Unable to establish connection on channel.',
      );
    } else if (replyMap['error'] != null) {
      final Map<Object?, Object?> error =
          (replyMap['error'] as Map<Object?, Object?>?)!;
      throw PlatformException(
        code: (error['code'] as String?)!,
        message: error['message'] as String?,
        details: error['details'],
      );
    } else if (replyMap['result'] == null) {
      throw PlatformException(
        code: 'null-error',
        message: 'Host platform returned null value for non-null return value.',
      );
    } else {
      return (replyMap['result'] as bool?)!;
    }
  }

  Future<List<StyleObjectInfo?>> getStyleSources() async {
    final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
        'dev.flutter.pigeon.StyleManager.getStyleSources', codec,
        binaryMessenger: _binaryMessenger);
    final Map<Object?, Object?>? replyMap =
        await channel.send(null) as Map<Object?, Object?>?;
    if (replyMap == null) {
      throw PlatformException(
        code: 'channel-error',
        message: 'Unable to establish connection on channel.',
      );
    } else if (replyMap['error'] != null) {
      final Map<Object?, Object?> error =
          (replyMap['error'] as Map<Object?, Object?>?)!;
      throw PlatformException(
        code: (error['code'] as String?)!,
        message: error['message'] as String?,
        details: error['details'],
      );
    } else if (replyMap['result'] == null) {
      throw PlatformException(
        code: 'null-error',
        message: 'Host platform returned null value for non-null return value.',
      );
    } else {
      return (replyMap['result'] as List<Object?>?)!.cast<StyleObjectInfo?>();
    }
  }

  Future<void> setStyleLight(String arg_properties) async {
    final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
        'dev.flutter.pigeon.StyleManager.setStyleLight', codec,
        binaryMessenger: _binaryMessenger);
    final Map<Object?, Object?>? replyMap =
        await channel.send(<Object?>[arg_properties]) as Map<Object?, Object?>?;
    if (replyMap == null) {
      throw PlatformException(
        code: 'channel-error',
        message: 'Unable to establish connection on channel.',
      );
    } else if (replyMap['error'] != null) {
      final Map<Object?, Object?> error =
          (replyMap['error'] as Map<Object?, Object?>?)!;
      throw PlatformException(
        code: (error['code'] as String?)!,
        message: error['message'] as String?,
        details: error['details'],
      );
    } else {
      return;
    }
  }

  Future<StylePropertyValue> getStyleLightProperty(String arg_property) async {
    final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
        'dev.flutter.pigeon.StyleManager.getStyleLightProperty', codec,
        binaryMessenger: _binaryMessenger);
    final Map<Object?, Object?>? replyMap =
        await channel.send(<Object?>[arg_property]) as Map<Object?, Object?>?;
    if (replyMap == null) {
      throw PlatformException(
        code: 'channel-error',
        message: 'Unable to establish connection on channel.',
      );
    } else if (replyMap['error'] != null) {
      final Map<Object?, Object?> error =
          (replyMap['error'] as Map<Object?, Object?>?)!;
      throw PlatformException(
        code: (error['code'] as String?)!,
        message: error['message'] as String?,
        details: error['details'],
      );
    } else if (replyMap['result'] == null) {
      throw PlatformException(
        code: 'null-error',
        message: 'Host platform returned null value for non-null return value.',
      );
    } else {
      return (replyMap['result'] as StylePropertyValue?)!;
    }
  }

  Future<void> setStyleLightProperty(
      String arg_property, Object arg_value) async {
    final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
        'dev.flutter.pigeon.StyleManager.setStyleLightProperty', codec,
        binaryMessenger: _binaryMessenger);
    final Map<Object?, Object?>? replyMap = await channel
        .send(<Object?>[arg_property, arg_value]) as Map<Object?, Object?>?;
    if (replyMap == null) {
      throw PlatformException(
        code: 'channel-error',
        message: 'Unable to establish connection on channel.',
      );
    } else if (replyMap['error'] != null) {
      final Map<Object?, Object?> error =
          (replyMap['error'] as Map<Object?, Object?>?)!;
      throw PlatformException(
        code: (error['code'] as String?)!,
        message: error['message'] as String?,
        details: error['details'],
      );
    } else {
      return;
    }
  }

  Future<void> setStyleTerrain(String arg_properties) async {
    final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
        'dev.flutter.pigeon.StyleManager.setStyleTerrain', codec,
        binaryMessenger: _binaryMessenger);
    final Map<Object?, Object?>? replyMap =
        await channel.send(<Object?>[arg_properties]) as Map<Object?, Object?>?;
    if (replyMap == null) {
      throw PlatformException(
        code: 'channel-error',
        message: 'Unable to establish connection on channel.',
      );
    } else if (replyMap['error'] != null) {
      final Map<Object?, Object?> error =
          (replyMap['error'] as Map<Object?, Object?>?)!;
      throw PlatformException(
        code: (error['code'] as String?)!,
        message: error['message'] as String?,
        details: error['details'],
      );
    } else {
      return;
    }
  }

  Future<StylePropertyValue> getStyleTerrainProperty(
      String arg_property) async {
    final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
        'dev.flutter.pigeon.StyleManager.getStyleTerrainProperty', codec,
        binaryMessenger: _binaryMessenger);
    final Map<Object?, Object?>? replyMap =
        await channel.send(<Object?>[arg_property]) as Map<Object?, Object?>?;
    if (replyMap == null) {
      throw PlatformException(
        code: 'channel-error',
        message: 'Unable to establish connection on channel.',
      );
    } else if (replyMap['error'] != null) {
      final Map<Object?, Object?> error =
          (replyMap['error'] as Map<Object?, Object?>?)!;
      throw PlatformException(
        code: (error['code'] as String?)!,
        message: error['message'] as String?,
        details: error['details'],
      );
    } else if (replyMap['result'] == null) {
      throw PlatformException(
        code: 'null-error',
        message: 'Host platform returned null value for non-null return value.',
      );
    } else {
      return (replyMap['result'] as StylePropertyValue?)!;
    }
  }

  Future<void> setStyleTerrainProperty(
      String arg_property, Object arg_value) async {
    final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
        'dev.flutter.pigeon.StyleManager.setStyleTerrainProperty', codec,
        binaryMessenger: _binaryMessenger);
    final Map<Object?, Object?>? replyMap = await channel
        .send(<Object?>[arg_property, arg_value]) as Map<Object?, Object?>?;
    if (replyMap == null) {
      throw PlatformException(
        code: 'channel-error',
        message: 'Unable to establish connection on channel.',
      );
    } else if (replyMap['error'] != null) {
      final Map<Object?, Object?> error =
          (replyMap['error'] as Map<Object?, Object?>?)!;
      throw PlatformException(
        code: (error['code'] as String?)!,
        message: error['message'] as String?,
        details: error['details'],
      );
    } else {
      return;
    }
  }

  Future<MbxImage?> getStyleImage(String arg_imageId) async {
    final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
        'dev.flutter.pigeon.StyleManager.getStyleImage', codec,
        binaryMessenger: _binaryMessenger);
    final Map<Object?, Object?>? replyMap =
        await channel.send(<Object?>[arg_imageId]) as Map<Object?, Object?>?;
    if (replyMap == null) {
      throw PlatformException(
        code: 'channel-error',
        message: 'Unable to establish connection on channel.',
      );
    } else if (replyMap['error'] != null) {
      final Map<Object?, Object?> error =
          (replyMap['error'] as Map<Object?, Object?>?)!;
      throw PlatformException(
        code: (error['code'] as String?)!,
        message: error['message'] as String?,
        details: error['details'],
      );
    } else {
      return (replyMap['result'] as MbxImage?);
    }
  }

  Future<void> addStyleImage(
      String arg_imageId,
      double arg_scale,
      MbxImage arg_image,
      bool arg_sdf,
      List<ImageStretches?> arg_stretchX,
      List<ImageStretches?> arg_stretchY,
      ImageContent? arg_content) async {
    final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
        'dev.flutter.pigeon.StyleManager.addStyleImage', codec,
        binaryMessenger: _binaryMessenger);
    final Map<Object?, Object?>? replyMap = await channel.send(<Object?>[
      arg_imageId,
      arg_scale,
      arg_image,
      arg_sdf,
      arg_stretchX,
      arg_stretchY,
      arg_content
    ]) as Map<Object?, Object?>?;
    if (replyMap == null) {
      throw PlatformException(
        code: 'channel-error',
        message: 'Unable to establish connection on channel.',
      );
    } else if (replyMap['error'] != null) {
      final Map<Object?, Object?> error =
          (replyMap['error'] as Map<Object?, Object?>?)!;
      throw PlatformException(
        code: (error['code'] as String?)!,
        message: error['message'] as String?,
        details: error['details'],
      );
    } else {
      return;
    }
  }

  Future<void> removeStyleImage(String arg_imageId) async {
    final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
        'dev.flutter.pigeon.StyleManager.removeStyleImage', codec,
        binaryMessenger: _binaryMessenger);
    final Map<Object?, Object?>? replyMap =
        await channel.send(<Object?>[arg_imageId]) as Map<Object?, Object?>?;
    if (replyMap == null) {
      throw PlatformException(
        code: 'channel-error',
        message: 'Unable to establish connection on channel.',
      );
    } else if (replyMap['error'] != null) {
      final Map<Object?, Object?> error =
          (replyMap['error'] as Map<Object?, Object?>?)!;
      throw PlatformException(
        code: (error['code'] as String?)!,
        message: error['message'] as String?,
        details: error['details'],
      );
    } else {
      return;
    }
  }

  Future<bool> hasStyleImage(String arg_imageId) async {
    final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
        'dev.flutter.pigeon.StyleManager.hasStyleImage', codec,
        binaryMessenger: _binaryMessenger);
    final Map<Object?, Object?>? replyMap =
        await channel.send(<Object?>[arg_imageId]) as Map<Object?, Object?>?;
    if (replyMap == null) {
      throw PlatformException(
        code: 'channel-error',
        message: 'Unable to establish connection on channel.',
      );
    } else if (replyMap['error'] != null) {
      final Map<Object?, Object?> error =
          (replyMap['error'] as Map<Object?, Object?>?)!;
      throw PlatformException(
        code: (error['code'] as String?)!,
        message: error['message'] as String?,
        details: error['details'],
      );
    } else if (replyMap['result'] == null) {
      throw PlatformException(
        code: 'null-error',
        message: 'Host platform returned null value for non-null return value.',
      );
    } else {
      return (replyMap['result'] as bool?)!;
    }
  }

  Future<void> invalidateStyleCustomGeometrySourceTile(
      String arg_sourceId, CanonicalTileID arg_tileId) async {
    final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
        'dev.flutter.pigeon.StyleManager.invalidateStyleCustomGeometrySourceTile',
        codec,
        binaryMessenger: _binaryMessenger);
    final Map<Object?, Object?>? replyMap = await channel
        .send(<Object?>[arg_sourceId, arg_tileId]) as Map<Object?, Object?>?;
    if (replyMap == null) {
      throw PlatformException(
        code: 'channel-error',
        message: 'Unable to establish connection on channel.',
      );
    } else if (replyMap['error'] != null) {
      final Map<Object?, Object?> error =
          (replyMap['error'] as Map<Object?, Object?>?)!;
      throw PlatformException(
        code: (error['code'] as String?)!,
        message: error['message'] as String?,
        details: error['details'],
      );
    } else {
      return;
    }
  }

  Future<void> invalidateStyleCustomGeometrySourceRegion(
      String arg_sourceId, CoordinateBounds arg_bounds) async {
    final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
        'dev.flutter.pigeon.StyleManager.invalidateStyleCustomGeometrySourceRegion',
        codec,
        binaryMessenger: _binaryMessenger);
    final Map<Object?, Object?>? replyMap = await channel
        .send(<Object?>[arg_sourceId, arg_bounds]) as Map<Object?, Object?>?;
    if (replyMap == null) {
      throw PlatformException(
        code: 'channel-error',
        message: 'Unable to establish connection on channel.',
      );
    } else if (replyMap['error'] != null) {
      final Map<Object?, Object?> error =
          (replyMap['error'] as Map<Object?, Object?>?)!;
      throw PlatformException(
        code: (error['code'] as String?)!,
        message: error['message'] as String?,
        details: error['details'],
      );
    } else {
      return;
    }
  }

  Future<bool> isStyleLoaded() async {
    final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
        'dev.flutter.pigeon.StyleManager.isStyleLoaded', codec,
        binaryMessenger: _binaryMessenger);
    final Map<Object?, Object?>? replyMap =
        await channel.send(null) as Map<Object?, Object?>?;
    if (replyMap == null) {
      throw PlatformException(
        code: 'channel-error',
        message: 'Unable to establish connection on channel.',
      );
    } else if (replyMap['error'] != null) {
      final Map<Object?, Object?> error =
          (replyMap['error'] as Map<Object?, Object?>?)!;
      throw PlatformException(
        code: (error['code'] as String?)!,
        message: error['message'] as String?,
        details: error['details'],
      );
    } else if (replyMap['result'] == null) {
      throw PlatformException(
        code: 'null-error',
        message: 'Host platform returned null value for non-null return value.',
      );
    } else {
      return (replyMap['result'] as bool?)!;
    }
  }

  Future<String> getProjection() async {
    final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
        'dev.flutter.pigeon.StyleManager.getProjection', codec,
        binaryMessenger: _binaryMessenger);
    final Map<Object?, Object?>? replyMap =
        await channel.send(null) as Map<Object?, Object?>?;
    if (replyMap == null) {
      throw PlatformException(
        code: 'channel-error',
        message: 'Unable to establish connection on channel.',
      );
    } else if (replyMap['error'] != null) {
      final Map<Object?, Object?> error =
          (replyMap['error'] as Map<Object?, Object?>?)!;
      throw PlatformException(
        code: (error['code'] as String?)!,
        message: error['message'] as String?,
        details: error['details'],
      );
    } else if (replyMap['result'] == null) {
      throw PlatformException(
        code: 'null-error',
        message: 'Host platform returned null value for non-null return value.',
      );
    } else {
      return (replyMap['result'] as String?)!;
    }
  }

  Future<void> setProjection(String arg_projection) async {
    final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
        'dev.flutter.pigeon.StyleManager.setProjection', codec,
        binaryMessenger: _binaryMessenger);
    final Map<Object?, Object?>? replyMap =
        await channel.send(<Object?>[arg_projection]) as Map<Object?, Object?>?;
    if (replyMap == null) {
      throw PlatformException(
        code: 'channel-error',
        message: 'Unable to establish connection on channel.',
      );
    } else if (replyMap['error'] != null) {
      final Map<Object?, Object?> error =
          (replyMap['error'] as Map<Object?, Object?>?)!;
      throw PlatformException(
        code: (error['code'] as String?)!,
        message: error['message'] as String?,
        details: error['details'],
      );
    } else {
      return;
    }
  }

  Future<void> localizeLabels(
      String arg_locale, List<String?>? arg_layerIds) async {
    final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
        'dev.flutter.pigeon.StyleManager.localizeLabels', codec,
        binaryMessenger: _binaryMessenger);
    final Map<Object?, Object?>? replyMap = await channel
        .send(<Object?>[arg_locale, arg_layerIds]) as Map<Object?, Object?>?;
    if (replyMap == null) {
      throw PlatformException(
        code: 'channel-error',
        message: 'Unable to establish connection on channel.',
      );
    } else if (replyMap['error'] != null) {
      final Map<Object?, Object?> error =
          (replyMap['error'] as Map<Object?, Object?>?)!;
      throw PlatformException(
        code: (error['code'] as String?)!,
        message: error['message'] as String?,
        details: error['details'],
      );
    } else {
      return;
    }
  }
}

class _CancelableCodec extends StandardMessageCodec {
  const _CancelableCodec();
}

class Cancelable {
  /// Constructor for [Cancelable].  The [binaryMessenger] named argument is
  /// available for dependency injection.  If it is left null, the default
  /// BinaryMessenger will be used which routes to the host platform.
  Cancelable({BinaryMessenger? binaryMessenger})
      : _binaryMessenger = binaryMessenger;

  final BinaryMessenger? _binaryMessenger;

  static const MessageCodec<Object?> codec = _CancelableCodec();

  Future<void> cancel() async {
    final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
        'dev.flutter.pigeon.Cancelable.cancel', codec,
        binaryMessenger: _binaryMessenger);
    final Map<Object?, Object?>? replyMap =
        await channel.send(null) as Map<Object?, Object?>?;
    if (replyMap == null) {
      throw PlatformException(
        code: 'channel-error',
        message: 'Unable to establish connection on channel.',
      );
    } else if (replyMap['error'] != null) {
      final Map<Object?, Object?> error =
          (replyMap['error'] as Map<Object?, Object?>?)!;
      throw PlatformException(
        code: (error['code'] as String?)!,
        message: error['message'] as String?,
        details: error['details'],
      );
    } else {
      return;
    }
  }
}

class _OfflineSwitchCodec extends StandardMessageCodec {
  const _OfflineSwitchCodec();
}

class OfflineSwitch {
  /// Constructor for [OfflineSwitch].  The [binaryMessenger] named argument is
  /// available for dependency injection.  If it is left null, the default
  /// BinaryMessenger will be used which routes to the host platform.
  OfflineSwitch({BinaryMessenger? binaryMessenger})
      : _binaryMessenger = binaryMessenger;

  final BinaryMessenger? _binaryMessenger;

  static const MessageCodec<Object?> codec = _OfflineSwitchCodec();

  Future<void> setMapboxStackConnected(bool arg_connected) async {
    final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
        'dev.flutter.pigeon.OfflineSwitch.setMapboxStackConnected', codec,
        binaryMessenger: _binaryMessenger);
    final Map<Object?, Object?>? replyMap =
        await channel.send(<Object?>[arg_connected]) as Map<Object?, Object?>?;
    if (replyMap == null) {
      throw PlatformException(
        code: 'channel-error',
        message: 'Unable to establish connection on channel.',
      );
    } else if (replyMap['error'] != null) {
      final Map<Object?, Object?> error =
          (replyMap['error'] as Map<Object?, Object?>?)!;
      throw PlatformException(
        code: (error['code'] as String?)!,
        message: error['message'] as String?,
        details: error['details'],
      );
    } else {
      return;
    }
  }

  Future<bool> isMapboxStackConnected() async {
    final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
        'dev.flutter.pigeon.OfflineSwitch.isMapboxStackConnected', codec,
        binaryMessenger: _binaryMessenger);
    final Map<Object?, Object?>? replyMap =
        await channel.send(null) as Map<Object?, Object?>?;
    if (replyMap == null) {
      throw PlatformException(
        code: 'channel-error',
        message: 'Unable to establish connection on channel.',
      );
    } else if (replyMap['error'] != null) {
      final Map<Object?, Object?> error =
          (replyMap['error'] as Map<Object?, Object?>?)!;
      throw PlatformException(
        code: (error['code'] as String?)!,
        message: error['message'] as String?,
        details: error['details'],
      );
    } else if (replyMap['result'] == null) {
      throw PlatformException(
        code: 'null-error',
        message: 'Host platform returned null value for non-null return value.',
      );
    } else {
      return (replyMap['result'] as bool?)!;
    }
  }

  Future<void> reset() async {
    final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
        'dev.flutter.pigeon.OfflineSwitch.reset', codec,
        binaryMessenger: _binaryMessenger);
    final Map<Object?, Object?>? replyMap =
        await channel.send(null) as Map<Object?, Object?>?;
    if (replyMap == null) {
      throw PlatformException(
        code: 'channel-error',
        message: 'Unable to establish connection on channel.',
      );
    } else if (replyMap['error'] != null) {
      final Map<Object?, Object?> error =
          (replyMap['error'] as Map<Object?, Object?>?)!;
      throw PlatformException(
        code: (error['code'] as String?)!,
        message: error['message'] as String?,
        details: error['details'],
      );
    } else {
      return;
    }
  }
}

class _TilesetDescriptorCodec extends StandardMessageCodec {
  const _TilesetDescriptorCodec();
}

class TilesetDescriptor {
  /// Constructor for [TilesetDescriptor].  The [binaryMessenger] named argument is
  /// available for dependency injection.  If it is left null, the default
  /// BinaryMessenger will be used which routes to the host platform.
  TilesetDescriptor({BinaryMessenger? binaryMessenger})
      : _binaryMessenger = binaryMessenger;

  final BinaryMessenger? _binaryMessenger;

  static const MessageCodec<Object?> codec = _TilesetDescriptorCodec();
}
