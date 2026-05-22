@JS('mapboxgl')
library;

import 'dart:js_interop';

import 'map_bindings.dart';

export 'json_helpers.dart' show jsonParse, jsonStringify;

// ===== Layer & source spec types =====

extension type JSLayer._(JSObject _) implements JSObject {
  external String get id;
  external String get type;
}

extension type JSSource._(JSObject _) implements JSObject {
  external String get type;
  external JSObject serialize();
}

/// Runtime `GeoJSONSource` instance returned by [Style.getSource].
///
/// [updateData] needs `dynamic: true` on the source spec; otherwise gl-js
/// fires a `map-loading-error` instead of applying the update. The accepted
/// shape is a FeatureCollection — features are merged by id, and a feature
/// whose `geometry` is `null` removes the prior entry with that id.
extension type JSGeoJSONSource._(JSObject _) implements JSSource {
  external void setData(JSAny data);
  external void updateData(JSAny data);
}

extension type JSImageSource._(JSObject _) implements JSSource {
  /// Current image URL. Needed so coordinates-only updates can pass the
  /// previously-set url back through [updateImage] (which requires it).
  external String get url;
  external void updateImage(JSImageSourceUpdateOptions update);
}

/// Options object accepted by `ImageSource.updateImage`. gl-js requires
/// [url] on every call (even when only the corners change); pass the
/// source's current [JSImageSource.url] through for coordinates-only
/// updates.
///
/// [coordinates] is the optional quad of corner positions clockwise from
/// top-left, each corner a `[longitude, latitude]` pair — exactly four
/// pairs when supplied.
@JS()
@anonymous
extension type JSImageSourceUpdateOptions._(JSObject _) implements JSObject {
  external factory JSImageSourceUpdateOptions({
    required String url,
    JSArray<JSLngLatPair>? coordinates,
  });
}

extension type JSRasterTileSource._(JSObject _) implements JSSource {
  external void setUrl(JSString url);
  external void setTiles(JSAny tiles);
}

// ===== addImage options =====

@JS()
@anonymous
extension type JSAddImageOptions._(JSObject _) implements JSObject {
  external factory JSAddImageOptions({
    double? pixelRatio,
    bool? sdf,
    JSArray<JSArray<JSNumber>>? stretchX,
    JSArray<JSArray<JSNumber>>? stretchY,
    JSArray<JSNumber>? content,
  });
}

/// Plain bag matching the `ImageData`-shape gl-js expects for raw RGBA
/// pixel uploads. We synthesise it rather than going through the browser's
/// `ImageData` constructor — gl-js only reads `{width, height, data}`.
@JS()
@anonymous
extension type JSRawImageData._(JSObject _) implements JSObject {
  external factory JSRawImageData({
    required int width,
    required int height,
    required JSUint8ClampedArray data,
  });
}

// ===== Style API surface on JSMap =====

extension Style on JSMap {
  // ----- Layers -----
  external void addLayer(JSAny layer, [String? beforeId]);
  external void moveLayer(String id, [String? beforeId]);
  external void removeLayer(String id);

  external JSLayer? getLayer(String id);

  external void setLayoutProperty(String layerId, String name, JSAny? value);
  external JSAny? getLayoutProperty(String layerId, String name);
  external void setPaintProperty(String layerId, String name, JSAny? value);
  external JSAny? getPaintProperty(String layerId, String name);
  external void setFilter(String layerId, JSAny? filter);
  external JSAny? getFilter(String layerId);
  external void setLayerZoomRange(
    String layerId,
    double? minzoom,
    double? maxzoom,
  );

  // ----- Sources -----
  external void addSource(String id, JSAny source);
  external void removeSource(String id);

  @JS('getSource')
  external JSSource? getSource(String id);

  // ----- Images -----
  external void addImage(String id, JSAny image, [JSAddImageOptions? options]);
  external void removeImage(String id);
  external bool hasImage(String id);
  external void updateImage(String id, JSAny image);

  // ----- Models -----
  external void addModel(String id, String url);
  external void removeModel(String id);
  external bool hasModel(String id);

  // ----- Lights / terrain / projection -----
  external void setLights(JSArray<JSObject> lights);
  external JSArray<JSObject>? getLights();
  external void setTerrain(JSAny? terrain);
  external JSAny? getTerrain();
  external void setProjection(JSAny projection);
  external JSAny? getProjection();
}

// ===== Style spec accessors (returned by JSMap.getStyle()) =====

/// Style-spec accessors layered on top of the camera-only fields declared
/// in [JSStyleSpec] (see `map_bindings.dart`). Same JS object, more reads.
extension StyleSpecAccessors on JSStyleSpec {
  external JSArray<JSLayer>? get layers;
  external JSObject? get sources;
  external JSArray<JSObject>? get imports;
}

// TODO(roman.laitarenko): remove this after get/setLayerProperty is available in GL JS
const Set<String> kLayoutPropertyNames = {
  'building-base',
  'building-facade',
  'building-facade-floors',
  'building-facade-unit-width',
  'building-facade-window',
  'building-flip-roof-orientation',
  'building-flood-light-ground-radius',
  'building-flood-light-wall-radius',
  'building-height',
  'building-roof-shape',
  'circle-elevation-reference',
  'circle-sort-key',
  'clip-layer-scope',
  'clip-layer-types',
  'fill-construct-bridge-guard-rail',
  'fill-elevation-reference',
  'fill-extrusion-edge-radius',
  'fill-sort-key',
  'icon-allow-overlap',
  'icon-anchor',
  'icon-ignore-placement',
  'icon-image',
  'icon-keep-upright',
  'icon-offset',
  'icon-optional',
  'icon-padding',
  'icon-pitch-alignment',
  'icon-rotate',
  'icon-rotation-alignment',
  'icon-size',
  'icon-size-scale-range',
  'icon-text-fit',
  'icon-text-fit-padding',
  'line-cap',
  'line-cross-slope',
  'line-elevation-ground-scale',
  'line-elevation-reference',
  'line-join',
  'line-miter-limit',
  'line-round-limit',
  'line-sort-key',
  'line-width-unit',
  'line-z-offset',
  'model-allow-density-reduction',
  'model-id',
  'source-max-zoom',
  'symbol-avoid-edges',
  'symbol-elevation-reference',
  'symbol-placement',
  'symbol-sort-key',
  'symbol-spacing',
  'symbol-z-elevate',
  'symbol-z-order',
  'text-allow-overlap',
  'text-anchor',
  'text-field',
  'text-font',
  'text-ignore-placement',
  'text-justify',
  'text-keep-upright',
  'text-letter-spacing',
  'text-line-height',
  'text-max-angle',
  'text-max-width',
  'text-offset',
  'text-optional',
  'text-padding',
  'text-pitch-alignment',
  'text-radial-offset',
  'text-rotate',
  'text-rotation-alignment',
  'text-size',
  'text-size-scale-range',
  'text-transform',
  'text-variable-anchor',
  'text-writing-mode',
  'visibility',
};
