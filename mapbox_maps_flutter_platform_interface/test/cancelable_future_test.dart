import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:mapbox_maps_flutter_platform_interface/mapbox_maps_flutter_platform_interface.dart';

void main() {
  test('cancel runs the callback once on a pending future', () {
    var calls = 0;
    final future = CancelableFuture<int>(
      Completer<int>().future,
      () => calls++,
    );

    future.cancel();
    future.cancel();

    expect(calls, 1);
  });

  test('cancel does not run the callback after completion', () async {
    var calls = 0;
    final future = CancelableFuture<int>(Future.value(1), () => calls++);

    await future;
    future.cancel();

    expect(calls, 0);
  });

  test('awaiting forwards the inner error', () async {
    final error = StateError('failed');
    final future = CancelableFuture<int>(Future.error(error), () {});

    await expectLater(future, throwsA(same(error)));
  });

  test('awaiting and then forward the inner value', () async {
    final future = CancelableFuture<int>(Future.value(1), () {});

    expect(await future, 1);
    expect(await future.then((value) => value + 1), 2);
  });
}
