import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'empty_map_widget.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('styleGlyphURL', (WidgetTester tester) async {
    final mapFuture = app.main();
    await tester.pumpAndSettle();
    final mapboxMap = await mapFuture;
    final styleGlyphURL = 'test://test/test/{fontstack}/{range}.pbf';

    await mapboxMap.setStyleGlyphURL(styleGlyphURL);
    expect(await mapboxMap.styleGlyphURL(), styleGlyphURL);
  });

  testWidgets('loadStyleURI', (WidgetTester tester) async {
    final mapFuture = app.main();
    await tester.pumpAndSettle();
    final mapboxMap = await mapFuture;
    await mapboxMap.loadStyleURI(MapboxStyles.DARK);
    var style = await mapboxMap.style.getStyleURI();
    expect(MapboxStyles.DARK, style);
  });

  testWidgets('loadStyleJson', (WidgetTester tester) async {
    final mapFuture = app.main();
    await tester.pumpAndSettle();
    final mapboxMap = await mapFuture;
    var styleJson = await rootBundle.loadString('assets/style.json');
    app.events.resetOnStyleLoaded();
    mapboxMap.loadStyleJson(styleJson);

    await app.events.onStyleLoaded.future;

    var getStyleJson = await mapboxMap.style.getStyleJSON();
    expect(styleJson, getStyleJson);
  });

  testWidgets('loadRasterArray', (WidgetTester tester) async {
    final mapFuture = app.main();
    await tester.pumpAndSettle();
    final mapboxMap = await mapFuture;
    var styleJson =
        await rootBundle.loadString('assets/raster_array_layers.json');
    var expectedValue = [
      RasterDataLayer("temperature", [
        "1659898800",
        "1659902400",
        "1659906000",
        "1659909600",
        "1659913200",
        "1659916800"
      ]),
      RasterDataLayer("humidity", [
        "1659898800",
        "1659902400",
        "1659906000",
        "1659909600",
        "1659913200",
        "1659916800"
      ])
    ];
    app.events.resetOnStyleLoaded();
    mapboxMap.loadStyleJson(styleJson);

    await app.events.onStyleLoaded.future;

    var getStyleJson = await mapboxMap.style.getStyleJSON();
    expect(styleJson, getStyleJson);

    // Test getStyleSourceProperty method
    var rasterLayers =
        await mapboxMap.style.getStyleSourceProperty("mapbox", "rasterLayers");
    final Map<Object?, Object?> dataMap =
        rasterLayers.value as Map<Object?, Object?>;
    List<RasterDataLayer> rasterDataLayers = [];

    dataMap.forEach((key, value) {
      rasterDataLayers
          .add(RasterDataLayer(key as String, (value as List).cast<String>()));
    });
    expect(rasterDataLayers.contains(expectedValue.first), true);
    expect(rasterDataLayers.contains(expectedValue.last), true);

    // Test getting the value from the source directly
    var source = await mapboxMap.style.getSource("mapbox");
    if (source is RasterArraySource) {
      var layers = await source.rasterLayers;
      expect(layers?.contains(expectedValue.first), true);
      expect(layers?.contains(expectedValue.last), true);
    } else {
      fail("Expected source to be RasterArraySource");
    }
  });

  testWidgets('clearData', (WidgetTester tester) async {
    final mapFuture = app.main();
    await tester.pumpAndSettle();
    final mapboxMap = await mapFuture;
    mapboxMap.clearData();
  });

  testWidgets('setTileCacheBudget', (WidgetTester tester) async {
    final mapFuture = app.main();
    await tester.pumpAndSettle();
    final mapboxMap = await mapFuture;
    mapboxMap.setTileCacheBudget(TileCacheBudgetInMegabytes(size: 100), null);
    mapboxMap.setTileCacheBudget(null, TileCacheBudgetInTiles(size: 100));
  });

  testWidgets('getSize', (WidgetTester tester) async {
    final mapFuture = app.main();
    await tester.pumpAndSettle();
    final mapboxMap = await mapFuture;

    await app.events.onMapLoaded.future;

    if (Platform.isIOS) {
      final throwsPlatformException = throwsA(predicate(
          (p) => p is PlatformException && p.message == 'Not available.'));
      expect(() async => await mapboxMap.getSize(), throwsPlatformException);
    } else {
      var size = await mapboxMap.getSize();
      expect(
          size.width, closeTo(tester.binding.renderViews.first.size.width, 1));
      expect(size.height,
          closeTo(tester.binding.renderViews.first.size.height, 1));
    }
  });

  testWidgets('reduceMemoryUse', (WidgetTester tester) async {
    final mapFuture = app.main();
    await tester.pumpAndSettle();
    final mapboxMap = await mapFuture;

    await mapboxMap.reduceMemoryUse();
  });

  testWidgets('triggerRepaint', (WidgetTester tester) async {
    final mapFuture = app.main();
    await tester.pumpAndSettle();
    final mapboxMap = await mapFuture;
    await mapboxMap.triggerRepaint();
  });

  testWidgets('PrefetchZoomDelta', (WidgetTester tester) async {
    final mapFuture = app.main();
    await tester.pumpAndSettle();
    final mapboxMap = await mapFuture;
    await mapboxMap.setPrefetchZoomDelta(10);
    var prefetchZoomDelta = await mapboxMap.getPrefetchZoomDelta();
    expect(prefetchZoomDelta, 10);
  });

  testWidgets('MapOptions', (WidgetTester tester) async {
    final mapFuture = app.main();
    await tester.pumpAndSettle();
    final mapboxMap = await mapFuture;
    var options = await mapboxMap.getMapOptions();
    expect(options.orientation, NorthOrientation.UPWARDS);
    expect(options.constrainMode, ConstrainMode.HEIGHT_ONLY);
    expect(options.contextMode, isNull);
    expect(options.viewportMode, ViewportMode.DEFAULT);

    expect(options.crossSourceCollisions, true);
    expect(options.pixelRatio, tester.view.devicePixelRatio);
    expect(options.glyphsRasterizationOptions, isNull);
    expect(options.size!.width, isNotNull);
    expect(options.size!.height, isNotNull);

    await mapboxMap.setConstrainMode(ConstrainMode.WIDTH_AND_HEIGHT);
    await mapboxMap.setNorthOrientation(NorthOrientation.DOWNWARDS);
    await mapboxMap.setViewportMode(ViewportMode.FLIPPED_Y);

    options = await mapboxMap.getMapOptions();
    expect(options.orientation, NorthOrientation.DOWNWARDS);
    expect(options.constrainMode, ConstrainMode.WIDTH_AND_HEIGHT);
    expect(options.viewportMode, ViewportMode.FLIPPED_Y);
  });

  testWidgets('isGestureInProgress', (WidgetTester tester) async {
    final mapFuture = app.main();
    await tester.pumpAndSettle();
    final mapboxMap = await mapFuture;

    expect(await mapboxMap.isGestureInProgress(), false);

    await mapboxMap.setGestureInProgress(true);
    expect(await mapboxMap.isGestureInProgress(), true);
  });

  testWidgets('isUserAnimationInProgress', (WidgetTester tester) async {
    final mapFuture = app.main();
    await tester.pumpAndSettle();
    final mapboxMap = await mapFuture;

    expect(await mapboxMap.isUserAnimationInProgress(), false);

    await mapboxMap.setUserAnimationInProgress(true);
    expect(await mapboxMap.isUserAnimationInProgress(), true);
  });

  testWidgets('debugOptions', (WidgetTester tester) async {
    final mapFuture = app.main();
    await tester.pumpAndSettle();
    final mapboxMap = await mapFuture;
    await mapboxMap.setDebugOptions([MapWidgetDebugOptions.tileBorders]);
    var debugOptions = await mapboxMap.getDebugOptions();
    expect(debugOptions.length, 1);
    expect(debugOptions.first, MapWidgetDebugOptions.tileBorders);
  });

  testWidgets('featureState', (WidgetTester tester) async {
    final mapFuture = app.main();
    await tester.pumpAndSettle();
    final mapboxMap = await mapFuture;
    var style = mapboxMap.style;
    var source = await rootBundle.loadString('assets/source.json');
    var layer = await rootBundle.loadString('assets/point_layer.json');

    app.events.resetOnStyleDataLoaded();
    app.events.resetOnMapIdle();
    style.addStyleSource('source', source);
    style.addStyleLayer(layer, null);

    await app.events.onSourceDataLoaded.future;
    await app.events.onMapIdle.future;

    await mapboxMap.setFeatureState(
        'source', 'custom', 'point', json.encode({'choose': true}));
    var featureState =
        await mapboxMap.getFeatureState('source', 'custom', 'point');
    var stateMap = json.decode(featureState);
    expect(stateMap.length, 1);
    expect(stateMap['choose'], true);

    await mapboxMap.removeFeatureState('source', 'custom', 'point', 'choose');
    featureState = await mapboxMap.getFeatureState('source', 'custom', 'point');
    stateMap = json.decode(featureState);
    expect(stateMap.length, 0);
  });

  testWidgets('MapboxMapsOptions default values', (WidgetTester tester) async {
    final _ = app.main();
    await tester.pumpAndSettle();

    expect(await MapboxOptions.getAccessToken(), isNotNull);
    expect(await MapboxMapsOptions.getBaseUrl(), 'https://api.mapbox.com');
    expect(await MapboxMapsOptions.getDataPath(), isNotNull);
    expect(await MapboxMapsOptions.getAssetPath(), isNotNull);
    expect(await MapboxMapsOptions.getTileStoreUsageMode(),
        TileStoreUsageMode.READ_ONLY);
  });

  testWidgets('MapboxMapsOptions read and update', (WidgetTester tester) async {
    final _ = app.main();
    await tester.pumpAndSettle();

    final originalBaseURL = await MapboxMapsOptions.getBaseUrl();
    final originalDataPath = await MapboxMapsOptions.getDataPath();
    final originalAssetPath = await MapboxMapsOptions.getAssetPath();
    final originalTileStoreUsageMode =
        await MapboxMapsOptions.getTileStoreUsageMode();

    // given
    final token = 'test token';
    final baseUrl = 'https://test.mapbox.com/maps-flutter-test';
    final dataPath = 'data/path';
    final assetPath = 'asset/path';
    final tileStoreUsageMode = TileStoreUsageMode.DISABLED;
    final language = "ua";
    final worldview = "MA";

    // when
    MapboxOptions.setAccessToken(token);
    MapboxMapsOptions.setBaseUrl(baseUrl);
    MapboxMapsOptions.setDataPath(dataPath);
    MapboxMapsOptions.setAssetPath(assetPath);
    MapboxMapsOptions.setTileStoreUsageMode(tileStoreUsageMode);
    MapboxMapsOptions.setLanguage(language);
    MapboxMapsOptions.setWorldview(worldview);

    // then
    expect(await MapboxOptions.getAccessToken(), token);
    expect(await MapboxMapsOptions.getBaseUrl(), baseUrl);
    expect(await MapboxMapsOptions.getDataPath(), endsWith(dataPath));
    expect(await MapboxMapsOptions.getAssetPath(),
        Platform.isAndroid ? "" : endsWith(assetPath));
    expect(await MapboxMapsOptions.getTileStoreUsageMode(), tileStoreUsageMode);
    expect(await MapboxMapsOptions.getLanguage(), language);
    expect(await MapboxMapsOptions.getWorldview(), worldview);

    // restore original values
    MapboxMapsOptions.setBaseUrl(originalBaseURL);
    MapboxMapsOptions.setDataPath(originalDataPath);
    MapboxMapsOptions.setAssetPath(originalAssetPath);
    MapboxMapsOptions.setTileStoreUsageMode(originalTileStoreUsageMode);
    MapboxMapsOptions.setLanguage(null);
    MapboxMapsOptions.setWorldview(null);
  });

  testWidgets('queryRenderedFeatures', (WidgetTester tester) async {
    final mapFuture = app.main();
    await tester.pumpAndSettle();
    final mapboxMap = await mapFuture;
    var style = mapboxMap.style;
    var options = CameraOptions(
        center: Point(coordinates: Position(-77.032667, 38.913175)), zoom: 10);

    app.events.resetOnCameraChanged();
    mapboxMap.setCamera(options);
    await app.events.onCameraChanged.future;

    var source = await rootBundle.loadString('assets/source.json');
    var layer = await rootBundle.loadString('assets/point_layer.json');
    final ByteData bytes =
        await rootBundle.load('assets/symbols/custom-icon.png');
    final Uint8List list = bytes.buffer.asUint8List();
    await style.addStyleImage('icon', 1.0,
        MbxImage(width: 40, height: 40, data: list), true, [], [], null);

    app.events.resetOnSourceDataLoaded();
    app.events.resetOnMapIdle();
    style.addStyleSource('source', source);
    style.addStyleLayer(layer, null);
    await app.events.onSourceDataLoaded.future;
    await app.events.onMapIdle.future;

    var screenBox = ScreenBox(
        min: ScreenCoordinate(x: 0.0, y: 0.0),
        max: ScreenCoordinate(x: 500.0, y: 1000.0));
    var renderedQueryGeometry = RenderedQueryGeometry.fromScreenBox(screenBox);
    var query = await mapboxMap.queryRenderedFeatures(renderedQueryGeometry,
        RenderedQueryOptions(layerIds: ['points'], filter: null));
    expect(query.length, greaterThan(0));
    expect(query[0]!.queriedFeature.source, 'source');
    expect(query[0]!.queriedFeature.feature['id'], 'point');

    query = await mapboxMap.queryRenderedFeatures(
        RenderedQueryGeometry.fromScreenCoordinate(
            ScreenCoordinate(x: 0.0, y: 0.0)),
        RenderedQueryOptions(layerIds: ['points'], filter: null));
    expect(query.length, 0);
    query = await mapboxMap.queryRenderedFeatures(
        RenderedQueryGeometry.fromList([
          ScreenCoordinate(x: 0.0, y: 0.0),
          ScreenCoordinate(x: 1.0, y: 1.0),
        ]),
        RenderedQueryOptions(layerIds: ['points'], filter: null));
    expect(query.length, 0);
  });

  testWidgets('querySourceFeatures', (WidgetTester tester) async {
    final mapFuture = app.main();
    await tester.pumpAndSettle();
    final mapboxMap = await mapFuture;
    var style = mapboxMap.style;
    var options = CameraOptions(
        center: Point(coordinates: Position(-77.032667, 38.913175)),
        zoom: 10,
        pitch: 0);

    await app.events.onMapLoaded.future;

    app.events.resetOnCameraChanged();
    mapboxMap.setCamera(options);
    await app.events.onCameraChanged.future;

    var source = await rootBundle.loadString('assets/source.json');
    var layer = await rootBundle.loadString('assets/point_layer.json');

    app.events.resetOnSourceDataLoaded();
    app.events.resetOnMapIdle();
    style.addStyleSource('source', source);
    style.addStyleLayer(layer, null);
    await app.events.onSourceDataLoaded.future;
    await app.events.onMapIdle.future;

    var query = await mapboxMap.querySourceFeatures(
        'source', SourceQueryOptions(filter: ''));
    expect(query.length, greaterThan(0));
    expect(query[0]!.queriedFeature.source, 'source');
    expect(query[0]!.queriedFeature.feature['id'], 'point');
  });

  testWidgets('queryFeatureExtensions', (WidgetTester tester) async {
    final mapFuture = app.main();
    await tester.pumpAndSettle();
    final mapboxMap = await mapFuture;
    var style = mapboxMap.style;
    var source =
        await rootBundle.loadString('assets/cluster/cluster_source.json');
    var layer =
        await rootBundle.loadString('assets/cluster/cluster_layer.json');
    var clusterCountLayer =
        await rootBundle.loadString('assets/cluster/cluster_count_layer.json');
    var unclusteredLayer = await rootBundle
        .loadString('assets/cluster/unclustered_point_layer.json');

    app.events.resetOnSourceDataLoaded();
    app.events.resetOnMapIdle();
    style.addStyleSource("earthquakes", source);
    style.addStyleLayer(layer, null);
    style.addStyleLayer(clusterCountLayer, null);
    style.addStyleLayer(unclusteredLayer, null);
    await app.events.onSourceDataLoaded.future;
    await app.events.onMapIdle.future;

    var feature = {
      "id": 1249,
      "properties": {
        "point_count_abbreviated": "10",
        "cluster_id": 1249,
        "cluster": true,
        "point_count": 10
      },
      "geometry": {
        "type": "Point",
        "coordinates": [-29.794921875, 59.220934076150456]
      },
      "type": "Feature"
    };

    var clusterLeaves = await mapboxMap.getGeoJsonClusterLeaves(
        'earthquakes', feature, null, null);
    expect(clusterLeaves.featureCollection!.length, 10);

    var clusterChildren =
        await mapboxMap.getGeoJsonClusterChildren('earthquakes', feature);
    expect(clusterChildren.featureCollection!.length, 2);

    var clusterExpansionZoom =
        await mapboxMap.getGeoJsonClusterExpansionZoom('earthquakes', feature);
    expect(clusterExpansionZoom.value, '1');
  });

  testWidgets('snapshot', (WidgetTester tester) async {
    final mapFuture = app.main();
    await tester.pumpAndSettle();
    final mapboxMap = await mapFuture;
    await mapboxMap.loadStyleURI(MapboxStyles.DARK);
    await app.events.onMapIdle.future;
    final snapshot = await mapboxMap.snapshot();
    expect(snapshot, isNotNull);
  });
}
