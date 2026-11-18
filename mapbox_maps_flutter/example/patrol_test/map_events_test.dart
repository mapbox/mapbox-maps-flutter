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
    // The Standard style keeps its sources in an import, and the SDKs report
    // only the sources of the root style. See the source data test below.
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

  patrolTest(
    'onSourceDataLoaded reports tiles and metadata of root style sources',
    ($) async {
      final tester = $.tester;
      addTearDown(() async {
        await tester.pumpWidget(const MaterialApp());
        await Future<void>.delayed(const Duration(milliseconds: 100));
      });

      // A root GeoJSON source next to an imported style. The native SDKs report
      // only the sources of the root style.
      const styleJson =
          '{"version":8,'
          '"imports":[{"id":"basemap","url":"mapbox://styles/mapbox/standard"}],'
          '"sources":{"root":{"type":"geojson","data":'
          '{"type":"Point","coordinates":[0,0]}}},'
          '"layers":[{"id":"circle","type":"circle","source":"root"}]}';

      final received = <SourceDataLoadedEventData>[];
      final rootTilesLoaded = Completer<void>();
      await tester.pumpWidget(
        MaterialApp(
          home: MapWidget(
            styleUri: '',
            onMapCreated: (map) => map.setStyleJSON(styleJson),
            onSourceDataLoadedListener: (data) {
              received.add(data);
              if (data.type == SourceDataType.TILE && data.loaded == true) {
                rootTilesLoaded.completeOnce();
              }
            },
          ),
        ),
      );
      await tester.pumpAndSettle();
      await rootTilesLoaded.future.timeout(const Duration(seconds: 20));

      expect(received.map((e) => e.id).toSet(), {'root'});

      final metadata = received.where((e) => e.type == SourceDataType.METADATA);
      expect(metadata, isNotEmpty);
      expect(
        metadata.every((e) => e.loaded == null && e.tileID == null),
        isTrue,
      );

      final tiles = received.where((e) => e.type == SourceDataType.TILE);
      expect(tiles, isNotEmpty);
      for (final tile in tiles) {
        expect(tile.tileID, isNotNull);
        expect(tile.tileID!.z, greaterThanOrEqualTo(0));
      }
    },
  );

  patrolTest('onSourceDataLoaded reports a GeoJSON data update', ($) async {
    final tester = $.tester;
    addTearDown(() async {
      await tester.pumpWidget(const MaterialApp());
      await Future<void>.delayed(const Duration(milliseconds: 100));
    });

    const styleJson =
        '{"version":8,'
        '"sources":{"root":{"type":"geojson","data":'
        '{"type":"Point","coordinates":[0,0]}}},'
        '"layers":[{"id":"circle","type":"circle","source":"root"}]}';

    final created = Completer<MapboxMap>();
    final firstLoad = Completer<void>();
    var update = Completer<void>();
    await tester.pumpWidget(
      MaterialApp(
        home: MapWidget(
          styleUri: '',
          onMapCreated: (map) {
            created.complete(map);
            map.setStyleJSON(styleJson);
          },
          onSourceDataLoadedListener: (data) {
            if (data.id != 'root' || data.type != SourceDataType.METADATA) {
              return;
            }
            firstLoad.isCompleted
                ? update.completeOnce()
                : firstLoad.complete();
          },
        ),
      ),
    );
    final map = await created.future;
    await firstLoad.future.timeout(const Duration(seconds: 20));
    await tester.pumpAndSettle();
    update = Completer<void>();

    await map.setStyleSourceProperty(
      'root',
      'data',
      '{"type":"Point","coordinates":[1,1]}',
    );
    await update.future.timeout(const Duration(seconds: 20));
  });

  patrolTest('onSourceDataLoaded reports each tile once per load', ($) async {
    final tester = $.tester;
    addTearDown(() async {
      await tester.pumpWidget(const MaterialApp());
      await Future<void>.delayed(const Duration(milliseconds: 100));
    });

    // Circle and symbol layers on one source: GL JS loads its tiles in two
    // tile caches. At zoom 0 it also loads them for each world copy.
    const styleJson =
        '{"version":8,'
        '"glyphs":"mapbox://fonts/mapbox/{fontstack}/{range}.pbf",'
        '"sources":{"root":{"type":"geojson","data":'
        '{"type":"Point","coordinates":[0,0]}}},'
        '"layers":[{"id":"circle","type":"circle","source":"root"},'
        '{"id":"label","type":"symbol","source":"root",'
        '"layout":{"text-field":"A"}}]}';

    final tiles = <String>[];
    final allLoaded = Completer<void>();
    await tester.pumpWidget(
      MaterialApp(
        home: MapWidget(
          styleUri: '',
          onMapCreated: (map) => map.setStyleJSON(styleJson),
          onSourceDataLoadedListener: (data) {
            if (data.type != SourceDataType.TILE) return;
            if (data.loaded == true) {
              // GL JS reports the end of the load on a copy of a tile event.
              allLoaded.completeOnce();
              return;
            }
            final tile = data.tileID!;
            tiles.add('${tile.z}/${tile.x}/${tile.y}');
          },
        ),
      ),
    );
    await allLoaded.future.timeout(const Duration(seconds: 20));
    await Future<void>.delayed(const Duration(seconds: 1));

    expect(tiles.toSet().length, tiles.length);
  });

  group('listeners after a rebuild', () {
    const key = ValueKey('rebuiltMap');

    Future<MapboxMap> pumpListenerMap(
      WidgetTester tester, {
      OnCameraChangeListener? onCameraChange,
    }) async {
      final created = Completer<MapboxMap>();
      await tester.pumpWidget(
        MaterialApp(
          home: MapWidget(
            key: key,
            onMapCreated: created.complete,
            onCameraChangeListener: onCameraChange,
          ),
        ),
      );
      await tester.pumpAndSettle();
      return created.future;
    }

    Future<void> moveCamera(MapboxMap map, double zoom) =>
        map.setCamera(CameraOptions(zoom: zoom));

    Future<void> tearDownMap(WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp());
      await Future<void>.delayed(const Duration(milliseconds: 100));
    }

    patrolTest('a replaced listener gets the next event', ($) async {
      final tester = $.tester;
      addTearDown(() => tearDownMap(tester));
      var firstCalls = 0;
      final second = Completer<void>();

      final map = await pumpListenerMap(
        tester,
        onCameraChange: (_) => firstCalls++,
      );
      await tester.pumpWidget(
        MaterialApp(
          home: MapWidget(
            key: key,
            onCameraChangeListener: (_) => second.completeOnce(),
          ),
        ),
      );
      await tester.pumpAndSettle();
      firstCalls = 0;

      await moveCamera(map, 5);
      await second.future.timeout(const Duration(seconds: 10));
      expect(firstCalls, 0);
    });

    patrolTest('a listener added in a rebuild gets the next event', ($) async {
      final tester = $.tester;
      addTearDown(() => tearDownMap(tester));
      final added = Completer<void>();

      final map = await pumpListenerMap(tester);
      await tester.pumpWidget(
        MaterialApp(
          home: MapWidget(
            key: key,
            onCameraChangeListener: (_) => added.completeOnce(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      await moveCamera(map, 5);
      await added.future.timeout(const Duration(seconds: 10));
    });

    patrolTest('a removed listener gets no more events', ($) async {
      final tester = $.tester;
      addTearDown(() => tearDownMap(tester));
      var calls = 0;

      final map = await pumpListenerMap(tester, onCameraChange: (_) => calls++);
      await tester.pumpWidget(const MaterialApp(home: MapWidget(key: key)));
      await tester.pumpAndSettle();
      calls = 0;

      await moveCamera(map, 5);
      await Future<void>.delayed(const Duration(seconds: 1));
      await tester.pumpAndSettle();
      expect(calls, 0);
    });
  });
}
