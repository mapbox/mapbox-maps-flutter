import 'package:turf/turf.dart';

import '../pigeons/platform_interface_data_types.dart';

/// Abstract interface for managing the map's style.
///
/// Implementations are provided by platform packages (mobile, web).
/// Layer and source typed APIs are provided through the platform-specific
/// style generators and will be unified in a future update.
abstract interface class StylePlatformInterface {
  // ===== Style loading =====

  /// Loads a style from a URI.
  Future<void> setStyleURI(String uri);

  /// Returns the current style URI.
  Future<String> getStyleURI();

  /// Loads a style from a JSON string.
  Future<void> setStyleJSON(String json);

  /// Returns the current style as a JSON string.
  Future<String> getStyleJSON();

  // ===== Default camera & transition =====

  /// Returns the default camera position defined by the style.
  Future<CameraOptions> getStyleDefaultCamera();

  /// Returns the current style transition options.
  Future<TransitionOptions> getStyleTransition();

  /// Sets the style transition options.
  Future<void> setStyleTransition(TransitionOptions transitionOptions);

  // ===== Style imports =====

  /// Adds a new import to the current style from a JSON string.
  Future<void> addStyleImportFromJSON(
    String importId,
    String json, {
    Map<String, Object>? config,
    ImportPosition? importPosition,
  });

  /// Adds a new import to the current style from a URI.
  Future<void> addStyleImportFromURI(
    String importId,
    String uri, {
    Map<String, Object>? config,
    ImportPosition? importPosition,
  });

  /// Updates an existing import from a JSON string.
  Future<void> updateStyleImportWithJSON(
    String importId,
    String json, {
    Map<String, Object>? config,
  });

  /// Updates an existing import from a URI.
  Future<void> updateStyleImportWithURI(
    String importId,
    String uri, {
    Map<String, Object>? config,
  });

  /// Moves an import to a new position.
  Future<void> moveStyleImport(String importId, ImportPosition? importPosition);

  /// Returns all current style imports.
  Future<List<StyleObjectInfo?>> getStyleImports();

  /// Removes an import from the style.
  Future<void> removeStyleImport(String importId);

  /// Returns the schema of a style import.
  Future<Object> getStyleImportSchema(String importId);

  /// Returns all configuration properties for a style import as a map.
  Future<Map<String, StylePropertyValue>> getStyleImportConfigProperties(
    String importId,
  );

  /// Returns a single configuration property for a style import.
  Future<StylePropertyValue> getStyleImportConfigProperty(
    String importId,
    String config,
  );

  // ===== Layers =====

  /// Adds a new style layer from a JSON properties string.
  Future<void> addStyleLayer(String properties, LayerPosition? layerPosition);

  /// Adds a persistent style layer. Persistent layers survive style reloads
  /// when the new style does not redefine the same layer id.
  Future<void> addPersistentStyleLayer(
    String properties,
    LayerPosition? layerPosition,
  );

  /// Returns whether the layer with the given id is persistent.
  Future<bool> isStyleLayerPersistent(String layerId);

  /// Returns the live value of a single layer property.
  Future<StylePropertyValue> getStyleLayerProperty(
    String layerId,
    String property,
  );

  /// Returns all style layers.
  Future<List<StyleObjectInfo?>> getStyleLayers();

  /// Returns whether a layer with the given id exists.
  Future<bool> styleLayerExists(String layerId);

  /// Removes a style layer.
  Future<void> removeStyleLayer(String layerId);

  /// Moves a style layer to a new position.
  Future<void> moveStyleLayer(String layerId, LayerPosition? layerPosition);

  // ===== Sources =====

  /// Adds a new style source from a JSON properties string.
  Future<void> addStyleSource(String sourceId, String properties);

  /// Returns all style sources.
  Future<List<StyleObjectInfo?>> getStyleSources();

  /// Returns whether a source with the given id exists.
  Future<bool> styleSourceExists(String sourceId);

  /// Removes a style source.
  Future<void> removeStyleSource(String sourceId);

  // ===== GeoJSON source partial updates =====

  /// Adds features to a GeoJSON style source. The add operation is scheduled
  /// and applied on a GeoJSON serialization queue; observe `onSourceDataLoaded`
  /// to know when changes are visible.
  Future<void> addGeoJSONSourceFeatures(
    String sourceId,
    String dataId,
    List<Feature> features,
  );

  /// Updates existing features in a GeoJSON style source. Features are matched
  /// by id; provide unique ids on every feature to avoid `map-loading-error`.
  Future<void> updateGeoJSONSourceFeatures(
    String sourceId,
    String dataId,
    List<Feature> features,
  );

  /// Removes features from a GeoJSON style source by id.
  Future<void> removeGeoJSONSourceFeatures(
    String sourceId,
    String dataId,
    List<String> featureIds,
  );

  // ===== Images =====

  /// Returns whether an image with the given id exists.
  Future<bool> hasStyleImage(String imageId);

  /// Adds an image to the style. Existing images with the same [imageId] are replaced.
  Future<void> addStyleImage(
    String imageId,
    double scale,
    MbxImage image,
    bool sdf,
    List<ImageStretches?> stretchX,
    List<ImageStretches?> stretchY,
    ImageContent? content,
  );

  /// Replaces the image data of an existing image-type style source.
  Future<void> updateStyleImageSourceImage(String sourceId, MbxImage image);

  /// Removes a style image.
  Future<void> removeStyleImage(String imageId);

  // ===== Models =====

  /// Adds a 3D model to the style for use as `model-id` in a model layer.
  /// If a model with the same id already exists, it is replaced.
  Future<void> addStyleModel(String modelId, String modelUri);

  /// Removes a 3D model from the style.
  Future<void> removeStyleModel(String modelId);

  // ===== Lights =====

  /// Returns the current style's lights.
  Future<List<StyleObjectInfo?>> getStyleLights();

  /// Sets a single flat light source. Use [setLights] for ambient + directional.
  Future<void> setLight(FlatLight flatLight);

  /// Sets ambient + directional lights together. Disables any flat light.
  Future<void> setLights(
    AmbientLight ambientLight,
    DirectionalLight directionalLight,
  );

  /// Returns the live value of a single light property.
  Future<StylePropertyValue> getStyleLightProperty(String id, String property);

  /// Sets a value on a single light property.
  Future<void> setStyleLightProperty(String id, String property, Object value);

  // ===== Terrain property access =====

  /// Returns the live value of a single terrain property.
  Future<StylePropertyValue> getStyleTerrainProperty(String property);

  /// Sets a value on a single terrain property.
  Future<void> setStyleTerrainProperty(String property, Object value);

  // ===== Image lookup =====

  /// Returns a previously-added style image, or null if none exists for [imageId].
  Future<MbxImage?> getStyleImage(String imageId);

  // ===== Custom geometry source invalidation =====

  /// Invalidates a tile in a custom geometry source so it gets re-fetched.
  Future<void> invalidateStyleCustomGeometrySourceTile(
    String sourceId,
    CanonicalTileID tileId,
  );

  /// Invalidates a region in a custom geometry source so its tiles get re-fetched.
  Future<void> invalidateStyleCustomGeometrySourceRegion(
    String sourceId,
    CoordinateBounds bounds,
  );

  // ===== Style state =====

  /// Returns whether the style is fully loaded.
  Future<bool> isStyleLoaded();

  /// Localizes label text in the style for the given locale, optionally
  /// scoped to a subset of layers.
  Future<void> localizeLabels(String locale, List<String>? layerIds);

  /// Returns the featuresets defined by the currently loaded style.
  Future<List<FeaturesetDescriptor>> getFeaturesets();

  // ===== Projection =====

  /// Returns the style projection.
  Future<StyleProjection?> getProjection();

  /// Sets the style projection.
  Future<void> setProjection(StyleProjection projection);

  // ===== Low-level property access =====

  /// Sets a layer property value from a JSON string.
  Future<void> setStyleLayerProperty(
    String layerId,
    String property,
    Object value,
  );

  /// Returns all properties of a layer as a JSON string.
  Future<String> getStyleLayerProperties(String layerId);

  /// Sets all properties of a layer from a JSON object string.
  Future<void> setStyleLayerProperties(String layerId, String properties);

  /// Returns all properties of a source as a JSON string. This reflects
  /// the source's declarative payload (the JSON passed to `addStyleSource`);
  /// volatile runtime properties updated via [setStyleSourceProperty] or
  /// [setStyleSourceProperties] are not always included. For a single-property
  /// live read that does see volatile values, use [getStyleSourceProperty].
  Future<String> getStyleSourceProperties(String sourceId);

  /// Returns the live value of a single source property as a
  /// [StylePropertyValue] envelope (raw value + kind). Reflects volatile
  /// runtime state, unlike [getStyleSourceProperties].
  Future<StylePropertyValue> getStyleSourceProperty(
    String sourceId,
    String property,
  );

  /// Sets a source property value from a JSON string.
  Future<void> setStyleSourceProperty(
    String sourceId,
    String property,
    Object value,
  );

  /// Sets all properties of a source from a JSON object string.
  Future<void> setStyleSourceProperties(String sourceId, String properties);

  /// Sets an import configuration property value.
  Future<void> setStyleImportConfigProperty(
    String importId,
    String config,
    Object value,
  );

  /// Sets all configuration properties for an import from a map.
  Future<void> setStyleImportConfigProperties(
    String importId,
    Map<String, Object> configs,
  );

  /// Sets the style terrain from a JSON string.
  Future<void> setStyleTerrain(String properties);
}
