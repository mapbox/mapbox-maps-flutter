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

  testWidgets('PolygonAnnotationManager custom id and position',
      (WidgetTester tester) async {
    final mapFuture = app.main();
    await tester.pumpAndSettle();
    final mapboxMap = await mapFuture;
    final dummyLayer = FillLayer(id: "dummyLayer", sourceId: 'sourceId');
    await mapboxMap.style.addLayer(dummyLayer);
    final id = "PolygonAnnotationManagerId";
    final manager = await mapboxMap.annotations
        .createPolygonAnnotationManager(id: id, below: 'dummyLayer');

    expect(await mapboxMap.style.styleLayerExists(id), isTrue);
    expect(await mapboxMap.style.styleSourceExists(id), isTrue);
    expect(manager.id, id);
    final layers = await mapboxMap.style.getStyleLayers();
    expect(layers.first?.id, id);
    expect(layers.last?.id, dummyLayer.id);

    // Print memory usage after test
    await app
        .printMemoryUsage('PolygonAnnotationManager custom id and position');
  });

  testWidgets('create PolygonAnnotation_manager ', (WidgetTester tester) async {
    final mapFuture = app.main();
    await tester.pumpAndSettle();
    final mapboxMap = await mapFuture;
    final manager =
        await mapboxMap.annotations.createPolygonAnnotationManager();

    await manager.setFillConstructBridgeGuardRail(true);
    var fillConstructBridgeGuardRail =
        await manager.getFillConstructBridgeGuardRail();
    expect(true, fillConstructBridgeGuardRail);

    await manager.setFillElevationReference(FillElevationReference.NONE);
    var fillElevationReference = await manager.getFillElevationReference();
    expect(FillElevationReference.NONE, fillElevationReference);

    await manager.setFillSortKey(1.0);
    var fillSortKey = await manager.getFillSortKey();
    expect(1.0, fillSortKey);

    await manager.setFillAntialias(true);
    var fillAntialias = await manager.getFillAntialias();
    expect(true, fillAntialias);

    await manager.setFillBridgeGuardRailColor(Colors.red.value);
    var fillBridgeGuardRailColor = await manager.getFillBridgeGuardRailColor();
    expect(Colors.red.value, fillBridgeGuardRailColor);

    await manager.setFillColor(Colors.red.value);
    var fillColor = await manager.getFillColor();
    expect(Colors.red.value, fillColor);

    await manager.setFillEmissiveStrength(1.0);
    var fillEmissiveStrength = await manager.getFillEmissiveStrength();
    expect(1.0, fillEmissiveStrength);

    await manager.setFillOpacity(1.0);
    var fillOpacity = await manager.getFillOpacity();
    expect(1.0, fillOpacity);

    await manager.setFillOutlineColor(Colors.red.value);
    var fillOutlineColor = await manager.getFillOutlineColor();
    expect(Colors.red.value, fillOutlineColor);

    await manager.setFillPattern("abc");
    var fillPattern = await manager.getFillPattern();
    expect("abc", fillPattern);

    await manager.setFillTranslate([0.0, 1.0]);
    var fillTranslate = await manager.getFillTranslate();
    expect([0.0, 1.0], fillTranslate);

    await manager.setFillTranslateAnchor(FillTranslateAnchor.MAP);
    var fillTranslateAnchor = await manager.getFillTranslateAnchor();
    expect(FillTranslateAnchor.MAP, fillTranslateAnchor);

    await manager.setFillTunnelStructureColor(Colors.red.value);
    var fillTunnelStructureColor = await manager.getFillTunnelStructureColor();
    expect(Colors.red.value, fillTunnelStructureColor);

    await manager.setFillZOffset(1.0);
    var fillZOffset = await manager.getFillZOffset();
    expect(1.0, fillZOffset);

    // Print memory usage after test
    await app.printMemoryUsage('create PolygonAnnotation_manager ');
  });

  group('annotation events', () {
    late MapboxMap mapboxMap;
    late PolygonAnnotationManager manager;
    late PolygonAnnotation createdAnnotation;
    late EventChannel eventChannel;

    Future<void> setupMap(
        WidgetTester tester, String eventChannelSuffix) async {
      final mapFuture = app.main();
      await Future.delayed(
          Duration(milliseconds: 100)); // Ensure app.main() is started
      await tester.pumpAndSettle();
      mapboxMap = await mapFuture;
      manager = await mapboxMap.annotations.createPolygonAnnotationManager();

      final geometry = Polygon(coordinates: [
        [
          Position(0, 0),
          Position(1.754703, -19.716317),
          Position(-15.747196, -21.085074),
          Position(-3.363937, -10.733102)
        ]
      ]);

      createdAnnotation = await manager.create(PolygonAnnotationOptions(
        geometry: geometry,
        isDraggable: true,
      ));

      eventChannel = EventChannel(
        "dev.flutter.pigeon.mapbox_maps_flutter.AnnotationInteractions._annotationInteractionEvents.0/${manager.id}/${eventChannelSuffix}",
        pigeonMethodCodec,
      );
    }

    testWidgets('annotation tap events can be listened and canceled',
        (tester) async {
      // Test tap event can be listened
      await setupMap(tester, 'tap');

      final tapCompleter = Completer();
      late MockStreamHandlerEventSink eventSink;
      var isCanceled = false;

      IntegrationTestWidgetsFlutterBinding.instance.defaultBinaryMessenger
          .setMockStreamHandler(
              eventChannel,
              MockStreamHandler.inline(
                onListen: (arguments, events) {
                  eventSink = events;
                },
                onCancel: (arguments) {
                  isCanceled = true;
                },
              ));

      final token = manager.tapEvents(
        onTap: (annotation) {
          if (isCanceled) {
            fail('This test should be canceled and not called.');
          } else {
            expect(annotation.id, equals(createdAnnotation.id));
            tapCompleter.complete();
          }
        },
      );

      eventSink.success(PolygonAnnotationInteractionContext(
        annotation: createdAnnotation,
        gestureState: GestureState.ended,
      ));

      await tapCompleter.future;
      expect(tapCompleter.isCompleted, isTrue);
      expect(isCanceled, isFalse);

      token.cancel();
      eventSink.success(PolygonAnnotationInteractionContext(
        annotation: createdAnnotation,
        gestureState: GestureState.ended,
      ));
      expect(isCanceled, isTrue);

      eventSink.endOfStream();
    });

    testWidgets('annotation long press events can be listened and canceled',
        (tester) async {
      await setupMap(tester, 'long_press');

      final longPressCompleter = Completer();
      late MockStreamHandlerEventSink eventSink;
      var isCanceled = false;

      IntegrationTestWidgetsFlutterBinding.instance.defaultBinaryMessenger
          .setMockStreamHandler(
              eventChannel,
              MockStreamHandler.inline(
                onListen: (arguments, events) {
                  eventSink = events;
                },
                onCancel: (arguments) {
                  isCanceled = true;
                },
              ));

      final token = manager.longPressEvents(
        onLongPress: (annotation) {
          if (isCanceled) {
            fail('This test should be canceled and not called.');
          } else {
            expect(annotation.id, equals(createdAnnotation.id));
            longPressCompleter.complete();
          }
        },
      );

      eventSink.success(PolygonAnnotationInteractionContext(
        annotation: createdAnnotation,
        gestureState: GestureState.ended,
      ));

      await longPressCompleter.future;
      expect(longPressCompleter.isCompleted, isTrue);
      expect(isCanceled, isFalse);

      token.cancel();
      eventSink.success(PolygonAnnotationInteractionContext(
        annotation: createdAnnotation,
        gestureState: GestureState.ended,
      ));
      expect(isCanceled, isTrue);

      eventSink.endOfStream();
    });

    testWidgets('annotation drag events can be listened and canceled',
        (tester) async {
      await setupMap(tester, 'drag');

      final dragBegin = Completer();
      final dragChanged = Completer();
      final dragEnd = Completer();
      late MockStreamHandlerEventSink eventSink;
      var isCanceled = false;

      IntegrationTestWidgetsFlutterBinding.instance.defaultBinaryMessenger
          .setMockStreamHandler(
              eventChannel,
              MockStreamHandler.inline(
                onListen: (arguments, events) {
                  eventSink = events;
                },
                onCancel: (arguments) {
                  isCanceled = true;
                },
              ));

      final token = manager.dragEvents(
        onBegin: (annotation) {
          if (isCanceled) {
            fail('This test should be canceled and not called.');
          } else {
            expect(annotation.id, equals(createdAnnotation.id));
            dragBegin.complete();
          }
        },
        onChanged: (annotation) {
          if (isCanceled) {
            fail('This test should be canceled and not called.');
          } else {
            expect(annotation.id, equals(createdAnnotation.id));
            dragChanged.complete();
          }
        },
        onEnd: (annotation) {
          if (isCanceled) {
            fail('This test should be canceled and not called.');
          } else {
            expect(annotation.id, equals(createdAnnotation.id));
            dragEnd.complete();
          }
        },
      );

      eventSink.success(PolygonAnnotationInteractionContext(
        annotation: createdAnnotation,
        gestureState: GestureState.started,
      ));
      eventSink.success(PolygonAnnotationInteractionContext(
        annotation: createdAnnotation,
        gestureState: GestureState.changed,
      ));
      eventSink.success(PolygonAnnotationInteractionContext(
        annotation: createdAnnotation,
        gestureState: GestureState.ended,
      ));

      await Future.wait([dragBegin.future, dragChanged.future, dragEnd.future]);
      expect(
          [dragBegin.isCompleted, dragChanged.isCompleted, dragEnd.isCompleted],
          everyElement(isTrue));
      expect(isCanceled, isFalse);

      token.cancel();
      eventSink.success(PolygonAnnotationInteractionContext(
        annotation: createdAnnotation,
        gestureState: GestureState.started,
      ));
      eventSink.success(PolygonAnnotationInteractionContext(
        annotation: createdAnnotation,
        gestureState: GestureState.changed,
      ));
      eventSink.success(PolygonAnnotationInteractionContext(
        annotation: createdAnnotation,
        gestureState: GestureState.ended,
      ));
      expect(isCanceled, isTrue);

      eventSink.endOfStream();
    });
  });
}
// End of generated file.
