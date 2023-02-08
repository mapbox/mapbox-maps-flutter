// This file is generated.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:mapbox_maps_example/empty_map_widget.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  Future<void> addDelay(int ms) async {
    await Future<void>.delayed(Duration(milliseconds: ms));
  }

  testWidgets('create CircleAnnotation_manager ', (WidgetTester tester) async {
    final mapFuture = app.main();
    await tester.pumpAndSettle();
    final mapboxMap = await mapFuture;
    final manager = await mapboxMap.annotations.createCircleAnnotationManager();
    await addDelay(1000);

    await manager.setCirclePitchAlignment(CirclePitchAlignment.MAP);
    var circlePitchAlignment = await manager.getCirclePitchAlignment();
    expect(CirclePitchAlignment.MAP, circlePitchAlignment);

    await manager.setCirclePitchScale(CirclePitchScale.MAP);
    var circlePitchScale = await manager.getCirclePitchScale();
    expect(CirclePitchScale.MAP, circlePitchScale);

    await manager.setCircleTranslate([0.0, 1.0]);
    var circleTranslate = await manager.getCircleTranslate();
    expect([0.0, 1.0], circleTranslate);

    await manager.setCircleTranslateAnchor(CircleTranslateAnchor.MAP);
    var circleTranslateAnchor = await manager.getCircleTranslateAnchor();
    expect(CircleTranslateAnchor.MAP, circleTranslateAnchor);
    await addDelay(1000);
  });
}
// End of generated file.
