import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'empty_map_widget.dart' as app;
import 'package:mapbox_maps_example/utils.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:path_provider/path_provider.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

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
            styleURI: MapboxStyles.OUTDOORS, minZoom: 0, maxZoom: 16),
      ],
      metadata: {"tag": "my-test-tile-region"},
      acceptExpired: true,
      networkRestriction: NetworkRestriction.NONE);

  tearDown(() async {
    await MapboxMapsOptions.clearData();
  });

  testWidgets("test downloading style pack", (widgetTester) async {
    app.runEmpty();
    await widgetTester.pumpAndSettle();
    final offlineManager = await OfflineManager.create();

    final downloadedStylePack = await offlineManager.loadStylePack(
        MapboxStyles.OUTDOORS, _stylePackLoadOptions, null);
    expect(downloadedStylePack.requiredResourceCount,
        downloadedStylePack.completedResourceCount);
    expect(downloadedStylePack.styleURI, MapboxStyles.OUTDOORS);
    expect(downloadedStylePack.glyphsRasterizationMode,
        GlyphsRasterizationMode.IDEOGRAPHS_RASTERIZED_LOCALLY);

    final metadata =
        await offlineManager.stylePackMetadata(MapboxStyles.OUTDOORS);
    expect(metadata["tag"], "my-test-style-pack");

    final allStylePacks = await offlineManager.allStylePacks();
    expect(
        allStylePacks
            .any((element) => element.styleURI == downloadedStylePack.styleURI),
        true);
  });

  testWidgets("test downloading tile region", (widgetTester) async {
    app.runEmpty();
    await widgetTester.pumpAndSettle();

    final tmpDir = await getTemporaryDirectory();
    final tileStore = await TileStore.createAt(tmpDir.uri);

    final downloadedTileRegion = await tileStore.loadTileRegion(
        "my-tile-region-id", _tileRegionLoadOptions, null);
    expect(downloadedTileRegion.completedResourceCount,
        downloadedTileRegion.requiredResourceCount);
    expect(downloadedTileRegion.id, "my-tile-region-id");

    final metadata = await tileStore.tileRegionMetadata("my-tile-region-id");
    expect(metadata["tag"], "my-test-tile-region");

    final allTileRegions = await tileStore.allTileRegions();
    expect(
        allTileRegions.any((element) => element.id == downloadedTileRegion.id),
        true);

    expect(
        await tileStore.tileRegionContainsDescriptor("my-tile-region-id", [
          TilesetDescriptorOptions(
              styleURI: MapboxStyles.OUTDOORS, minZoom: 0, maxZoom: 16)
        ]),
        true);
  });
}
