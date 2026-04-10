import 'dart:async';
import 'dart:js_interop';

import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:mapbox_maps_flutter_platform_interface/mapbox_maps_flutter_platform_interface.dart';
import 'package:mapbox_maps_flutter_web/mapbox_maps_flutter_web.dart';
import 'package:turf/turf.dart' show Point, Polygon, Position;

import 'empty_map_widget.dart' as app;

/// Retrieves the [JSMap] from the widget tree and waits for it to be idle.
Future<JSMap> waitForMap(WidgetTester tester) async {
  await tester.pumpAndSettle();

  final state = tester.state(find.byType(MapWebWidget));
  final map = (state as dynamic).currentMap as JSMap?;
  if (map == null) fail('Map not created');

  final completer = Completer<void>();
  map.once('idle', (() => completer.complete()).toJS);
  await completer.future;

  return map;
}

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('CameraViewportState test', (WidgetTester tester) async {
    final cameraViewport = CameraViewportState(
      center: Point(coordinates: Position(5, 6)),
      zoom: 16.35,
      bearing: 8,
      pitch: 42,
    );
    app.main(viewport: cameraViewport);
    final map = await waitForMap(tester);
    final center = map.getCenter();

    expect(center.lng, moreOrLessEquals(5, epsilon: 0.01));
    expect(center.lat, moreOrLessEquals(6, epsilon: 0.01));
    expect(map.getZoom(), moreOrLessEquals(16.35, epsilon: 0.01));
    expect(map.getBearing(), moreOrLessEquals(8, epsilon: 0.01));
    expect(map.getPitch(), moreOrLessEquals(42, epsilon: 0.01));
  });

  testWidgets('OverviewViewportState test', (WidgetTester tester) async {
    final overviewViewport = OverviewViewportState(
      geometry: Polygon.fromPoints(
        points: [
          [
            Point(coordinates: Position(0, 0)),
            Point(coordinates: Position(0, 10)),
            Point(coordinates: Position(10, 10)),
            Point(coordinates: Position(10, 0)),
            Point(coordinates: Position(0, 0)),
          ],
        ],
      ),
      bearing: 30.0,
      pitch: 45.0,
    );
    app.main(viewport: overviewViewport);
    final map = await waitForMap(tester);
    final center = map.getCenter();

    expect(center.lng, moreOrLessEquals(5, epsilon: 0.5));
    expect(center.lat, moreOrLessEquals(5, epsilon: 0.5));
    expect(map.getBearing(), moreOrLessEquals(30, epsilon: 0.01));
    expect(map.getPitch(), moreOrLessEquals(45, epsilon: 0.01));
  });

  testWidgets('IdleViewportState test', (WidgetTester tester) async {
    app.main(viewport: IdleViewportState());
    final map = await waitForMap(tester);

    // Idle viewport is a no-op — map should use default camera.
    expect(map.getZoom(), moreOrLessEquals(0, epsilon: 0.01));
  });
}
