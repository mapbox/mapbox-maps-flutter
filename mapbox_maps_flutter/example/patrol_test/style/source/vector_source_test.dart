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

  patrolTest('Set properties after adding VectorSource', ($) async {
    final mapboxMap = await app.pumpMap(tester: $.tester);
    await $.tester.pumpAndSettle();
    await app.waitForEvent($.tester, app.events.onMapLoaded.future);

    {
      const id = 'source-url';
      await mapboxMap.addSource(VectorSource(id: id, tiles: ["a"]));
      await mapboxMap.setStyleSourceProperty(
        id,
        'url',
        "mapbox://mapbox.mapbox-streets-v8",
      );

      final source = await mapboxMap.getSource(id) as VectorSource;
      final url = await source.url;
      expect(url, "mapbox://mapbox.mapbox-streets-v8", reason: 'url');
    }

    {
      const id = 'source-tiles';
      await mapboxMap.addSource(VectorSource(id: id, tiles: ["a"]));
      await mapboxMap.setStyleSourceProperty(id, 'tiles', ["a", "b", "c"]);

      final source = await mapboxMap.getSource(id) as VectorSource;
      final tiles = await source.tiles;
      expect(tiles, ["a", "b", "c"], reason: 'tiles');
    }

    {
      const id = 'source-minzoom';
      await mapboxMap.addSource(VectorSource(id: id, tiles: ["a"]));
      await mapboxMap.setStyleSourceProperty(id, 'minzoom', 2.0);

      final source = await mapboxMap.getSource(id) as VectorSource;
      final minzoom = await source.minzoom;
      expect(minzoom, 2.0, reason: 'minzoom');
    }

    {
      const id = 'source-maxzoom';
      await mapboxMap.addSource(VectorSource(id: id, tiles: ["a"]));
      await mapboxMap.setStyleSourceProperty(id, 'maxzoom', 2.0);

      final source = await mapboxMap.getSource(id) as VectorSource;
      final maxzoom = await source.maxzoom;
      expect(maxzoom, 2.0, reason: 'maxzoom');
    }

    // GL JS does not cache tiles locally.
    if (!kIsWeb) {
      const id = 'source-volatile';
      await mapboxMap.addSource(VectorSource(id: id, tiles: ["a"]));
      await mapboxMap.setStyleSourceProperty(id, 'volatile', true);

      final source = await mapboxMap.getSource(id) as VectorSource;
      final volatile = await source.volatile;
      expect(volatile, true, reason: 'volatile');
    }

    // GL JS has no equivalent tile loading setting.
    if (!kIsWeb) {
      const id = 'source-prefetch-zoom-delta';
      await mapboxMap.addSource(VectorSource(id: id, tiles: ["a"]));
      await mapboxMap.setStyleSourceProperty(id, 'prefetch-zoom-delta', 2.0);

      final source = await mapboxMap.getSource(id) as VectorSource;
      final prefetchZoomDelta = await source.prefetchZoomDelta;
      expect(prefetchZoomDelta, 2.0, reason: 'prefetch-zoom-delta');
    }

    // GL JS has no equivalent tile loading setting.
    if (!kIsWeb) {
      const id = 'source-tile-cache-budget';
      await mapboxMap.addSource(VectorSource(id: id, tiles: ["a"]));
      await mapboxMap.setStyleSourceProperty(
        id,
        'tile-cache-budget',
        TileCacheBudget.inMegabytes(
          TileCacheBudgetInMegabytes(size: 3),
        ).toJson(),
      );

      final source = await mapboxMap.getSource(id) as VectorSource;
      final tileCacheBudget = await source.tileCacheBudget;
      expect(
        tileCacheBudget?.size,
        TileCacheBudget.inMegabytes(TileCacheBudgetInMegabytes(size: 3)).size,
        reason: 'tile-cache-budget',
      );
      expect(
        tileCacheBudget?.type,
        TileCacheBudget.inMegabytes(TileCacheBudgetInMegabytes(size: 3)).type,
        reason: 'tile-cache-budget',
      );
    }

    // GL JS has no equivalent tile loading setting.
    if (!kIsWeb) {
      const id = 'source-minimum-tile-update-interval';
      await mapboxMap.addSource(VectorSource(id: id, tiles: ["a"]));
      await mapboxMap.setStyleSourceProperty(
        id,
        'minimum-tile-update-interval',
        2.0,
      );

      final source = await mapboxMap.getSource(id) as VectorSource;
      final minimumTileUpdateInterval = await source.minimumTileUpdateInterval;
      expect(
        minimumTileUpdateInterval,
        2.0,
        reason: 'minimum-tile-update-interval',
      );
    }

    // GL JS has no equivalent tile loading setting.
    if (!kIsWeb) {
      const id = 'source-max-overscale-factor-for-parent-tiles';
      await mapboxMap.addSource(VectorSource(id: id, tiles: ["a"]));
      await mapboxMap.setStyleSourceProperty(
        id,
        'max-overscale-factor-for-parent-tiles',
        2.0,
      );

      final source = await mapboxMap.getSource(id) as VectorSource;
      final maxOverscaleFactorForParentTiles =
          await source.maxOverscaleFactorForParentTiles;
      expect(
        maxOverscaleFactorForParentTiles,
        2.0,
        reason: 'max-overscale-factor-for-parent-tiles',
      );
    }

    // GL JS has no equivalent tile loading setting.
    if (!kIsWeb) {
      const id = 'source-tile-requests-delay';
      await mapboxMap.addSource(VectorSource(id: id, tiles: ["a"]));
      await mapboxMap.setStyleSourceProperty(id, 'tile-requests-delay', 2.0);

      final source = await mapboxMap.getSource(id) as VectorSource;
      final tileRequestsDelay = await source.tileRequestsDelay;
      expect(tileRequestsDelay, 2.0, reason: 'tile-requests-delay');
    }

    // GL JS has no equivalent tile loading setting.
    if (!kIsWeb) {
      const id = 'source-tile-network-requests-delay';
      await mapboxMap.addSource(VectorSource(id: id, tiles: ["a"]));
      await mapboxMap.setStyleSourceProperty(
        id,
        'tile-network-requests-delay',
        2.0,
      );

      final source = await mapboxMap.getSource(id) as VectorSource;
      final tileNetworkRequestsDelay = await source.tileNetworkRequestsDelay;
      expect(
        tileNetworkRequestsDelay,
        2.0,
        reason: 'tile-network-requests-delay',
      );
    }
  });
}

// End of generated file.
