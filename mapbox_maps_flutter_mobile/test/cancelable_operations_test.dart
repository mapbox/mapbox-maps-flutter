import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mapbox_maps_flutter_mobile/mapbox_maps_flutter_mobile.dart';

void main() {
  late List<int> hostCancels;
  late CancelableOperations operations;

  setUp(() {
    hostCancels = [];
    operations = CancelableOperations((operationId) async {
      hostCancels.add(operationId);
    });
  });

  Matcher isCanceledError() => isA<PlatformException>().having(
    (error) => error.code,
    'code',
    'CANCELED',
  );

  test('each operation gets its own id', () async {
    final ids = <int>[];
    await operations.start(run: (id) async => ids.add(id));
    await operations.start(run: (id) async => ids.add(id));

    expect(ids, hasLength(2));
    expect(ids[0], isNot(ids[1]));
  });

  test('cancel of a running operation reaches the host once', () async {
    final host = Completer<int>();
    int? runningId;
    final future = operations.start(
      run: (id) {
        runningId = id;
        return host.future;
      },
    );
    await pumpEventQueue();

    future.cancel();
    future.cancel();
    await pumpEventQueue();

    expect(hostCancels, [runningId]);
    host.complete(1);
    expect(await future, 1);
  });

  test('cancel before start fails with CANCELED and skips the host', () async {
    var hostCalls = 0;
    final future = operations.start(
      prepare: (_) async => hostCalls++,
      run: (_) async => hostCalls++,
    );

    future.cancel();

    await expectLater(future, throwsA(isCanceledError()));
    expect(hostCalls, 0);
    expect(hostCancels, isEmpty);
  });

  test('cancel during prepare fails with CANCELED and skips run', () async {
    final prepare = Completer<void>();
    var runCalls = 0;
    final future = operations.start(
      prepare: (_) => prepare.future,
      run: (_) async => runCalls++,
    );
    await pumpEventQueue();

    future.cancel();
    prepare.complete();

    await expectLater(future, throwsA(isCanceledError()));
    expect(runCalls, 0);
    expect(hostCancels, isEmpty);
  });

  group('onDone runs once when the operation', () {
    test('succeeds', () async {
      var doneCalls = 0;
      await operations.start(run: (_) async => 1, onDone: () => doneCalls++);

      expect(doneCalls, 1);
    });

    test('fails', () async {
      var doneCalls = 0;
      final future = operations.start<int>(
        run: (_) async => throw StateError('host failure'),
        onDone: () => doneCalls++,
      );

      await expectLater(future, throwsStateError);
      expect(doneCalls, 1);
    });

    test('is canceled', () async {
      var doneCalls = 0;
      final future = operations.start(
        run: (_) async => 1,
        onDone: () => doneCalls++,
      );
      future.cancel();

      await expectLater(future, throwsA(isCanceledError()));
      expect(doneCalls, 1);
    });
  });
}
