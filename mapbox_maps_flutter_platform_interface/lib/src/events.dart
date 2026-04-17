import 'package:turf/turf.dart';

import 'pigeons/platform_interface_data_types.dart';

// ===== Private JSON helpers =====

CameraState _cameraStateFromJson(Map<String, dynamic> json) {
  final padding = json['padding'] as Map<String, dynamic>;
  return CameraState(
    center: Point.fromJson(json['center'] as Map<String, dynamic>),
    padding: MbxEdgeInsets(
      top: (padding['top'] as num).toDouble(),
      left: (padding['left'] as num).toDouble(),
      bottom: (padding['bottom'] as num).toDouble(),
      right: (padding['right'] as num).toDouble(),
    ),
    zoom: (json['zoom'] as num).toDouble(),
    bearing: (json['bearing'] as num).toDouble(),
    pitch: (json['pitch'] as num).toDouble(),
  );
}

ResponseError _responseErrorFromJson(Map<String, dynamic> json) =>
    ResponseError(
      reason: ResponseErrorReason.values[json['reason'] as int],
      message: json['message'] as String,
    );

ResourceResponse _resourceResponseFromJson(Map<String, dynamic> json) =>
    ResourceResponse(
      eTag: json['etag'] as String?,
      mustRevalidate: json['mustRevalidate'] as bool,
      noContent: json['noContent'] as bool,
      modified: json['modified'] != null
          ? DateTime.fromMicrosecondsSinceEpoch(json['modified'] as int)
          : null,
      source: ResponseSourceType.values[json['source'] as int],
      notModified: json['notModified'] as bool,
      expires: json['expires'] != null
          ? DateTime.fromMicrosecondsSinceEpoch(json['expires'] as int)
          : null,
      size: json['size'] as int,
      error: json['error'] != null
          ? _responseErrorFromJson(json['error'] as Map<String, dynamic>)
          : null,
    );

ResourceRequest _resourceRequestFromJson(Map<String, dynamic> json) =>
    ResourceRequest(
      loadingMethod: (json['loadingMethod'] as List)
          .cast<int>()
          .map((e) => RequestLoadingMethodType.values[e])
          .toList(),
      url: json['url'] as String,
      kind: RequestType.values[json['resource'] as int],
      priority: RequestPriority.values[json['priority'] as int],
    );

// ===== Event time =====

/// The time interval of an event.
class EventTimeInterval {
  /// Timestamp taken at the time of event creation; in microseconds since epoch.
  final DateTime begin;

  /// Timestamp taken at the time of event completion.
  final DateTime end;

  EventTimeInterval({required this.begin, required this.end});

  EventTimeInterval.fromJson(Map<String, dynamic> json)
    : begin = DateTime.fromMicrosecondsSinceEpoch(json['begin'] as int),
      end = DateTime.fromMicrosecondsSinceEpoch(json['end'] as int);
}

// ===== Tile / source identifiers =====

/// Identifies a tile by its z/x/y coordinates.
class TileID {
  /// The zoom level.
  final int z;

  /// The x coordinate.
  final int x;

  /// The y coordinate.
  final int y;

  TileID({required this.x, required this.y, required this.z});

  TileID.fromJson(Map<String, dynamic> json)
    : x = json['x'] as int,
      y = json['y'] as int,
      z = json['z'] as int;
}

// ===== Event data classes =====

/// Base sealed class for all map events.
sealed class MapEvent {}

/// Data for the `styleLoaded` event.
class StyleLoadedEventData extends MapEvent {
  final EventTimeInterval timeInterval;

  StyleLoadedEventData({required this.timeInterval});

  StyleLoadedEventData.fromJson(Map<String, dynamic> json)
    : timeInterval = EventTimeInterval.fromJson(
        json['timeInterval'] as Map<String, dynamic>,
      );
}

/// Data for the `cameraChanged` event.
class CameraChangedEventData extends MapEvent {
  final int timestamp;
  final CameraState cameraState;

  CameraChangedEventData({required this.timestamp, required this.cameraState});

  CameraChangedEventData.fromJson(Map<String, dynamic> json)
    : timestamp = json['timestamp'] as int,
      cameraState = _cameraStateFromJson(
        json['cameraState'] as Map<String, dynamic>,
      );
}

/// Data for the `mapIdle` event.
class MapIdleEventData extends MapEvent {
  final int timestamp;

  MapIdleEventData({required this.timestamp});

  MapIdleEventData.fromJson(Map<String, dynamic> json)
    : timestamp = json['timestamp'] as int;
}

/// Data for the `mapLoaded` event.
class MapLoadedEventData extends MapEvent {
  final EventTimeInterval timeInterval;

  MapLoadedEventData({required this.timeInterval});

  MapLoadedEventData.fromJson(Map<String, dynamic> json)
    : timeInterval = EventTimeInterval.fromJson(
        json['timeInterval'] as Map<String, dynamic>,
      );
}

/// Describes what resource could not be loaded.
enum MapLoadErrorType {
  /// An error related to style.
  STYLE,

  /// An error related to sprite.
  SPRITE,

  /// An error related to source.
  SOURCE,

  /// An error related to glyphs.
  GLYPHS,

  /// An error related to tile.
  TILE,
}

/// Data for the `mapLoadingError` event.
class MapLoadingErrorEventData extends MapEvent {
  final MapLoadErrorType type;
  final String message;
  final String? sourceId;
  final TileID? tileId;
  final int timestamp;

  MapLoadingErrorEventData({
    required this.type,
    required this.message,
    this.sourceId,
    this.tileId,
    required this.timestamp,
  });

  MapLoadingErrorEventData.fromJson(Map<String, dynamic> json)
    : type = MapLoadErrorType.values[json['type'] as int],
      message = json['message'] as String,
      sourceId = json['sourceId'] as String?,
      tileId = json['tileId'] != null
          ? TileID.fromJson(json['tileId'] as Map<String, dynamic>)
          : null,
      timestamp = json['timestamp'] as int;
}

/// Describes whether a map or frame has been fully rendered.
enum RenderMode {
  /// The map is partially rendered.
  PARTIAL,

  /// The map is fully rendered.
  FULL,
}

/// Data for the `renderFrameStarted` event.
class RenderFrameStartedEventData extends MapEvent {
  final int timestamp;

  RenderFrameStartedEventData({required this.timestamp});

  RenderFrameStartedEventData.fromJson(Map<String, dynamic> json)
    : timestamp = json['timestamp'] as int;
}

/// Data for the `renderFrameFinished` event.
class RenderFrameFinishedEventData extends MapEvent {
  final EventTimeInterval timeInterval;
  final RenderMode renderMode;
  final bool needsRepaint;
  final bool placementChanged;

  RenderFrameFinishedEventData({
    required this.timeInterval,
    required this.renderMode,
    required this.needsRepaint,
    required this.placementChanged,
  });

  RenderFrameFinishedEventData.fromJson(Map<String, dynamic> json)
    : timeInterval = EventTimeInterval.fromJson(
        json['timeInterval'] as Map<String, dynamic>,
      ),
      renderMode = RenderMode.values[json['renderMode'] as int],
      needsRepaint = json['needsRepaint'] as bool,
      placementChanged = json['placementChanged'] as bool;
}

/// Data for the `sourceAdded` event.
class SourceAddedEventData extends MapEvent {
  final int timestamp;
  final String id;

  SourceAddedEventData({required this.timestamp, required this.id});

  SourceAddedEventData.fromJson(Map<String, dynamic> json)
    : timestamp = json['timestamp'] as int,
      id = json['sourceId'] as String;
}

/// Data for the `sourceRemoved` event.
class SourceRemovedEventData extends MapEvent {
  final int timestamp;
  final String id;

  SourceRemovedEventData({required this.timestamp, required this.id});

  SourceRemovedEventData.fromJson(Map<String, dynamic> json)
    : timestamp = json['timestamp'] as int,
      id = json['sourceId'] as String;
}

/// Defines what kind of source data was loaded.
enum SourceDataType {
  /// Source metadata (e.g. TileJSON).
  METADATA,

  /// Source tile data.
  TILE,
}

/// Data for the `sourceDataLoaded` event.
class SourceDataLoadedEventData extends MapEvent {
  final String id;
  final SourceDataType type;
  final bool? loaded;
  final TileID? tileID;
  final String? dataId;
  final EventTimeInterval timeInterval;

  SourceDataLoadedEventData({
    required this.id,
    required this.type,
    this.loaded,
    this.tileID,
    this.dataId,
    required this.timeInterval,
  });

  SourceDataLoadedEventData.fromJson(Map<String, dynamic> json)
    : id = json['sourceId'] as String,
      type = SourceDataType.values[json['type'] as int],
      loaded = json['loaded'] as bool?,
      tileID = json['tileId'] != null
          ? TileID.fromJson(json['tileId'] as Map<String, dynamic>)
          : null,
      dataId = json['dataId'] as String?,
      timeInterval = EventTimeInterval.fromJson(
        json['timeInterval'] as Map<String, dynamic>,
      );
}

/// Defines what kind of style data was loaded.
enum StyleDataType {
  /// Style JSON.
  STYLE,

  /// Sprite data.
  SPRITE,

  /// Source metadata.
  SOURCES,
}

/// Data for the `styleDataLoaded` event.
class StyleDataLoadedEventData extends MapEvent {
  final EventTimeInterval timeInterval;
  final StyleDataType type;

  StyleDataLoadedEventData({required this.timeInterval, required this.type});

  StyleDataLoadedEventData.fromJson(Map<String, dynamic> json)
    : type = StyleDataType.values[json['type'] as int],
      timeInterval = EventTimeInterval.fromJson(
        json['timeInterval'] as Map<String, dynamic>,
      );
}

/// Data for the `styleImageMissing` event.
class StyleImageMissingEventData extends MapEvent {
  final int timestamp;
  final String id;

  StyleImageMissingEventData({required this.timestamp, required this.id});

  StyleImageMissingEventData.fromJson(Map<String, dynamic> json)
    : timestamp = json['timestamp'] as int,
      id = json['imageId'] as String;
}

/// Data for the `styleImageUnused` event.
class StyleImageUnusedEventData extends MapEvent {
  final int timestamp;
  final String id;

  StyleImageUnusedEventData({required this.timestamp, required this.id});

  StyleImageUnusedEventData.fromJson(Map<String, dynamic> json)
    : timestamp = json['timestamp'] as int,
      id = json['imageId'] as String;
}

/// Describes the data source type for a resource request.
enum DataSourceType { ASSET, DATABASE, FILE_SYSTEM, NETWORK, RESOURCE_LOADER }

// ResponseErrorReason is generated in platform_interface_data_types.dart
// (pigeon spec) so it also appears in the native Swift/Kotlin pigeon output.

/// The source of a response.
enum ResponseSourceType { NETWORK, CACHE, TILE_STORE, LOCAL_FILE }

/// The method used to make a resource request.
enum RequestLoadingMethodType { NETWORK, CACHE }

/// The type of a requested resource.
enum RequestType {
  UNKNOWN,
  STYLE,
  SOURCE,
  TILE,
  GLYPHS,
  SPRITE_IMAGE,
  SPRITE_JSON,
  IMAGE,
  MODEL,
}

/// The priority of a request.
enum RequestPriority { REGULAR, LOW }

/// An error in a resource response.
class ResponseError {
  final ResponseErrorReason reason;
  final String message;

  ResponseError({required this.reason, required this.message});
}

/// A resource response.
class ResourceResponse {
  final String? eTag;
  final bool mustRevalidate;
  final bool noContent;
  final DateTime? modified;
  final ResponseSourceType source;
  final bool notModified;
  final DateTime? expires;
  final int size;
  final ResponseError? error;

  ResourceResponse({
    this.eTag,
    required this.mustRevalidate,
    required this.noContent,
    this.modified,
    required this.source,
    required this.notModified,
    this.expires,
    required this.size,
    this.error,
  });
}

/// A resource request.
class ResourceRequest {
  final List<RequestLoadingMethodType> loadingMethod;
  final String url;
  final RequestType kind;
  final RequestPriority priority;

  ResourceRequest({
    required this.loadingMethod,
    required this.url,
    required this.kind,
    required this.priority,
  });
}

/// Data for the `resourceRequest` event.
class ResourceEventData extends MapEvent {
  final EventTimeInterval timeInterval;
  final DataSourceType dataSource;
  final ResourceRequest request;
  final ResourceResponse? response;
  final bool cancelled;

  ResourceEventData({
    required this.timeInterval,
    required this.dataSource,
    required this.request,
    this.response,
    required this.cancelled,
  });

  ResourceEventData.fromJson(Map<String, dynamic> json)
    : timeInterval = EventTimeInterval.fromJson(
        json['timeInterval'] as Map<String, dynamic>,
      ),
      dataSource = DataSourceType.values[json['source'] as int],
      request = _resourceRequestFromJson(
        json['request'] as Map<String, dynamic>,
      ),
      response = json['response'] != null
          ? _resourceResponseFromJson(json['response'] as Map<String, dynamic>)
          : null,
      cancelled = json['cancelled'] as bool;
}

// ===== Listener typedefs =====

/// Invoked when the style is fully loaded.
typedef OnStyleLoadedListener =
    void Function(StyleLoadedEventData styleLoadedEventData);

/// Invoked whenever the camera position changes.
typedef OnCameraChangeListener =
    void Function(CameraChangedEventData cameraChangedEventData);

/// Invoked whenever the map has entered the idle state.
typedef OnMapIdleListener = void Function(MapIdleEventData mapIdleEventData);

/// Invoked when map loading finishes.
typedef OnMapLoadedListener =
    void Function(MapLoadedEventData mapLoadedEventData);

/// Invoked whenever the map load errors out.
typedef OnMapLoadErrorListener =
    void Function(MapLoadingErrorEventData mapLoadingErrorEventData);

/// Invoked whenever the map started rendering a frame.
typedef OnRenderFrameStartedListener =
    void Function(RenderFrameStartedEventData renderFrameStartedEventData);

/// Invoked whenever the map finished rendering a frame.
typedef OnRenderFrameFinishedListener =
    void Function(RenderFrameFinishedEventData renderFrameFinishedEventData);

/// Invoked whenever a source is added.
typedef OnSourceAddedListener =
    void Function(SourceAddedEventData sourceAddedEventData);

/// Invoked when the requested source data has been loaded.
typedef OnSourceDataLoadedListener =
    void Function(SourceDataLoadedEventData sourceDataLoadedEventData);

/// Invoked whenever a source is removed.
typedef OnSourceRemovedListener =
    void Function(SourceRemovedEventData sourceRemovedEventData);

/// Invoked when the requested style data has been loaded.
typedef OnStyleDataLoadedListener =
    void Function(StyleDataLoadedEventData styleDataLoadedEventData);

/// Invoked when the style has a missing image.
typedef OnStyleImageMissingListener =
    void Function(StyleImageMissingEventData styleImageMissingEventData);

/// Invoked when an image added to the style is no longer needed.
typedef OnStyleImageUnusedListener =
    void Function(StyleImageUnusedEventData styleImageUnusedEventData);

/// Invoked when the map makes a resource request.
typedef OnResourceRequestListener =
    void Function(ResourceEventData resourceEventData);

/// Gesture listener called on map tap.
typedef OnMapTapListener = void Function(MapContentGestureContext context);

/// Gesture listener called on map long tap.
typedef OnMapLongTapListener = void Function(MapContentGestureContext context);

/// Gesture listener called on map scroll.
typedef OnMapScrollListener = void Function(MapContentGestureContext context);

/// Gesture listener called on map zoom.
typedef OnMapZoomListener = void Function(MapContentGestureContext context);

/// Interaction callback for any feature type.
typedef OnInteraction<T extends FeaturesetFeature> =
    void Function(T? feature, MapContentGestureContext context);

/// Interaction callback for a specific featureset which returns a non-optional FeaturesetFeature.
typedef OnInteractionFeatureContext<T extends FeaturesetFeature> =
    void Function(T feature, MapContentGestureContext context);

/// Interaction callback that just returns the MapContentGestureContext.
typedef OnInteractionContext = void Function(MapContentGestureContext context);
