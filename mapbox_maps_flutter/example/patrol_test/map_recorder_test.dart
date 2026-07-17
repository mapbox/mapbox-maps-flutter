// MapRecorder is intentionally `@experimental`; this integration test
// exercises the API by design.
// ignore_for_file: experimental_member_use, invalid_use_of_visible_for_testing_member

import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'patrol.dart';

import 'empty_map_widget.dart' as app;

const ACCESS_TOKEN = String.fromEnvironment('ACCESS_TOKEN');

// MapRecorder is a native-only debug/replay tool; the web stub throws
// UnsupportedError. Skip the whole suite on web per WS2 handoff intent.
void main() {
  setUpAll(() => MapboxOptions.setAccessToken(ACCESS_TOKEN));
  if (kIsWeb) return;

  patrolTest('startRecording', ($) async {
    final tester = $.tester;
    final mapboxMap = await app.pumpMap(tester: $.tester);
    await tester.pumpAndSettle();

    await mapboxMap.recorder.startRecording(
      timeWindow: const Duration(seconds: 60),
      loggingEnabled: false,
      compressed: true,
    );

    await Future.delayed(const Duration(milliseconds: 100));

    await mapboxMap.setCamera(
      CameraOptions(
        center: Point(coordinates: Position(-74.0060, 40.7128)),
        zoom: 12.0,
      ),
    );
    await tester.pumpAndSettle();

    await Future.delayed(const Duration(milliseconds: 100));

    final sequence = await mapboxMap.recorder.stopRecording();

    expect(sequence, isNotNull);
    expect(sequence, isA<Uint8List>());
    expect(sequence.length, greaterThan(0));
  });

  patrolTest('getState', ($) async {
    final tester = $.tester;
    final mapboxMap = await app.pumpMap(tester: $.tester);
    await tester.pumpAndSettle();

    final state = await mapboxMap.recorder.getState();
    expect(state, 'stopped');
  });

  patrolTest('replay', ($) async {
    final tester = $.tester;
    final mapboxMap = await app.pumpMap(tester: $.tester);
    await tester.pumpAndSettle();

    await mapboxMap.recorder.startRecording(
      timeWindow: const Duration(seconds: 60),
      loggingEnabled: false,
      compressed: true,
    );

    await Future.delayed(const Duration(milliseconds: 100));

    await mapboxMap.setCamera(
      CameraOptions(
        center: Point(coordinates: Position(-73.581, 45.4588)),
        zoom: 10.0,
      ),
    );
    await tester.pumpAndSettle();

    await Future.delayed(const Duration(milliseconds: 100));

    final sequence = await mapboxMap.recorder.stopRecording();
    expect(sequence.length, greaterThan(0));

    await mapboxMap.recorder.replay(
      sequence,
      playbackCount: 1,
      playbackSpeedMultiplier: 1.0,
      avoidPlaybackPauses: false,
    );

    final stateAfterReplay = await mapboxMap.recorder.getState();
    expect(stateAfterReplay, 'stopped');
  });

  patrolTest('togglePause', ($) async {
    final tester = $.tester;
    final mapboxMap = await app.pumpMap(tester: $.tester);
    await tester.pumpAndSettle();

    await mapboxMap.recorder.startRecording(
      timeWindow: const Duration(seconds: 60),
      loggingEnabled: false,
      compressed: true,
    );

    await Future.delayed(const Duration(milliseconds: 100));

    for (int i = 0; i < 5; i++) {
      await mapboxMap.setCamera(
        CameraOptions(
          center: Point(
            coordinates: Position(-122.4194 + (i * 0.1), 37.7749 + (i * 0.05)),
          ),
          zoom: 11.0 + (i * 0.2),
        ),
      );
      await tester.pumpAndSettle();
      await Future.delayed(const Duration(milliseconds: 100));
    }

    final sequence = await mapboxMap.recorder.stopRecording();
    expect(sequence.length, greaterThan(0));

    final replayFuture = mapboxMap.recorder.replay(
      sequence,
      playbackCount: 3,
      playbackSpeedMultiplier: 0.3,
      avoidPlaybackPauses: false,
    );

    await Future.delayed(const Duration(milliseconds: 200));

    final playingState = await mapboxMap.recorder.getState();
    expect(playingState, 'playing');

    await mapboxMap.recorder.togglePause();

    await Future.delayed(const Duration(milliseconds: 50));

    final pausedState = await mapboxMap.recorder.getState();
    expect(pausedState, 'paused');

    await mapboxMap.recorder.togglePause();

    await Future.delayed(const Duration(milliseconds: 50));
    final resumedState = await mapboxMap.recorder.getState();
    expect(resumedState, 'playing');

    await replayFuture;

    final finalState = await mapboxMap.recorder.getState();
    expect(finalState, 'stopped');
  });

  patrolTest('recordingWithOptions', ($) async {
    final tester = $.tester;
    final mapboxMap = await app.pumpMap(tester: $.tester);
    await tester.pumpAndSettle();

    await mapboxMap.recorder.startRecording(
      timeWindow: const Duration(seconds: 30),
      loggingEnabled: false,
      compressed: false,
    );

    await Future.delayed(const Duration(milliseconds: 100));

    await mapboxMap.setCamera(
      CameraOptions(center: Point(coordinates: Position(0.0, 0.0)), zoom: 5.0),
    );
    await tester.pumpAndSettle();

    await Future.delayed(const Duration(milliseconds: 100));

    final sequence = await mapboxMap.recorder.stopRecording();
    expect(sequence.length, greaterThan(0));

    await mapboxMap.recorder.replay(
      sequence,
      playbackCount: 1,
      playbackSpeedMultiplier: 2.0,
      avoidPlaybackPauses: true,
    );
  });
}
