import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:mapbox_maps_flutter_platform_interface/mapbox_maps_flutter_platform_interface.dart';
import 'package:turf/turf.dart';

import 'style/layer/background_layer.dart';
import 'style/layer/circle_layer.dart';
import 'style/layer/clip_layer.dart';
import 'style/layer/fill_extrusion_layer.dart';
import 'style/layer/fill_layer.dart';
import 'style/layer/heatmap_layer.dart';
import 'style/layer/hillshade_layer.dart';
import 'style/layer/layer.dart';
import 'style/layer/line_layer.dart';
import 'style/layer/location_indicator_layer.dart';
import 'style/layer/model_layer.dart';
import 'style/layer/raster_layer.dart';
import 'style/layer/raster_particle_layer.dart';
import 'style/layer/sky_layer.dart';
import 'style/layer/slot_layer.dart';
import 'style/layer/symbol_layer.dart';
import 'style/source/geojson_source.dart';
import 'style/source/image_source.dart';
import 'style/source/raster_source.dart';
import 'style/source/rasterarray_source.dart';
import 'style/source/rasterdem_source.dart';
import 'style/source/source.dart';
import 'style/source/vector_source.dart';

/// Manages the map's style, including layers, sources, images, and imports.
class StyleManager {
  final StylePlatformInterface _impl;

  @internal
  StyleManager(this._impl);

  // ===== Style loading =====

  /// Loads a style from a URI.
  Future<void> setStyleURI(String uri) => _impl.setStyleURI(uri);

  /// Returns the current style URI.
  Future<String> getStyleURI() => _impl.getStyleURI();

  /// Loads a style from a JSON string.
  Future<void> setStyleJSON(String json) => _impl.setStyleJSON(json);

  /// Returns the current style as a JSON string.
  Future<String> getStyleJSON() => _impl.getStyleJSON();

  // ===== Default camera & transition =====

  /// Returns the default camera position defined by the style.
  Future<CameraOptions> getStyleDefaultCamera() =>
      _impl.getStyleDefaultCamera();

  /// Returns the current style transition options.
  Future<TransitionOptions> getStyleTransition() => _impl.getStyleTransition();

  /// Sets the style transition options.
  Future<void> setStyleTransition(TransitionOptions transitionOptions) =>
      _impl.setStyleTransition(transitionOptions);

  // ===== Style imports =====

  /// Adds a new import to the current style from a JSON string.
  Future<void> addStyleImportFromJSON(
    String importId,
    String json, {
    Map<String, Object>? config,
    ImportPosition? importPosition,
  }) => _impl.addStyleImportFromJSON(
    importId,
    json,
    config: config,
    importPosition: importPosition,
  );

  /// Adds a new import to the current style from a URI.
  Future<void> addStyleImportFromURI(
    String importId,
    String uri, {
    Map<String, Object>? config,
    ImportPosition? importPosition,
  }) => _impl.addStyleImportFromURI(
    importId,
    uri,
    config: config,
    importPosition: importPosition,
  );

  /// Updates an existing import from a JSON string.
  Future<void> updateStyleImportWithJSON(
    String importId,
    String json, {
    Map<String, Object>? config,
  }) => _impl.updateStyleImportWithJSON(importId, json, config: config);

  /// Updates an existing import from a URI.
  Future<void> updateStyleImportWithURI(
    String importId,
    String uri, {
    Map<String, Object>? config,
  }) => _impl.updateStyleImportWithURI(importId, uri, config: config);

  /// Moves an import to a new position.
  Future<void> moveStyleImport(
    String importId,
    ImportPosition? importPosition,
  ) => _impl.moveStyleImport(importId, importPosition);

  /// Returns all current style imports.
  Future<List<StyleObjectInfo?>> getStyleImports() => _impl.getStyleImports();

  /// Removes an import from the style.
  Future<void> removeStyleImport(String importId) =>
      _impl.removeStyleImport(importId);

  /// Returns the schema of a style import.
  Future<Object> getStyleImportSchema(String importId) =>
      _impl.getStyleImportSchema(importId);

  /// Returns all configuration properties for a style import as a map.
  Future<Map<String, StylePropertyValue>> getStyleImportConfigProperties(
    String importId,
  ) => _impl.getStyleImportConfigProperties(importId);

  /// Returns a single configuration property for a style import.
  Future<StylePropertyValue> getStyleImportConfigProperty(
    String importId,
    String config,
  ) => _impl.getStyleImportConfigProperty(importId, config);

  // ===== Layers =====

  /// Adds a new style layer from a JSON properties string. Prefer the typed
  /// [addLayer] / [addLayerAt] helpers when constructing layers from facade
  /// classes; this raw-JSON form is for callers driving layers from style
  /// spec strings directly.
  Future<void> addStyleLayer(String properties, LayerPosition? layerPosition) =>
      _impl.addStyleLayer(properties, layerPosition);

  /// Adds a persistent style layer from a JSON properties string. Persistent
  /// layers survive style reloads when the new style does not redefine the
  /// same layer id. Prefer the typed [addPersistentLayer] helpers for facade
  /// layer classes.
  Future<void> addPersistentStyleLayer(
    String properties,
    LayerPosition? layerPosition,
  ) => _impl.addPersistentStyleLayer(properties, layerPosition);

  /// Returns whether the layer with the given id is persistent.
  Future<bool> isStyleLayerPersistent(String layerId) =>
      _impl.isStyleLayerPersistent(layerId);

  /// Returns the live value of a single layer property.
  Future<StylePropertyValue> getStyleLayerProperty(
    String layerId,
    String property,
  ) => _impl.getStyleLayerProperty(layerId, property);

  /// Returns all style layers.
  Future<List<StyleObjectInfo?>> getStyleLayers() => _impl.getStyleLayers();

  /// Returns whether a layer with the given id exists.
  Future<bool> styleLayerExists(String layerId) =>
      _impl.styleLayerExists(layerId);

  /// Removes a style layer.
  Future<void> removeStyleLayer(String layerId) =>
      _impl.removeStyleLayer(layerId);

  /// Moves a style layer to a new position.
  Future<void> moveStyleLayer(String layerId, LayerPosition? layerPosition) =>
      _impl.moveStyleLayer(layerId, layerPosition);

  // ===== Sources =====

  /// Adds a new style source from a JSON properties string. Prefer the typed
  /// [addSource] helper when constructing sources from facade classes; this
  /// raw-JSON form is for callers driving sources from style spec strings.
  Future<void> addStyleSource(String sourceId, String properties) =>
      _impl.addStyleSource(sourceId, properties);

  /// Returns all style sources.
  Future<List<StyleObjectInfo?>> getStyleSources() => _impl.getStyleSources();

  /// Returns whether a source with the given id exists.
  Future<bool> styleSourceExists(String sourceId) =>
      _impl.styleSourceExists(sourceId);

  /// Removes a style source.
  Future<void> removeStyleSource(String sourceId) =>
      _impl.removeStyleSource(sourceId);

  // ===== GeoJSON source partial updates =====

  /// Adds features to a GeoJSON style source.
  Future<void> addGeoJSONSourceFeatures(
    String sourceId,
    String dataId,
    List<Feature> features,
  ) => _impl.addGeoJSONSourceFeatures(sourceId, dataId, features);

  /// Updates existing features in a GeoJSON style source.
  Future<void> updateGeoJSONSourceFeatures(
    String sourceId,
    String dataId,
    List<Feature> features,
  ) => _impl.updateGeoJSONSourceFeatures(sourceId, dataId, features);

  /// Removes features from a GeoJSON style source by id.
  Future<void> removeGeoJSONSourceFeatures(
    String sourceId,
    String dataId,
    List<String> featureIds,
  ) => _impl.removeGeoJSONSourceFeatures(sourceId, dataId, featureIds);

  // ===== Images =====

  /// Returns whether an image with the given id exists.
  Future<bool> hasStyleImage(String imageId) => _impl.hasStyleImage(imageId);

  /// Adds an image to the style. Existing images with the same [imageId] are
  /// replaced. [stretchX] and [stretchY] default to empty lists; [content]
  /// and [sdf] to null/false — mirroring the most common usage.
  Future<void> addStyleImage(
    String imageId,
    double scale,
    MbxImage image, {
    bool sdf = false,
    List<ImageStretches?> stretchX = const <ImageStretches?>[],
    List<ImageStretches?> stretchY = const <ImageStretches?>[],
    ImageContent? content,
  }) => _impl.addStyleImage(
    imageId,
    scale,
    image,
    sdf,
    stretchX,
    stretchY,
    content,
  );

  /// Replaces the image data of an existing image-type style source.
  Future<void> updateStyleImageSourceImage(String sourceId, MbxImage image) =>
      _impl.updateStyleImageSourceImage(sourceId, image);

  /// Removes a style image.
  Future<void> removeStyleImage(String imageId) =>
      _impl.removeStyleImage(imageId);

  // ===== Models =====

  /// Adds a 3D model to the style for use as `model-id` in a model layer.
  Future<void> addStyleModel(String modelId, String modelUri) =>
      _impl.addStyleModel(modelId, modelUri);

  /// Removes a 3D model from the style.
  Future<void> removeStyleModel(String modelId) =>
      _impl.removeStyleModel(modelId);

  // ===== Lights =====

  /// Returns the current style's lights.
  Future<List<StyleObjectInfo?>> getStyleLights() => _impl.getStyleLights();

  /// Sets a single flat light source. Use [setLights] for ambient + directional.
  Future<void> setLight(FlatLight flatLight) => _impl.setLight(flatLight);

  /// Sets ambient + directional lights together. Disables any flat light.
  Future<void> setLights(
    AmbientLight ambientLight,
    DirectionalLight directionalLight,
  ) => _impl.setLights(ambientLight, directionalLight);

  /// Returns the live value of a single light property.
  Future<StylePropertyValue> getStyleLightProperty(
    String id,
    String property,
  ) => _impl.getStyleLightProperty(id, property);

  /// Sets a value on a single light property.
  Future<void> setStyleLightProperty(
    String id,
    String property,
    Object value,
  ) => _impl.setStyleLightProperty(id, property, value);

  // ===== Terrain property access =====

  /// Returns the live value of a single terrain property.
  Future<StylePropertyValue> getStyleTerrainProperty(String property) =>
      _impl.getStyleTerrainProperty(property);

  /// Sets a value on a single terrain property.
  Future<void> setStyleTerrainProperty(String property, Object value) =>
      _impl.setStyleTerrainProperty(property, value);

  // ===== Image lookup =====

  /// Returns a previously-added style image, or null when [imageId] is unknown.
  Future<MbxImage?> getStyleImage(String imageId) =>
      _impl.getStyleImage(imageId);

  // ===== Custom geometry source invalidation =====

  /// Invalidates a tile in a custom geometry source so it gets re-fetched.
  Future<void> invalidateStyleCustomGeometrySourceTile(
    String sourceId,
    CanonicalTileID tileId,
  ) => _impl.invalidateStyleCustomGeometrySourceTile(sourceId, tileId);

  /// Invalidates a region in a custom geometry source so its tiles get re-fetched.
  Future<void> invalidateStyleCustomGeometrySourceRegion(
    String sourceId,
    CoordinateBounds bounds,
  ) => _impl.invalidateStyleCustomGeometrySourceRegion(sourceId, bounds);

  // ===== Style state =====

  /// Returns whether the style is fully loaded.
  Future<bool> isStyleLoaded() => _impl.isStyleLoaded();

  /// Localizes label text in the style for the given locale, optionally
  /// scoped to a subset of layers.
  Future<void> localizeLabels(String locale, List<String>? layerIds) =>
      _impl.localizeLabels(locale, layerIds);

  /// Returns the featuresets defined by the currently loaded style.
  Future<List<FeaturesetDescriptor>> getFeaturesets() => _impl.getFeaturesets();

  // ===== Projection =====

  /// Returns the style projection.
  Future<StyleProjection?> getProjection() => _impl.getProjection();

  /// Sets the style projection.
  Future<void> setProjection(StyleProjection projection) =>
      _impl.setProjection(projection);

  // ===== Low-level property access =====

  /// Sets a layer property value from a JSON string.
  Future<void> setStyleLayerProperty(
    String layerId,
    String property,
    Object value,
  ) => _impl.setStyleLayerProperty(layerId, property, value);

  /// Returns all properties of a layer as a JSON string.
  Future<String> getStyleLayerProperties(String layerId) =>
      _impl.getStyleLayerProperties(layerId);

  /// Sets all properties of a layer from a JSON object string.
  Future<void> setStyleLayerProperties(String layerId, String properties) =>
      _impl.setStyleLayerProperties(layerId, properties);

  /// Returns all properties of a source as a JSON string.
  Future<String> getStyleSourceProperties(String sourceId) =>
      _impl.getStyleSourceProperties(sourceId);

  /// Returns the live value of a single source property as a
  /// [StylePropertyValue] envelope.
  Future<StylePropertyValue> getStyleSourceProperty(
    String sourceId,
    String property,
  ) => _impl.getStyleSourceProperty(sourceId, property);

  /// Sets a source property value from a JSON string.
  Future<void> setStyleSourceProperty(
    String sourceId,
    String property,
    Object value,
  ) => _impl.setStyleSourceProperty(sourceId, property, value);

  /// Sets all properties of a source from a JSON object string.
  Future<void> setStyleSourceProperties(String sourceId, String properties) =>
      _impl.setStyleSourceProperties(sourceId, properties);

  /// Sets an import configuration property value.
  Future<void> setStyleImportConfigProperty(
    String importId,
    String config,
    Object value,
  ) => _impl.setStyleImportConfigProperty(importId, config, value);

  /// Sets all configuration properties for an import from a map.
  Future<void> setStyleImportConfigProperties(
    String importId,
    Map<String, Object> configs,
  ) => _impl.setStyleImportConfigProperties(importId, configs);

  /// Sets the style terrain from a JSON string.
  Future<void> setStyleTerrain(String properties) =>
      _impl.setStyleTerrain(properties);

  // ===== Typed layer/source helpers =====

  /// Adds a [Layer] to the current style. Serializes the layer to JSON and
  /// forwards to [StylePlatformInterface.addStyleLayer].
  Future<void> addLayer(Layer layer, [LayerPosition? position]) async {
    final encoded = await layer.encode();
    return _impl.addStyleLayer(encoded, null);
  }

  /// Adds a persistent [Layer] to the current style. Persistent layers
  /// survive style reloads when the new style does not redefine the layer id.
  Future<void> addPersistentLayer(
    Layer layer, [
    LayerPosition? position,
  ]) async {
    final encoded = await layer.encode();
    return _impl.addPersistentStyleLayer(encoded, null);
  }

  /// Updates an existing layer. Serializes the layer to JSON and forwards
  /// to [StylePlatformInterface.setStyleLayerProperties].
  Future<void> updateLayer(Layer layer) async {
    final encoded = await layer.encode();
    return _impl.setStyleLayerProperties(layer.id, encoded);
  }

  /// Returns a decoded [Layer] by id, or null when [layerId] is unknown or
  /// its type is not handled.
  Future<Layer?> getLayer(String layerId) async {
    final properties = await _impl.getStyleLayerProperties(layerId);
    final map = json.decode(properties);
    switch (map["type"]) {
      case "background":
        return BackgroundLayer.decode(properties);
      case "location-indicator":
        return LocationIndicatorLayer.decode(properties);
      case "sky":
        return SkyLayer.decode(properties);
      case "circle":
        return CircleLayer.decode(properties);
      case "fill-extrusion":
        return FillExtrusionLayer.decode(properties);
      case "fill":
        return FillLayer.decode(properties);
      case "heatmap":
        return HeatmapLayer.decode(properties);
      case "hillshade":
        return HillshadeLayer.decode(properties);
      case "line":
        return LineLayer.decode(properties);
      case "raster":
        return RasterLayer.decode(properties);
      case "symbol":
        return SymbolLayer.decode(properties);
      case "model":
        return ModelLayer.decode(properties);
      case "slot":
        return SlotLayer.decode(properties);
      case "raster-particle":
        return RasterParticleLayer.decode(properties);
      case "clip":
        return ClipLayer.decode(properties);
      default:
        return null;
    }
  }

  /// Adds a [Source] to the current style. Sources with multi-phase add
  /// requirements (e.g. `GeoJsonSource` with initial data) override
  /// [Source.addToStyle] to handle their specifics.
  Future<void> addSource(Source source) => source.addToStyle(_impl);

  /// Updates an existing source. Serializes the source to JSON and forwards
  /// to [StylePlatformInterface.setStyleSourceProperties].
  Future<void> updateSource(Source source) =>
      _impl.setStyleSourceProperties(source.id, source.encode(volatile: true));

  /// Returns a [Source] by id, or null when [sourceId] is unknown or its
  /// type is not handled. The returned source is bound to this style so
  /// subsequent property getters work.
  Future<Source?> getSource(String sourceId) async {
    final properties = await _impl.getStyleSourceProperties(sourceId);
    final map = json.decode(properties);
    Source? source;
    switch (map["type"]) {
      case "vector":
        source = VectorSource(id: sourceId);
        break;
      case "geojson":
        source = GeoJsonSource(id: sourceId);
        break;
      case "image":
        source = ImageSource(id: sourceId);
        break;
      case "raster-dem":
        source = RasterDemSource(id: sourceId);
        break;
      case "raster":
        source = RasterSource(id: sourceId);
        break;
      case "raster-array":
        source = RasterArraySource(id: sourceId);
        break;
    }
    source?.bind(_impl);
    return source;
  }
}

// Silence analyzer warnings for layer/source imports that are used
// dynamically by [StyleManager.getLayer] and [StyleManager.getSource]'s
// switch dispatch. Flagged because Dart has no flow-sensitive reachability
// check for `switch` arms that call static members.
// ignore_for_file: unused_element
