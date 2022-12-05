import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:mapbox_maps_example/empty_map_widget.dart' as app;
import 'package:turf/helpers.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  Future<void> addDelay(int ms) async {
    await Future<void>.delayed(Duration(milliseconds: ms));
  }

  testWidgets('Style uri', (WidgetTester tester) async {
    final mapFuture = app.main();
    await tester.pumpAndSettle();
    final mapboxMap = await mapFuture;
    var style = mapboxMap.style;
    await expectLater(
        style.getStyleURI(), completion(MapboxStyles.MAPBOX_STREETS));
    style.setStyleURI(MapboxStyles.DARK);
    await expectLater(style.getStyleURI(), completion(MapboxStyles.DARK));
  });

  testWidgets('Style json', (WidgetTester tester) async {
    final mapFuture = app.main();
    await tester.pumpAndSettle();
    final mapboxMap = await mapFuture;
    var style = mapboxMap.style;
    var styleJson = await rootBundle.loadString('assets/style.json');
    style.setStyleJSON(styleJson);
    await expectLater(style.getStyleJSON(), completion(styleJson));
  });

  testWidgets('Style is loaded', (WidgetTester tester) async {
    final mapFuture = app.main();
    await tester.pumpAndSettle();
    final mapboxMap = await mapFuture;
    var style = mapboxMap.style;
    await addDelay(1000);
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
    expect(double.parse(radius.value), 20.0);
    var color = await style.getStyleLayerProperty('custom', 'circle-color');
    if (Platform.isIOS) {
      expect(
          color.value,
          '(\n'
          '    rgba,\n'
          '    255,\n'
          '    "51.00000381469727",\n'
          '    0,\n'
          '    1\n'
          ')');
    } else {
      expect(color.value, '[rgba, 255.0, 51.000003814697266, 0.0, 1.0]');
    }
    var styleLayerProperty =
        await style.getStyleLayerProperty('custom', 'circle-radius');
    expect(double.parse(styleLayerProperty.value), 20.0);
    await style.setStyleLayerProperty('custom', 'circle-radius', 1.0);
    await style.setStyleLayerProperty('custom', 'circle-color', 'red');

    radius = await style.getStyleLayerProperty('custom', 'circle-radius');
    expect(double.parse(radius.value), 1.0);
    color = await style.getStyleLayerProperty('custom', 'circle-color');
    if (Platform.isIOS) {
      expect(
          color.value,
          '(\n'
          '    rgba,\n'
          '    255,\n'
          '    0,\n'
          '    0,\n'
          '    1\n'
          ')');
    } else {
      expect(color.value, '[rgba, 255.0, 0.0, 0.0, 1.0]');
    }
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
    var formatedProperties =
        json.decode(styleLayerProperties) as Map<String, dynamic>;
    expect(formatedProperties['paint']['circle-radius'], 10);
    expect(formatedProperties['paint']['circle-color'],
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
    expect(styleSourceProperties.length, 2);
  });

  testWidgets('getStyleDefaultCamera', (WidgetTester tester) async {
    final mapFuture = app.main();
    await tester.pumpAndSettle();
    final mapboxMap = await mapFuture;
    var style = mapboxMap.style;

    var camera = await style.getStyleDefaultCamera();
    expect(camera.bearing, 0);
    expect(camera.pitch, 0);
    expect(camera.zoom, 3.0);
    expect(camera.anchor, null);
    var coordinates = camera.center!['coordinates'] as List;
    expect(coordinates.first, 0);
    expect(coordinates.last, 0);
  });

  testWidgets('StyleLightProperty', (WidgetTester tester) async {
    final mapFuture = app.main();
    await tester.pumpAndSettle();
    final mapboxMap = await mapFuture;
    var style = mapboxMap.style;
    await style.setStyleLightProperty('color', 'white');
    await style.setStyleLightProperty('intensity', 0.4);

    var intensity = await style.getStyleLightProperty('intensity');
    expect(intensity.value, isNotNull);
    expect(double.parse(intensity.value).toStringAsFixed(1), '0.4');

    var color = await style.getStyleLightProperty('color');
    if (Platform.isIOS) {
      expect(
          color.value,
          '(\n'
          '    rgba,\n'
          '    255,\n'
          '    255,\n'
          '    255,\n'
          '    1\n'
          ')');
    } else {
      expect(color.value, '[rgba, 255.0, 255.0, 255.0, 1.0]');
    }
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
    expect(double.parse(exaggeration.value), 2);

    await style.setStyleTerrainProperty('exaggeration', 3);
    exaggeration = await style.getStyleTerrainProperty('exaggeration');
    expect(double.parse(exaggeration.value), 3);
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
    await addDelay(1000);
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
            )).toJson(),
            northeast: Point(
                coordinates: Position(
              3.0,
              4.0,
            )).toJson(),
            infiniteBounds: true));
    await addDelay(1000);
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
    var projection = await mapboxMap.style.getProjection();
    expect(projection, "mercator");
    await mapboxMap.style.setProjection("globe");
    projection = await mapboxMap.style.getProjection();
    expect(projection, "globe");
    await addDelay(1000);
  });
}
