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
  patrolTest('Add VectorSource', ($) async {
    final tester = $.tester;
    final mapboxMap = await app.pumpMap(tester: $.tester);
    await tester.pumpAndSettle();
    await app.waitForEvent($.tester, app.events.onMapLoaded.future);

    await mapboxMap.addSource(
      VectorSource(
        id: "source",
        tiles: ["a", "b", "c"],
        bounds: [0.0, 1.0, 2.0, 3.0],
        scheme: Scheme.XYZ,
        minzoom: 1.0,
        maxzoom: 1.0,
        attribution: "abc",
        volatile: true,
        prefetchZoomDelta: 1.0,
        tileCacheBudget: TileCacheBudget.inMegabytes(
          TileCacheBudgetInMegabytes(size: 3),
        ),
        minimumTileUpdateInterval: 1.0,
        maxOverscaleFactorForParentTiles: 1.0,
        tileRequestsDelay: 1.0,
        tileNetworkRequestsDelay: 1.0,
      ),
    );

    var source = await mapboxMap.getSource('source') as VectorSource;
    expect(source.id, 'source');
    var tiles = await source.tiles;
    expect(tiles, ["a", "b", "c"]);

    var bounds = await source.bounds;
    expect(bounds, [0.0, 1.0, 2.0, 3.0]);

    var scheme = await source.scheme;
    expect(scheme, Scheme.XYZ);

    var minzoom = await source.minzoom;
    expect(minzoom, 1.0);

    var maxzoom = await source.maxzoom;
    expect(maxzoom, 1.0);

    var attribution = await source.attribution;
    expect(attribution, "abc");

    var volatile = await source.volatile;
    expect(volatile, true);

    if (!kIsWeb) {
      var prefetchZoomDelta = await source.prefetchZoomDelta;
      expect(prefetchZoomDelta, 1.0);
    }

    if (!kIsWeb) {
      var tileCacheBudget = await source.tileCacheBudget;
      expect(
        tileCacheBudget?.size,
        TileCacheBudget.inMegabytes(TileCacheBudgetInMegabytes(size: 3)).size,
      );
      expect(
        tileCacheBudget?.type,
        TileCacheBudget.inMegabytes(TileCacheBudgetInMegabytes(size: 3)).type,
      );
    }

    if (!kIsWeb) {
      var minimumTileUpdateInterval = await source.minimumTileUpdateInterval;
      expect(minimumTileUpdateInterval, 1.0);
    }

    if (!kIsWeb) {
      var maxOverscaleFactorForParentTiles =
          await source.maxOverscaleFactorForParentTiles;
      expect(maxOverscaleFactorForParentTiles, 1.0);
    }

    if (!kIsWeb) {
      var tileRequestsDelay = await source.tileRequestsDelay;
      expect(tileRequestsDelay, 1.0);
    }

    if (!kIsWeb) {
      var tileNetworkRequestsDelay = await source.tileNetworkRequestsDelay;
      expect(tileNetworkRequestsDelay, 1.0);
    }
  });

  patrolTest('Set url after adding VectorSource', ($) async {
    final mapboxMap = await app.pumpMap(tester: $.tester);
    await $.tester.pumpAndSettle();
    await app.waitForEvent($.tester, app.events.onMapLoaded.future);

    await mapboxMap.addSource(VectorSource(id: "source", tiles: ["a"]));
    await mapboxMap.setStyleSourceProperty(
      'source',
      'url',
      "mapbox://mapbox.mapbox-streets-v8",
    );

    var source = await mapboxMap.getSource('source') as VectorSource;
    var url = await source.url;
    expect(url, "mapbox://mapbox.mapbox-streets-v8");
  });

  patrolTest('Set tiles after adding VectorSource', ($) async {
    final mapboxMap = await app.pumpMap(tester: $.tester);
    await $.tester.pumpAndSettle();
    await app.waitForEvent($.tester, app.events.onMapLoaded.future);

    await mapboxMap.addSource(VectorSource(id: "source", tiles: ["a"]));
    await mapboxMap.setStyleSourceProperty('source', 'tiles', ["a", "b", "c"]);

    var source = await mapboxMap.getSource('source') as VectorSource;
    var tiles = await source.tiles;
    expect(tiles, ["a", "b", "c"]);
  });

  patrolTest('Set minzoom after adding VectorSource', ($) async {
    final mapboxMap = await app.pumpMap(tester: $.tester);
    await $.tester.pumpAndSettle();
    await app.waitForEvent($.tester, app.events.onMapLoaded.future);

    await mapboxMap.addSource(VectorSource(id: "source", tiles: ["a"]));
    await mapboxMap.setStyleSourceProperty('source', 'minzoom', 2.0);

    var source = await mapboxMap.getSource('source') as VectorSource;
    var minzoom = await source.minzoom;
    expect(minzoom, 2.0);
  });

  patrolTest('Set maxzoom after adding VectorSource', ($) async {
    final mapboxMap = await app.pumpMap(tester: $.tester);
    await $.tester.pumpAndSettle();
    await app.waitForEvent($.tester, app.events.onMapLoaded.future);

    await mapboxMap.addSource(VectorSource(id: "source", tiles: ["a"]));
    await mapboxMap.setStyleSourceProperty('source', 'maxzoom', 2.0);

    var source = await mapboxMap.getSource('source') as VectorSource;
    var maxzoom = await source.maxzoom;
    expect(maxzoom, 2.0);
  });

  // GL JS does not cache tiles locally.
  patrolTest('Set volatile after adding VectorSource', skip: kIsWeb, ($) async {
    final mapboxMap = await app.pumpMap(tester: $.tester);
    await $.tester.pumpAndSettle();
    await app.waitForEvent($.tester, app.events.onMapLoaded.future);

    await mapboxMap.addSource(VectorSource(id: "source", tiles: ["a"]));
    await mapboxMap.setStyleSourceProperty('source', 'volatile', true);

    var source = await mapboxMap.getSource('source') as VectorSource;
    var volatile = await source.volatile;
    expect(volatile, true);
  });

  // GL JS has no equivalent tile loading setting.
  patrolTest(
    'Set prefetch-zoom-delta after adding VectorSource',
    skip: kIsWeb,
    ($) async {
      final mapboxMap = await app.pumpMap(tester: $.tester);
      await $.tester.pumpAndSettle();
      await app.waitForEvent($.tester, app.events.onMapLoaded.future);

      await mapboxMap.addSource(VectorSource(id: "source", tiles: ["a"]));
      await mapboxMap.setStyleSourceProperty(
        'source',
        'prefetch-zoom-delta',
        2.0,
      );

      var source = await mapboxMap.getSource('source') as VectorSource;
      var prefetchZoomDelta = await source.prefetchZoomDelta;
      expect(prefetchZoomDelta, 2.0);
    },
  );

  // GL JS has no equivalent tile loading setting.
  patrolTest('Set tile-cache-budget after adding VectorSource', skip: kIsWeb, (
    $,
  ) async {
    final mapboxMap = await app.pumpMap(tester: $.tester);
    await $.tester.pumpAndSettle();
    await app.waitForEvent($.tester, app.events.onMapLoaded.future);

    await mapboxMap.addSource(VectorSource(id: "source", tiles: ["a"]));
    await mapboxMap.setStyleSourceProperty(
      'source',
      'tile-cache-budget',
      TileCacheBudget.inMegabytes(TileCacheBudgetInMegabytes(size: 3)).toJson(),
    );

    var source = await mapboxMap.getSource('source') as VectorSource;
    var tileCacheBudget = await source.tileCacheBudget;
    expect(
      tileCacheBudget?.size,
      TileCacheBudget.inMegabytes(TileCacheBudgetInMegabytes(size: 3)).size,
    );
    expect(
      tileCacheBudget?.type,
      TileCacheBudget.inMegabytes(TileCacheBudgetInMegabytes(size: 3)).type,
    );
  });

  // GL JS has no equivalent tile loading setting.
  patrolTest(
    'Set minimum-tile-update-interval after adding VectorSource',
    skip: kIsWeb,
    ($) async {
      final mapboxMap = await app.pumpMap(tester: $.tester);
      await $.tester.pumpAndSettle();
      await app.waitForEvent($.tester, app.events.onMapLoaded.future);

      await mapboxMap.addSource(VectorSource(id: "source", tiles: ["a"]));
      await mapboxMap.setStyleSourceProperty(
        'source',
        'minimum-tile-update-interval',
        2.0,
      );

      var source = await mapboxMap.getSource('source') as VectorSource;
      var minimumTileUpdateInterval = await source.minimumTileUpdateInterval;
      expect(minimumTileUpdateInterval, 2.0);
    },
  );

  // GL JS has no equivalent tile loading setting.
  patrolTest(
    'Set max-overscale-factor-for-parent-tiles after adding VectorSource',
    skip: kIsWeb,
    ($) async {
      final mapboxMap = await app.pumpMap(tester: $.tester);
      await $.tester.pumpAndSettle();
      await app.waitForEvent($.tester, app.events.onMapLoaded.future);

      await mapboxMap.addSource(VectorSource(id: "source", tiles: ["a"]));
      await mapboxMap.setStyleSourceProperty(
        'source',
        'max-overscale-factor-for-parent-tiles',
        2.0,
      );

      var source = await mapboxMap.getSource('source') as VectorSource;
      var maxOverscaleFactorForParentTiles =
          await source.maxOverscaleFactorForParentTiles;
      expect(maxOverscaleFactorForParentTiles, 2.0);
    },
  );

  // GL JS has no equivalent tile loading setting.
  patrolTest(
    'Set tile-requests-delay after adding VectorSource',
    skip: kIsWeb,
    ($) async {
      final mapboxMap = await app.pumpMap(tester: $.tester);
      await $.tester.pumpAndSettle();
      await app.waitForEvent($.tester, app.events.onMapLoaded.future);

      await mapboxMap.addSource(VectorSource(id: "source", tiles: ["a"]));
      await mapboxMap.setStyleSourceProperty(
        'source',
        'tile-requests-delay',
        2.0,
      );

      var source = await mapboxMap.getSource('source') as VectorSource;
      var tileRequestsDelay = await source.tileRequestsDelay;
      expect(tileRequestsDelay, 2.0);
    },
  );

  // GL JS has no equivalent tile loading setting.
  patrolTest(
    'Set tile-network-requests-delay after adding VectorSource',
    skip: kIsWeb,
    ($) async {
      final mapboxMap = await app.pumpMap(tester: $.tester);
      await $.tester.pumpAndSettle();
      await app.waitForEvent($.tester, app.events.onMapLoaded.future);

      await mapboxMap.addSource(VectorSource(id: "source", tiles: ["a"]));
      await mapboxMap.setStyleSourceProperty(
        'source',
        'tile-network-requests-delay',
        2.0,
      );

      var source = await mapboxMap.getSource('source') as VectorSource;
      var tileNetworkRequestsDelay = await source.tileNetworkRequestsDelay;
      expect(tileNetworkRequestsDelay, 2.0);
    },
  );
}

// End of generated file.
