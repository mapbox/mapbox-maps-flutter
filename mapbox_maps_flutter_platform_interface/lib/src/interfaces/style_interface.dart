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

  // ===== Layers =====

  /// Returns all style layers.
  Future<List<StyleObjectInfo?>> getStyleLayers();

  /// Returns whether a layer with the given id exists.
  Future<bool> styleLayerExists(String layerId);

  /// Removes a style layer.
  Future<void> removeStyleLayer(String layerId);

  /// Moves a style layer to a new position.
  Future<void> moveStyleLayer(String layerId, LayerPosition? layerPosition);

  // ===== Sources =====

  /// Returns all style sources.
  Future<List<StyleObjectInfo?>> getStyleSources();

  /// Returns whether a source with the given id exists.
  Future<bool> styleSourceExists(String sourceId);

  /// Removes a style source.
  Future<void> removeStyleSource(String sourceId);

  // ===== Images =====

  /// Returns whether an image with the given id exists.
  Future<bool> hasStyleImage(String imageId);

  /// Removes a style image.
  Future<void> removeStyleImage(String imageId);

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

  /// Returns all properties of a source as a JSON string.
  Future<String> getStyleSourceProperties(String sourceId);

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
