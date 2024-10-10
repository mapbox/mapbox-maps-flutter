import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import '../empty_map_widget.dart' as app;

import '../utils/list_close_to_matcher.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Style uri', (WidgetTester tester) async {
    final mapFuture = app.main();
    await tester.pumpAndSettle();
    final mapboxMap = await mapFuture;
    var style = mapboxMap.style;

    await app.events.onMapLoaded.future;

    await expectLater(style.getStyleURI(), completion(MapboxStyles.STANDARD));
    style.setStyleURI(MapboxStyles.DARK);
    app.events.resetOnMapLoaded();
    await app.events.onMapLoaded.future;
    await expectLater(style.getStyleURI(), completion(MapboxStyles.DARK));
  });

  testWidgets('Style json', (WidgetTester tester) async {
    final mapFuture = app.main();
    await tester.pumpAndSettle();
    final mapboxMap = await mapFuture;
    var style = mapboxMap.style;
    var styleJson = await rootBundle.loadString('assets/style.json');
    style.setStyleJSON(styleJson);
    await app.events.onMapLoaded.future;
    await expectLater(style.getStyleJSON(), completion(styleJson));
  });

  testWidgets('Style is loaded', (WidgetTester tester) async {
    final mapFuture = app.main();
    await tester.pumpAndSettle();
    final mapboxMap = await mapFuture;
    var style = mapboxMap.style;
    var styleLoaded = await style.isStyleLoaded();
    expect(styleLoaded, true);
  });

  testWidgets('Style Transition', (WidgetTester tester) async {
    final mapFuture = app.main();
    await tester.pumpAndSettle();
    final mapboxMap = await mapFuture;
    var style = mapboxMap.style;
    var transition = TransitionOptions(
        delay: 100, duration: 200, enablePlacementTransitions: false);
    style.setStyleTransition(transition);
    var styleTransition = await style.getStyleTransition();
    expect(styleTransition.duration, 200);
    expect(styleTransition.delay, 100);
    expect(styleTransition.enablePlacementTransitions, false);
  });

  testWidgets('Add and remove layer and source', (WidgetTester tester) async {
    final mapFuture = app.main();
    await tester.pumpAndSettle();
    final mapboxMap = await mapFuture;
    var style = mapboxMap.style;
    await expectLater(style.styleLayerExists('custom'), completion(false));
    await expectLater(style.styleSourceExists('source'), completion(false));

    var source = await rootBundle.loadString('assets/source.json');
    var layer = await rootBundle.loadString('assets/layer.json');

    // Add source and layer
    style.addStyleSource('source', source);
    style.addStyleLayer(layer, null);
    await expectLater(style.styleLayerExists('custom'), completion(true));
    await expectLater(style.styleSourceExists('source'), completion(true));
    await expectLater(
        style.isStyleLayerPersistent('custom'), completion(false));

    // Remove source and layer
    style.removeStyleLayer('custom');
    style.removeStyleSource('source');
    await expectLater(style.styleLayerExists('custom'), completion(false));
    await expectLater(style.styleSourceExists('source'), completion(false));

    // Add persistent layer
    style.addPersistentStyleLayer(layer, null);
    await expectLater(style.isStyleLayerPersistent('custom'), completion(true));
  });

  testWidgets('Move layer', (WidgetTester tester) async {
    final mapFuture = app.main();
    await tester.pumpAndSettle();
    final mapboxMap = await mapFuture;
    var style = mapboxMap.style;

    await style.setStyleURI(MapboxStyles.MAPBOX_STREETS);

    await expectLater(style.styleLayerExists('custom'), completion(false));
    await expectLater(style.styleSourceExists('source'), completion(false));
    var layers = await style.getStyleLayers();
    expect(layers.first!.id, 'land');

    var source = await rootBundle.loadString('assets/source.json');
    var layer = await rootBundle.loadString('assets/layer.json');

    // Add source and layer
    style.addStyleSource('source', source);
    style.addStyleLayer(layer, LayerPosition(at: 0));
    await expectLater(style.styleLayerExists('custom'), completion(true));
    await expectLater(style.styleSourceExists('source'), completion(true));

    // Custom layer is added on top by default
    layers = await style.getStyleLayers();
    expect(layers.first!.id, 'custom');

    style.moveStyleLayer('custom', LayerPosition(below: 'pitch-outline'));

    layers = await style.getStyleLayers();
    expect(layers.first!.id, 'land');
  });

  testWidgets('StyleLayerProperty', (WidgetTester tester) async {
    final mapFuture = app.main();
    await tester.pumpAndSettle();
    final mapboxMap = await mapFuture;
    var style = mapboxMap.style;
    var source = await rootBundle.loadString('assets/source.json');
    var layer = await rootBundle.loadString('assets/layer.json');

    // Add source and layer
    style.addStyleSource('source', source);
    style.addStyleLayer(layer, null);

    var radius = await style.getStyleLayerProperty('custom', 'circle-radius');
    expect(radius.value, 20.0);
    var color = await style.getStyleLayerProperty('custom', 'circle-color');
    expect(color.value, listCloseTo(Color(0xFFFF3300).toRGBAList(), 0.00001));

    var styleLayerProperty =
        await style.getStyleLayerProperty('custom', 'circle-radius');
    expect(styleLayerProperty.value, 20.0);
    await style.setStyleLayerProperty('custom', 'circle-radius', 1.0);
    await style.setStyleLayerProperty('custom', 'circle-color', 'red');

    radius = await style.getStyleLayerProperty('custom', 'circle-radius');
    expect(radius.value, 1.0);
    color = await style.getStyleLayerProperty('custom', 'circle-color');
    expect(color.value, listCloseTo(Color(0xFFFF0000).toRGBAList(), 0.00001));
  });

  testWidgets('StyleLayerProperties', (WidgetTester tester) async {
    final mapFuture = app.main();
    await tester.pumpAndSettle();
    final mapboxMap = await mapFuture;
    var style = mapboxMap.style;
    var source = await rootBundle.loadString('assets/source.json');
    var layer = await rootBundle.loadString('assets/layer.json');

    var properties = {'circle-radius': 10.0, 'circle-color': 'white'};

    // Add source and layer
    style.addStyleSource('source', source);
    style.addStyleLayer(layer, null);
    await style.setStyleLayerProperties('custom', json.encode(properties));
    var styleLayerProperties = await style.getStyleLayerProperties('custom');
    var formattedProperties =
        json.decode(styleLayerProperties) as Map<String, dynamic>;
    expect(formattedProperties['paint']['circle-radius'], 10);
    expect(formattedProperties['paint']['circle-color'],
        ['rgba', 255, 255, 255, 1]);
  });

  testWidgets('StyleSourceProperty', (WidgetTester tester) async {
    final mapFuture = app.main();
    await tester.pumpAndSettle();
    final mapboxMap = await mapFuture;
    var style = mapboxMap.style;
    var source = await rootBundle.loadString('assets/source.json');

    // Add source and layer
    style.addStyleSource('source', source);
    var styleSourceProperty =
        await style.getStyleSourceProperty('source', 'type');
    await expectLater(styleSourceProperty.value, 'geojson');
    await expectLater(
        styleSourceProperty.kind, StylePropertyValueKind.CONSTANT);
    var styleSourceAttributionProperty =
        await style.getStyleSourceProperty('source', 'attribution');
    await expectLater(styleSourceAttributionProperty.value,
        '<a href=\"https://www.mapbox.com/about/maps/\" target=\"_blank\" title=\"Mapbox\" aria-label=\"Mapbox\" role=\"listitem\">© Mapbox</a>');
    await expectLater(
        styleSourceProperty.kind, StylePropertyValueKind.CONSTANT);
  });

  testWidgets('StyleSourceProperties', (WidgetTester tester) async {
    final mapFuture = app.main();
    await tester.pumpAndSettle();
    final mapboxMap = await mapFuture;
    var style = mapboxMap.style;
    var source = await rootBundle.loadString('assets/source.json');

    // Add source and layer
    style.addStyleSource('source', source);
    var styleSourcePropertiesString =
        await style.getStyleSourceProperties('source');
    var styleSourceProperties =
        json.decode(styleSourcePropertiesString) as Map<String, dynamic>;

    if (Platform.isIOS) {
      expect(styleSourceProperties.length, 3);
      expect(styleSourceProperties['id'], 'source');
    } else {
      expect(styleSourceProperties.length, 2);
    }
    expect(styleSourceProperties['type'], 'geojson');
    expect(styleSourceProperties['attribution'],
        '<a href=\"https://www.mapbox.com/about/maps/\" target=\"_blank\" title=\"Mapbox\" aria-label=\"Mapbox\" role=\"listitem\">© Mapbox</a>');
  });

  testWidgets('addAndRemoveGeoJSONSourceFeatures', (WidgetTester tester) async {
    final mapFuture = app.main();
    await tester.pumpAndSettle();
    final mapboxMap = await mapFuture;
    var data = await rootBundle
        .loadString('assets/from_crema_to_council_crest.geojson');
    var feature = Feature(
        id: "addedFeature",
        geometry: Point(coordinates: Position(1, 1)),
        properties: {"test": "data"});

    // Reset map events
    app.events.resetOnSourceDataLoaded();
    app.events.resetOnMapIdle();

    // Add GeoJSONSourceFeature
    await mapboxMap.style.addSource(GeoJsonSource(id: "line", data: data));
    await mapboxMap.style.addGeoJSONSourceFeatures("line", "dataID", [feature]);
    await mapboxMap.style
        .addLayer(CircleLayer(id: "circle_layer", sourceId: "line"));

    // Wait for map and source to finish
    await app.events.onSourceDataLoaded.future;
    await app.events.onMapIdle.future;

    // Test dataId is returned
    expect(app.events.sourceDataIDs.first, "dataID");

    // Test added Features
    var returnedSourceFeatures = await mapboxMap.querySourceFeatures(
        'line', SourceQueryOptions(filter: ''));
    expect(returnedSourceFeatures.length, 1);
    expect(returnedSourceFeatures.first?.queriedFeature.feature['id'],
        "addedFeature");
    expect(returnedSourceFeatures.first?.queriedFeature.feature['properties'],
        {"test": "data"});

    // Reset map events
    app.events.resetOnSourceDataLoaded();
    app.events.resetOnMapIdle();

    await mapboxMap.style
        .removeGeoJSONSourceFeatures("line", "dataID", ["addedFeature"]);

    // Wait for map and source to finish
    await app.events.onSourceDataLoaded.future;
    await app.events.onMapIdle.future;

    returnedSourceFeatures = await mapboxMap.querySourceFeatures(
        'line', SourceQueryOptions(filter: ''));
    expect(returnedSourceFeatures.length, 0);
  });

  testWidgets('updateGeoJSONSourceFeatures', (WidgetTester tester) async {
    final mapFuture = app.main();
    await tester.pumpAndSettle();
    final mapboxMap = await mapFuture;
    var data = await rootBundle
        .loadString('assets/from_crema_to_council_crest.geojson');
    var feature = Feature(
        id: "addedFeature",
        geometry: Point(coordinates: Position(1, 1)),
        properties: {"test": "data"});

    // Reset map events
    app.events.resetOnSourceDataLoaded();
    app.events.resetOnMapIdle();

    // Add and update GeoJSONSourceFeature
    await mapboxMap.style.addSource(GeoJsonSource(id: "line", data: data));
    await mapboxMap.style.addGeoJSONSourceFeatures("line", "dataID", [feature]);
    await mapboxMap.style
        .addLayer(CircleLayer(id: "circle_layer", sourceId: "line"));
    feature.properties = {"test": "newData"};
    await mapboxMap.style
        .updateGeoJSONSourceFeatures("line", "dataID", [feature]);

    // Wait for map and source to finish
    await app.events.onSourceDataLoaded.future;
    await app.events.onMapIdle.future;

    // Test dataId is returned
    expect(app.events.sourceDataIDs.first, "dataID");

    // Test query
    var returnedSourceFeatures = await mapboxMap.querySourceFeatures(
        'line', SourceQueryOptions(filter: ''));
    expect(returnedSourceFeatures.length, 1);
    expect(returnedSourceFeatures.first?.queriedFeature.feature['id'],
        "addedFeature");
    expect(returnedSourceFeatures.first?.queriedFeature.feature['properties'],
        {"test": "newData"});
  });

  testWidgets('getStyleDefaultCamera', (WidgetTester tester) async {
    final mapFuture = app.main();
    await tester.pumpAndSettle();
    final mapboxMap = await mapFuture;
    var style = mapboxMap.style;
    await style.setStyleURI(MapboxStyles.MAPBOX_STREETS);

    var camera = await style.getStyleDefaultCamera();
    expect(camera.bearing, 0);
    expect(camera.pitch, 0);
    expect(camera.zoom, 2.0);
    expect(camera.anchor, null);
    final point = camera.center;
    expect(point?.coordinates.lng, -92.25);
    expect(point?.coordinates.lat, 37.75);
  });

  testWidgets('StyleLightProperty', (WidgetTester tester) async {
    final mapFuture = app.main();
    await tester.pumpAndSettle();
    final mapboxMap = await mapFuture;
    var style = mapboxMap.style;

    await app.events.onMapLoaded.future;

    await style.setLights(AmbientLight(id: "ambient-light-id"),
        DirectionalLight(id: "directional-light-id"));

    await style.setStyleLightProperty('ambient-light-id', 'color', 'white');
    await style.setStyleLightProperty('directional-light-id', 'intensity', 0.4);

    var intensity =
        await style.getStyleLightProperty('directional-light-id', 'intensity');
    expect(intensity.value, isNotNull);
    expect(intensity.value, closeTo(0.4, 0.00001));

    var color = await style.getStyleLightProperty('ambient-light-id', 'color');
    expect(color.value, Colors.white.toRGBAList());
  });

  testWidgets('Flat Light', (WidgetTester tester) async {
    final mapFuture = app.main();
    await tester.pumpAndSettle();
    final mapboxMap = await mapFuture;
    var style = mapboxMap.style;

    final flatLight = FlatLight(
        id: "flat-light-id",
        anchor: Anchor.MAP,
        color: Colors.red.value,
        colorTransition: TransitionOptions(duration: 300, delay: 200),
        intensity: 3,
        intensityTransition: TransitionOptions(duration: 100, delay: 50),
        position: [1, 2, 3],
        positionTransition: TransitionOptions(duration: 10, delay: 5));
    await style.setLight(flatLight);

    expect((await style.getStyleLightProperty("flat-light-id", "color")).value,
        listCloseTo(Colors.red.toRGBAList(), 0.0001));
    expect(
        (await style.getStyleLightProperty("flat-light-id", "color-transition"))
            .value,
        flatLight.colorTransition?.toJSON());
    expect(
        (await style.getStyleLightProperty("flat-light-id", "intensity")).value,
        3);
    expect(
        (await style.getStyleLightProperty(
                "flat-light-id", "intensity-transition"))
            .value,
        flatLight.intensityTransition?.toJSON());
    expect(
        (await style.getStyleLightProperty("flat-light-id", "position")).value,
        [1, 2, 3]);
    expect(
        (await style.getStyleLightProperty(
                "flat-light-id", "position-transition"))
            .value,
        flatLight.positionTransition?.toJSON());
  });

  testWidgets('3D Lights', (WidgetTester tester) async {
    final mapFuture = app.main();
    await tester.pumpAndSettle();
    final mapboxMap = await mapFuture;
    var style = mapboxMap.style;

    await app.events.onMapLoaded.future;

    final ambientLight = AmbientLight(
        id: 'ambient-light-id',
        color: Colors.blue.value,
        colorTransition: TransitionOptions(duration: 300, delay: 200),
        intensity: 3,
        intensityTransition: TransitionOptions(duration: 100, delay: 50));
    final directionalLight = DirectionalLight(
        id: 'directional-light-id',
        castShadows: true,
        color: Colors.blue.value,
        colorTransition: TransitionOptions(duration: 300, delay: 200),
        direction: [1, 2],
        directionTransition: TransitionOptions(duration: 10, delay: 5),
        intensity: 3,
        intensityTransition: TransitionOptions(duration: 100, delay: 50),
        shadowIntensity: 5,
        shadowIntensityTransition: TransitionOptions(duration: 1, delay: 3));
    await style.setLights(ambientLight, directionalLight);

    expect(
        (await style.getStyleLightProperty(
                "directional-light-id", "cast-shadows"))
            .value,
        true);
    expect(
        (await style.getStyleLightProperty("directional-light-id", "color"))
            .value,
        listCloseTo(Colors.blue.toRGBAList(), 0.0001));
    expect(
        (await style.getStyleLightProperty(
                "directional-light-id", "color-transition"))
            .value,
        directionalLight.colorTransition?.toJSON());
    expect(
        (await style.getStyleLightProperty("directional-light-id", "direction"))
            .value,
        [1, 2]);
    expect(
        (await style.getStyleLightProperty(
                "directional-light-id", "direction-transition"))
            .value,
        directionalLight.directionTransition?.toJSON());
    expect(
        (await style.getStyleLightProperty("directional-light-id", "intensity"))
            .value,
        3);
    expect(
        (await style.getStyleLightProperty(
                "directional-light-id", "intensity-transition"))
            .value,
        directionalLight.intensityTransition?.toJSON());
    expect(
        (await style.getStyleLightProperty(
                "directional-light-id", "shadow-intensity"))
            .value,
        5);
    expect(
        (await style.getStyleLightProperty(
                "directional-light-id", "shadow-intensity-transition"))
            .value,
        directionalLight.shadowIntensityTransition?.toJSON());

    expect(
        (await style.getStyleLightProperty("ambient-light-id", "color")).value,
        listCloseTo(Colors.blue.toRGBAList(), 0.0001));
    expect(
        (await style.getStyleLightProperty(
                "ambient-light-id", "color-transition"))
            .value,
        ambientLight.colorTransition?.toJSON());
    expect(
        (await style.getStyleLightProperty("ambient-light-id", "intensity"))
            .value,
        3);
    expect(
        (await style.getStyleLightProperty(
                "ambient-light-id", "intensity-transition"))
            .value,
        ambientLight.intensityTransition?.toJSON());
  });

  testWidgets('StyleTerrain', (WidgetTester tester) async {
    final mapFuture = app.main();
    await tester.pumpAndSettle();
    final mapboxMap = await mapFuture;
    var style = mapboxMap.style;
    var terrain = {'source': 'mapbox-raster-dem', 'exaggeration': 2};
    await style.setStyleTerrain(json.encode(terrain));

    var source = await style.getStyleTerrainProperty('source');
    expect(source.value, "mapbox-raster-dem");

    var exaggeration = await style.getStyleTerrainProperty('exaggeration');
    expect(exaggeration.value, 2);

    await style.setStyleTerrainProperty('exaggeration', 3);
    exaggeration = await style.getStyleTerrainProperty('exaggeration');
    expect(exaggeration.value, 3);
  });

  testWidgets('invalidateStyleCustomGeometrySourceTile',
      (WidgetTester tester) async {
    final mapFuture = app.main();
    await tester.pumpAndSettle();
    final mapboxMap = await mapFuture;
    var style = mapboxMap.style;
    var source = await rootBundle.loadString('assets/source.json');
    style.addStyleSource('source', source);
    await style.invalidateStyleCustomGeometrySourceTile(
        'source', CanonicalTileID(z: 0, x: 1, y: 2));
  });

  testWidgets('invalidateStyleCustomGeometrySourceRegion',
      (WidgetTester tester) async {
    final mapFuture = app.main();
    await tester.pumpAndSettle();
    final mapboxMap = await mapFuture;
    var style = mapboxMap.style;
    var source = await rootBundle.loadString('assets/source.json');
    style.addStyleSource('source', source);
    await style.invalidateStyleCustomGeometrySourceRegion(
        'source',
        CoordinateBounds(
            southwest: Point(
                coordinates: Position(
              1.0,
              2.0,
            )),
            northeast: Point(
                coordinates: Position(
              3.0,
              4.0,
            )),
            infiniteBounds: true));
  });

  testWidgets('handleImage', (WidgetTester tester) async {
    final mapFuture = app.main();
    await tester.pumpAndSettle();
    final mapboxMap = await mapFuture;
    var style = mapboxMap.style;
    var getImage = await style.getStyleImage('icon');
    expect(getImage, isNull);

    final ByteData bytes =
        await rootBundle.load('assets/symbols/custom-icon.png');
    final Uint8List list = bytes.buffer.asUint8List();
    await style.addStyleImage('icon', 1.0,
        MbxImage(width: 40, height: 40, data: list), true, [], [], null);

    getImage = await style.getStyleImage('icon');
    expect(getImage, isNotNull);
    expect(getImage!.width, 40);
    expect(getImage.height, 40);

    await style.removeStyleImage('icon');

    getImage = await style.getStyleImage('icon');
    expect(getImage, isNull);
  });

  testWidgets('MapProjection', (WidgetTester tester) async {
    final mapFuture = app.main();
    await tester.pumpAndSettle();
    final mapboxMap = await mapFuture;

    await app.events.onMapLoaded.future;

    await mapboxMap.style.setProjection(
      StyleProjection(name: StyleProjectionName.mercator),
    );
    var projection = await mapboxMap.style.getProjection();
    expect(projection?.name, StyleProjectionName.mercator);
  });
}

extension ToJSON on TransitionOptions {
  Map<String, dynamic> toJSON() {
    return {'duration': duration, 'delay': delay};
  }
}

extension ToList on Color {
  List<dynamic> toRGBAList() {
    return ['rgba', red, green, blue, alpha / 255.0];
  }
}
