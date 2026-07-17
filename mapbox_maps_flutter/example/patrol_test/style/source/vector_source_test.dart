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

    await mapboxMap.style.addSource(
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

    var source = await mapboxMap.style.getSource('source') as VectorSource;
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
}

// End of generated file.
