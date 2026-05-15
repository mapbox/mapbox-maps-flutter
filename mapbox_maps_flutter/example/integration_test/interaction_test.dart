import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

import 'empty_map_widget.dart' as app;

// Verifies the meta-package's `TapInteraction.onMap` sugar wires up against
// a live `MapboxMap` without throwing. Trigger semantics — the actual
// click → handler dispatch — are covered in the platform packages
// (`mapbox_maps_flutter_mobile/example` and `mapbox_maps_flutter_web/
// example`), since each platform needs its own click-synthesis hook.
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('TapInteraction.onMap can be added and removed', (
    WidgetTester tester,
  ) async {
    final mapFuture = app.main();
    await tester.pumpAndSettle();
    final mapboxMap = await mapFuture;

    const id = 'test-tap-interaction';
    mapboxMap.addInteraction(TapInteraction.onMap((_) {}), interactionID: id);
    mapboxMap.removeInteraction(id);
  });
}
