// This file is generated.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import '../../empty_map_widget.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Add ModelSource', (WidgetTester tester) async {
    final mapFuture = app.main();
    await tester.pumpAndSettle();
    final mapboxMap = await mapFuture;
    await app.events.onMapLoaded.future;

    await mapboxMap.style.addSource(ModelSource(
      id: "source",
      models: [
        ModelSourceModel(
          id: 'model-1',
          uri: 'https://example.com/model.glb',
          position: [10.0, 20.0],
          orientation: [1.0, 2.0, 3.0],
          nodeOverrideNames: ['node-1'],
          materialOverrideNames: ['material-1'],
          featureProperties: {'key': 'value'},
          nodeOverrides: [
            ModelNodeOverride(name: 'node-1', orientation: [4.0, 5.0, 6.0]),
          ],
          materialOverrides: [
            ModelMaterialOverride(
              name: 'material-1',
              modelColor: Colors.red.value,
              modelColorMixIntensity: 0.5,
              modelOpacity: 0.8,
              modelEmissiveStrength: 0.3,
            ),
          ],
        ),
      ],
    ));

    var source = await mapboxMap.style.getSource('source') as ModelSource;
    expect(source.id, 'source');
    var models = await source.models;
    expect(models?.length, 1);
    var model = models![0];
    expect(model.id, 'model-1');
    expect(model.uri, 'https://example.com/model.glb');
    expect(model.position, [10.0, 20.0]);
    expect(model.orientation, [1.0, 2.0, 3.0]);
    expect(model.nodeOverrideNames, ['node-1']);
    expect(model.materialOverrideNames, ['material-1']);
    expect(model.featureProperties, {'key': 'value'});
    expect(model.nodeOverrides?.length, 1);
    expect(model.nodeOverrides?[0].name, 'node-1');
    expect(model.nodeOverrides?[0].orientation, [4.0, 5.0, 6.0]);
    expect(model.materialOverrides?.length, 1);
    expect(model.materialOverrides?[0].name, 'material-1');
    expect(model.materialOverrides?[0].modelColor, Colors.red.value);
    // Overrides round-trip through a native 32-bit float, so allow for the
    // resulting loss of precision instead of asserting exact equality.
    expect(
        model.materialOverrides?[0].modelColorMixIntensity, closeTo(0.5, 1e-4));
    expect(model.materialOverrides?[0].modelOpacity, closeTo(0.8, 1e-4));
    expect(
        model.materialOverrides?[0].modelEmissiveStrength, closeTo(0.3, 1e-4));
  });

  testWidgets('Add batched ModelSource', (WidgetTester tester) async {
    final mapFuture = app.main();
    await tester.pumpAndSettle();
    final mapboxMap = await mapFuture;
    await app.events.onMapLoaded.future;

    await mapboxMap.style.addSource(ModelSource(
      id: "source",
      batched: true,
      maxzoom: 1.0,
      minzoom: 1.0,
      tiles: ["a", "b", "c"],
    ));

    var source = await mapboxMap.style.getSource('source') as ModelSource;
    expect(source.id, 'source');

    var maxzoom = await source.maxzoom;
    expect(maxzoom, 1.0);

    var minzoom = await source.minzoom;
    expect(minzoom, 1.0);

    var tiles = await source.tiles;
    expect(tiles, ["a", "b", "c"]);
  });
}
// End of generated file.
