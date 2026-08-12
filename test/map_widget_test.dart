import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

void main() {
  group('MapWidget.isOpaque assert', () {
    test('throws when isOpaque:false and textureView:false', () {
      expect(
        () => MapWidget(isOpaque: false, textureView: false),
        throwsAssertionError,
      );
    });

    test('allows isOpaque:false with textureView:true', () {
      expect(
        () => MapWidget(isOpaque: false, textureView: true),
        returnsNormally,
      );
    });

    test('allows isOpaque:false with default textureView', () {
      expect(() => MapWidget(isOpaque: false), returnsNormally);
    });

    test('allows isOpaque:true with textureView:false', () {
      expect(
        () => MapWidget(isOpaque: true, textureView: false),
        returnsNormally,
      );
    });

    test('defaults to opaque', () {
      expect(MapWidget().isOpaque, isTrue);
    });
  });

  group('MapWidget platform-view creation timing', () {
    // Regression test: the platform-view-created callback used to read this
    // element's render-object size unguarded. That read throws instead of
    // returning null when the element is mounted but hasn't been through
    // layout yet, and because it happened inside an unawaited async
    // callback, the throw escaped every app-level try/catch as an unhandled
    // error. Reachable on iOS always, and on Android whenever
    // androidHostingMode is HC, since neither gates native-view creation on
    // layout completing first. HC isn't the Android default here (VD is),
    // but it's user-selectable and shares this widget's callback.
    testWidgets('does not crash when the platform view is '
        'created before this element has been laid out', (tester) async {
      final createStarted = Completer<void>();
      final releaseCreate = Completer<void>();

      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(SystemChannels.platform_views, (
            call,
          ) async {
            if (call.method == 'create' && !createStarted.isCompleted) {
              createStarted.complete();
              await releaseCreate.future;
            }
            return null;
          });
      addTearDown(
        () => TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
            .setMockMethodCallHandler(
              SystemChannels.platform_views,
              (call) async => null,
            ),
      );

      // No need to force defaultTargetPlatform: flutter_test always
      // reports TargetPlatform.android regardless of the host OS.
      //
      // Stops the pipeline right after the build phase, before layout, so
      // the MapWidget's element is mounted but not yet laid out.
      await tester.pumpWidget(
        const MaterialApp(
          home: MapWidget(
            androidHostingMode: AndroidPlatformViewHostingMode.HC,
          ),
        ),
        phase: EnginePhase.build,
      );

      // The native "create" round trip has started and is held open by our
      // mock handler.
      await createStarted.future;

      // Let it reply now, while this element still hasn't been laid out.
      releaseCreate.complete();
      await tester.idle();

      // A regression here surfaces as an uncaught exception that fails this
      // test, not as a normal assertion failure. Settling afterwards also
      // confirms the widget recovers normally once layout does run.
      await tester.pumpAndSettle();
    });
  });
}
