// This file is generated.
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import '../../empty_map_widget.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Add RasterArraySource', (WidgetTester tester) async {
    final mapFuture = app.main();
    await tester.pumpAndSettle();
    final mapboxMap = await mapFuture;
    await app.events.onMapLoaded.future;

    await mapboxMap.style.addSource(RasterArraySource(
      id: "source",
      tiles: ["a", "b", "c"],
      bounds: [0.0, 1.0, 2.0, 3.0],
      minzoom: 1.0,
      maxzoom: 1.0,
      tileSize: 1.0,
      attribution: "abc",
      tileCacheBudget:
          TileCacheBudget.inMegabytes(TileCacheBudgetInMegabytes(size: 3)),
    ));

    var source = await mapboxMap.style.getSource('source') as RasterArraySource;
    expect(source.id, 'source');
    var tiles = await source.tiles;
    expect(tiles, ["a", "b", "c"]);

    var bounds = await source.bounds;
    expect(bounds, [0.0, 1.0, 2.0, 3.0]);

    var minzoom = await source.minzoom;
    expect(minzoom, 1.0);

    var maxzoom = await source.maxzoom;
    expect(maxzoom, 1.0);

    var tileSize = await source.tileSize;
    expect(tileSize, 1.0);

    var attribution = await source.attribution;
    expect(attribution, "abc");

    var tileCacheBudget = await source.tileCacheBudget;
    expect(tileCacheBudget?.size,
        TileCacheBudget.inMegabytes(TileCacheBudgetInMegabytes(size: 3)).size);
    expect(tileCacheBudget?.type,
        TileCacheBudget.inMegabytes(TileCacheBudgetInMegabytes(size: 3)).type);
  });
}
// End of generated file.
