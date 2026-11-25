// ignore_for_file: experimental_member_use, invalid_use_of_visible_for_testing_member
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
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

  Matcher isCanceled() => isA<PlatformException>().having(
    (error) => error.code,
    'code',
    'CANCELED',
  );

  patrolTest("cancel stops a running tile region load", skip: kIsWeb, (
    $,
  ) async {
    await app.runEmpty($.tester);
    await $.tester.pumpAndSettle();
    final tileStore = await TileStore.createDefault();

    // Cancel on the first progress event, so the native load is running.
    late final CancelableFuture<TileRegion> load;
    var progressCount = 0;
    load = tileStore.loadTileRegion(
      "cancel-tile-region-id",
      _tileRegionLoadOptions,
      (_) {
        if (progressCount++ == 0) load.cancel();
      },
    );

    await expectLater(load, throwsA(isCanceled()));
    expect(progressCount, greaterThan(0));

    // The native load stopped: the stored region does not grow any more.
    final canceled = await tileStore.tileRegion("cancel-tile-region-id");
    await Future<void>.delayed(const Duration(seconds: 3));
    final later = await tileStore.tileRegion("cancel-tile-region-id");
    expect(later.completedResourceCount, canceled.completedResourceCount);
    expect(later.completedResourceCount, lessThan(later.requiredResourceCount));
    tileStore.removeRegion("cancel-tile-region-id");
  });

  patrolTest("cancel stops a running tile region estimate", skip: kIsWeb, (
    $,
  ) async {
    await app.runEmpty($.tester);
    await $.tester.pumpAndSettle();
    final tileStore = await TileStore.createDefault();

    late final CancelableFuture<TileRegionEstimateResult> estimate;
    var progressCount = 0;
    estimate = tileStore.estimateTileRegion(
      "cancel-estimate-region-id",
      _tileRegionLoadOptions,
      null,
      (_) {
        if (progressCount++ == 0) estimate.cancel();
      },
    );

    await expectLater(estimate, throwsA(isCanceled()));
    expect(progressCount, greaterThan(0));
  });

  patrolTest("cancel stops a running style pack load", skip: kIsWeb, ($) async {
    await app.runEmpty($.tester);
    await $.tester.pumpAndSettle();
    final offlineManager = await OfflineManager.create();

    late final CancelableFuture<StylePack> load;
    var progressCount = 0;
    load = offlineManager.loadStylePack(
      MapboxStyles.SATELLITE_STREETS,
      _stylePackLoadOptions,
      (_) {
        if (progressCount++ == 0) load.cancel();
      },
    );

    await expectLater(load, throwsA(isCanceled()));
    expect(progressCount, greaterThan(0));

    // The native load stopped: the stored style pack does not grow any more.
    final canceled = await offlineManager.stylePack(
      MapboxStyles.SATELLITE_STREETS,
    );
    await Future<void>.delayed(const Duration(seconds: 3));
    final later = await offlineManager.stylePack(
      MapboxStyles.SATELLITE_STREETS,
    );
    expect(later.completedResourceCount, canceled.completedResourceCount);
    expect(later.completedResourceCount, lessThan(later.requiredResourceCount));
  });

  patrolTest("estimate reports progress", skip: kIsWeb, ($) async {
    await app.runEmpty($.tester);
    await $.tester.pumpAndSettle();
    final tileStore = await TileStore.createDefault();

    var progressCount = 0;
    final result = await tileStore.estimateTileRegion(
      "estimate-progress-region-id",
      _tileRegionLoadOptions,
      null,
      (_) => progressCount++,
    );

    expect(result.transferSize, greaterThan(0));
    expect(progressCount, greaterThan(0));
  });
}
