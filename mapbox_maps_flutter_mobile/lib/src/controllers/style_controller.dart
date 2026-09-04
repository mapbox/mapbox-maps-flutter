part of 'package:mapbox_maps_flutter_mobile/mapbox_maps_flutter_mobile.dart';

/// Mobile [StylePlatformInterface] implementation, backed by the
/// pigeon-generated [StyleManager]. Forwards every call as-is, except the
/// image methods, which convert the public [StyleImage] to and from the
/// pigeon [StyleImageWire] crossed over the platform channel.
class StyleController implements StylePlatformInterface {
  StyleController(this._api);

  final StyleManager _api;

  // ===== Style loading =====

  @override
  Future<void> setStyleURI(String uri) => _api.setStyleURI(uri);

  @override
  Future<String> getStyleURI() => _api.getStyleURI();

  @override
  Future<void> setStyleJSON(String json) => _api.setStyleJSON(json);

  @override
  Future<String> getStyleJSON() => _api.getStyleJSON();

  // ===== Default camera & transition =====

  @override
  Future<CameraOptions> getStyleDefaultCamera() => _api.getStyleDefaultCamera();

  @override
  Future<TransitionOptions> getStyleTransition() => _api.getStyleTransition();

  @override
  Future<void> setStyleTransition(TransitionOptions transitionOptions) =>
      _api.setStyleTransition(transitionOptions);

  // ===== Style imports =====

  @override
  Future<void> addStyleImportFromJSON(
    String importId,
    String json, {
    Map<String, Object>? config,
    ImportPosition? importPosition,
  }) => _api.addStyleImportFromJSON(
    importId,
    json,
    config: config,
    importPosition: importPosition,
  );

  @override
  Future<void> addStyleImportFromURI(
    String importId,
    String uri, {
    Map<String, Object>? config,
    ImportPosition? importPosition,
  }) => _api.addStyleImportFromURI(
    importId,
    uri,
    config: config,
    importPosition: importPosition,
  );

  @override
  Future<void> updateStyleImportWithJSON(
    String importId,
    String json, {
    Map<String, Object>? config,
  }) => _api.updateStyleImportWithJSON(importId, json, config: config);

  @override
  Future<void> updateStyleImportWithURI(
    String importId,
    String uri, {
    Map<String, Object>? config,
  }) => _api.updateStyleImportWithURI(importId, uri, config: config);

  @override
  Future<void> moveStyleImport(
    String importId,
    ImportPosition? importPosition,
  ) => _api.moveStyleImport(importId, importPosition);

  @override
  Future<List<StyleObjectInfo?>> getStyleImports() => _api.getStyleImports();

  @override
  Future<void> removeStyleImport(String importId) =>
      _api.removeStyleImport(importId);

  @override
  Future<Object> getStyleImportSchema(String importId) =>
      _api.getStyleImportSchema(importId);

  @override
  Future<Map<String, StylePropertyValue>> getStyleImportConfigProperties(
    String importId,
  ) => _api.getStyleImportConfigProperties(importId);

  @override
  Future<StylePropertyValue> getStyleImportConfigProperty(
    String importId,
    String config,
  ) => _api.getStyleImportConfigProperty(importId, config);

  // ===== Layers =====

  @override
  Future<void> addStyleLayer(String properties, LayerPosition? layerPosition) =>
      _api.addStyleLayer(properties, layerPosition);

  @override
  Future<void> addPersistentStyleLayer(
    String properties,
    LayerPosition? layerPosition,
  ) => _api.addPersistentStyleLayer(properties, layerPosition);

  @override
  Future<bool> isStyleLayerPersistent(String layerId) =>
      _api.isStyleLayerPersistent(layerId);

  @override
  Future<StylePropertyValue> getStyleLayerProperty(
    String layerId,
    String property,
  ) => _api.getStyleLayerProperty(layerId, property);

  @override
  Future<List<StyleObjectInfo?>> getStyleLayers() => _api.getStyleLayers();

  @override
  Future<bool> styleLayerExists(String layerId) =>
      _api.styleLayerExists(layerId);

  @override
  Future<void> removeStyleLayer(String layerId) =>
      _api.removeStyleLayer(layerId);

  @override
  Future<void> moveStyleLayer(String layerId, LayerPosition? layerPosition) =>
      _api.moveStyleLayer(layerId, layerPosition);

  // ===== Sources =====

  @override
  Future<void> addStyleSource(String sourceId, String properties) =>
      _api.addStyleSource(sourceId, properties);

  @override
  Future<List<StyleObjectInfo?>> getStyleSources() => _api.getStyleSources();

  @override
  Future<bool> styleSourceExists(String sourceId) =>
      _api.styleSourceExists(sourceId);

  @override
  Future<void> removeStyleSource(String sourceId) =>
      _api.removeStyleSource(sourceId);

  // ===== GeoJSON source partial updates =====

  @override
  Future<void> addGeoJSONSourceFeatures(
    String sourceId,
    String dataId,
    List<Feature> features,
  ) => _api.addGeoJSONSourceFeatures(sourceId, dataId, features);

  @override
  Future<void> updateGeoJSONSourceFeatures(
    String sourceId,
    String dataId,
    List<Feature> features,
  ) => _api.updateGeoJSONSourceFeatures(sourceId, dataId, features);

  @override
  Future<void> removeGeoJSONSourceFeatures(
    String sourceId,
    String dataId,
    List<String> featureIds,
  ) => _api.removeGeoJSONSourceFeatures(sourceId, dataId, featureIds);

  // ===== Images =====

  @override
  Future<bool> hasStyleImage(String imageId) => _api.hasStyleImage(imageId);

  @override
  Future<void> addStyleImage(
    String imageId,
    double scale,
    StyleImage image,
    bool sdf,
    List<ImageStretches?> stretchX,
    List<ImageStretches?> stretchY,
    ImageContent? content,
  ) => _api.addStyleImage(
    imageId,
    scale,
    image.toWire(),
    sdf,
    stretchX,
    stretchY,
    content,
  );

  @override
  Future<void> updateStyleImageSourceImage(String sourceId, StyleImage image) =>
      _api.updateStyleImageSourceImage(sourceId, image.toWire());

  @override
  Future<void> removeStyleImage(String imageId) =>
      _api.removeStyleImage(imageId);

  // ===== Models =====

  @override
  Future<void> addStyleModel(String modelId, String modelUri) =>
      _api.addStyleModel(modelId, modelUri);

  @override
  Future<void> removeStyleModel(String modelId) =>
      _api.removeStyleModel(modelId);

  // ===== Lights =====

  @override
  Future<List<StyleObjectInfo?>> getStyleLights() => _api.getStyleLights();

  @override
  Future<void> setLight(FlatLight flatLight) => _api.setLight(flatLight);

  @override
  Future<void> setLights(
    AmbientLight ambientLight,
    DirectionalLight directionalLight,
  ) => _api.setLights(ambientLight, directionalLight);

  @override
  Future<StylePropertyValue> getStyleLightProperty(
    String id,
    String property,
  ) => _api.getStyleLightProperty(id, property);

  @override
  Future<void> setStyleLightProperty(
    String id,
    String property,
    Object value,
  ) => _api.setStyleLightProperty(id, property, value);

  // ===== Terrain property access =====

  @override
  Future<StylePropertyValue> getStyleTerrainProperty(String property) =>
      _api.getStyleTerrainProperty(property);

  @override
  Future<void> setStyleTerrainProperty(String property, Object value) =>
      _api.setStyleTerrainProperty(property, value);

  // ===== Image lookup =====

  @override
  Future<StyleImageRgba?> getStyleImage(String imageId) async =>
      (await _api.getStyleImage(imageId))?.toStyleImageRgba();

  // ===== Custom geometry source invalidation =====

  @override
  Future<void> invalidateStyleCustomGeometrySourceTile(
    String sourceId,
    CanonicalTileID tileId,
  ) => _api.invalidateStyleCustomGeometrySourceTile(sourceId, tileId);

  @override
  Future<void> invalidateStyleCustomGeometrySourceRegion(
    String sourceId,
    CoordinateBounds bounds,
  ) => _api.invalidateStyleCustomGeometrySourceRegion(sourceId, bounds);

  // ===== Style state =====

  @override
  Future<bool> isStyleLoaded() => _api.isStyleLoaded();

  @override
  Future<void> localizeLabels(String locale, List<String>? layerIds) =>
      _api.localizeLabels(locale, layerIds);

  @override
  Future<List<FeaturesetDescriptor>> getFeaturesets() => _api.getFeaturesets();

  // ===== Projection =====

  @override
  Future<StyleProjection?> getProjection() => _api.getProjection();

  @override
  Future<void> setProjection(StyleProjection projection) =>
      _api.setProjection(projection);

  // ===== Low-level property access =====

  @override
  Future<void> setStyleLayerProperty(
    String layerId,
    String property,
    Object value,
  ) => _api.setStyleLayerProperty(layerId, property, value);

  @override
  Future<String> getStyleLayerProperties(String layerId) =>
      _api.getStyleLayerProperties(layerId);

  @override
  Future<void> setStyleLayerProperties(String layerId, String properties) =>
      _api.setStyleLayerProperties(layerId, properties);

  @override
  Future<String> getStyleSourceProperties(String sourceId) =>
      _api.getStyleSourceProperties(sourceId);

  @override
  Future<StylePropertyValue> getStyleSourceProperty(
    String sourceId,
    String property,
  ) => _api.getStyleSourceProperty(sourceId, property);

  @override
  Future<void> setStyleSourceProperty(
    String sourceId,
    String property,
    Object value,
  ) => _api.setStyleSourceProperty(sourceId, property, value);

  @override
  Future<void> setStyleSourceProperties(String sourceId, String properties) =>
      _api.setStyleSourceProperties(sourceId, properties);

  @override
  Future<void> setStyleImportConfigProperty(
    String importId,
    String config,
    Object value,
  ) => _api.setStyleImportConfigProperty(importId, config, value);

  @override
  Future<void> setStyleImportConfigProperties(
    String importId,
    Map<String, Object> configs,
  ) => _api.setStyleImportConfigProperties(importId, configs);

  @override
  Future<void> setStyleTerrain(String properties) =>
      _api.setStyleTerrain(properties);
}
