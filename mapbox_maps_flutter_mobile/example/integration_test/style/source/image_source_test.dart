// This file is generated.
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import '../../empty_map_widget.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Add ImageSource', (WidgetTester tester) async {
    final mapFuture = app.main();
    await tester.pumpAndSettle();
    final mapboxMap = await mapFuture;
    await app.events.onMapLoaded.future;

    await mapboxMap.style.addSource(ImageSource(
      id: "source",
      coordinates: [
        [0.0, 1.0],
        [0.0, 1.0],
        [0.0, 1.0],
        [0.0, 1.0]
      ],
      prefetchZoomDelta: 1.0,
    ));

    var source = await mapboxMap.style.getSource('source') as ImageSource;
    expect(source.id, 'source');
    var coordinates = await source.coordinates;
    expect(coordinates, [
      [0.0, 1.0],
      [0.0, 1.0],
      [0.0, 1.0],
      [0.0, 1.0]
    ]);

    var prefetchZoomDelta = await source.prefetchZoomDelta;
    expect(prefetchZoomDelta, 1.0);
  });
}
// End of generated file.
