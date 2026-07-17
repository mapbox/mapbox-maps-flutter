// ignore_for_file: experimental_member_use, invalid_use_of_visible_for_testing_member
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'patrol.dart';

import 'empty_map_widget.dart' show CompleterExpect;

const ACCESS_TOKEN = String.fromEnvironment('ACCESS_TOKEN');

void main() {
  setUpAll(() => MapboxOptions.setAccessToken(ACCESS_TOKEN));

  patrolTest('all map lifecycle events are received during map load', (
    $,
  ) async {
    final tester = $.tester;

    // This test builds its own MapWidget (rather than going through
    // `app.pumpMap()`), so unmount it after the test. Patrol does not reset the
    // widget tree between tests; a lingering map stalls the between-test
    // handoff on CI's software-WebGL runner. See
    // integration_test/empty_map_widget.dart.
    addTearDown(() async {
      await tester.pumpWidget(const MaterialApp());
      await Future<void>.delayed(const Duration(milliseconds: 100));
    });

    final mapCreated = Completer<void>();

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
    // TODO: remove force complete once onResourceRequest event is supported
    final onResourceRequest = Completer<void>()..complete();

    // Events will complete normally if onMapCreated has already fired;
    // otherwise they complete with an error naming the event that jumped ahead.
    await tester.pumpWidget(
      MaterialApp(
        home: MapWidget(
          onMapCreated: (_) {
            mapCreated.completeOnce();
          },
          onStyleLoadedListener: (_) => onStyleLoaded.completeWhen(
            mapCreated.isCompleted,
            'styleLoaded should not fire before mapCreated',
          ),
          onMapLoadedListener: (_) => onMapLoaded.completeWhen(
            mapCreated.isCompleted,
            'mapLoaded should not fire before mapCreated',
          ),
          onMapIdleListener: (_) => onMapIdle.completeWhen(
            mapCreated.isCompleted,
            'mapIdle should not fire before mapCreated',
          ),
          onStyleDataLoadedListener: (_) => onStyleDataLoaded.completeWhen(
            mapCreated.isCompleted,
            'styleDataLoaded should not fire before mapCreated',
          ),
          onSourceDataLoadedListener: (_) => onSourceDataLoaded.completeWhen(
            mapCreated.isCompleted,
            'sourceDataLoaded should not fire before mapCreated',
          ),
          onSourceAddedListener: (_) => onSourceAdded.completeWhen(
            mapCreated.isCompleted,
            'sourceAdded should not fire before mapCreated',
          ),
          onCameraChangeListener: (_) => onCameraChanged.completeWhen(
            mapCreated.isCompleted,
            'cameraChanged should not fire before mapCreated',
          ),
          onRenderFrameStartedListener: (_) =>
              onRenderFrameStarted.completeWhen(
                mapCreated.isCompleted,
                'renderFrameStarted should not fire before mapCreated',
              ),
          onRenderFrameFinishedListener: (_) =>
              onRenderFrameFinished.completeWhen(
                mapCreated.isCompleted,
                'renderFrameFinished should not fire before mapCreated',
              ),
          onResourceRequestListener: (_) => onResourceRequest.completeWhen(
            mapCreated.isCompleted,
            'resourceRequest should not fire before mapCreated',
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    final events = <String, Completer<void>>{
      'mapCreated': mapCreated,
      'styleLoaded': onStyleLoaded,
      'mapLoaded': onMapLoaded,
      'mapIdle': onMapIdle,
      'styleDataLoaded': onStyleDataLoaded,
      'sourceDataLoaded': onSourceDataLoaded,
      'sourceAdded': onSourceAdded,
      'cameraChanged': onCameraChanged,
      'renderFrameStarted': onRenderFrameStarted,
      'renderFrameFinished': onRenderFrameFinished,
      'resourceRequest': onResourceRequest,
    };

    // 20s rather than ~1s for a healthy load: headless CI renders with
    // software WebGL, so idle/load can lag under runner load.
    try {
      await Future.wait(
        events.values.map((c) => c.future),
      ).timeout(const Duration(seconds: 20));
    } on TimeoutException {
      final missing = events.entries
          .where((entry) => !entry.value.isCompleted)
          .map((entry) => entry.key)
          .toList();
      fail('Timed out waiting for map lifecycle events: $missing');
    }
  });
}
