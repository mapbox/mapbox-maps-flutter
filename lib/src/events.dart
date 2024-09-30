part of mapbox_maps_flutter;

/// List of supported event types by the `map` and `map snapshotter` objects,
/// and event data format specification for each event.
///
/// ``` text
/// Simplified diagram for events emitted by the map object.
///
/// ┌─────────────┐               ┌─────────┐                   ┌──────────────┐
/// │ Application │               │   Map   │                   │ResourceLoader│
/// └──────┬──────┘               └────┬────┘                   └───────┬──────┘
///        │                           │                                │
///        ├───────setStyleURI────────▶│                                │
///        │                           ├───────────get style───────────▶│
///        │                           │                                │
///        │                           │◀─────────style data────────────┤
///        │                           │                                │
///        │                           ├─parse style─┐                  │
///        │                           │             │                  │
///        │      StyleDataLoaded      ◀─────────────┘                  │
///        │◀────{"type": "style"}─────┤                                │
///        │                           ├─────────get sprite────────────▶│
///        │                           │                                │
///        │                           │◀────────sprite data────────────┤
///        │                           │                                │
///        │                           ├──────parse sprite───────┐      │
///        │                           │                         │      │
///        │      StyleDataLoaded      ◀─────────────────────────┘      │
///        │◀───{"type": "sprite"}─────┤                                │
///        │                           ├─────get source TileJSON(s)────▶│
///        │                           │                                │
///        │     SourceDataLoaded      │◀─────parse TileJSON data───────┤
///        │◀──{"type": "metadata"}────┤                                │
///        │                           │                                │
///        │                           │                                │
///        │      StyleDataLoaded      │                                │
///        │◀───{"type": "sources"}────┤                                │
///        │                           ├──────────get tiles────────────▶│
///        │                           │                                │
///        │◀───────StyleLoaded────────┤                                │
///        │                           │                                │
///        │     SourceDataLoaded      │◀─────────tile data─────────────┤
///        │◀────{"type": "tile"}──────┤                                │
///        │                           │                                │
///        │                           │                                │
///        │◀────RenderFrameStarted────┤                                │
///        │                           ├─────render─────┐               │
///        │                           │                │               │
///        │                           ◀────────────────┘               │
///        │◀───RenderFrameFinished────┤                                │
///        │                           ├──render, all tiles loaded──┐   │
///        │                           │                            │   │
///        │                           ◀────────────────────────────┘   │
///        │◀────────MapLoaded─────────┤                                │
///        │                           │                                │
///        │                           │                                │
///        │◀─────────MapIdle──────────┤                                │
///        │                    ┌ ─── ─┴─ ─── ┐                         │
///        │                    │   offline   │                         │
///        │                    └ ─── ─┬─ ─── ┘                         │
///        │                           │                                │
///        ├─────────setCamera────────▶│                                │
///        │                           ├───────────get tiles───────────▶│
///        │                           │                                │
///        │                           │┌ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─   │
///        │◀─────────MapIdle──────────┤   waiting for connectivity  │  │
///        │                           ││  Map renders cached data      │
///        │                           │ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ┘  │
///        │                           │                                │
/// ```

/// The time interval of an event. The `begin` property represents the time
/// origin of an event, and the `end` property represents the time when the particular
/// operation is complete. The timestamps are sampled at the origin and do not include
/// the time required to dispatch an event.
class EventTimeInterval {
  /// Representing timestamp taken at the time of an event creation; in microseconds; since the epoch.
  final DateTime begin;

  /// For an interfinal events; an optional `end` property will be present that represents timestamp taken at the time
  /// of an event completion.
  final DateTime end;

  EventTimeInterval.fromJson(Map<String, dynamic> json)
      : begin = DateTime.fromMicrosecondsSinceEpoch(json['begin']),
        end = DateTime.fromMicrosecondsSinceEpoch(json['end']);

  @override
  String toString() {
    return "EventTimeInterval begin: $begin, end: $end";
  }
}

/// The class for camera-changed event in Observer
class CameraChangedEventData {
  /// The time when the camera was changed.
  final int timestamp;

  /// The current state of the camera.
  final CameraState cameraState;

  CameraChangedEventData.fromJson(Map<String, dynamic> json)
      : timestamp = json['timestamp'],
        cameraState = Conversion.fromJson(json['cameraState']);
}

/// The class for map-idle event in Observer
class MapIdleEventData {
  /// The timestamp of the `MapIdle` event.
  final int timestamp;

  MapIdleEventData.fromJson(Map<String, dynamic> json)
      : timestamp = json['timestamp'];
}

/// The class for map-loaded event in Observer
class MapLoadedEventData {
  /// The `timeInterval.begin` represents the time when a style is set, and the
  /// `timeInterval.end` is taken when the `map` is fully loaded.
  final EventTimeInterval timeInterval;

  MapLoadedEventData.fromJson(Map<String, dynamic> json)
      : timeInterval = EventTimeInterval.fromJson(json['timeInterval']);
}

/// The class for map-loading-error event in Observer
class MapLoadingErrorEventData {
  /// Defines what resource could not be loaded.
  final MapLoadErrorType type;

  /// The descriptive error message of the error.
  final String message;

  /// In case of `source` or `tile` loading errors; `source-id` will contain the id of the source failing.
  final String? sourceId;

  /// In case of `tile` loading errors; `tile-id` will contain the id of the tile.
  final TileID? tileId;

  /// The timestamp of the `MapLoadingError` event.
  final int timestamp;

  MapLoadingErrorEventData.fromJson(Map<String, dynamic> json)
      : type = MapLoadErrorType.values[json['type']],
        message = json['message'],
        sourceId = json['sourceId'],
        tileId =
            json['tileId'] != null ? TileID.fromJson(json['tileId']) : null,
        timestamp = json['timestamp'];
}

/// The class for render-frame-finished event in Observer
class RenderFrameFinishedEventData {
  /// The `timeInterval.begin` is when the `map` started rendering the frame, and
  /// `timeInterval.end` is when the frame was rendered.
  final EventTimeInterval timeInterval;

  /// The render-mode finalue tells whether the Map has all {"full"} required to render the visible viewport.
  final RenderMode renderMode;

  /// The needs-repaint finalue provides information about ongoing transitions that trigger Map repaint.
  final bool needsRepaint;

  /// The placement-changed finalue tells if the symbol placement has been changed in the visible viewport.
  final bool placementChanged;

  RenderFrameFinishedEventData.fromJson(Map<String, dynamic> json)
      : timeInterval = EventTimeInterval.fromJson(json['timeInterval']),
        renderMode = RenderMode.values[json['renderMode']],
        placementChanged = json['placementChanged'],
        needsRepaint = json['needsRepaint'];
}

/// Describes whether a map or frame has been fully rendered or not.
/// @param value String value of this enum
enum RenderMode {
  /// The map is partially rendered. Partially rendered map means
  /// that not all data needed to render the map has been arrived
  /// from the network or being parsed.
  PARTIAL,

  /// The map is fully rendered.
  FULL
}

/// The class for render-frame-started event in Observer
class RenderFrameStartedEventData {
  /// The timestamp of an event when the `map` started rendering the frame.
  final int timestamp;

  RenderFrameStartedEventData.fromJson(Map<String, dynamic> json)
      : timestamp = json['timestamp'];
}

///The class for event in Observer
class ResourceEventData {
  /// The timestamps of the resource request event. The `timeInterval.begin` is when
  /// the resource request is made, and the `timeInterval.end` is when the request is completed.
  final EventTimeInterval timeInterval;

  /// The type of data source from which the resource is requested.
  final DataSourceType dataSource;

  /// "request" property
  final Request request;

  /// "response" property
  final Response? response;

  /// "cancelled" property
  final bool cancelled;

  ResourceEventData.fromJson(Map<String, dynamic> json)
      : timeInterval = EventTimeInterval.fromJson(json['timeInterval']),
        dataSource = DataSourceType.values[json['source']],
        request = Request.fromJson(json['request']),
        response = json['response'] != null
            ? Response.fromJson(json['response'])
            : null,
        cancelled = json['cancelled'];
}

/// Describes data source of request for resource-request event.
/// @param value String value of this enum
enum DataSourceType {
  /// data source as asset.
  ASSET,

  /// data source as database.
  DATABASE,

  /// data source as file-system.
  FILE_SYSTEM,

  /// data source as network.
  NETWORK,

  /// data source as resource-loader.
  RESOURCE_LOADER,
}

/// The class for source-added event in Observer
class SourceAddedEventData {
  /// The timestamp of source addition.
  final int timestamp;

  /// The ID of the added source.
  final String id;

  SourceAddedEventData.fromJson(Map<String, dynamic> json)
      : id = json['sourceId'],
        timestamp = json['timestamp'];
}

/// The class for source-data-loaded event in Observer
class SourceDataLoadedEventData {
  /// The 'id' property defines the source id.
  final String id;

  /// The 'type' property defines if source's meta{e.g.; TileJSON} or tile has been loaded.
  final SourceDataType type;

  /// The 'loaded' property will be set to 'true' if all source's required for Map's visible viewport; are loaded.
  final bool? loaded;

  /// The 'tile-id' property defines the tile id if the 'type' field equals 'tile'.
  final TileID? tileID;

  /// When the `type` of an event is `SourceDataLoadedType.Metadata` and the
  /// data identifier was provided to the `setStyleGeoJSONSourceData` method,
  /// this property can be used to determine what data was loaded by the `GeoJSON` source.
  final String? dataId;

  /// The `timeInterval.begin` is when source data begins loading, and the `timeInterval.end` is when source data is loaded.
  final EventTimeInterval timeInterval;

  SourceDataLoadedEventData.fromJson(Map<String, dynamic> json)
      : id = json['sourceId'],
        type = SourceDataType.values[json['type']],
        loaded = json['loaded'],
        tileID =
            json['tileId'] != null ? TileID.fromJson(json['tileId']) : null,
        dataId = json['dataId'],
        timeInterval = EventTimeInterval.fromJson(json['timeInterval']);
}

/// The class for source-removed event in Observer
class SourceRemovedEventData {
  /// The timestamp of source removal.
  final int timestamp;

  /// The ID of the removal source.
  final String id;

  SourceRemovedEventData.fromJson(Map<String, dynamic> json)
      : id = json['sourceId'],
        timestamp = json['timestamp'];
}

/// The class for style-data-loaded event in Observer
class StyleDataLoadedEventData {
  /// The `timeInterval.begin` is when style data begins loading, and the `timeInterval.end` is when style data is loaded.
  final EventTimeInterval timeInterval;

  /// The 'type' property defines what kind of style has been loaded.
  final StyleDataType type;

  StyleDataLoadedEventData.fromJson(Map<String, dynamic> json)
      : type = StyleDataType.values[json['type']],
        timeInterval = EventTimeInterval.fromJson(json['timeInterval']);
}

/// The class for style-image-missing event in Observer
class StyleImageMissingEventData {
  /// The timestamp of an event when the `map` requested a missing image.
  final int timestamp;

  /// The ID of the missing image.
  final String id;

  StyleImageMissingEventData.fromJson(Map<String, dynamic> json)
      : timestamp = json['timestamp'],
        id = json['imageId'];
}

/// The class for style-image-remove-unused event in Observer
class StyleImageUnusedEventData {
  /// The timestamp of an event when the `map` no longer needs a previously added image.
  final int timestamp;

  /// The identifier of an image that is not used by the `map`.
  final String id;

  StyleImageUnusedEventData.fromJson(Map<String, dynamic> json)
      : timestamp = json['timestamp'],
        id = json['imageId'];
}

/// The class for style-loaded event in Observer
class StyleLoadedEventData {
  /// The `timeInterval.begin` is when the style begins loading, and the `timeInterval.end` is when the style is loaded.
  final EventTimeInterval timeInterval;

  StyleLoadedEventData.fromJson(Map<String, dynamic> json)
      : timeInterval = EventTimeInterval.fromJson(json['timeInterval']);
}

/// Describes an error type while loading the map.
/// Defines what resource could not be loaded.
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
  TILE
}

/// Defines what kind of style data has been loaded in a style-data-loaded event.
/// @param finalue String finalue of this enum
enum StyleDataType {
  /// The style data loaded event is associated with style.
  STYLE,

  /// The style data loaded event is associated with sprite.
  SPRITE,

  /// The style data loaded event is associated with sources.
  SOURCES
}

/// Defines what kind of source data has been loaded in a source-data-loaded event.
/// @param finalue String finalue of this enum
enum SourceDataType {
  /// The source data loaded event is associated with source metadata.
  METADATA,

  /// The source data loaded event is associated with source tile.
  TILE
}

/// Defines the tile id in a source-data-loaded event.
class TileID {
  /// The zoom level.
  final int z;

  /// The x coordinate of the tile
  final int x;

  /// The y coordinate of the tile
  final int y;

  TileID.fromJson(Map<String, dynamic> json)
      : x = json['x'],
        y = json['y'],
        z = json['z'];

  dynamic toMap() => <String, dynamic>{'x': x, 'y': y, 'z': z};
}

///The data class for error in Observer
class Error {
  /// "reason" property
  final ResponseErrorReason reason;

  /// "message" property
  final String message;

  Error.fromJson(Map<String, dynamic> json)
      : reason = ResponseErrorReason.values[json['reason']],
        message = json['message'];
}

/// The response data class that included in EventData
class Response {
  /// "etag" property
  final String? eTag;

  /// "must-revalidate" property
  final bool mustRevalidate;

  /// "no-content" property
  final bool noContent;

  /// "modified" property
  final DateTime? modified;

  /// "source" property
  final ResponseSourceType source;

  /// "notModified" property
  final bool notModified;

  /// "expires" property
  final DateTime? expires;

  /// "size" property
  final int size;

  /// "error" property
  final Error? error;

  Response.fromJson(Map<String, dynamic> json)
      : eTag = json['etag'],
        mustRevalidate = json['mustRevalidate'],
        noContent = json['noContent'],
        modified = json['modified'] != null
            ? DateTime.fromMicrosecondsSinceEpoch(json['modified'])
            : null,
        source = ResponseSourceType.values[json['source']],
        notModified = json['notModified'],
        expires = json['expires'] != null
            ? DateTime.fromMicrosecondsSinceEpoch(json['expires'])
            : null,
        size = json['size'],
        error = json['error'] != null ? Error.fromJson(json['error']) : null;
}

/// Describes source data type for response in resource-request event.
/// @param value String value of this enum
enum ResponseSourceType {
  /// source type as network.
  NETWORK,

  /// source type as cache.
  CACHE,

  /// source type as tile-store.
  TILE_STORE,

  /// source type as local-file.
  LOCAL_FILE,
}

/// The enumeration defines the method used to make a resource request.
enum RequestLoadingMethodType {
  /// The engine should try loading a resource from the network.
  NETWORK,

  /// The engine should try loading a resource from the cache.
  CACHE
}

/// The request data class that included in EventData
class Request {
  /// "loading-method" property
  final List<RequestLoadingMethodType> loadingMethod;

  /// "url" property
  final String url;

  /// The type of a requested resource
  final RequestType kind;

  /// "priority" property
  final RequestPriority priority;

  Request.fromJson(Map<String, dynamic> json)
      : loadingMethod = json['loadingMethod']
            .cast<int>()
            .map((e) => RequestLoadingMethodType.values[e])
            .toList()
            .cast<RequestLoadingMethodType>(),
        url = json['url'],
        kind = RequestType.values[json['resource']],
        priority = RequestPriority.values[json['priority']];
}

/// Describes type for request object.
/// @param value String value of this enum
enum RequestType {
  /// Request type unknown.
  UNKNOWN,

  /// Request type style.
  STYLE,

  /// Request type source.
  SOURCE,

  /// Request type tile.
  TILE,

  /// Request type glyphs.
  GLYPHS,

  /// Request type sprite-image.
  SPRITE_IMAGE,

  /// Request type sprite-json.
  SPRITE_JSON,

  /// Request type image.
  IMAGE,

  /// The resource type is a 3D model.
  MODEL
}

/// Describes priority for request object.
/// @param value String value of this enum
enum RequestPriority {
  /// Regular priority.
  REGULAR,

  /// low priority.
  LOW
}
