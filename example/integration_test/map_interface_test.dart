import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:mapbox_maps_example/empty_map_widget.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  Future<void> addDelay(int ms) async {
    await Future<void>.delayed(Duration(milliseconds: ms));
  }

  testWidgets('loadStyleURI', (WidgetTester tester) async {
    final mapFuture = app.main();
    await tester.pumpAndSettle();
    final mapboxMap = await mapFuture;
    await mapboxMap.loadStyleURI(MapboxStyles.DARK);
    var style = await mapboxMap.style.getStyleURI();
    expect(MapboxStyles.DARK, style);
    await addDelay(1000);
  });

  testWidgets('loadStyleJson', (WidgetTester tester) async {
    final mapFuture = app.main();
    await tester.pumpAndSettle();
    final mapboxMap = await mapFuture;
    var styleJson = await rootBundle.loadString('assets/style.json');
    mapboxMap.loadStyleJson(styleJson);
    var getStyleJson = await mapboxMap.style.getStyleJSON();
    expect(styleJson, getStyleJson);
    await addDelay(1000);
  });

  testWidgets('clearData', (WidgetTester tester) async {
    final mapFuture = app.main();
    await tester.pumpAndSettle();
    final mapboxMap = await mapFuture;
    mapboxMap.clearData();
    await addDelay(1000);
  });

  testWidgets('setMemoryBudget', (WidgetTester tester) async {
    final mapFuture = app.main();
    await tester.pumpAndSettle();
    final mapboxMap = await mapFuture;
    mapboxMap.setMemoryBudget(MapMemoryBudgetInMegabytes(size: 100), null);
    mapboxMap.setMemoryBudget(null, MapMemoryBudgetInTiles(size: 100));
    await addDelay(1000);
  });

  if (Platform.isAndroid) {
    testWidgets('getSize', (WidgetTester tester) async {
      final mapFuture = app.main();
      await tester.pumpAndSettle();
      final mapboxMap = await mapFuture;
      var size = await mapboxMap.getSize();
      expect(size.width, tester.binding.window.physicalSize.width);
      expect(size.height, tester.binding.window.physicalSize.height);
      await addDelay(1000);
    });

    testWidgets('reduceMemoryUse', (WidgetTester tester) async {
      final mapFuture = app.main();
      await tester.pumpAndSettle();
      final mapboxMap = await mapFuture;

      await mapboxMap.reduceMemoryUse();
      await addDelay(1000);
    });
  }

  testWidgets('triggerRepaint', (WidgetTester tester) async {
    final mapFuture = app.main();
    await tester.pumpAndSettle();
    final mapboxMap = await mapFuture;
    await mapboxMap.triggerRepaint();
    await addDelay(1000);
  });

  testWidgets('PrefetchZoomDelta', (WidgetTester tester) async {
    final mapFuture = app.main();
    await tester.pumpAndSettle();
    final mapboxMap = await mapFuture;
    await mapboxMap.setPrefetchZoomDelta(10);
    var prefetchZoomDelta = await mapboxMap.getPrefetchZoomDelta();
    expect(prefetchZoomDelta, 10);
    await addDelay(1000);
  });

  testWidgets('MapOptions', (WidgetTester tester) async {
    final mapFuture = app.main();
    await tester.pumpAndSettle();
    final mapboxMap = await mapFuture;
    var options = await mapboxMap.getMapOptions();
    if (Platform.isAndroid) {
      expect(options.orientation, NorthOrientation.UPWARDS);
      expect(options.constrainMode, ConstrainMode.HEIGHT_ONLY);
      expect(options.contextMode, isNull);
      expect(options.viewportMode, ViewportMode.DEFAULT);
    }
    expect(options.crossSourceCollisions, true);
    expect(options.optimizeForTerrain, true);
    expect(options.pixelRatio, tester.binding.window.devicePixelRatio);
    expect(options.glyphsRasterizationOptions, isNull);
    expect(options.size!.width, isNotNull);
    expect(options.size!.height, isNotNull);
    if (Platform.isAndroid) {
      await mapboxMap.setConstrainMode(ConstrainMode.WIDTH_AND_HEIGHT);
      await mapboxMap.setNorthOrientation(NorthOrientation.DOWNWARDS);
      await mapboxMap.setViewportMode(ViewportMode.FLIPPED_Y);

      options = await mapboxMap.getMapOptions();
      expect(options.orientation, NorthOrientation.DOWNWARDS);
      expect(options.constrainMode, ConstrainMode.WIDTH_AND_HEIGHT);
      expect(options.viewportMode, ViewportMode.FLIPPED_Y);
    }
    await addDelay(1000);
  });

  testWidgets('isGestureInProgress', (WidgetTester tester) async {
    final mapFuture = app.main();
    await tester.pumpAndSettle();
    final mapboxMap = await mapFuture;
    if (Platform.isAndroid) {
      var isGestureInProgress = await mapboxMap.isGestureInProgress();
      expect(isGestureInProgress, false);
    }
    await mapboxMap.setGestureInProgress(true);
    if (Platform.isAndroid) {
      var isGestureInProgress = await mapboxMap.isGestureInProgress();
      expect(isGestureInProgress, true);
    }
    await addDelay(1000);
  });

  testWidgets('isUserAnimationInProgress', (WidgetTester tester) async {
    final mapFuture = app.main();
    await tester.pumpAndSettle();
    final mapboxMap = await mapFuture;
    if (Platform.isAndroid) {
      var isUserAnimationInProgress =
          await mapboxMap.isUserAnimationInProgress();
      expect(isUserAnimationInProgress, false);
    }
    await mapboxMap.setUserAnimationInProgress(true);
    if (Platform.isAndroid) {
      var isUserAnimationInProgress =
          await mapboxMap.isUserAnimationInProgress();
      expect(isUserAnimationInProgress, true);
    }
    await addDelay(1000);
  });

  testWidgets('debugOptions', (WidgetTester tester) async {
    final mapFuture = app.main();
    await tester.pumpAndSettle();
    final mapboxMap = await mapFuture;
    await mapboxMap.setDebug(
        [MapDebugOptions(data: MapDebugOptionsData.TILE_BORDERS)], true);
    var debugOptions = await mapboxMap.getDebug();
    expect(debugOptions.length, 1);
    expect(debugOptions.first!.data, MapDebugOptionsData.TILE_BORDERS);
    await addDelay(1000);
  });

  testWidgets('featureState', (WidgetTester tester) async {
    final mapFuture = app.main();
    await tester.pumpAndSettle();
    final mapboxMap = await mapFuture;
    var style = mapboxMap.style;
    var source = await rootBundle.loadString('assets/source.json');
    var layer = await rootBundle.loadString('assets/point_layer.json');
    style.addStyleSource('source', source);
    style.addStyleLayer(layer, null);
    await addDelay(1000);

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
    await addDelay(1000);
  });

  testWidgets('getResourceOptions', (WidgetTester tester) async {
    final mapFuture = app.main();
    await tester.pumpAndSettle();
    final mapboxMap = await mapFuture;

    var options = await mapboxMap.getResourceOptions();
    expect(options.accessToken, isNotNull);
    if (Platform.isAndroid) {
      expect(options.baseURL, 'https://api.mapbox.com');
    } else {
      expect(options.baseURL, 'file:///https:/api.mapbox.com');
    }
    await addDelay(1000);
  });

  testWidgets('queryRenderedFeatures', (WidgetTester tester) async {
    final mapFuture = app.main();
    await tester.pumpAndSettle();
    final mapboxMap = await mapFuture;
    var style = mapboxMap.style;
    var source = await rootBundle.loadString('assets/source.json');
    var layer = await rootBundle.loadString('assets/point_layer.json');
    style.addStyleSource('source', source);
    style.addStyleLayer(layer, null);
    await addDelay(1000);

    var screenBox = ScreenBox(
        min: ScreenCoordinate(x: 0.0, y: 0.0),
        max: ScreenCoordinate(x: 500.0, y: 1000.0));
    var renderedQueryGeometry = RenderedQueryGeometry(
        value: json.encode(screenBox.encode()), type: Type.SCREEN_BOX);
    var query = await mapboxMap.queryRenderedFeatures(renderedQueryGeometry,
        RenderedQueryOptions(layerIds: ['points'], filter: null));
    expect(query.length, 1);
    expect(query[0]!.source, 'source');
    expect(query[0]!.feature['id'], 'point');

    query = await mapboxMap.queryRenderedFeatures(
        RenderedQueryGeometry(
            value: json.encode(ScreenCoordinate(x: 0.0, y: 0.0).encode()),
            type: Type.SCREEN_COORDINATE),
        RenderedQueryOptions(layerIds: ['points'], filter: null));
    expect(query.length, 0);
    query = await mapboxMap.queryRenderedFeatures(
        RenderedQueryGeometry(
            value: json.encode([
              ScreenCoordinate(x: 0.0, y: 0.0).encode(),
              ScreenCoordinate(x: 1.0, y: 1.0).encode()
            ]),
            type: Type.LIST),
        RenderedQueryOptions(layerIds: ['points'], filter: null));
    expect(query.length, 0);
    await addDelay(1000);
  });

  testWidgets('querySourceFeatures', (WidgetTester tester) async {
    final mapFuture = app.main();
    await tester.pumpAndSettle();
    final mapboxMap = await mapFuture;
    var style = mapboxMap.style;
    var source = await rootBundle.loadString('assets/source.json');
    var layer = await rootBundle.loadString('assets/point_layer.json');
    style.addStyleSource('source', source);
    style.addStyleLayer(layer, null);
    await addDelay(1000);
    var query = await mapboxMap.querySourceFeatures(
        'source', SourceQueryOptions(filter: ''));
    expect(query.length, 1);
    expect(query[0]!.source, 'source');
    expect(query[0]!.feature['id'], 'point');
  });

  testWidgets('queryFeatureExtensions', (WidgetTester tester) async {
    final mapFuture = app.main();
    await tester.pumpAndSettle();
    final mapboxMap = await mapFuture;
    var style = mapboxMap.style;
    var source =
        await rootBundle.loadString('assets/cluster/cluster_source.json');
    style.addStyleSource("earthquakes", source);
    var layer =
        await rootBundle.loadString('assets/cluster/cluster_layer.json');
    style.addStyleLayer(layer, null);

    var clusterCountLayer =
        await rootBundle.loadString('assets/cluster/cluster_count_layer.json');
    style.addStyleLayer(clusterCountLayer, null);

    var unclusteredLayer = await rootBundle
        .loadString('assets/cluster/unclustered_point_layer.json');
    style.addStyleLayer(unclusteredLayer, null);
    await addDelay(5000);
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
}
