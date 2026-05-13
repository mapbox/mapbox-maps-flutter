import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:mapbox_maps_flutter_platform_interface/mapbox_maps_flutter_platform_interface.dart';
import 'package:turf/turf.dart' show Point, Position;
import 'package:web/web.dart' as web;

import 'empty_map_widget.dart' as app;
import 'viewport_test.dart' show waitForMap;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('TapInteraction.onMap fires on map click', (
    WidgetTester tester,
  ) async {
    MapboxMapPlatformInterface? controller;
    app.main(
      viewport: CameraViewportState(
        center: Point(coordinates: Position(0, 0)),
        zoom: 5,
      ),
      onMapCreated: (c) => controller = c,
    );
    await waitForMap(tester);
    expect(controller, isNotNull, reason: 'onMapCreated should have fired');

    final completer = Completer<MapContentGestureContext>();
    controller!.addInteraction(
      TypedInteraction<TypedFeaturesetFeature<FeaturesetDescriptor>>(
        interactionType: InteractionType.tap,
        featureFactory: TypedFeaturesetFeature.fromFeaturesetFeature,
        action: (feature, context) {
          // onMap interactions are targetless — feature is null.
          expect(feature, isNull);
          if (!completer.isCompleted) completer.complete(context);
        },
      ),
    );

    // Real DOM click on the GL JS canvas container — exercises the full
    // pipeline (DOM event → MapEventHandler.click → map.fire('click') →
    // InteractionSet → our handler).
    final canvas = web.document.querySelector('.mapboxgl-canvas-container');
    expect(canvas, isNotNull, reason: 'canvas container should be in the DOM');
    final rect = canvas!.getBoundingClientRect();
    final eventInit = web.MouseEventInit(
      clientX: (rect.left + rect.width / 2).round(),
      clientY: (rect.top + rect.height / 2).round(),
      bubbles: true,
      cancelable: true,
    );
    canvas.dispatchEvent(web.MouseEvent('click', eventInit));

    final context = await completer.future.timeout(const Duration(seconds: 3));
    expect(context.gestureState, GestureState.ended);
  });
}
