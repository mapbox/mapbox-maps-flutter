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

/// The part of a serialized GeoJSON source spec this package reads back.
extension type JSGeoJSONSourceSpec._(JSObject _) implements JSObject {
  external bool? get dynamic;
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

  /// Each cluster query calls [callback] with `(error, result)`.
  external void getClusterLeaves(
    int clusterId,
    int limit,
    int offset,
    JSFunction callback,
  );
  external void getClusterChildren(int clusterId, JSFunction callback);
  external void getClusterExpansionZoom(int clusterId, JSFunction callback);

  /// Whether the source spec declared `dynamic: true`, required by [updateData].
  bool get isDynamic => (serialize() as JSGeoJSONSourceSpec).dynamic ?? false;
}

/// Runtime `ImageSource` instance returned by [Style.getSource].
extension type JSImageSource._(JSObject _) implements JSSource {
  external void updateImage(JSImageSourceUpdateOptions update);
  external void setCoordinates(JSArray<JSLngLatPair> coordinates);
}

/// Options object accepted by `ImageSource.updateImage`.
@JS()
@anonymous
extension type JSImageSourceUpdateOptions._(JSObject _) implements JSObject {
  external factory JSImageSourceUpdateOptions({required String url});
}

/// Runtime tile source instance returned by [Style.getSource]. GL JS
/// raster, raster-dem, raster-array and vector sources share these setters.
extension type JSRasterTileSource._(JSObject _) implements JSSource {
  external void setUrl(JSString url);
  external void setTiles(JSAny tiles);
  external void setMinzoom(double minzoom);
  external void setMaxzoom(double maxzoom);
}

/// Runtime `ModelSource` instance returned by [Style.getSource].
///
/// [setModels] takes an object of model specifications by model id.
extension type JSModelSource._(JSObject _) implements JSSource {
  external void setModels(JSAny models);
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

/// Mirrors gl-js's `ImportSpecification` plain-object shape. [url] is
/// required by the type system but may be passed as an empty string when
/// [data] supplies the style JSON inline — the caller is responsible for
/// ensuring at least one of [url] or [data] is meaningful.
@JS()
@anonymous
extension type JSImportSpecification._(JSObject _) implements JSObject {
  external factory JSImportSpecification({
    required String id,
    required String url,
    JSAny? data,
    JSAny? config,
  });
}

/// An `ImageData` or `ImageBitmap`, the image types that gl-js `addImage`
/// and `updateImage` accept.
extension type JSSizedImage._(JSObject _) implements JSObject {
  external int get width;
  external int get height;
}

// ===== Internal style image access =====

extension type JSInternalStyle._(JSObject _) implements JSObject {
  /// Accepts a plain id string: the lookup only calls `toString()` on it.
  /// Searches the root style scope only, not imported styles.
  external JSInternalStyleImage? getImage(String id);
}

extension type JSInternalStyleImage._(JSObject _) implements JSObject {
  /// Straight (non-premultiplied) RGBA pixels. Null for images that GL JS
  /// rasterizes on demand, for example SVG icons from an iconset.
  external JSInternalRGBAImage? get data;
  external double get pixelRatio;
  external bool get sdf;
  external JSArray<JSArray<JSNumber>>? get stretchX;
  external JSArray<JSArray<JSNumber>>? get stretchY;
  external JSArray<JSNumber>? get content;
}

extension type JSInternalRGBAImage._(JSObject _) implements JSObject {
  external int get width;
  external int get height;
  external JSUint8Array get data;
}

/// Mirrors gl-js's `TransitionSpecification`.
///
/// Set only the values that exist. GL JS validation rejects a `null` value.
extension type JSTransitionSpecification._(JSObject _) implements JSObject {
  JSTransitionSpecification() : _ = JSObject();

  external int? get duration;
  external set duration(int value);
  external int? get delay;
  external set delay(int value);
}

/// Mirrors gl-js's `LightsSpecification`: an ambient, directional or flat
/// light.
@JS()
@anonymous
extension type JSLightSpecification._(JSObject _) implements JSObject {
  external factory JSLightSpecification({
    required String id,
    required String type,
    JSObject? properties,
  });

  external String get id;
  external String get type;
  external JSObject? get properties;
}

/// The `properties` of a flat light.
///
/// Set only the values that exist. GL JS validation rejects a `null` value.
extension type JSFlatLightProperties._(JSObject _) implements JSObject {
  JSFlatLightProperties() : _ = JSObject();

  external set anchor(String value);
  external set color(String value);
  @JS('color-transition')
  external set colorTransition(JSTransitionSpecification value);
  external set intensity(double value);
  @JS('intensity-transition')
  external set intensityTransition(JSTransitionSpecification value);
  external set position(JSArray<JSNumber> value);
  @JS('position-transition')
  external set positionTransition(JSTransitionSpecification value);
}

/// The `properties` of an ambient light.
///
/// Set only the values that exist. GL JS validation rejects a `null` value.
extension type JSAmbientLightProperties._(JSObject _) implements JSObject {
  JSAmbientLightProperties() : _ = JSObject();

  external set color(String value);
  @JS('color-use-theme')
  external set colorUseTheme(String value);
  @JS('color-transition')
  external set colorTransition(JSTransitionSpecification value);
  external set intensity(double value);
  @JS('intensity-transition')
  external set intensityTransition(JSTransitionSpecification value);
}

/// The `properties` of a directional light.
///
/// Set only the values that exist. GL JS validation rejects a `null` value.
extension type JSDirectionalLightProperties._(JSObject _) implements JSObject {
  JSDirectionalLightProperties() : _ = JSObject();

  @JS('cast-shadows')
  external set castShadows(bool value);
  external set color(String value);
  @JS('color-use-theme')
  external set colorUseTheme(String value);
  @JS('color-transition')
  external set colorTransition(JSTransitionSpecification value);
  external set direction(JSArray<JSNumber> value);
  @JS('direction-transition')
  external set directionTransition(JSTransitionSpecification value);
  external set intensity(double value);
  @JS('intensity-transition')
  external set intensityTransition(JSTransitionSpecification value);
  @JS('shadow-draw-before-layer')
  external set shadowDrawBeforeLayer(String value);
  @JS('shadow-intensity')
  external set shadowIntensity(double value);
  @JS('shadow-intensity-transition')
  external set shadowIntensityTransition(JSTransitionSpecification value);
}

extension StyleFlatLight on JSStyle {
  /// The flat light. GL JS has one for each style, also if the style JSON
  /// has no light. `Map.getLight` gives the same properties, but it is
  /// deprecated and logs a warning.
  external JSFlatLight get light;

  /// The style JSON that GL JS loaded. `Map.setLights` does not change it.
  external JSStyleSpecification get stylesheet;

  /// The [stylesheet], or null before the style loads. GL JS makes a new
  /// object for each new style.
  @JS('stylesheet')
  external JSStyleSpecification? get loadedStylesheet;
}

/// The lights of a style JSON.
extension type JSStyleSpecification._(JSObject _) implements JSObject {
  external JSObject? get light;
  external JSArray<JSLightSpecification>? get lights;
}

/// The flat light of a style.
extension type JSFlatLight._(JSObject _) implements JSObject {
  external String get id;

  /// Returns the properties that have a value.
  external JSObject getLight();
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

  /// The internal GL JS `Style` instance. Null before the first style load.
  @JS('style')
  external JSInternalStyle? get internalStyle;

  // ----- Models -----
  external void addModel(String id, String url);
  external void removeModel(String id);
  external bool hasModel(String id);

  // ----- Lights / terrain / projection -----
  external void setLights(JSArray<JSLightSpecification>? lights);

  /// Returns the ambient and directional lights. Without them, returns only
  /// the flat light, which GL JS always has.
  external JSArray<JSLightSpecification>? getLights();
  external void setTerrain(JSAny? terrain);
  external JSAny? getTerrain();
  external void setProjection(JSAny projection);
  external JSAny? getProjection();

  // ----- Imports -----
  external void addImport(JSImportSpecification spec, [String? beforeId]);
  external void updateImport(String id, JSAny spec);
  external void removeImport(String id);
  external void moveImport(String id, [String? beforeId]);
  external JSAny? getConfig(String importId);
  external void setConfig(String importId, JSAny config);
  external JSAny? getConfigProperty(String importId, String configName);
  external void setConfigProperty(
    String importId,
    String configName,
    JSAny? value,
  );
  external JSAny? getSchema(String importId);
  external void setColorTheme(JSAny? colorTheme);
  external void setImportColorTheme(String importId, JSAny? colorTheme);
  external void setFog(JSAny? fog);
  external JSAny? getFog();
  external void setSnow(JSAny? snow);
  external JSAny? getSnow();
  external void setRain(JSAny? rain);
  external JSAny? getRain();

  // ----- Transition -----
  external void setTransition(JSTransitionSpecification transition);

  /// Returns the transition with the GL JS default values for a duration or
  /// delay that the style does not set.
  external JSTransitionSpecification? getTransition();

  /// Sets the duration of the label fade, in milliseconds.
  external void setFadeDuration(int duration);

  /// Returns the duration of the label fade, in milliseconds.
  external int getFadeDuration();
}

// ===== Style spec accessors (returned by JSMap.getStyle()) =====

/// Style-spec accessors layered on top of the camera-only fields declared
/// in [JSStyleSpec] (see `map_bindings.dart`). Same JS object, more reads.
extension StyleSpecAccessors on JSStyleSpec {
  external JSArray<JSLayer>? get layers;
  external JSObject? get sources;
  external JSArray<JSObject>? get imports;
  external String? get glyphs;
}

/// An entry of the style `imports` array. GL JS sets [data] to the
/// serialized style of the import.
extension type JSImportSpec._(JSObject _) implements JSObject {
  external String get id;
  external JSStyleSpec? get data;
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
