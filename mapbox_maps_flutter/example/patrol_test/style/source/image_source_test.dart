// This file is generated.
// ignore_for_file: experimental_member_use, invalid_use_of_visible_for_testing_member
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import '../../patrol.dart';
import '../../empty_map_widget.dart' as app;

const ACCESS_TOKEN = String.fromEnvironment('ACCESS_TOKEN');

void main() {
  setUpAll(() => MapboxOptions.setAccessToken(ACCESS_TOKEN));

  // Style-mutation APIs are supported on web via the GL JS-backed style
  // controller. Some source properties still have platform-specific behavior
  // or remain unsupported on web, so this test covers only the generated
  // property set below rather than assuming full cross-platform parity.
  patrolTest('Add ImageSource', ($) async {
    final tester = $.tester;
    final mapboxMap = await app.pumpMap(tester: $.tester);
    await tester.pumpAndSettle();
    await app.waitForEvent($.tester, app.events.onMapLoaded.future);

    await mapboxMap.addSource(
      ImageSource(
        id: "source",
        coordinates: [
          [0.0, 1.0],
          [0.0, 1.0],
          [0.0, 1.0],
          [0.0, 1.0],
        ],
        prefetchZoomDelta: 1.0,
      ),
    );

    var source = await mapboxMap.getSource('source') as ImageSource;
    expect(source.id, 'source');
    var coordinates = await source.coordinates;
    expect(coordinates, [
      [0.0, 1.0],
      [0.0, 1.0],
      [0.0, 1.0],
      [0.0, 1.0],
    ]);

    if (!kIsWeb) {
      var prefetchZoomDelta = await source.prefetchZoomDelta;
      expect(prefetchZoomDelta, 1.0);
    }
  });

  patrolTest('Set url after adding ImageSource', ($) async {
    final mapboxMap = await app.pumpMap(tester: $.tester);
    await $.tester.pumpAndSettle();
    await app.waitForEvent($.tester, app.events.onMapLoaded.future);

    await mapboxMap.addSource(
      ImageSource(
        id: "source",
        coordinates: [
          [0.0, 1.0],
          [0.0, 1.0],
          [0.0, 1.0],
          [0.0, 1.0],
        ],
      ),
    );
    await mapboxMap.setStyleSourceProperty(
      'source',
      'url',
      "https://docs.mapbox.com/mapbox-gl-js/assets/radar.gif",
    );

    var source = await mapboxMap.getSource('source') as ImageSource;
    var url = await source.url;
    expect(url, "https://docs.mapbox.com/mapbox-gl-js/assets/radar.gif");
  });

  patrolTest('Set coordinates after adding ImageSource', ($) async {
    final mapboxMap = await app.pumpMap(tester: $.tester);
    await $.tester.pumpAndSettle();
    await app.waitForEvent($.tester, app.events.onMapLoaded.future);

    await mapboxMap.addSource(
      ImageSource(
        id: "source",
        coordinates: [
          [0.0, 1.0],
          [0.0, 1.0],
          [0.0, 1.0],
          [0.0, 1.0],
        ],
      ),
    );
    await mapboxMap.setStyleSourceProperty('source', 'coordinates', [
      [0.0, 1.0],
      [0.0, 1.0],
      [0.0, 1.0],
      [0.0, 1.0],
    ]);

    var source = await mapboxMap.getSource('source') as ImageSource;
    var coordinates = await source.coordinates;
    expect(coordinates, [
      [0.0, 1.0],
      [0.0, 1.0],
      [0.0, 1.0],
      [0.0, 1.0],
    ]);
  });

  // GL JS has no equivalent tile loading setting.
  patrolTest('Set prefetch-zoom-delta after adding ImageSource', skip: kIsWeb, (
    $,
  ) async {
    final mapboxMap = await app.pumpMap(tester: $.tester);
    await $.tester.pumpAndSettle();
    await app.waitForEvent($.tester, app.events.onMapLoaded.future);

    await mapboxMap.addSource(
      ImageSource(
        id: "source",
        coordinates: [
          [0.0, 1.0],
          [0.0, 1.0],
          [0.0, 1.0],
          [0.0, 1.0],
        ],
      ),
    );
    await mapboxMap.setStyleSourceProperty(
      'source',
      'prefetch-zoom-delta',
      2.0,
    );

    var source = await mapboxMap.getSource('source') as ImageSource;
    var prefetchZoomDelta = await source.prefetchZoomDelta;
    expect(prefetchZoomDelta, 2.0);
  });
}

// End of generated file.
