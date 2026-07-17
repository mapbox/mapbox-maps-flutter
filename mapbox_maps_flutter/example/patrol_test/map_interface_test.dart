// ignore_for_file: experimental_member_use, invalid_use_of_visible_for_testing_member
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'patrol.dart';
import 'package:turf/turf.dart' show Point, Position;

import 'empty_map_widget.dart' as app;

const ACCESS_TOKEN = String.fromEnvironment('ACCESS_TOKEN');

void main() {
  setUpAll(() => MapboxOptions.setAccessToken(ACCESS_TOKEN));

  patrolTest('styleGlyphURL', skip: kIsWeb, ($) async {
    final tester = $.tester;
    final mapboxMap = await app.pumpMap(tester: $.tester);
    await tester.pumpAndSettle();
    final styleGlyphURL = 'test://test/test/{fontstack}/{range}.pbf';

    await mapboxMap.setStyleGlyphURL(styleGlyphURL);
    expect(await mapboxMap.styleGlyphURL(), styleGlyphURL);
  });

  patrolTest('loadStyleURI', skip: kIsWeb, ($) async {
    final tester = $.tester;
    final mapboxMap = await app.pumpMap(tester: $.tester);
    await tester.pumpAndSettle();
    await mapboxMap.loadStyleURI(MapboxStyles.DARK);
    var style = await mapboxMap.style.getStyleURI();
    expect(MapboxStyles.DARK, style);
  });

  patrolTest('loadStyleJson', skip: kIsWeb, ($) async {
    final tester = $.tester;
    final mapboxMap = await app.pumpMap(tester: $.tester);
    await tester.pumpAndSettle();
    var styleJson = await rootBundle.loadString('assets/style.json');
    app.events.resetOnStyleLoaded();
    mapboxMap.loadStyleJson(styleJson);

    await app.waitForEvent($.tester, app.events.onStyleLoaded.future);

    var getStyleJson = await mapboxMap.style.getStyleJSON();
    expect(styleJson, getStyleJson);
  });

  patrolTest('loadRasterArray', skip: kIsWeb, ($) async {
    final tester = $.tester;
    final mapboxMap = await app.pumpMap(tester: $.tester);
    await tester.pumpAndSettle();
    var styleJson = await rootBundle.loadString(
      'assets/raster_array_layers.json',
    );
    var expectedValue = [
      RasterDataLayer("temperature", [
        "1659898800",
        "1659902400",
        "1659906000",
        "1659909600",
        "1659913200",
        "1659916800",
      ]),
      RasterDataLayer("humidity", [
        "1659898800",
        "1659902400",
        "1659906000",
        "1659909600",
        "1659913200",
        "1659916800",
      ]),
    ];
    app.events.resetOnStyleLoaded();
    mapboxMap.loadStyleJson(styleJson);

    await app.waitForEvent($.tester, app.events.onStyleLoaded.future);

    var getStyleJson = await mapboxMap.style.getStyleJSON();
    expect(styleJson, getStyleJson);

    // Test getStyleSourceProperty method
    var rasterLayers = await mapboxMap.style.getStyleSourceProperty(
      "mapbox",
      "rasterLayers",
    );
    final Map<Object?, Object?> dataMap =
        rasterLayers.value as Map<Object?, Object?>;
    List<RasterDataLayer> rasterDataLayers = [];

    dataMap.forEach((key, value) {
      rasterDataLayers.add(
        RasterDataLayer(key as String, (value as List).cast<String>()),
      );
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

  patrolTest('clearData', ($) async {
    final tester = $.tester;
    final mapboxMap = await app.pumpMap(tester: $.tester);
    await tester.pumpAndSettle();
    mapboxMap.clearData();
  });

  patrolTest('setTileCacheBudget', skip: kIsWeb, ($) async {
    final tester = $.tester;
    final mapboxMap = await app.pumpMap(tester: $.tester);
    await tester.pumpAndSettle();
    mapboxMap.setTileCacheBudget(TileCacheBudgetInMegabytes(size: 100), null);
    mapboxMap.setTileCacheBudget(null, TileCacheBudgetInTiles(size: 100));
  });

  patrolTest('getSize', ($) async {
    final tester = $.tester;
    final mapboxMap = await app.pumpMap(tester: $.tester);
    await tester.pumpAndSettle();

    await app.waitForEvent($.tester, app.events.onMapLoaded.future);

    if (!kIsWeb && defaultTargetPlatform == TargetPlatform.iOS) {
      final throwsPlatformException = throwsA(
        predicate(
          (p) => p is PlatformException && p.message == 'Not available.',
        ),
      );
      expect(() async => await mapboxMap.getSize(), throwsPlatformException);
    } else {
      var size = await mapboxMap.getSize();
      expect(
        size.width,
        closeTo(tester.binding.renderViews.first.size.width, 1),
      );
      expect(
        size.height,
        closeTo(tester.binding.renderViews.first.size.height, 1),
      );
    }
  });

  patrolTest('reduceMemoryUse', skip: kIsWeb, ($) async {
    final tester = $.tester;
    final mapboxMap = await app.pumpMap(tester: $.tester);
    await tester.pumpAndSettle();

    await mapboxMap.reduceMemoryUse();
  });

  patrolTest('triggerRepaint', ($) async {
    final tester = $.tester;
    final mapboxMap = await app.pumpMap(tester: $.tester);
    await tester.pumpAndSettle();
    await mapboxMap.triggerRepaint();
  });

  patrolTest('PrefetchZoomDelta', skip: kIsWeb, ($) async {
    final tester = $.tester;
    final mapboxMap = await app.pumpMap(tester: $.tester);
    await tester.pumpAndSettle();
    await mapboxMap.setPrefetchZoomDelta(10);
    var prefetchZoomDelta = await mapboxMap.getPrefetchZoomDelta();
    expect(prefetchZoomDelta, 10);
  });

  patrolTest('MapOptions', skip: kIsWeb, ($) async {
    final tester = $.tester;
    final mapboxMap = await app.pumpMap(tester: $.tester);
    await tester.pumpAndSettle();
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

  patrolTest('isGestureInProgress', skip: kIsWeb, ($) async {
    final tester = $.tester;
    final mapboxMap = await app.pumpMap(tester: $.tester);
    await tester.pumpAndSettle();

    expect(await mapboxMap.isGestureInProgress(), false);

    await mapboxMap.setGestureInProgress(true);
    expect(await mapboxMap.isGestureInProgress(), true);
  });

  patrolTest('isUserAnimationInProgress', skip: kIsWeb, ($) async {
    final tester = $.tester;
    final mapboxMap = await app.pumpMap(tester: $.tester);
    await tester.pumpAndSettle();

    expect(await mapboxMap.isUserAnimationInProgress(), false);

    await mapboxMap.setUserAnimationInProgress(true);
    expect(await mapboxMap.isUserAnimationInProgress(), true);
  });

  patrolTest('debugOptions', skip: kIsWeb, ($) async {
    final tester = $.tester;
    final mapboxMap = await app.pumpMap(tester: $.tester);
    await tester.pumpAndSettle();
    await mapboxMap.setDebugOptions([MapWidgetDebugOptions.tileBorders]);
    var debugOptions = await mapboxMap.getDebugOptions();
    expect(debugOptions.length, 1);
    expect(debugOptions.first, MapWidgetDebugOptions.tileBorders);
  });

  patrolTest('featureState', ($) async {
    final tester = $.tester;
    final mapboxMap = await app.pumpMap(tester: $.tester);
    await tester.pumpAndSettle();
    var style = mapboxMap.style;
    var source = await rootBundle.loadString('assets/source.json');
    var layer = await rootBundle.loadString('assets/point_layer.json');

    app.events.resetOnStyleDataLoaded();
    app.events.resetOnMapIdle();
    style.addStyleSource('source', source);
    style.addStyleLayer(layer, null);

    await app.waitForEvent($.tester, app.events.onSourceDataLoaded.future);
    await app.waitForEvent($.tester, app.events.onMapIdle.future);

    await mapboxMap.setFeatureState(
      'source',
      null,
      'point',
      json.encode({'choose': true}),
    );
    var featureState = await mapboxMap.getFeatureState('source', null, 'point');
    var stateMap = json.decode(featureState);
    expect(stateMap.length, 1);
    expect(stateMap['choose'], true);

    await mapboxMap.removeFeatureState('source', null, 'point', 'choose');
    featureState = await mapboxMap.getFeatureState('source', null, 'point');
    stateMap = json.decode(featureState);
    expect(stateMap.length, 0);
  });

  patrolTest('MapboxMapsOptions default values', skip: kIsWeb, ($) async {
    final tester = $.tester;
    final _ = await app.pumpMap(tester: $.tester);
    await tester.pumpAndSettle();

    expect(await MapboxOptions.accessToken, isNotNull);
    expect(await MapboxMapsOptions.getBaseUrl(), 'https://api.mapbox.com');
    expect(await MapboxMapsOptions.getDataPath(), isNotNull);
    expect(await MapboxMapsOptions.getAssetPath(), isNotNull);
    expect(
      await MapboxMapsOptions.getTileStoreUsageMode(),
      TileStoreUsageMode.READ_ONLY,
    );
  });

  patrolTest('MapboxMapsOptions read and update', skip: kIsWeb, ($) async {
    final tester = $.tester;
    final _ = await app.pumpMap(tester: $.tester);
    await tester.pumpAndSettle();

    final originalAccessToken = await MapboxOptions.accessToken;
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
    expect(await MapboxOptions.accessToken, token);
    expect(await MapboxMapsOptions.getBaseUrl(), baseUrl);
    expect(await MapboxMapsOptions.getDataPath(), endsWith(dataPath));
    expect(
      await MapboxMapsOptions.getAssetPath(),
      !kIsWeb && defaultTargetPlatform == TargetPlatform.android
          ? ""
          : endsWith(assetPath),
    );
    expect(await MapboxMapsOptions.getTileStoreUsageMode(), tileStoreUsageMode);
    expect(await MapboxMapsOptions.getLanguage(), language);
    expect(await MapboxMapsOptions.getWorldview(), worldview);

    // restore original values
    MapboxOptions.setAccessToken(originalAccessToken);
    MapboxMapsOptions.setBaseUrl(originalBaseURL);
    MapboxMapsOptions.setDataPath(originalDataPath);
    MapboxMapsOptions.setAssetPath(originalAssetPath);
    MapboxMapsOptions.setTileStoreUsageMode(originalTileStoreUsageMode);
    MapboxMapsOptions.setLanguage(null);
    MapboxMapsOptions.setWorldview(null);
  });

  // Skipped on web: relies on Style.addStyleImage, which isn't implemented there yet.
  patrolTest('queryRenderedFeatures', skip: kIsWeb, ($) async {
    final tester = $.tester;
    final mapboxMap = await app.pumpMap(tester: $.tester);
    await tester.pumpAndSettle();
    var style = mapboxMap.style;
    var options = CameraOptions(
      center: Point(coordinates: Position(-77.032667, 38.913175)),
      zoom: 10,
    );

    app.events.resetOnCameraChanged();
    mapboxMap.setCamera(options);
    await app.waitForEvent($.tester, app.events.onCameraChanged.future);

    var source = await rootBundle.loadString('assets/source.json');
    var layer = await rootBundle.loadString('assets/point_layer.json');
    final ByteData bytes = await rootBundle.load(
      'assets/symbols/custom-icon.png',
    );
    final Uint8List list = bytes.buffer.asUint8List();
    await style.addStyleImage(
      'icon',
      1.0,
      MbxImage(width: 40, height: 40, data: list),
      sdf: true,
      stretchX: [],
      stretchY: [],
      content: null,
    );

    app.events.resetOnSourceDataLoaded();
    app.events.resetOnMapIdle();
    style.addStyleSource('source', source);
    style.addStyleLayer(layer, null);
    await app.waitForEvent($.tester, app.events.onSourceDataLoaded.future);
    await app.waitForEvent($.tester, app.events.onMapIdle.future);

    var screenBox = ScreenBox(
      min: ScreenCoordinate(x: 0.0, y: 0.0),
      max: ScreenCoordinate(x: 500.0, y: 1000.0),
    );
    var renderedQueryGeometry = RenderedQueryGeometry.fromScreenBox(screenBox);
    var query = await mapboxMap.queryRenderedFeatures(
      renderedQueryGeometry,
      RenderedQueryOptions(layerIds: ['points'], filter: null),
    );
    expect(query.length, greaterThan(0));
    expect(query[0]!.queriedFeature.source, 'source');
    expect(query[0]!.queriedFeature.feature['id'], 'point');

    query = await mapboxMap.queryRenderedFeatures(
      RenderedQueryGeometry.fromScreenCoordinate(
        ScreenCoordinate(x: 0.0, y: 0.0),
      ),
      RenderedQueryOptions(layerIds: ['points'], filter: null),
    );
    expect(query.length, 0);
    query = await mapboxMap.queryRenderedFeatures(
      RenderedQueryGeometry.fromList([
        ScreenCoordinate(x: 0.0, y: 0.0),
        ScreenCoordinate(x: 1.0, y: 1.0),
      ]),
      RenderedQueryOptions(layerIds: ['points'], filter: null),
    );
    expect(query.length, 0);
  });

  // Skipped on web: the fixture's GeoJSON feature has a string id ("point"),
  // and GL JS's internal vector-tile pipeline only round-trips numeric
  // feature ids through querySourceFeatures.
  patrolTest('querySourceFeatures', skip: kIsWeb, ($) async {
    final tester = $.tester;
    final mapboxMap = await app.pumpMap(tester: $.tester);
    await tester.pumpAndSettle();
    var style = mapboxMap.style;
    var options = CameraOptions(
      center: Point(coordinates: Position(-77.032667, 38.913175)),
      zoom: 10,
      pitch: 0,
    );

    await app.waitForEvent($.tester, app.events.onMapLoaded.future);

    app.events.resetOnCameraChanged();
    mapboxMap.setCamera(options);
    await app.waitForEvent($.tester, app.events.onCameraChanged.future);

    var source = await rootBundle.loadString('assets/source.json');
    var layer = await rootBundle.loadString('assets/point_layer.json');

    app.events.resetOnSourceDataLoaded();
    app.events.resetOnMapIdle();
    style.addStyleSource('source', source);
    style.addStyleLayer(layer, null);
    await app.waitForEvent($.tester, app.events.onSourceDataLoaded.future);
    await app.waitForEvent($.tester, app.events.onMapIdle.future);

    var query = await mapboxMap.querySourceFeatures(
      'source',
      SourceQueryOptions(filter: ''),
    );
    expect(query.length, greaterThan(0));
    expect(query[0]!.queriedFeature.source, 'source');
    expect(query[0]!.queriedFeature.feature['id'], 'point');
  });

  patrolTest('queryFeatureExtensions', skip: kIsWeb, ($) async {
    final tester = $.tester;
    final mapboxMap = await app.pumpMap(tester: $.tester);
    await tester.pumpAndSettle();
    var style = mapboxMap.style;
    var source = await rootBundle.loadString(
      'assets/cluster/cluster_source.json',
    );
    var layer = await rootBundle.loadString(
      'assets/cluster/cluster_layer.json',
    );
    var clusterCountLayer = await rootBundle.loadString(
      'assets/cluster/cluster_count_layer.json',
    );
    var unclusteredLayer = await rootBundle.loadString(
      'assets/cluster/unclustered_point_layer.json',
    );

    app.events.resetOnSourceDataLoaded();
    app.events.resetOnMapIdle();
    style.addStyleSource("earthquakes", source);
    style.addStyleLayer(layer, null);
    style.addStyleLayer(clusterCountLayer, null);
    style.addStyleLayer(unclusteredLayer, null);
    await app.waitForEvent($.tester, app.events.onSourceDataLoaded.future);
    await app.waitForEvent($.tester, app.events.onMapIdle.future);

    var feature = {
      "id": 1249,
      "properties": {
        "point_count_abbreviated": "10",
        "cluster_id": 1249,
        "cluster": true,
        "point_count": 10,
      },
      "geometry": {
        "type": "Point",
        "coordinates": [-29.794921875, 59.220934076150456],
      },
      "type": "Feature",
    };

    var clusterLeaves = await mapboxMap.getGeoJsonClusterLeaves(
      'earthquakes',
      feature,
      null,
      null,
    );
    expect(clusterLeaves.featureCollection!.length, 10);

    var clusterChildren = await mapboxMap.getGeoJsonClusterChildren(
      'earthquakes',
      feature,
    );
    expect(clusterChildren.featureCollection!.length, 2);

    var clusterExpansionZoom = await mapboxMap.getGeoJsonClusterExpansionZoom(
      'earthquakes',
      feature,
    );
    expect(clusterExpansionZoom.value, '1');
  });

  patrolTest('snapshot', skip: kIsWeb, ($) async {
    final tester = $.tester;
    final mapboxMap = await app.pumpMap(tester: $.tester);
    await tester.pumpAndSettle();
    await mapboxMap.loadStyleURI(MapboxStyles.DARK);
    await app.waitForEvent($.tester, app.events.onMapIdle.future);
    final snapshot = await mapboxMap.snapshot();
    expect(snapshot, isNotNull);
  });
}
