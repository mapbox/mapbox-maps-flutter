import 'package:flutter_test/flutter_test.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

void main() {
  late ViewportController controller;

  setUp(() {
    controller = ViewportController();
  });

  tearDown(() {
    controller.dispose();
  });

  group('initial state', () {
    test('state is null', () {
      expect(controller.state, isNull);
    });

    test('consumeTransition returns null', () {
      expect(controller.consumeTransition(), isNull);
    });

    test('consumeCompletion returns null', () {
      expect(controller.consumeCompletion(), isNull);
    });
  });

  group('moveTo', () {
    test('sets state', () {
      final viewport = CameraViewportState(zoom: 10);
      controller.moveTo(viewport);
      expect(controller.state, viewport);
    });

    test('notifies listeners', () {
      int callCount = 0;
      controller.addListener(() => callCount++);

      controller.moveTo(CameraViewportState(zoom: 10));
      expect(callCount, 1);

      controller.moveTo(CameraViewportState(zoom: 12));
      expect(callCount, 2);
    });

    test('sets transition', () {
      final transition = FlyViewportTransition(duration: Duration(seconds: 2));
      controller.moveTo(CameraViewportState(zoom: 10), transition: transition);
      expect(controller.consumeTransition(), transition);
    });

    test('uses DefaultViewportTransition by default', () {
      controller.moveTo(CameraViewportState(zoom: 10));
      expect(controller.consumeTransition(), isA<DefaultViewportTransition>());
    });

    test('allows null transition for instant jump', () {
      controller.moveTo(CameraViewportState(zoom: 10), transition: null);
      expect(controller.consumeTransition(), isNull);
    });
  });

  group('consumeTransition', () {
    test('returns transition once then null', () {
      final transition = FlyViewportTransition(duration: Duration(seconds: 1));
      controller.moveTo(CameraViewportState(zoom: 10), transition: transition);

      expect(controller.consumeTransition(), transition);
      expect(controller.consumeTransition(), isNull);
    });
  });

  group('consumeCompletion', () {
    test('returns wrapped completion that clears after firing', () {
      controller.moveTo(
        CameraViewportState(zoom: 10),
        completion: (_) {},
      );

      final wrapped = controller.consumeCompletion()!;
      wrapped(true);

      // After the wrapped completion fires, it clears the pending state
      expect(controller.consumeCompletion(), isNull);
    });

    test('wrapped completion calls original', () {
      bool? result;
      controller.moveTo(
        CameraViewportState(zoom: 10),
        completion: (r) => result = r,
      );

      final wrapped = controller.consumeCompletion()!;
      wrapped(true);
      expect(result, true);
    });

    test('wrapped completion clears pending state', () {
      controller.moveTo(
        CameraViewportState(zoom: 10),
        completion: (_) {},
      );

      final wrapped = controller.consumeCompletion()!;
      wrapped(true);

      // After completion fires, consumeCompletion should return null
      expect(controller.consumeCompletion(), isNull);
    });
  });

  group('cancellation', () {
    test('moveTo cancels previous completion with false', () {
      bool? firstResult;
      controller.moveTo(
        CameraViewportState(zoom: 10),
        completion: (r) => firstResult = r,
      );

      controller.moveTo(
        CameraViewportState(zoom: 12),
        completion: (_) {},
      );

      expect(firstResult, false);
    });

    test('completed animation is not cancelled by next moveTo', () {
      final results = <bool>[];
      controller.moveTo(
        CameraViewportState(zoom: 10),
        completion: (r) => results.add(r),
      );

      // Simulate: MapWidget consumes and platform fires completion
      final wrapped = controller.consumeCompletion()!;
      wrapped(true);

      // Next moveTo should not re-cancel the already-completed one
      controller.moveTo(
        CameraViewportState(zoom: 12),
        completion: (_) {},
      );

      // First completion was called exactly once with true
      expect(results, [true]);
    });

    test('unconsumed completion is cancelled by next moveTo', () {
      final results = <bool>[];
      controller.moveTo(
        CameraViewportState(zoom: 10),
        completion: (r) => results.add(r),
      );

      // Don't consume — simulates moveTo called before build
      controller.moveTo(
        CameraViewportState(zoom: 12),
        completion: (_) {},
      );

      expect(results, [false]);
    });
  });

  group('state updates', () {
    test('each moveTo updates state', () {
      final first = CameraViewportState(zoom: 5);
      final second = OverviewViewportState(
        geometry: Point(coordinates: Position(0, 0)),
      );

      controller.moveTo(first);
      expect(controller.state, first);

      controller.moveTo(second);
      expect(controller.state, second);
    });

    test('state persists after transition is consumed', () {
      final viewport = CameraViewportState(zoom: 10);
      controller.moveTo(viewport);

      controller.consumeTransition();
      controller.consumeCompletion();

      expect(controller.state, viewport);
    });
  });
}
