// ignore_for_file: experimental_member_use, invalid_use_of_visible_for_testing_member
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'empty_map_widget.dart' as app;
import 'package:mapbox_maps_flutter_examples/utils.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'patrol.dart';

const ACCESS_TOKEN = String.fromEnvironment('ACCESS_TOKEN');

void main() {
  setUpAll(() => MapboxOptions.setAccessToken(ACCESS_TOKEN));

  final _stylePackLoadOptions = StylePackLoadOptions(
    glyphsRasterizationMode:
        GlyphsRasterizationMode.IDEOGRAPHS_RASTERIZED_LOCALLY,
    metadata: {"tag": "my-test-style-pack"},
    acceptExpired: true,
  );

  final _tileRegionLoadOptions = TileRegionLoadOptions(
    geometry: City.helsinki.toJson(),
    descriptorsOptions: [
      TilesetDescriptorOptions(
        styleURI: MapboxStyles.OUTDOORS,
        minZoom: 0,
        maxZoom: 16,
      ),
    ],
    metadata: {"tag": "my-test-tile-region"},
    acceptExpired: true,
    networkRestriction: NetworkRestriction.NONE,
  );

  tearDown(() async {
    await MapboxMapsOptions.clearData();
  });

  patrolTest("test downloading style pack", skip: kIsWeb, ($) async {
    final widgetTester = $.tester;
    await app.runEmpty($.tester);
    await widgetTester.pumpAndSettle();
    final offlineManager = await OfflineManager.create();

    final downloadedStylePack = await offlineManager.loadStylePack(
      MapboxStyles.OUTDOORS,
      _stylePackLoadOptions,
      null,
    );
    expect(
      downloadedStylePack.requiredResourceCount,
      downloadedStylePack.completedResourceCount,
    );
    expect(downloadedStylePack.styleURI, MapboxStyles.OUTDOORS);
    expect(
      downloadedStylePack.glyphsRasterizationMode,
      GlyphsRasterizationMode.IDEOGRAPHS_RASTERIZED_LOCALLY,
    );

    final metadata = await offlineManager.stylePackMetadata(
      MapboxStyles.OUTDOORS,
    );
    expect(metadata["tag"], "my-test-style-pack");

    final allStylePacks = await offlineManager.allStylePacks();
    expect(
      allStylePacks.any(
        (element) => element.styleURI == downloadedStylePack.styleURI,
      ),
      true,
    );
  });

  patrolTest("test downloading tile region", skip: kIsWeb, ($) async {
    final widgetTester = $.tester;
    await app.runEmpty($.tester);
    await widgetTester.pumpAndSettle();

    final tileStore = await TileStore.createDefault();

    final downloadedTileRegion = await tileStore.loadTileRegion(
      "my-tile-region-id",
      _tileRegionLoadOptions,
      null,
    );
    expect(
      downloadedTileRegion.completedResourceCount,
      downloadedTileRegion.requiredResourceCount,
    );
    expect(downloadedTileRegion.id, "my-tile-region-id");

    final metadata = await tileStore.tileRegionMetadata("my-tile-region-id");
    expect(metadata["tag"], "my-test-tile-region");

    final allTileRegions = await tileStore.allTileRegions();
    expect(
      allTileRegions.any((element) => element.id == downloadedTileRegion.id),
      true,
    );

    expect(
      await tileStore.tileRegionContainsDescriptor("my-tile-region-id", [
        TilesetDescriptorOptions(
          styleURI: MapboxStyles.OUTDOORS,
          minZoom: 0,
          maxZoom: 16,
        ),
      ]),
      true,
    );

    // Remove tile region before releasing the tile store to prevent
    // stale regions from leaking into subsequent tests.
    tileStore.removeRegion('my-tile-region-id');
    // Force eviction of tile data, then restore default quota
    tileStore.setDiskQuota(0);
    await tileStore.allTileRegions();
    tileStore.setDiskQuota(null);
  });
}
