import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'empty_map_widget.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('test_featureset_QRF', (WidgetTester tester) async {
    // load style and position camera
    final mapFuture = app.main(
        width: 200,
        height: 200,
        camera:
            CameraOptions(center: Point(coordinates: Position(0, 0)), zoom: 10),
        alignment: Alignment(100, 100));
    await tester.pumpAndSettle();
    final mapboxMap = await mapFuture;
    var styleJson = await rootBundle.loadString('assets/featuresetsStyle.json');
    mapboxMap.style.setStyleJSON(styleJson);

    await Future.delayed(Duration(seconds: 3));

    // test queryRenderedFeaturesForFeatureset
    var coord = await mapboxMap
        .pixelForCoordinate(Point(coordinates: Position(0.01, 0.01)));
    var featuresetQuery = await mapboxMap.queryRenderedFeaturesForFeatureset(
        geometry: RenderedQueryGeometry.fromScreenCoordinate(coord),
        featureset:
            FeaturesetDescriptor(featuresetId: "poi", importId: "nested"));

    expect(featuresetQuery.length, 2);
    expect(featuresetQuery.first.properties["name"], "nest2");
    expect(featuresetQuery[1].properties["name"], "nest1");
    expect(featuresetQuery[0].properties["class"], "poi");

    // test queryRenderedFeaturesForFeatureset with filter
    var filter = '["==",["get", "type"], "A"]';
    var featuresetFilterQuery =
        await mapboxMap.queryRenderedFeaturesForFeatureset(
            geometry: RenderedQueryGeometry.fromScreenCoordinate(coord),
            featureset:
                FeaturesetDescriptor(featuresetId: "poi", importId: "nested"),
            filter: filter);

    expect(featuresetFilterQuery.length, 1);
    expect(featuresetFilterQuery[0].properties["name"], "nest1");
    expect(featuresetFilterQuery[0].properties["class"], "poi");

    //test queryRenderedFeaturesInViewport
    var viewportQuery = await mapboxMap.queryRenderedFeaturesInViewport(
        featureset:
            FeaturesetDescriptor(featuresetId: "poi", importId: "nested"));

    expect(viewportQuery.length, 3);
    expect(viewportQuery[0].properties["name"], "nest2");
    expect(viewportQuery[1].properties["name"], "nest1");
    expect(viewportQuery[2].properties["name"], "nest3");
    expect(viewportQuery[2].properties["class"], "poi");
  });

  testWidgets('test_featurestate_methods', (WidgetTester tester) async {
    // load style and position camera
    final mapFuture = app.main(
        width: 200,
        height: 200,
        camera:
            CameraOptions(center: Point(coordinates: Position(0, 0)), zoom: 10),
        alignment: Alignment(100, 100));
    await tester.pumpAndSettle();
    final mapboxMap = await mapFuture;
    var styleJson = await rootBundle.loadString('assets/featuresetsStyle.json');
    mapboxMap.style.setStyleJSON(styleJson);

    await app.events.onMapLoaded.future;

    var feature = FeaturesetFeature(
        id: FeaturesetFeatureId(id: "11", namespace: "A"),
        featureset:
            FeaturesetDescriptor(featuresetId: "poi", importId: "nested"),
        geometry: Point(coordinates: Position(0.01, 0.01)).toJson(),
        properties: {},
        state: {});
    Map<String, Object?> state = {
      "highlight": true,
    };

    // test set and get featurestate
    await mapboxMap.setFeatureStateForFeaturesetFeature(feature, state);
    var returnedFeatureState =
        await mapboxMap.getFeatureStateForFeaturesetFeature(feature);
    expect(returnedFeatureState, state);

    // test remove featurestate
    await mapboxMap.removeFeatureStateForFeaturesetFeature(
        feature, "highlight");
    var returnedFeatureState2 =
        await mapboxMap.getFeatureStateForFeaturesetFeature(feature);
    expect(returnedFeatureState2, {});

    // test reset featurestate
    await Future.delayed(Duration(seconds: 5));
    await mapboxMap.setFeatureStateForFeaturesetFeature(feature, state);
    var returnedFeatureState3 =
        await mapboxMap.getFeatureStateForFeaturesetFeature(feature);
    expect(returnedFeatureState3, state);

    await mapboxMap.resetFeatureStatesForFeatureset(
        FeaturesetDescriptor(featuresetId: "poi", importId: "nested"));
    var returnedFeatureState4 =
        await mapboxMap.getFeatureStateForFeaturesetFeature(feature);
    expect(returnedFeatureState4, {});
  });

  testWidgets('test_featurestate_descriptor_methods',
      (WidgetTester tester) async {
    // load style and position camera
    final mapFuture = app.main(
        width: 200,
        height: 200,
        camera:
            CameraOptions(center: Point(coordinates: Position(0, 0)), zoom: 10),
        alignment: Alignment(100, 100));
    await tester.pumpAndSettle();
    final mapboxMap = await mapFuture;
    var styleJson = await rootBundle.loadString('assets/featuresetsStyle.json');
    mapboxMap.style.setStyleJSON(styleJson);

    await app.events.onMapLoaded.future;

    var featuresetDescriptor =
        FeaturesetDescriptor(featuresetId: "poi", importId: "nested");
    var featuresetID = FeaturesetFeatureId(id: "11", namespace: "A");
    Map<String, Object?> state = {
      "highlight": true,
    };

    await Future.delayed(Duration(seconds: 1));

    // test set and get featurestate
    await mapboxMap.setFeatureStateForFeaturesetFeatureDescriptor(
        featuresetDescriptor, featuresetID, state);
    var returnedFeatureState =
        await mapboxMap.getFeatureStateForFeaturesetDescriptor(
            featuresetDescriptor, featuresetID);
    expect(returnedFeatureState, state);

    // test remove featurestate
    await mapboxMap.removeFeatureStateForFeaturesetFeatureDescriptor(
        featuresetDescriptor, featuresetID, "highlight");
    var returnedFeatureState2 =
        await mapboxMap.getFeatureStateForFeaturesetDescriptor(
            featuresetDescriptor, featuresetID);
    expect(returnedFeatureState2, {});
  });

  testWidgets('test_state_is_queried', (WidgetTester tester) async {
    // load style and position camera
    final mapFuture = app.main(
        width: 200,
        height: 200,
        camera:
            CameraOptions(center: Point(coordinates: Position(0, 0)), zoom: 10),
        alignment: Alignment(100, 100));
    await tester.pumpAndSettle();
    final mapboxMap = await mapFuture;
    var styleJson = await rootBundle.loadString('assets/featuresetsStyle.json');
    mapboxMap.style.setStyleJSON(styleJson);

    await app.events.onMapLoaded.future;

    var featuresetID = FeaturesetFeatureId(id: "11", namespace: "A");
    var featuresetDescriptor =
        FeaturesetDescriptor(featuresetId: "poi", importId: "nested");
    Map<String, Object?> state = {
      "hide": true,
    };
    var filter = '["==",["get", "type"], "A"]';
    Map<String, Object?> expectedProperties = {
      "name": "nest1",
      "type": "A",
      "class": "poi"
    };

    await mapboxMap.setFeatureStateForFeaturesetFeatureDescriptor(
        featuresetDescriptor, featuresetID, state);
    var queryResult = await mapboxMap.queryRenderedFeaturesInViewport(
        featureset: featuresetDescriptor, filter: filter);
    var poi = queryResult.first;
    var point = Point.decode(poi.geometry);

    expect(queryResult.length, 1);
    expect(poi.id?.id, featuresetID.id);
    expect(poi.id?.namespace, featuresetID.namespace);
    expect(poi.state, state);
    expect(point.coordinates.lat, closeTo(0.01, 0.05));
    expect(point.coordinates.lng, closeTo(0.01, 0.05));
    expect(poi.properties, expectedProperties);
  });

  testWidgets('test_getFeaturesets', (WidgetTester tester) async {
    // load style and position camera
    final mapFuture = app.main(
        width: 200,
        height: 200,
        camera:
            CameraOptions(center: Point(coordinates: Position(0, 0)), zoom: 10),
        alignment: Alignment(100, 100));
    await tester.pumpAndSettle();
    final mapboxMap = await mapFuture;
    var styleJson = await rootBundle.loadString('assets/featuresetsStyle.json');
    mapboxMap.style.setStyleJSON(styleJson);

    await app.events.onMapLoaded.future;

    var returnedFeaturesets = await mapboxMap.style.getFeaturesets();

    expect(returnedFeaturesets.length, 1);
    expect(returnedFeaturesets.first.importId, "nested");
  });

  testWidgets('test_query_featureset_target', (WidgetTester tester) async {
    // load style and position camera
    final mapFuture = app.main(
        width: 200,
        height: 200,
        camera:
            CameraOptions(center: Point(coordinates: Position(0, 0)), zoom: 10),
        alignment: Alignment(100, 100));
    await tester.pumpAndSettle();
    final mapboxMap = await mapFuture;
    var styleJson = await rootBundle.loadString('assets/featuresetsStyle.json');
    mapboxMap.style.setStyleJSON(styleJson);

    await app.events.onMapLoaded.future;
    await Future.delayed(Duration(seconds: 1));

    var featuresetFilter = '["==", ["get", "type"], "B"]';
    var layerFilter = '["==", ["get", "filter"], true]';
    var featuresetPOI =
        FeaturesetDescriptor(featuresetId: "poi", importId: "nested");
    var featuresetLayer = FeaturesetDescriptor(layerId: "circle-2");
    var coord = await mapboxMap
        .pixelForCoordinate(Point(coordinates: Position(0.01, 0.01)));
    var targets = [
      FeaturesetQueryTarget(
          featureset: featuresetPOI, filter: featuresetFilter, id: 1),
      FeaturesetQueryTarget(
          featureset: featuresetLayer, filter: layerFilter, id: 2)
    ];
    Map<String, Object?> expectedProperties = {
      "name": "qux",
      "filter": true,
      "bar": 2
    };
    Map<String, Object?> expectedProperties2 = {
      "type": "B",
      "class": "poi",
      "name": "nest2"
    };

    var returnedQuery = await mapboxMap.queryRenderedFeaturesForTargets(
        RenderedQueryGeometry.fromScreenCoordinate(coord), targets);

    expect(returnedQuery.length, 2);
    expect(returnedQuery[0]?.queryTargets?.length, 1);
    expect(returnedQuery[0]?.queryTargets?.last.id, 2);
    expect(returnedQuery[0]?.queryTargets?.last.featureset.layerId, "circle-2");
    expect(returnedQuery[0]?.queryTargets?.last.filter, null);
    //expect(returnedQuery[0]!.queriedFeature.feature["id"], 2);
    expect(returnedQuery[0]!.queriedFeature.feature["properties"], expectedProperties);
    expect(returnedQuery[1]?.queryTargets?.length, 1);
    expect(returnedQuery[1]?.queryTargets?.last.id, 1);
    expect(returnedQuery[1]?.queryTargets?.last.featureset.featuresetId, "poi");
    expect(returnedQuery[1]?.queryTargets?.last.featureset.importId, "nested");
    expect(returnedQuery[1]?.queryTargets?.last.filter, null);
    //expect(returnedQuery[1]!.queriedFeature.feature["id"], 12);
    expect(returnedQuery[1]!.queriedFeature.feature["properties"], expectedProperties2);
  });
}
