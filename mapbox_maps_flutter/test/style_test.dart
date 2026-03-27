import 'package:flutter_test/flutter_test.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

class MockStylePlatformInterface implements StylePlatformInterface {
  int setStyleURICallCount = 0;
  int getStyleURICallCount = 0;
  int setStyleJSONCallCount = 0;
  int getStyleJSONCallCount = 0;
  int getStyleDefaultCameraCallCount = 0;
  int getStyleTransitionCallCount = 0;
  int setStyleTransitionCallCount = 0;
  int addStyleImportFromJSONCallCount = 0;
  int addStyleImportFromURICallCount = 0;
  int updateStyleImportWithJSONCallCount = 0;
  int updateStyleImportWithURICallCount = 0;
  int moveStyleImportCallCount = 0;
  int getStyleImportsCallCount = 0;
  int removeStyleImportCallCount = 0;
  int getStyleImportSchemaCallCount = 0;
  int getStyleLayersCallCount = 0;
  int styleLayerExistsCallCount = 0;
  int removeStyleLayerCallCount = 0;
  int moveStyleLayerCallCount = 0;
  int getStyleSourcesCallCount = 0;
  int styleSourceExistsCallCount = 0;
  int removeStyleSourceCallCount = 0;
  int hasStyleImageCallCount = 0;
  int removeStyleImageCallCount = 0;
  int getProjectionCallCount = 0;
  int setProjectionCallCount = 0;
  int setStyleLayerPropertyCallCount = 0;
  int getStyleLayerPropertiesCallCount = 0;
  int setStyleLayerPropertiesCallCount = 0;
  int getStyleSourcePropertiesCallCount = 0;
  int setStyleSourcePropertyCallCount = 0;
  int setStyleSourcePropertiesCallCount = 0;
  int setStyleImportConfigPropertyCallCount = 0;
  int setStyleImportConfigPropertiesCallCount = 0;
  int setStyleTerrainCallCount = 0;

  String? lastUri;
  String? lastJson;
  String? lastImportId;
  String? lastLayerId;
  String? lastSourceId;
  String? lastImageId;
  String? lastProperty;
  Object? lastValue;
  ImportPosition? lastImportPosition;
  LayerPosition? lastLayerPosition;
  Map<String, Object>? lastConfig;
  Map<String, Object>? lastConfigs;

  @override
  Future<void> setStyleURI(String uri) async {
    setStyleURICallCount++;
    lastUri = uri;
  }

  @override
  Future<String> getStyleURI() async {
    getStyleURICallCount++;
    return 'mapbox://styles/mapbox/streets-v12';
  }

  @override
  Future<void> setStyleJSON(String json) async {
    setStyleJSONCallCount++;
    lastJson = json;
  }

  @override
  Future<String> getStyleJSON() async {
    getStyleJSONCallCount++;
    return '{"version": 8}';
  }

  @override
  Future<CameraOptions> getStyleDefaultCamera() async {
    getStyleDefaultCameraCallCount++;
    return CameraOptions(zoom: 10);
  }

  @override
  Future<TransitionOptions> getStyleTransition() async {
    getStyleTransitionCallCount++;
    return TransitionOptions(duration: 300, delay: 0);
  }

  @override
  Future<void> setStyleTransition(TransitionOptions transitionOptions) async {
    setStyleTransitionCallCount++;
  }

  @override
  Future<void> addStyleImportFromJSON(String importId, String json,
      {Map<String, Object>? config, ImportPosition? importPosition}) async {
    addStyleImportFromJSONCallCount++;
    lastImportId = importId;
    lastJson = json;
    lastConfig = config;
    lastImportPosition = importPosition;
  }

  @override
  Future<void> addStyleImportFromURI(String importId, String uri,
      {Map<String, Object>? config, ImportPosition? importPosition}) async {
    addStyleImportFromURICallCount++;
    lastImportId = importId;
    lastUri = uri;
    lastConfig = config;
    lastImportPosition = importPosition;
  }

  @override
  Future<void> updateStyleImportWithJSON(String importId, String json,
      {Map<String, Object>? config}) async {
    updateStyleImportWithJSONCallCount++;
    lastImportId = importId;
    lastJson = json;
    lastConfig = config;
  }

  @override
  Future<void> updateStyleImportWithURI(String importId, String uri,
      {Map<String, Object>? config}) async {
    updateStyleImportWithURICallCount++;
    lastImportId = importId;
    lastUri = uri;
    lastConfig = config;
  }

  @override
  Future<void> moveStyleImport(String importId,
      {ImportPosition? importPosition}) async {
    moveStyleImportCallCount++;
    lastImportId = importId;
    lastImportPosition = importPosition;
  }

  @override
  Future<List<StyleObjectInfo?>> getStyleImports() async {
    getStyleImportsCallCount++;
    return [];
  }

  @override
  Future<void> removeStyleImport(String importId) async {
    removeStyleImportCallCount++;
    lastImportId = importId;
  }

  @override
  Future<Object> getStyleImportSchema(String importId) async {
    getStyleImportSchemaCallCount++;
    lastImportId = importId;
    return {};
  }

  @override
  Future<List<StyleObjectInfo?>> getStyleLayers() async {
    getStyleLayersCallCount++;
    return [];
  }

  @override
  Future<bool> styleLayerExists(String layerId) async {
    styleLayerExistsCallCount++;
    lastLayerId = layerId;
    return true;
  }

  @override
  Future<void> removeStyleLayer(String layerId) async {
    removeStyleLayerCallCount++;
    lastLayerId = layerId;
  }

  @override
  Future<void> moveStyleLayer(String layerId,
      {LayerPosition? layerPosition}) async {
    moveStyleLayerCallCount++;
    lastLayerId = layerId;
    lastLayerPosition = layerPosition;
  }

  @override
  Future<List<StyleObjectInfo?>> getStyleSources() async {
    getStyleSourcesCallCount++;
    return [];
  }

  @override
  Future<bool> styleSourceExists(String sourceId) async {
    styleSourceExistsCallCount++;
    lastSourceId = sourceId;
    return true;
  }

  @override
  Future<void> removeStyleSource(String sourceId) async {
    removeStyleSourceCallCount++;
    lastSourceId = sourceId;
  }

  @override
  Future<bool> hasStyleImage(String imageId) async {
    hasStyleImageCallCount++;
    lastImageId = imageId;
    return true;
  }

  @override
  Future<void> removeStyleImage(String imageId) async {
    removeStyleImageCallCount++;
    lastImageId = imageId;
  }

  @override
  Future<StyleProjection?> getProjection() async {
    getProjectionCallCount++;
    return StyleProjection(name: StyleProjectionName.mercator);
  }

  @override
  Future<void> setProjection(StyleProjection projection) async {
    setProjectionCallCount++;
  }

  @override
  Future<void> setStyleLayerProperty(
      String layerId, String property, Object value) async {
    setStyleLayerPropertyCallCount++;
    lastLayerId = layerId;
    lastProperty = property;
    lastValue = value;
  }

  @override
  Future<String> getStyleLayerProperties(String layerId) async {
    getStyleLayerPropertiesCallCount++;
    lastLayerId = layerId;
    return '{"id": "layer-1"}';
  }

  @override
  Future<void> setStyleLayerProperties(
      String layerId, String properties) async {
    setStyleLayerPropertiesCallCount++;
    lastLayerId = layerId;
  }

  @override
  Future<String> getStyleSourceProperties(String sourceId) async {
    getStyleSourcePropertiesCallCount++;
    lastSourceId = sourceId;
    return '{"type": "geojson"}';
  }

  @override
  Future<void> setStyleSourceProperty(
      String sourceId, String property, Object value) async {
    setStyleSourcePropertyCallCount++;
    lastSourceId = sourceId;
    lastProperty = property;
    lastValue = value;
  }

  @override
  Future<void> setStyleSourceProperties(
      String sourceId, String properties) async {
    setStyleSourcePropertiesCallCount++;
    lastSourceId = sourceId;
  }

  @override
  Future<void> setStyleImportConfigProperty(
      String importId, String config, Object value) async {
    setStyleImportConfigPropertyCallCount++;
    lastImportId = importId;
    lastProperty = config;
    lastValue = value;
  }

  @override
  Future<void> setStyleImportConfigProperties(
      String importId, Map<String, Object> configs) async {
    setStyleImportConfigPropertiesCallCount++;
    lastImportId = importId;
    lastConfigs = configs;
  }

  @override
  Future<void> setStyleTerrain(String properties) async {
    setStyleTerrainCallCount++;
    lastJson = properties;
  }
}

void main() {
  late MockStylePlatformInterface mockImpl;
  late Style style;

  setUp(() {
    mockImpl = MockStylePlatformInterface();
    style = Style(mockImpl);
  });

  group('Style', () {
    // ===== Style loading =====

    test('setStyleURI delegates to interface', () async {
      await style.setStyleURI('mapbox://styles/mapbox/streets-v12');

      expect(mockImpl.setStyleURICallCount, 1);
      expect(mockImpl.lastUri, 'mapbox://styles/mapbox/streets-v12');
    });

    test('getStyleURI delegates to interface', () async {
      final result = await style.getStyleURI();

      expect(mockImpl.getStyleURICallCount, 1);
      expect(result, 'mapbox://styles/mapbox/streets-v12');
    });

    test('setStyleJSON delegates to interface', () async {
      await style.setStyleJSON('{"version": 8}');

      expect(mockImpl.setStyleJSONCallCount, 1);
      expect(mockImpl.lastJson, '{"version": 8}');
    });

    test('getStyleJSON delegates to interface', () async {
      final result = await style.getStyleJSON();

      expect(mockImpl.getStyleJSONCallCount, 1);
      expect(result, '{"version": 8}');
    });

    // ===== Default camera & transition =====

    test('getStyleDefaultCamera delegates to interface', () async {
      final result = await style.getStyleDefaultCamera();

      expect(mockImpl.getStyleDefaultCameraCallCount, 1);
      expect(result.zoom, 10);
    });

    test('getStyleTransition delegates to interface', () async {
      final result = await style.getStyleTransition();

      expect(mockImpl.getStyleTransitionCallCount, 1);
      expect(result.duration, 300);
    });

    test('setStyleTransition delegates to interface', () async {
      await style.setStyleTransition(TransitionOptions(duration: 500, delay: 0));

      expect(mockImpl.setStyleTransitionCallCount, 1);
    });

    // ===== Style imports =====

    test('addStyleImportFromJSON delegates to interface', () async {
      await style.addStyleImportFromJSON('import-1', '{}',
          config: {'key': 'value'});

      expect(mockImpl.addStyleImportFromJSONCallCount, 1);
      expect(mockImpl.lastImportId, 'import-1');
      expect(mockImpl.lastJson, '{}');
      expect(mockImpl.lastConfig, {'key': 'value'});
    });

    test('addStyleImportFromURI delegates to interface', () async {
      await style.addStyleImportFromURI(
          'import-1', 'mapbox://styles/mapbox/dark-v11');

      expect(mockImpl.addStyleImportFromURICallCount, 1);
      expect(mockImpl.lastImportId, 'import-1');
      expect(mockImpl.lastUri, 'mapbox://styles/mapbox/dark-v11');
    });

    test('updateStyleImportWithJSON delegates to interface', () async {
      await style.updateStyleImportWithJSON('import-1', '{}');

      expect(mockImpl.updateStyleImportWithJSONCallCount, 1);
      expect(mockImpl.lastImportId, 'import-1');
    });

    test('updateStyleImportWithURI delegates to interface', () async {
      await style.updateStyleImportWithURI('import-1', 'mapbox://test');

      expect(mockImpl.updateStyleImportWithURICallCount, 1);
      expect(mockImpl.lastImportId, 'import-1');
    });

    test('moveStyleImport delegates to interface', () async {
      await style.moveStyleImport('import-1');

      expect(mockImpl.moveStyleImportCallCount, 1);
      expect(mockImpl.lastImportId, 'import-1');
    });

    test('getStyleImports delegates to interface', () async {
      final result = await style.getStyleImports();

      expect(mockImpl.getStyleImportsCallCount, 1);
      expect(result, isEmpty);
    });

    test('removeStyleImport delegates to interface', () async {
      await style.removeStyleImport('import-1');

      expect(mockImpl.removeStyleImportCallCount, 1);
      expect(mockImpl.lastImportId, 'import-1');
    });

    test('getStyleImportSchema delegates to interface', () async {
      await style.getStyleImportSchema('import-1');

      expect(mockImpl.getStyleImportSchemaCallCount, 1);
      expect(mockImpl.lastImportId, 'import-1');
    });

    // ===== Layers =====

    test('getStyleLayers delegates to interface', () async {
      final result = await style.getStyleLayers();

      expect(mockImpl.getStyleLayersCallCount, 1);
      expect(result, isEmpty);
    });

    test('styleLayerExists delegates to interface', () async {
      final result = await style.styleLayerExists('layer-1');

      expect(mockImpl.styleLayerExistsCallCount, 1);
      expect(mockImpl.lastLayerId, 'layer-1');
      expect(result, true);
    });

    test('removeStyleLayer delegates to interface', () async {
      await style.removeStyleLayer('layer-1');

      expect(mockImpl.removeStyleLayerCallCount, 1);
      expect(mockImpl.lastLayerId, 'layer-1');
    });

    test('moveStyleLayer delegates to interface', () async {
      await style.moveStyleLayer('layer-1');

      expect(mockImpl.moveStyleLayerCallCount, 1);
      expect(mockImpl.lastLayerId, 'layer-1');
    });

    // ===== Sources =====

    test('getStyleSources delegates to interface', () async {
      final result = await style.getStyleSources();

      expect(mockImpl.getStyleSourcesCallCount, 1);
      expect(result, isEmpty);
    });

    test('styleSourceExists delegates to interface', () async {
      final result = await style.styleSourceExists('source-1');

      expect(mockImpl.styleSourceExistsCallCount, 1);
      expect(mockImpl.lastSourceId, 'source-1');
      expect(result, true);
    });

    test('removeStyleSource delegates to interface', () async {
      await style.removeStyleSource('source-1');

      expect(mockImpl.removeStyleSourceCallCount, 1);
      expect(mockImpl.lastSourceId, 'source-1');
    });

    // ===== Images =====

    test('hasStyleImage delegates to interface', () async {
      final result = await style.hasStyleImage('marker-icon');

      expect(mockImpl.hasStyleImageCallCount, 1);
      expect(mockImpl.lastImageId, 'marker-icon');
      expect(result, true);
    });

    test('removeStyleImage delegates to interface', () async {
      await style.removeStyleImage('marker-icon');

      expect(mockImpl.removeStyleImageCallCount, 1);
      expect(mockImpl.lastImageId, 'marker-icon');
    });

    // ===== Projection =====

    test('getProjection delegates to interface', () async {
      final result = await style.getProjection();

      expect(mockImpl.getProjectionCallCount, 1);
      expect(result?.name, StyleProjectionName.mercator);
    });

    test('setProjection delegates to interface', () async {
      await style
          .setProjection(StyleProjection(name: StyleProjectionName.globe));

      expect(mockImpl.setProjectionCallCount, 1);
    });

    // ===== Low-level property access =====

    test('setStyleLayerProperty delegates to interface', () async {
      await style.setStyleLayerProperty('layer-1', 'visibility', 'visible');

      expect(mockImpl.setStyleLayerPropertyCallCount, 1);
      expect(mockImpl.lastLayerId, 'layer-1');
      expect(mockImpl.lastProperty, 'visibility');
      expect(mockImpl.lastValue, 'visible');
    });

    test('getStyleLayerProperties delegates to interface', () async {
      final result = await style.getStyleLayerProperties('layer-1');

      expect(mockImpl.getStyleLayerPropertiesCallCount, 1);
      expect(mockImpl.lastLayerId, 'layer-1');
      expect(result, '{"id": "layer-1"}');
    });

    test('setStyleLayerProperties delegates to interface', () async {
      await style.setStyleLayerProperties('layer-1', '{}');

      expect(mockImpl.setStyleLayerPropertiesCallCount, 1);
      expect(mockImpl.lastLayerId, 'layer-1');
    });

    test('getStyleSourceProperties delegates to interface', () async {
      final result = await style.getStyleSourceProperties('source-1');

      expect(mockImpl.getStyleSourcePropertiesCallCount, 1);
      expect(mockImpl.lastSourceId, 'source-1');
      expect(result, '{"type": "geojson"}');
    });

    test('setStyleSourceProperty delegates to interface', () async {
      await style.setStyleSourceProperty('source-1', 'data', '{}');

      expect(mockImpl.setStyleSourcePropertyCallCount, 1);
      expect(mockImpl.lastSourceId, 'source-1');
      expect(mockImpl.lastProperty, 'data');
    });

    test('setStyleSourceProperties delegates to interface', () async {
      await style.setStyleSourceProperties('source-1', '{}');

      expect(mockImpl.setStyleSourcePropertiesCallCount, 1);
      expect(mockImpl.lastSourceId, 'source-1');
    });

    test('setStyleImportConfigProperty delegates to interface', () async {
      await style.setStyleImportConfigProperty(
          'import-1', 'theme', 'dark');

      expect(mockImpl.setStyleImportConfigPropertyCallCount, 1);
      expect(mockImpl.lastImportId, 'import-1');
      expect(mockImpl.lastProperty, 'theme');
      expect(mockImpl.lastValue, 'dark');
    });

    test('setStyleImportConfigProperties delegates to interface', () async {
      await style.setStyleImportConfigProperties(
          'import-1', {'theme': 'dark', 'labels': 'en'});

      expect(mockImpl.setStyleImportConfigPropertiesCallCount, 1);
      expect(mockImpl.lastImportId, 'import-1');
      expect(mockImpl.lastConfigs, {'theme': 'dark', 'labels': 'en'});
    });

    test('setStyleTerrain delegates to interface', () async {
      await style.setStyleTerrain('{"source": "dem"}');

      expect(mockImpl.setStyleTerrainCallCount, 1);
      expect(mockImpl.lastJson, '{"source": "dem"}');
    });
  });
}
