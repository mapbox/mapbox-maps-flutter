// ignore_for_file: experimental_member_use
import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'patrol.dart';
import 'empty_map_widget.dart' as app;

const ACCESS_TOKEN = String.fromEnvironment('ACCESS_TOKEN');

// Paris Orly airport — a venue with built-in Standard style indoor data.
final _orlyViewport = CameraViewportState(
  center: Point(coordinates: Position(2.36020, 48.72861)),
  zoom: 17,
);

void main() {
  setUpAll(() => MapboxOptions.setAccessToken(ACCESS_TOKEN));

  patrolTest('Indoor floors and floor selection', ($) async {
    final tester = $.tester;
    final mapboxMap = await app.pumpMap(
      tester: tester,
      viewport: _orlyViewport,
    );
    await tester.pumpAndSettle();
    await _enableShowIndoor(mapboxMap);

    IndoorState? latest;
    Completer<IndoorState>? waiter;
    bool Function(IndoorState)? predicate;
    final subscription = mapboxMap.indoor.indoorUpdates.listen((state) {
      latest = state;
      if (waiter != null && !waiter!.isCompleted && predicate!(state)) {
        waiter!.complete(state);
      }
    });
    addTearDown(subscription.cancel);

    Future<IndoorState> waitForState(
      bool Function(IndoorState) test,
      String description,
    ) {
      if (latest != null && test(latest!)) return Future.value(latest!);
      predicate = test;
      waiter = Completer<IndoorState>();
      return app.waitForEvent(
        tester,
        waiter!.future,
        description: () => description,
      );
    }

    final initial = await waitForState(
      (s) => s.floors.isNotEmpty,
      'Timed out waiting for indoor floors near Orly',
    );
    expect(initial.floors.length, greaterThan(1));

    final otherFloor = initial.floors.firstWhere(
      (f) => f.id != initial.selectedFloorId,
      orElse: () => initial.floors.first,
    );

    await mapboxMap.indoor.selectFloor(otherFloor.id);
    final afterSelect = await waitForState(
      (s) => s.selectedFloorId == otherFloor.id,
      'Timed out waiting for floor ${otherFloor.id} to be selected',
    );
    expect(afterSelect.selectedFloorId, otherFloor.id);

    await mapboxMap.indoor.selectFloor(null);
    final afterClear = await waitForState(
      (s) => s.selectedFloorId == null,
      'Timed out waiting for floor selection to clear',
    );
    expect(afterClear.selectedFloorId, isNull);
  });
}

// The Standard style's "basemap" import may still be loading when this
// runs, so the very first write can silently not take (web) or throw
// because the import doesn't exist yet (Android). Retry until
// getStyleImportConfigProperty confirms it did.
Future<void> _enableShowIndoor(MapboxMap mapboxMap) async {
  for (var attempt = 0; attempt < 20; attempt++) {
    try {
      await mapboxMap.setStyleImportConfigProperty(
        'basemap',
        'showIndoor',
        true,
      );
      final applied = await mapboxMap.getStyleImportConfigProperty(
        'basemap',
        'showIndoor',
      );
      if (applied.value == true) return;
    } catch (_) {
      // Import not merged into the style yet; retry below.
    }
    await Future.delayed(const Duration(milliseconds: 300));
  }
}
