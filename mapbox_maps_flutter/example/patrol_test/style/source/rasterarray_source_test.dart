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
  patrolTest('Add RasterArraySource', ($) async {
    final tester = $.tester;
    final mapboxMap = await app.pumpMap(tester: $.tester);
    await tester.pumpAndSettle();
    await app.waitForEvent($.tester, app.events.onMapLoaded.future);

    await mapboxMap.addSource(
      RasterArraySource(
        id: "source",
        tiles: ["a", "b", "c"],
        bounds: [0.0, 1.0, 2.0, 3.0],
        minzoom: 1.0,
        maxzoom: 1.0,
        tileSize: 1.0,
        attribution: "abc",
        volatile: true,
        tileCacheBudget: TileCacheBudget.inMegabytes(
          TileCacheBudgetInMegabytes(size: 3),
        ),
      ),
    );

    var source = await mapboxMap.getSource('source') as RasterArraySource;
    expect(source.id, 'source');
    var tiles = await source.tiles;
    expect(tiles, ["a", "b", "c"]);

    var bounds = await source.bounds;
    expect(bounds, [0.0, 1.0, 2.0, 3.0]);

    var minzoom = await source.minzoom;
    expect(minzoom, 1.0);

    var maxzoom = await source.maxzoom;
    expect(maxzoom, 1.0);

    var tileSize = await source.tileSize;
    expect(tileSize, 1.0);

    var attribution = await source.attribution;
    expect(attribution, "abc");

    var volatile = await source.volatile;
    expect(volatile, true);

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
  });

  patrolTest('Set properties after adding RasterArraySource', ($) async {
    final mapboxMap = await app.pumpMap(tester: $.tester);
    await $.tester.pumpAndSettle();
    await app.waitForEvent($.tester, app.events.onMapLoaded.future);

    {
      const id = 'source-url';
      await mapboxMap.addSource(RasterArraySource(id: id, tiles: ["a"]));
      await mapboxMap.setStyleSourceProperty(
        id,
        'url',
        "mapbox://mapbox.gfs-winds",
      );

      final source = await mapboxMap.getSource(id) as RasterArraySource;
      final url = await source.url;
      expect(url, "mapbox://mapbox.gfs-winds", reason: 'url');
    }

    {
      const id = 'source-tiles';
      await mapboxMap.addSource(RasterArraySource(id: id, tiles: ["a"]));
      await mapboxMap.setStyleSourceProperty(id, 'tiles', ["a", "b", "c"]);

      final source = await mapboxMap.getSource(id) as RasterArraySource;
      final tiles = await source.tiles;
      expect(tiles, ["a", "b", "c"], reason: 'tiles');
    }

    {
      const id = 'source-minzoom';
      await mapboxMap.addSource(RasterArraySource(id: id, tiles: ["a"]));
      await mapboxMap.setStyleSourceProperty(id, 'minzoom', 2.0);

      final source = await mapboxMap.getSource(id) as RasterArraySource;
      final minzoom = await source.minzoom;
      expect(minzoom, 2.0, reason: 'minzoom');
    }

    {
      const id = 'source-maxzoom';
      await mapboxMap.addSource(RasterArraySource(id: id, tiles: ["a"]));
      await mapboxMap.setStyleSourceProperty(id, 'maxzoom', 2.0);

      final source = await mapboxMap.getSource(id) as RasterArraySource;
      final maxzoom = await source.maxzoom;
      expect(maxzoom, 2.0, reason: 'maxzoom');
    }

    // GL JS does not cache tiles locally.
    if (!kIsWeb) {
      const id = 'source-volatile';
      await mapboxMap.addSource(RasterArraySource(id: id, tiles: ["a"]));
      await mapboxMap.setStyleSourceProperty(id, 'volatile', true);

      final source = await mapboxMap.getSource(id) as RasterArraySource;
      final volatile = await source.volatile;
      expect(volatile, true, reason: 'volatile');
    }

    // GL JS has no equivalent tile loading setting.
    if (!kIsWeb) {
      const id = 'source-tile-cache-budget';
      await mapboxMap.addSource(RasterArraySource(id: id, tiles: ["a"]));
      await mapboxMap.setStyleSourceProperty(
        id,
        'tile-cache-budget',
        TileCacheBudget.inMegabytes(
          TileCacheBudgetInMegabytes(size: 3),
        ).toJson(),
      );

      final source = await mapboxMap.getSource(id) as RasterArraySource;
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
  });
}
// End of generated file.
