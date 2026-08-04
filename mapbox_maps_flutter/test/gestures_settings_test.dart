import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

class MockGesturesSettingsPlatformInterface
    implements GesturesSettingsPlatformInterface {
  GesturesSettings? lastUpdatedSettings;
  GesturesSettings settingsToReturn = GesturesSettings();
  int getSettingsCallCount = 0;
  int updateSettingsCallCount = 0;

  final panController = StreamController<MapContentGestureContext>.broadcast();
  final zoomController = StreamController<MapContentGestureContext>.broadcast();
  final rotateController =
      StreamController<MapContentGestureContext>.broadcast();
  final pitchController =
      StreamController<MapContentGestureContext>.broadcast();
  final keyboardController =
      StreamController<MapKeyboardGestureContext>.broadcast();

  @override
  Stream<MapContentGestureContext> get panEvents => panController.stream;

  @override
  Stream<MapContentGestureContext> get zoomEvents => zoomController.stream;

  @override
  Stream<MapContentGestureContext> get rotateEvents => rotateController.stream;

  @override
  Stream<MapContentGestureContext> get pitchEvents => pitchController.stream;

  @override
  Stream<MapKeyboardGestureContext> get keyboardEvents =>
      keyboardController.stream;

  @override
  Future<GesturesSettings> getSettings() async {
    getSettingsCallCount++;
    return settingsToReturn;
  }

  @override
  Future<void> updateSettings(GesturesSettings settings) async {
    updateSettingsCallCount++;
    lastUpdatedSettings = settings;
  }
}

void main() {
  late MockGesturesSettingsPlatformInterface mockImpl;
  late GesturesSettingsManager gesturesSettings;

  setUp(() {
    mockImpl = MockGesturesSettingsPlatformInterface();
    gesturesSettings = GesturesSettingsManager(mockImpl);
  });

  group('GesturesSettingsManager', () {
    test('getSettings delegates to interface', () async {
      final expected = GesturesSettings(rotateEnabled: true);
      mockImpl.settingsToReturn = expected;

      final result = await gesturesSettings.getSettings();

      expect(result, same(expected));
      expect(mockImpl.getSettingsCallCount, 1);
    });

    test('updateSettings delegates to interface', () async {
      final settings = GesturesSettings(
        rotateEnabled: true,
        pinchToZoomEnabled: false,
      );

      await gesturesSettings.updateSettings(settings);

      expect(mockImpl.updateSettingsCallCount, 1);
      expect(mockImpl.lastUpdatedSettings, same(settings));
    });

    test('getSettings can be called multiple times', () async {
      await gesturesSettings.getSettings();
      await gesturesSettings.getSettings();

      expect(mockImpl.getSettingsCallCount, 2);
    });

    test('updateSettings passes all fields correctly', () async {
      final settings = GesturesSettings(
        rotateEnabled: true,
        pinchToZoomEnabled: false,
        scrollEnabled: true,
        pitchEnabled: false,
        doubleTapToZoomInEnabled: true,
        quickZoomEnabled: false,
      );

      await gesturesSettings.updateSettings(settings);

      final updated = mockImpl.lastUpdatedSettings!;
      expect(updated.rotateEnabled, true);
      expect(updated.pinchToZoomEnabled, false);
      expect(updated.scrollEnabled, true);
      expect(updated.pitchEnabled, false);
      expect(updated.doubleTapToZoomInEnabled, true);
      expect(updated.quickZoomEnabled, false);
    });

    MapContentGestureContext fakeContext() => MapContentGestureContext(
      touchPosition: ScreenCoordinate(x: 12, y: 34),
      point: Point(coordinates: Position(0.5, 0.6)),
      gestureState: GestureState.changed,
    );

    test('pan.gestureEvents forwards from interface.panEvents', () async {
      final pushed = fakeContext();
      final received = gesturesSettings.pan.gestureEvents.first;
      mockImpl.panController.add(pushed);
      expect(await received, same(pushed));
    });

    test('zoom.gestureEvents forwards from interface.zoomEvents', () async {
      final pushed = fakeContext();
      final received = gesturesSettings.zoom.gestureEvents.first;
      mockImpl.zoomController.add(pushed);
      expect(await received, same(pushed));
    });

    test('rotate.gestureEvents forwards from interface.rotateEvents', () async {
      final pushed = fakeContext();
      final received = gesturesSettings.rotate.gestureEvents.first;
      mockImpl.rotateController.add(pushed);
      expect(await received, same(pushed));
    });

    test('pitch.gestureEvents forwards from interface.pitchEvents', () async {
      final pushed = fakeContext();
      final received = gesturesSettings.pitch.gestureEvents.first;
      mockImpl.pitchController.add(pushed);
      expect(await received, same(pushed));
    });

    MapKeyboardGestureContext fakeKeyboardContext() =>
        MapKeyboardGestureContext(
          cameraState: CameraState(
            center: Point(coordinates: Position(0.5, 0.6)),
            padding: MbxEdgeInsets(top: 0, left: 0, bottom: 0, right: 0),
            zoom: 10,
            bearing: 0,
            pitch: 0,
          ),
          gestureState: GestureState.changed,
        );

    test(
      'keyboard.gestureEvents forwards from interface.keyboardEvents',
      () async {
        final pushed = fakeKeyboardContext();
        final received = gesturesSettings.keyboard.gestureEvents.first;
        mockImpl.keyboardController.add(pushed);
        expect(await received, same(pushed));
      },
    );
  });
}
