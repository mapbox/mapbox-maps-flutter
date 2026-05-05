import 'dart:typed_data';

import 'package:mapbox_maps_flutter_platform_interface/mapbox_maps_flutter_platform_interface.dart';
import 'package:turf/turf.dart' show Point;

/// Throwing stubs for every [MapboxMapPlatformInterface] sub-interface that
/// the web implementation does not yet back with Mapbox GL JS.
///
/// Error-class choice follows the WS2 handoff checklist:
///   * [UnsupportedError]   — by-design not on web (debug/replay tools,
///                            native-file-system offline).
///   * [UnimplementedError] — not-yet-implemented; GL JS has a plausible
///                            analogue waiting to be wired.
///
/// Settings sub-interfaces (gestures/location/scale bar/compass/attribution/
/// logo/indoor selector) are all [UnimplementedError] — GL JS exposes gesture
/// handlers and a few built-in controls (attribution, scale), but none are
/// wired into this package yet. The web-parity follow-up epic owns unstub.

UnimplementedError _unimplemented(String method, String owner) =>
    UnimplementedError('$owner.$method is not yet implemented on web.');

UnsupportedError _unsupported(String method, String reason) =>
    UnsupportedError('$method is not supported on web: $reason');

class UnsupportedStyleWeb implements StylePlatformInterface {
  @override
  Future<void> setStyleURI(String uri) =>
      throw _unimplemented('setStyleURI', 'Style');
  @override
  Future<String> getStyleURI() => throw _unimplemented('getStyleURI', 'Style');
  @override
  Future<void> setStyleJSON(String json) =>
      throw _unimplemented('setStyleJSON', 'Style');
  @override
  Future<String> getStyleJSON() =>
      throw _unimplemented('getStyleJSON', 'Style');
  @override
  Future<CameraOptions> getStyleDefaultCamera() =>
      throw _unimplemented('getStyleDefaultCamera', 'Style');
  @override
  Future<TransitionOptions> getStyleTransition() =>
      throw _unimplemented('getStyleTransition', 'Style');
  @override
  Future<void> setStyleTransition(TransitionOptions transitionOptions) =>
      throw _unimplemented('setStyleTransition', 'Style');
  @override
  Future<void> addStyleImportFromJSON(
    String importId,
    String json, {
    Map<String, Object>? config,
    ImportPosition? importPosition,
  }) => throw _unimplemented('addStyleImportFromJSON', 'Style');
  @override
  Future<void> addStyleImportFromURI(
    String importId,
    String uri, {
    Map<String, Object>? config,
    ImportPosition? importPosition,
  }) => throw _unimplemented('addStyleImportFromURI', 'Style');
  @override
  Future<void> updateStyleImportWithJSON(
    String importId,
    String json, {
    Map<String, Object>? config,
  }) => throw _unimplemented('updateStyleImportWithJSON', 'Style');
  @override
  Future<void> updateStyleImportWithURI(
    String importId,
    String uri, {
    Map<String, Object>? config,
  }) => throw _unimplemented('updateStyleImportWithURI', 'Style');
  @override
  Future<void> moveStyleImport(
    String importId,
    ImportPosition? importPosition,
  ) => throw _unimplemented('moveStyleImport', 'Style');
  @override
  Future<List<StyleObjectInfo?>> getStyleImports() =>
      throw _unimplemented('getStyleImports', 'Style');
  @override
  Future<void> removeStyleImport(String importId) =>
      throw _unimplemented('removeStyleImport', 'Style');
  @override
  Future<Object> getStyleImportSchema(String importId) =>
      throw _unimplemented('getStyleImportSchema', 'Style');
  @override
  Future<void> addStyleLayer(String properties, LayerPosition? layerPosition) =>
      throw _unimplemented('addStyleLayer', 'Style');
  @override
  Future<void> addPersistentStyleLayer(
    String properties,
    LayerPosition? layerPosition,
  ) => throw _unimplemented('addPersistentStyleLayer', 'Style');
  @override
  Future<List<StyleObjectInfo?>> getStyleLayers() =>
      throw _unimplemented('getStyleLayers', 'Style');
  @override
  Future<bool> styleLayerExists(String layerId) =>
      throw _unimplemented('styleLayerExists', 'Style');
  @override
  Future<void> removeStyleLayer(String layerId) =>
      throw _unimplemented('removeStyleLayer', 'Style');
  @override
  Future<void> moveStyleLayer(String layerId, LayerPosition? layerPosition) =>
      throw _unimplemented('moveStyleLayer', 'Style');
  @override
  Future<void> addStyleSource(String sourceId, String properties) =>
      throw _unimplemented('addStyleSource', 'Style');
  @override
  Future<List<StyleObjectInfo?>> getStyleSources() =>
      throw _unimplemented('getStyleSources', 'Style');
  @override
  Future<bool> styleSourceExists(String sourceId) =>
      throw _unimplemented('styleSourceExists', 'Style');
  @override
  Future<void> removeStyleSource(String sourceId) =>
      throw _unimplemented('removeStyleSource', 'Style');
  @override
  Future<bool> hasStyleImage(String imageId) =>
      throw _unimplemented('hasStyleImage', 'Style');
  @override
  Future<void> addStyleImage(
    String imageId,
    double scale,
    MbxImage image,
    bool sdf,
    List<ImageStretches?> stretchX,
    List<ImageStretches?> stretchY,
    ImageContent? content,
  ) => throw _unimplemented('addStyleImage', 'Style');
  @override
  Future<void> updateStyleImageSourceImage(String sourceId, MbxImage image) =>
      throw _unimplemented('updateStyleImageSourceImage', 'Style');
  @override
  Future<void> removeStyleImage(String imageId) =>
      throw _unimplemented('removeStyleImage', 'Style');
  @override
  Future<StyleProjection?> getProjection() =>
      throw _unimplemented('getProjection', 'Style');
  @override
  Future<void> setProjection(StyleProjection projection) =>
      throw _unimplemented('setProjection', 'Style');
  @override
  Future<void> setStyleLayerProperty(
    String layerId,
    String property,
    Object value,
  ) => throw _unimplemented('setStyleLayerProperty', 'Style');
  @override
  Future<String> getStyleLayerProperties(String layerId) =>
      throw _unimplemented('getStyleLayerProperties', 'Style');
  @override
  Future<void> setStyleLayerProperties(String layerId, String properties) =>
      throw _unimplemented('setStyleLayerProperties', 'Style');
  @override
  Future<String> getStyleSourceProperties(String sourceId) =>
      throw _unimplemented('getStyleSourceProperties', 'Style');
  @override
  Future<StylePropertyValue> getStyleSourceProperty(
    String sourceId,
    String property,
  ) => throw _unimplemented('getStyleSourceProperty', 'Style');
  @override
  Future<void> setStyleSourceProperty(
    String sourceId,
    String property,
    Object value,
  ) => throw _unimplemented('setStyleSourceProperty', 'Style');
  @override
  Future<void> setStyleSourceProperties(String sourceId, String properties) =>
      throw _unimplemented('setStyleSourceProperties', 'Style');
  @override
  Future<void> setStyleImportConfigProperty(
    String importId,
    String config,
    Object value,
  ) => throw _unimplemented('setStyleImportConfigProperty', 'Style');
  @override
  Future<void> setStyleImportConfigProperties(
    String importId,
    Map<String, Object> configs,
  ) => throw _unimplemented('setStyleImportConfigProperties', 'Style');
  @override
  Future<void> setStyleTerrain(String properties) =>
      throw _unimplemented('setStyleTerrain', 'Style');
}

class UnsupportedGesturesSettingsWeb
    implements GesturesSettingsPlatformInterface {
  @override
  Future<GesturesSettings> getSettings() =>
      throw _unimplemented('getSettings', 'GesturesSettings');
  @override
  Future<void> updateSettings(GesturesSettings settings) =>
      throw _unimplemented('updateSettings', 'GesturesSettings');
}

class UnsupportedLocationSettingsWeb
    implements LocationSettingsPlatformInterface {
  @override
  Future<LocationComponentSettings> getSettings() =>
      throw _unimplemented('getSettings', 'LocationSettings');
  @override
  Future<void> updateSettings(LocationComponentSettings settings) =>
      throw _unimplemented('updateSettings', 'LocationSettings');
}

class UnsupportedScaleBarSettingsWeb
    implements ScaleBarSettingsPlatformInterface {
  @override
  Future<ScaleBarSettings> getSettings() =>
      throw _unimplemented('getSettings', 'ScaleBarSettings');
  @override
  Future<void> updateSettings(ScaleBarSettings settings) =>
      throw _unimplemented('updateSettings', 'ScaleBarSettings');
}

class UnsupportedCompassSettingsWeb
    implements CompassSettingsPlatformInterface {
  @override
  Future<CompassSettings> getSettings() =>
      throw _unimplemented('getSettings', 'CompassSettings');
  @override
  Future<void> updateSettings(CompassSettings settings) =>
      throw _unimplemented('updateSettings', 'CompassSettings');
}

class UnsupportedAttributionSettingsWeb
    implements AttributionSettingsPlatformInterface {
  @override
  Future<AttributionSettings> getSettings() =>
      throw _unimplemented('getSettings', 'AttributionSettings');
  @override
  Future<void> updateSettings(AttributionSettings settings) =>
      throw _unimplemented('updateSettings', 'AttributionSettings');
}

class UnsupportedLogoSettingsWeb implements LogoSettingsPlatformInterface {
  @override
  Future<LogoSettings> getSettings() =>
      throw _unimplemented('getSettings', 'LogoSettings');
  @override
  Future<void> updateSettings(LogoSettings settings) =>
      throw _unimplemented('updateSettings', 'LogoSettings');
}

class UnsupportedIndoorSelectorSettingsWeb
    implements IndoorSelectorSettingsPlatformInterface {
  @override
  Future<IndoorSelectorSettings> getSettings() =>
      throw _unimplemented('getSettings', 'IndoorSelectorSettings');
  @override
  Future<void> updateSettings(IndoorSelectorSettings settings) =>
      throw _unimplemented('updateSettings', 'IndoorSelectorSettings');
}

class UnsupportedAnnotationManagerWeb
    implements AnnotationManagerPlatformInterface {
  @override
  Future<PointAnnotationManagerPlatformInterface> createPointAnnotationManager({
    String? id,
    String? below,
  }) =>
      throw _unimplemented('createPointAnnotationManager', 'AnnotationManager');
  @override
  Future<CircleAnnotationManagerPlatformInterface>
  createCircleAnnotationManager({String? id, String? below}) =>
      throw _unimplemented(
        'createCircleAnnotationManager',
        'AnnotationManager',
      );
  @override
  Future<PolylineAnnotationManagerPlatformInterface>
  createPolylineAnnotationManager({String? id, String? below}) =>
      throw _unimplemented(
        'createPolylineAnnotationManager',
        'AnnotationManager',
      );
  @override
  Future<PolygonAnnotationManagerPlatformInterface>
  createPolygonAnnotationManager({String? id, String? below}) =>
      throw _unimplemented(
        'createPolygonAnnotationManager',
        'AnnotationManager',
      );
  @override
  Future<void> removeAnnotationManager(
    BaseAnnotationManagerPlatformInterface manager,
  ) => throw _unimplemented('removeAnnotationManager', 'AnnotationManager');
  @override
  Future<void> removeAnnotationManagerById(String id) =>
      throw _unimplemented('removeAnnotationManagerById', 'AnnotationManager');
}

class UnsupportedHttpServiceWeb implements MapboxHttpServicePlatformInterface {
  @override
  Future<void> setCustomHeaders(Map<String, String> headers) =>
      throw _unimplemented('setCustomHeaders', 'HttpService');
}

class UnsupportedProjectionWeb implements ProjectionPlatformInterface {
  @override
  Future<double> getMetersPerPixelAtLatitude(double latitude, double zoom) =>
      throw _unimplemented('getMetersPerPixelAtLatitude', 'Projection');
  @override
  Future<ProjectedMeters> projectedMetersForCoordinate(Point coordinate) =>
      throw _unimplemented('projectedMetersForCoordinate', 'Projection');
  @override
  Future<Point> coordinateForProjectedMeters(ProjectedMeters projectedMeters) =>
      throw _unimplemented('coordinateForProjectedMeters', 'Projection');
  @override
  Future<MercatorCoordinate> project(Point coordinate, double zoomScale) =>
      throw _unimplemented('project', 'Projection');
  @override
  Future<Point> unproject(MercatorCoordinate coordinate, double zoomScale) =>
      throw _unimplemented('unproject', 'Projection');
}

class UnsupportedMapRecorderWeb implements MapRecorderPlatformInterface {
  static const _reason = 'debug/replay tool is native-only';
  @override
  Future<void> startRecording({
    int? timeWindow,
    required bool loggingEnabled,
    required bool compressed,
  }) => throw _unsupported('MapRecorder.startRecording', _reason);
  @override
  Future<Uint8List> stopRecording() =>
      throw _unsupported('MapRecorder.stopRecording', _reason);
  @override
  Future<void> replay(
    Uint8List recordedSequence, {
    required int playbackCount,
    required double playbackSpeedMultiplier,
    required bool avoidPlaybackPauses,
  }) => throw _unsupported('MapRecorder.replay', _reason);
  @override
  Future<void> togglePause() =>
      throw _unsupported('MapRecorder.togglePause', _reason);
  @override
  Future<String> getState() =>
      throw _unsupported('MapRecorder.getState', _reason);
}
