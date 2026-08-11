import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
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
        'source', null, 'point', json.encode({'choose': true}));
    var featureState = await mapboxMap.getFeatureState('source', null, 'point');
    var stateMap = json.decode(featureState);
    expect(stateMap.length, 1);
    expect(stateMap['choose'], true);

    await mapboxMap.removeFeatureState('source', null, 'point', 'choose');
    featureState = await mapboxMap.getFeatureState('source', null, 'point');
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
    app.events.resetMapLoadingErrors();
    await style.addStyleSource('source', source);
    await style.addStyleLayer(layer, null);
    await _waitForSourceDataLoaded(app.events, 'source');
    await app.events.onMapIdle.future;

    var screenBox = ScreenBox(
        min: ScreenCoordinate(x: 0.0, y: 0.0),
        max: ScreenCoordinate(x: 500.0, y: 1000.0));
    var renderedQueryGeometry = RenderedQueryGeometry.fromScreenBox(screenBox);
    var query = await _queryUntilFound(
        mapboxMap, renderedQueryGeometry, 'points',
        sourceId: 'source', imageId: 'icon');
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
    app.events.resetMapLoadingErrors();
    await style.addStyleSource('source', source);
    await style.addStyleLayer(layer, null);
    await _waitForSourceDataLoaded(app.events, 'source');
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
    app.events.resetMapLoadingErrors();
    await style.addStyleSource("earthquakes", source);
    await style.addStyleLayer(layer, null);
    await style.addStyleLayer(clusterCountLayer, null);
    await style.addStyleLayer(unclusteredLayer, null);
    // "earthquakes" data is fetched from a remote URL (see cluster_source.json),
    // unlike the inline GeoJSON used elsewhere in this file, so give it more
    // time to land under a cold cache.
    await _waitForSourceDataLoaded(
      app.events,
      "earthquakes",
      timeout: const Duration(seconds: 20),
    );
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

/// Works around the symbol query flaking on iOS only - Android is unaffected.
/// It fails on the first run against a cold cache, roughly one run in four, and
/// has never reproduced locally on a simulator.
///
/// `MapIdle` means the map has nothing left to draw right now, not that a
/// symbol has been placed, so the feature can still be missing from the first
/// frame after idle. This polls, and if the feature never turns up it reports
/// what the map actually contained - the root cause is still unknown, so that
/// output is the point: it should identify which invariant broke.
Future<List<QueriedRenderedFeature?>> _queryUntilFound(
  MapboxMap mapboxMap,
  RenderedQueryGeometry geometry,
  String layerId, {
  required String sourceId,
  required String imageId,
  Duration timeout = const Duration(seconds: 5),
}) async {
  final options = RenderedQueryOptions(layerIds: [layerId], filter: null);
  final deadline = DateTime.now().add(timeout);
  var attempt = 0;
  var query = await mapboxMap.queryRenderedFeatures(geometry, options);
  while (query.isEmpty && DateTime.now().isBefore(deadline)) {
    attempt++;
    debugPrint(
        '_queryUntilFound: "$layerId" empty on attempt $attempt, retrying...');
    await Future.delayed(const Duration(milliseconds: 200));
    query = await mapboxMap.queryRenderedFeatures(geometry, options);
  }
  if (attempt > 0 && query.isNotEmpty) {
    debugPrint('_queryUntilFound: "$layerId" found after $attempt retries');
  }
  if (query.isEmpty) {
    final style = mapboxMap.style;
    final camera = await mapboxMap.getCameraState();
    fail('No features in "$layerId" after ${timeout.inSeconds}s - '
        'layer: ${await style.styleLayerExists(layerId)}, '
        'source "$sourceId": ${await style.styleSourceExists(sourceId)}, '
        'image "$imageId": ${await style.hasStyleImage(imageId)}, '
        'camera: ${camera.center.coordinates} z${camera.zoom}, '
        'mapLoadingErrors: ${_describeMapLoadingErrors(app.events)}');
  }
  return query;
}

/// Waits until a `SourceDataLoaded` event for [sourceId] has been observed.
///
/// `onSourceDataLoaded.future` resolves on the first `SourceDataLoaded` event
/// after the last reset, which can belong to any source already streaming
/// tiles in the background - not necessarily [sourceId]. This waits for the
/// specific source instead.
Future<void> _waitForSourceDataLoaded(
  app.Events events,
  String sourceId, {
  Duration timeout = const Duration(seconds: 5),
}) async {
  final deadline = DateTime.now().add(timeout);
  while (!events.loadedSourceIds.contains(sourceId) &&
      DateTime.now().isBefore(deadline)) {
    await Future.delayed(const Duration(milliseconds: 50));
  }
  if (!events.loadedSourceIds.contains(sourceId)) {
    fail(
        'No SourceDataLoaded event for "$sourceId" after ${timeout.inSeconds}s - '
        'observed sources: ${events.loadedSourceIds}, '
        'mapLoadingErrors: ${_describeMapLoadingErrors(events)}');
  }
}

/// Formats collected `MapLoadingError`s for a failure message, excluding
/// per-tile errors: background tile fetches routinely get cancelled by
/// widget teardown and camera moves, which would otherwise drown out the
/// style/source/sprite/glyphs errors this diagnostic exists to surface.
String _describeMapLoadingErrors(app.Events events) {
  return events.mapLoadingErrors
      .where((e) => e.type != MapLoadErrorType.TILE)
      .map((e) => '${e.type}: ${e.message}')
      .toList()
      .toString();
}
