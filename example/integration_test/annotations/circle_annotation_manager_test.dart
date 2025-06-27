// This file is generated.
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import '../empty_map_widget.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('CircleAnnotationManager custom id and position',
      (WidgetTester tester) async {
    final mapFuture = app.main();
    await tester.pumpAndSettle();
    final mapboxMap = await mapFuture;
    final dummyLayer = CircleLayer(id: "dummyLayer", sourceId: 'sourceId');
    await mapboxMap.style.addLayer(dummyLayer);
    final id = "CircleAnnotationManagerId";
    final manager = await mapboxMap.annotations
        .createCircleAnnotationManager(id: id, below: 'dummyLayer');

    expect(await mapboxMap.style.styleLayerExists(id), isTrue);
    expect(await mapboxMap.style.styleSourceExists(id), isTrue);
    expect(manager.id, id);
    final layers = await mapboxMap.style.getStyleLayers();
    expect(layers.first?.id, id);
    expect(layers.last?.id, dummyLayer.id);
  });

  testWidgets('create CircleAnnotation_manager ', (WidgetTester tester) async {
    final mapFuture = app.main();
    await tester.pumpAndSettle();
    final mapboxMap = await mapFuture;
    final manager = await mapboxMap.annotations.createCircleAnnotationManager();

    await manager.setCircleElevationReference(CircleElevationReference.NONE);
    var circleElevationReference = await manager.getCircleElevationReference();
    expect(CircleElevationReference.NONE, circleElevationReference);

    await manager.setCircleSortKey(1.0);
    var circleSortKey = await manager.getCircleSortKey();
    expect(1.0, circleSortKey);

    await manager.setCircleBlur(1.0);
    var circleBlur = await manager.getCircleBlur();
    expect(1.0, circleBlur);

    await manager.setCircleColor(Colors.red.value);
    var circleColor = await manager.getCircleColor();
    expect(Colors.red.value, circleColor);

    await manager.setCircleEmissiveStrength(1.0);
    var circleEmissiveStrength = await manager.getCircleEmissiveStrength();
    expect(1.0, circleEmissiveStrength);

    await manager.setCircleOpacity(1.0);
    var circleOpacity = await manager.getCircleOpacity();
    expect(1.0, circleOpacity);

    await manager.setCirclePitchAlignment(CirclePitchAlignment.MAP);
    var circlePitchAlignment = await manager.getCirclePitchAlignment();
    expect(CirclePitchAlignment.MAP, circlePitchAlignment);

    await manager.setCirclePitchScale(CirclePitchScale.MAP);
    var circlePitchScale = await manager.getCirclePitchScale();
    expect(CirclePitchScale.MAP, circlePitchScale);

    await manager.setCircleRadius(1.0);
    var circleRadius = await manager.getCircleRadius();
    expect(1.0, circleRadius);

    await manager.setCircleStrokeColor(Colors.red.value);
    var circleStrokeColor = await manager.getCircleStrokeColor();
    expect(Colors.red.value, circleStrokeColor);

    await manager.setCircleStrokeOpacity(1.0);
    var circleStrokeOpacity = await manager.getCircleStrokeOpacity();
    expect(1.0, circleStrokeOpacity);

    await manager.setCircleStrokeWidth(1.0);
    var circleStrokeWidth = await manager.getCircleStrokeWidth();
    expect(1.0, circleStrokeWidth);

    await manager.setCircleTranslate([0.0, 1.0]);
    var circleTranslate = await manager.getCircleTranslate();
    expect([0.0, 1.0], circleTranslate);

    await manager.setCircleTranslateAnchor(CircleTranslateAnchor.MAP);
    var circleTranslateAnchor = await manager.getCircleTranslateAnchor();
    expect(CircleTranslateAnchor.MAP, circleTranslateAnchor);
  });

  testWidgets('annotation tap events', (tester) async {
    final mapFuture = app.main();
    await tester.pumpAndSettle();

    final mapboxMap = await mapFuture;
    final manager = await mapboxMap.annotations.createCircleAnnotationManager();

    final geometry = Point(coordinates: Position(0, 0));

    final createdAnnotation = await manager.create(CircleAnnotationOptions(
      geometry: geometry,
    ));

    // Mock tap events
    final eventChannel = EventChannel(
        "dev.flutter.pigeon.mapbox_maps_flutter.AnnotationInteractions._annotationInteractionEvents.0/${manager.id}/tap",
        pigeonMethodCodec);
    IntegrationTestWidgetsFlutterBinding.instance.defaultBinaryMessenger
        .setMockStreamHandler(eventChannel,
            MockStreamHandler.inline(onListen: (arguments, events) {
      events.success(CircleAnnotationInteractionContext(
        annotation: createdAnnotation,
        gestureState: GestureState.ended,
      ));
      events.endOfStream();
    }));

    final onTap = Completer();
    manager.tapEvents(
      onTap: (annotation) {
        expect(annotation.id, equals(createdAnnotation.id));
        onTap.complete();
      },
    );

    await onTap.future;
    expect(onTap.isCompleted, isTrue);
  });

  testWidgets('annotation long press events', (tester) async {
    final mapFuture = app.main();
    await tester.pumpAndSettle();

    final mapboxMap = await mapFuture;
    final manager = await mapboxMap.annotations.createCircleAnnotationManager();

    final geometry = Point(coordinates: Position(0, 0));

    final createdAnnotation = await manager.create(CircleAnnotationOptions(
      geometry: geometry,
    ));

    // Mock long press events
    final eventChannel = EventChannel(
        "dev.flutter.pigeon.mapbox_maps_flutter.AnnotationInteractions._annotationInteractionEvents.0/${manager.id}/long_press",
        pigeonMethodCodec);
    IntegrationTestWidgetsFlutterBinding.instance.defaultBinaryMessenger
        .setMockStreamHandler(eventChannel,
            MockStreamHandler.inline(onListen: (arguments, events) {
      events.success(CircleAnnotationInteractionContext(
        annotation: createdAnnotation,
        gestureState: GestureState.ended,
      ));
      events.endOfStream();
    }));

    final onLongPress = Completer();
    manager.longPressEvents(
      onLongPress: (annotation) {
        expect(annotation.id, equals(createdAnnotation.id));
        onLongPress.complete();
      },
    );

    await onLongPress.future;
    expect(onLongPress.isCompleted, isTrue);
  });

  testWidgets('annotation drag events', (WidgetTester tester) async {
    final mapFuture = app.main();
    await tester.pumpAndSettle();

    final mapboxMap = await mapFuture;
    final manager = await mapboxMap.annotations.createCircleAnnotationManager();

    final geometry = Point(coordinates: Position(0, 0));

    final createdAnnotation = await manager.create(CircleAnnotationOptions(
      geometry: geometry,
      isDraggable: true,
    ));

    // Mock drag events
    final eventChannel = EventChannel(
        "dev.flutter.pigeon.mapbox_maps_flutter.AnnotationInteractions._annotationInteractionEvents.0/${manager.id}/drag",
        pigeonMethodCodec);
    IntegrationTestWidgetsFlutterBinding.instance.defaultBinaryMessenger
        .setMockStreamHandler(eventChannel,
            MockStreamHandler.inline(onListen: (arguments, events) {
      events.success(CircleAnnotationInteractionContext(
        annotation: createdAnnotation,
        gestureState: GestureState.started,
      ));
      events.success(CircleAnnotationInteractionContext(
        annotation: createdAnnotation,
        gestureState: GestureState.changed,
      ));
      events.success(CircleAnnotationInteractionContext(
        annotation: createdAnnotation,
        gestureState: GestureState.ended,
      ));
      events.endOfStream();
    }));

    final onDragBegin = Completer();
    final onDragChanged = Completer();
    final onDragEnd = Completer();

    manager.dragEvents(
      onBegin: (annotation) {
        expect(annotation.id, equals(createdAnnotation.id));
        onDragBegin.complete();
      },
      onChanged: (annotation) {
        expect(annotation.id, equals(createdAnnotation.id));
        onDragChanged.complete();
      },
      onEnd: (annotation) {
        expect(annotation.id, equals(createdAnnotation.id));
        onDragEnd.complete();
      },
    );

    await Future.wait(
        [onDragBegin.future, onDragChanged.future, onDragEnd.future]);
  });
}
// End of generated file.
