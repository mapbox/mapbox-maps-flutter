import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';


void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('all map lifecycle events are received during map load',
      (WidgetTester tester) async {
    final onStyleLoaded = Completer<void>();
    final onMapLoaded = Completer<void>();
    final onMapIdle = Completer<void>();
    final onStyleDataLoaded = Completer<void>();
    // TODO: remove force complete once onSourceDataLoaded event is supported
    final onSourceDataLoaded = Completer<void>()..complete();
    // TODO: remove force complete once onSourceAdded event is supported
    final onSourceAdded = Completer<void>()..complete();
    final onCameraChanged = Completer<void>();
    final onRenderFrameStarted = Completer<void>();
    final onRenderFrameFinished = Completer<void>();
    final onResourceRequest = Completer<void>();

    runApp(MaterialApp(
      home: MapWidget(
        onStyleLoadedListener: (_) {
          if (!onStyleLoaded.isCompleted) onStyleLoaded.complete();
        },
        onMapLoadedListener: (_) {
          if (!onMapLoaded.isCompleted) onMapLoaded.complete();
        },
        onMapIdleListener: (_) {
          if (!onMapIdle.isCompleted) onMapIdle.complete();
        },
        onStyleDataLoadedListener: (_) {
          if (!onStyleDataLoaded.isCompleted) onStyleDataLoaded.complete();
        },
        onSourceDataLoadedListener: (_) {
          if (!onSourceDataLoaded.isCompleted) onSourceDataLoaded.complete();
        },
        onSourceAddedListener: (_) {
          if (!onSourceAdded.isCompleted) onSourceAdded.complete();
        },
        onCameraChangeListener: (_) {
          if (!onCameraChanged.isCompleted) onCameraChanged.complete();
        },
        onRenderFrameStartedListener: (_) {
          if (!onRenderFrameStarted.isCompleted) {
            onRenderFrameStarted.complete();
          }
        },
        onRenderFrameFinishedListener: (_) {
          if (!onRenderFrameFinished.isCompleted) {
            onRenderFrameFinished.complete();
          }
        },
        onResourceRequestListener: (_) {
          if (!onResourceRequest.isCompleted) onResourceRequest.complete();
        },
      ),
    ));
    await tester.pumpAndSettle();

    await Future.wait([
      onStyleLoaded.future,
      onMapLoaded.future,
      onMapIdle.future,
      onStyleDataLoaded.future,
      onSourceDataLoaded.future,
      onSourceAdded.future,
      onCameraChanged.future,
      onRenderFrameStarted.future,
      onRenderFrameFinished.future,
      onResourceRequest.future,
    ]).timeout(Duration(seconds: 15));
  });
}
