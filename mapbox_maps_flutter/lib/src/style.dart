import 'package:flutter/foundation.dart';
import 'package:mapbox_maps_flutter_platform_interface/mapbox_maps_flutter_platform_interface.dart';

/// Manages the map's style, including layers, sources, images, and imports.
class Style {
  final StylePlatformInterface _impl;

  @internal
  Style(this._impl);

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
  Future<TransitionOptions> getStyleTransition() =>
      _impl.getStyleTransition();

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
  }) =>
      _impl.addStyleImportFromJSON(importId, json,
          config: config, importPosition: importPosition);

  /// Adds a new import to the current style from a URI.
  Future<void> addStyleImportFromURI(
    String importId,
    String uri, {
    Map<String, Object>? config,
    ImportPosition? importPosition,
  }) =>
      _impl.addStyleImportFromURI(importId, uri,
          config: config, importPosition: importPosition);

  /// Updates an existing import from a JSON string.
  Future<void> updateStyleImportWithJSON(
    String importId,
    String json, {
    Map<String, Object>? config,
  }) =>
      _impl.updateStyleImportWithJSON(importId, json, config: config);

  /// Updates an existing import from a URI.
  Future<void> updateStyleImportWithURI(
    String importId,
    String uri, {
    Map<String, Object>? config,
  }) =>
      _impl.updateStyleImportWithURI(importId, uri, config: config);

  /// Moves an import to a new position.
  Future<void> moveStyleImport(String importId,
          {ImportPosition? importPosition}) =>
      _impl.moveStyleImport(importId, importPosition: importPosition);

  /// Returns all current style imports.
  Future<List<StyleObjectInfo?>> getStyleImports() => _impl.getStyleImports();

  /// Removes an import from the style.
  Future<void> removeStyleImport(String importId) =>
      _impl.removeStyleImport(importId);

  /// Returns the schema of a style import.
  Future<Object> getStyleImportSchema(String importId) =>
      _impl.getStyleImportSchema(importId);

  // ===== Layers =====

  /// Returns all style layers.
  Future<List<StyleObjectInfo?>> getStyleLayers() => _impl.getStyleLayers();

  /// Returns whether a layer with the given id exists.
  Future<bool> styleLayerExists(String layerId) =>
      _impl.styleLayerExists(layerId);

  /// Removes a style layer.
  Future<void> removeStyleLayer(String layerId) =>
      _impl.removeStyleLayer(layerId);

  /// Moves a style layer to a new position.
  Future<void> moveStyleLayer(String layerId,
          {LayerPosition? layerPosition}) =>
      _impl.moveStyleLayer(layerId, layerPosition: layerPosition);

  // ===== Sources =====

  /// Returns all style sources.
  Future<List<StyleObjectInfo?>> getStyleSources() => _impl.getStyleSources();

  /// Returns whether a source with the given id exists.
  Future<bool> styleSourceExists(String sourceId) =>
      _impl.styleSourceExists(sourceId);

  /// Removes a style source.
  Future<void> removeStyleSource(String sourceId) =>
      _impl.removeStyleSource(sourceId);

  // ===== Images =====

  /// Returns whether an image with the given id exists.
  Future<bool> hasStyleImage(String imageId) => _impl.hasStyleImage(imageId);

  /// Removes a style image.
  Future<void> removeStyleImage(String imageId) =>
      _impl.removeStyleImage(imageId);

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
  ) =>
      _impl.setStyleLayerProperty(layerId, property, value);

  /// Returns all properties of a layer as a JSON string.
  Future<String> getStyleLayerProperties(String layerId) =>
      _impl.getStyleLayerProperties(layerId);

  /// Sets all properties of a layer from a JSON object string.
  Future<void> setStyleLayerProperties(String layerId, String properties) =>
      _impl.setStyleLayerProperties(layerId, properties);

  /// Returns all properties of a source as a JSON string.
  Future<String> getStyleSourceProperties(String sourceId) =>
      _impl.getStyleSourceProperties(sourceId);

  /// Sets a source property value from a JSON string.
  Future<void> setStyleSourceProperty(
    String sourceId,
    String property,
    Object value,
  ) =>
      _impl.setStyleSourceProperty(sourceId, property, value);

  /// Sets all properties of a source from a JSON object string.
  Future<void> setStyleSourceProperties(String sourceId, String properties) =>
      _impl.setStyleSourceProperties(sourceId, properties);

  /// Sets an import configuration property value.
  Future<void> setStyleImportConfigProperty(
    String importId,
    String config,
    Object value,
  ) =>
      _impl.setStyleImportConfigProperty(importId, config, value);

  /// Sets all configuration properties for an import from a map.
  Future<void> setStyleImportConfigProperties(
    String importId,
    Map<String, Object> configs,
  ) =>
      _impl.setStyleImportConfigProperties(importId, configs);

  /// Sets the style terrain from a JSON string.
  Future<void> setStyleTerrain(String properties) =>
      _impl.setStyleTerrain(properties);
}
